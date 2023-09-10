# frozen_string_literal: true

require_relative 'user'

Plugin.create(:miktpub) do

  defevent :miktpub_users, prototype: [String, Pluggaloid::COLLECT]

  defdsl :miktpub_acct do |username, host|
    collect(:miktpub_users, host).filter do |user|
      user.value.preferred_username == username
    end
  end
end
