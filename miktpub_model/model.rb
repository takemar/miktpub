module Plugin::MiktpubModel

  class Model < Diva::Model

    register :miktpub_model, name: Plugin[:miktpub_model]._('Miktpub'), timeline: true

    def initialize(args)
      super(
        args.transform_keys(
          self.class.field_by_uri.transform_keys(&:to_sym)
        ).transform_values do |value|
          if value.kind_of?(Array)
            value.map do |v|
              if v.kind_of?(Hash) && v.key?(:@value)
                v[:@value]
              elsif v.kind_of?(Hash) && v.size == 1 && v.key?(:@id)
                v[:@id]
              else
                v
              end
            end
          else
            value
          end
        end
      )
    end

    class << self

      alias _new new

      def new(args)
        t = Array(args[:@type]).map do |type|
          _, x = Plugin.filtering(:miktpub_model_type, Diva::URI(type), [])
          x
        end.flatten
        unless (self.types - [t, t.map(&:ancestor_types)].flatten).empty?
          raise(
            Diva::InvalidTypeError,
            "Type for #{ args.inspect } is #{ t.inspect }, not superset of #{ self.types.inspect }"
          )
        end
        Model[*t.uniq.sort(&:hash)]._new(args)
      end

      def [](*types)
        @@memo ||= Hash.new do |h, k|
          x = k.uniq.sort_by(&:hash)
          unless h.key?(x)
            h[x] = Class.new(Model) do
              x.each do |type|
                include type
              end
              define_singleton_method :types do
                x
              end
            end
          end
          h[k] = h[x]
        end
        @@memo[types]
      end

      def types = []

      def ancestor_types
        @ancestor_types ||= types.map do |t|
          [t, t.ancestor_types]
        end.flatten.uniq
      end

      def inspect
        self.name || "Plugin::MiktpubModel::Model[#{ types.map(&:inspect).join(', ') }]"
      end

      def fields
        @fields ||= self.ancestor_types.map(&:fields).flatten
      end

      def field_by_uri
        @field_by_uri ||= self.ancestor_types.map(&:field_by_uri).reduce do |result, item|
          result.merge(item)
        end.to_h
      end
    end
  end

  class Type < Module

    include Diva::ModelExtend

    def initialize(*supertypes, &block)
      super()
      @supertypes = supertypes
      supertypes.each do |t|
        include t
      end
      if block
        self.module_eval(&block)
      end
    end

    def ancestor_types
      @supertypes.reverse.map do |supertype|
        [supertype, supertype.ancestor_types]
      end.flatten.uniq
    end

    private def method_missing(name, ...)
      @supertypes.reverse_each do |t|
        if t.respond_to?(name)
          return t.send(name, ...)
        end
      end
      super
    end

    def respond_to_missing?(name, include_private)
      @supertypes.any? { _1.respond_to?(name, include_private) }
    end

    def define_field(field_name, type, required: false, uri: nil, base_uri: nil)
      field_type = (
        case type
        when Array
          types = type.flatten.map do |t|
            if t.kind_of?(Type) then Model[t] else t end
          end
          if types.size >= 2
            [types]
          else
            types
          end
        when Type
          [Model[type]]
        else
          [type]
        end
      )

      add_field(field_name, type: field_type, required: required)

      define_method("#{ field_name }!") do
        @value[field_name]&.first
      end

      if base_uri.nil? && self.respond_to?(:field_base_uri, true)
        base_uri = self.field_base_uri
      end
      if uri.nil?
        uri = (
          if self.respond_to?(:field_uri, true)
            field_uri(field_name, base_uri)
          else
            "#{ base_uri }#{ field_name }"
          end
        )
      end
      field_by_uri[uri] = field_name
    end

    attr_writer :field_base_uri

    def field_by_uri
      @field_by_uri ||= {}
    end
  end
end