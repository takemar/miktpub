# frozen_string_literal: true

Plugin.create(:miktpub_tmp) do

  collection(:miktpub_users, 'localhost') do |collector|
    acct = Object.new
    def acct.id = 'http://localhost/users/takemaro'
    def acct.preferred_username = 'takemaro'
    def acct.domain = 'localhost'
    collector.add(acct)
  end
end
