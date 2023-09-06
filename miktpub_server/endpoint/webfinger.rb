module Plugin::MiktpubServer; module Endpoint

  class Webfinger

    def call(env)
      [200, {}, ['Hello World!']]
    end
  end

end; end
