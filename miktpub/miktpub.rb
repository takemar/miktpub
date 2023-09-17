# frozen_string_literal: true

require_relative 'user'

Plugin.create(:miktpub) do

  defevent :miktpub_query_local_users, prototype: [Hash, Pluggaloid::COLLECT]

end
