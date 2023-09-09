require 'json'
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
      acct = Plugin.collect(:miktpub_acct, preferred_username.downcase, domain.downcase).first
      return error(404) unless acct
      response({
        subject: "acct:#{ acct.preferred_username }@#{ acct.domain }",
        links: [
          {
            rel: 'self',
            type: 'application/activity+json',
            href: acct.id,
          },
        ],
      })
    end
  end

end; end
