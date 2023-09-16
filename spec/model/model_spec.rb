require 'json'
require 'diva'
require './miktpub_model/model'
require './miktpub_model/as'

RSpec.describe Plugin::MiktpubModel::Model do

  shared_examples 'create_note' do
    example 'モデルが正しく構築されている' do
      is_expected.to be_kind_of(Plugin::MiktpubModel::Model)
      is_expected.to be_kind_of(Plugin::MiktpubModel::AS::Create)
      is_expected.to be_kind_of(Plugin::MiktpubModel::AS::Activity)
      is_expected.to be_kind_of(Plugin::MiktpubModel::AS::BaseObject)
      expect(subject.class).to eq(Plugin::MiktpubModel::Model[Plugin::MiktpubModel::AS::Create])
      expect(subject.published!).to eq(Time.new('2007-08-31T09:00:00Z'))
      expect(subject.object!).to be_kind_of(Plugin::MiktpubModel::Model)
      expect(subject.object!).to be_kind_of(Plugin::MiktpubModel::AS::Note)
      expect(subject.object!).to be_kind_of(Plugin::MiktpubModel::AS::BaseObject)
      expect(subject.object!.class).to eq(Plugin::MiktpubModel::Model[Plugin::MiktpubModel::AS::Note])
      expect(subject.object!.content!).to eq('Hello World!')
      expect(subject.object!.attributed_to!.name!).to eq('みくったーちゃん')
    end
  end

  before do
    ns = 'https://www.w3.org/ns/activitystreams#'
    allow(Plugin).to receive(:filtering) do |event_name, type_uri, types|
      expect(type_uri.to_s).to be_start_with(ns)
      [type_uri, [Plugin::MiktpubModel::AS.const_get(type_uri.to_s.delete_prefix(ns), false)]]
    end
  end

  context 'JSON-LD expanded形式のハッシュでnew' do

    subject do
      json = File.read('./spec/fixtures/files/create_note.json')
      hash = JSON.parse(json, symbolize_names: true)
      Plugin::MiktpubModel::Model.new(hash)
    end

    include_examples 'create_note'

  end
end
