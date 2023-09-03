# frozen_string_literal: true

require 'rackup'

module Plugin::MiktpubReceiver

  class Application

    def call(env)
      [200, {}, ['Hello World!']]
    end
  end
end

Plugin.create(:miktpub_receiver) do

  Delayer.new do
    Thread.new do
      Rackup::Server.start({
        Port: 3939,
        app: Plugin::MiktpubReceiver::Application.new
      })
    end
  end
end
