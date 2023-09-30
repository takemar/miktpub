require_relative '../endpoint.rb'

module Plugin::MiktpubServer; module Endpoint

  class User < Base

    def default_content_type = 'application/activity+json'

    def call
      user_id = @request.env['router.params'][:user_id]
      host = @request.server_name
      user = Plugin.collect(:miktpub_query_local_users, { user_id:, host: }).first

      return error(404) unless user

      response(user.data)
    end
  end

end; end
