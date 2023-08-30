module Plugin::MiktpubModel

  class Type < Module

    include Diva::ModelExtend

    def initialize(*supertypes, &block)
      super()
      supertypes.each do |t|
        include t
      end
      if block
        self.module_eval(&block)
      end
    end
  end

  class Model < Diva::Model

    class << self

      alias _new new

      def new(args)
        t = Array(args[:@type]).map do |type|
          Plugin.filtering(:miktpub_model_type, Diva::URI(type), [])
        end.flatten
        Model[*(self.types + t).uniq.sort(&:hash)]._new(args)
      end

      def [](*types)
        @@memo ||= Hash.new do |h, k|
          x = k.uniq.sort_by(&:hash)
          unless h.key?(x)
            h[x] = Class.new(self) do
              x.sort_by(&:hash).each do |type|
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

      def inspect
        if self == Model
          super
        else
          "Plugin::MiktPubModel::Model[#{ types.map(&:inspect).join(', ') }]"
        end
      end

      def fields
        @fields ||= []
        self.included_modules.filter { _1.kind_of?(Type) }.map(&:fields).flatten + @fields
      end
    end
  end
end
