# frozen_string_literal: true

require 'rack'
require 'hanami/router'
require_relative 'endpoint/webfinger'
require_relative 'endpoint/user'

Plugin.create(:miktpub_server) do

  def sigint_default
    Reserver.new(1) do
      Delayer.new do
        before = Signal.trap(:INT, 'DEFAULT')
        if before == 'DEFAULT'
          sigint_default
        end
      end
    end
  end

  rack_app = Hanami::Router.new do
    get '/.well-known/webfinger', to: Plugin::MiktpubServer::Endpoint::Webfinger
    get '/users/:user_id', to Plugin::MiktpubServer::Endpoint::User
    post '/users/:user_id/inbox' to Plugin::MiktpubServer::Endpoint::Inbox::Post
  end

  Delayer.new do
    Thread.new do
      s = Rack::Server.new({
        Port: 3939,
        app: rack_app
      })
      sigint_default
      block_value = nil
      s.start do |x|
        block_value = x
      end
    ensure
      case
      when s.server.respond_to?(:shutdown) # WEBrick
        s.server.shutdown
      when block_value.respond_to?(:stop) # puma
        block_value.stop
      end
    end
  end
end
