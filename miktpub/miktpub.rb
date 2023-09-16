# frozen_string_literal: true

require_relative 'user'

Plugin.create(:miktpub) do

  defevent :miktpub_query_local_users, prototype: [Hash, Pluggaloid::COLLECT]

  defdsl :miktpub_acct do |username, host|
    collect(:miktpub_users, host).filter do |user|
      user.value.preferred_username == username
    end
  end
end
