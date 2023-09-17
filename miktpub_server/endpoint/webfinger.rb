require_relative '../endpoint.rb'

module Plugin::MiktpubServer; module Endpoint

  class Webfinger < Base

    def default_content_type = 'application/jrd+json'

    def call
      resource = @request.params['resource']
      return error(400) unless resource
      match_data = resource.match(/\Aacct:@?([^@]+)@([^@]+)\z/)
      return error(404) unless match_data # TODO: resource=https://...
      preferred_username, domain = match_data.captures
      rel = @request.params['rel']
      user = Plugin.collect(
        :miktpub_query_local_users,
        { username: preferred_username.downcase, host: domain.downcase },
      ).first
      return error(404) unless user
      response({
        subject: "acct:#{ user.username }@#{ user.host }",
        links: [
          {
            rel: 'self',
            type: 'application/activity+json',
            href: user.id,
          },
        ],
      })
    end
  end

end; end
