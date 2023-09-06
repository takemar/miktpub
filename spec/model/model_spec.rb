require 'json'
require 'diva'
require './miktpub_model/model'
require './miktpub_model/as'

RSpec.describe Plugin::MiktpubModel::Model do

  let(:example_json) { File.read('./spec/fixtures/files/create_note.json') }
  let(:example_hash) { JSON.parse(example_json, symbolize_names: true) }

  it 'JSON-LD expanded形式のハッシュでnewできる' do

    ns = 'https://www.w3.org/ns/activitystreams#'

    allow(Plugin).to receive(:filtering) do |event_name, type_uri, types|
      expect(type_uri.to_s).to be_start_with(ns)
      [type_uri, [Plugin::MiktpubModel::AS.const_get(type_uri.to_s.delete_prefix(ns), false)]]
    end

    model = Plugin::MiktpubModel::Model.new(example_hash)

    expect(model).to be_kind_of(Plugin::MiktpubModel::Model)
    expect(model).to be_kind_of(Plugin::MiktpubModel::AS::Create)
    expect(model).to be_kind_of(Plugin::MiktpubModel::AS::Activity)
    expect(model).to be_kind_of(Plugin::MiktpubModel::AS::BaseObject)
    expect(model.class).to eq(Plugin::MiktpubModel::Model[Plugin::MiktpubModel::AS::Create])
    expect(model.published!).to eq(Time.new('2007-08-31T09:00:00Z'))
    expect(model.object!).to be_kind_of(Plugin::MiktpubModel::Model)
    expect(model.object!).to be_kind_of(Plugin::MiktpubModel::AS::Note)
    expect(model.object!).to be_kind_of(Plugin::MiktpubModel::AS::BaseObject)
    expect(model.object!.class).to eq(Plugin::MiktpubModel::Model[Plugin::MiktpubModel::AS::Note])
    expect(model.object!.content!).to eq('Hello World!')
    expect(model.object!.attributed_to!.name!).to eq('みくったーちゃん')
  end
end
