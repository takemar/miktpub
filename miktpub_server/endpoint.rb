require 'json'

module Plugin::MiktpubServer; module Endpoint

  class Base

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def self.call(env)
      self.new(env).call
    end

    def response(body, status = 200, headers = {}, content_type: default_content_type)
      unless content_type.nil?
        headers = { 'Content-Type' => content_type }.merge(headers)
      end
      if body.kind_of?(Hash)
        body = [body.to_json]
      end
      [status, default_headers.merge(headers), body]
    end

    def default_headers = {}

    def default_content_type = nil

    def error(status)
      [status, {'Content-Type': 'text/plain'}, [Rack::Utils::HTTP_STATUS_CODES[status]]]
    end
  end

end; end
