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

  Delayer.new do
    Thread.new do
      s = Rackup::Server.new({
        Port: 3939,
        app: Plugin::MiktpubReceiver::Application.new
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
