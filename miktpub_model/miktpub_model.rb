# frozen_string_literal: true

require_relative 'model'
require_relative 'as'

Plugin.create(:miktpub_model) do

  as_types = Plugin::MiktpubModel::AS.constants(false)

  filter_miktpub_model_type do |type_uri, types|
    if match_data = type_uri.to_s.match(%r|\Ahttps://www.w3.org/ns/activitystreams#(.*)\z|)
      as_type = match_data[1].to_sym
      if as_types.include?(as_type)
        types << Plugin::MiktpubModel::AS.const_get(as_type, false)
      end
    end
    [type_uri, types]
  end
end
