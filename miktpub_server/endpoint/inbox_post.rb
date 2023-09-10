require 'json'
require_relative '../endpoint.rb'

module Plugin::MiktpubServer; module Endpoint; module Inbox

  class Post

    def call
      # TODO: verify HTTP signatures
      Plugin[:miktpub_server].miktpub_model(req.body.read)
      [200, {}, []]
    end
  end

end; end; end
