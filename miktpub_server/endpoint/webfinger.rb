require 'json'

module Plugin::MiktpubServer; module Endpoint

  class Webfinger

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def self.call(env)
      self.new(env).call
    end

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

    def response(body, status = 200, headers = {}, content_type: 'application/jrd+json')
      default_headers = {
        'Content-Type' => content_type
      }
      [status, default_headers.merge(headers), [body.to_json]]
    end

    def error(status)
      [status, {'Content-Type': 'text/plain'}, [Rack::Utils::HTTP_STATUS_CODES[status]]]
    end
  end

end; end
