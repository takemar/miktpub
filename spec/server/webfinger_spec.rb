require 'json'
require 'rack/test'
require './miktpub_server/endpoint/webfinger'

RSpec.describe Plugin::MiktpubServer::Endpoint::Webfinger do

  include Rack::Test::Methods

  def app = Plugin::MiktpubServer::Endpoint::Webfinger

  before do
    allow(Plugin).to receive(:collect) do |event_name, preferred_username, domain|
      expect(event_name).to eq(:miktpub_acct)
      if preferred_username == 'mikutterchan' && domain == 'social.hachune.example.net'
        acct = Object.new
        def acct.id = 'https://social.hachune.example.net/users/mikutterchan'
        def acct.preferred_username = 'mikutterchan'
        def acct.domain = 'social.hachune.example.net'
        [acct]
      else
        []
      end
    end
  end

  context '存在するacctリソースに対するwebfingerリクエスト' do

    it '正しくレスポンスを返す' do

      get '/.well-known/webfinger?resource=acct:mikutterchan@social.hachune.example.net'

      expected = JSON.parse(File.read(File.expand_path('webfinger.json', __dir__)))

      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/jrd+json')
      expect(JSON.parse(last_response.body)).to eq(expected)
    end
  end

  context 'acctに@がprefixされたwebfingerリクエスト' do

    it '正しくレスポンスを返す' do

      get '/.well-known/webfinger?resource=acct:@mikutterchan@social.hachune.example.net'

      expected = JSON.parse(File.read(File.expand_path('webfinger.json', __dir__)))

      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/jrd+json')
      expect(JSON.parse(last_response.body)).to eq(expected)
    end
  end

  context '存在しないacctリソースに対するwebfingerリクエスト' do

    it '404を返す' do
      get '/.well-known/webfinger?resource=acct:hachune@social.hachune.example.net'
      expect(last_response).to be_not_found
    end
  end

  context 'フォーマットが正しくないacctリソースに対するwebfingerリクエスト' do

    it '400を返す' do
      pending
      get '/.well-known/webfinger?resource=acct:hachune_social.hachune.example.net'
      expect(last_response).to be_bad_request
    end
  end

  context 'acctリソース以外に対するwebfingerリクエスト' do

    it '404を返す' do
      get '/.well-known/webfinger?resource=mailto:mikutterchan@social.hachune.example.net'
      expect(last_response).to be_not_found
    end
  end

  context 'resouceパラメタがないwebfingerリクエスト' do

    it '400を返す' do
      get '/.well-known/webfinger'
      expect(last_response).to be_bad_request
    end
  end
end
