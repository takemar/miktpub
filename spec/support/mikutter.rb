require 'diva'
require 'delayer'
require 'pluggaloid'

module Diva; class Model

  module MessageMixin; end
  module UserMixin; end

  class << self
    def register(...); end
  end

end; end

Delayer.default = Delayer.generate_class(
  priority: %i[
    ui_response
    routine_active
    ui_passive
    routine_passive
    ui_favorited
    destroy_cache
  ],
  default: :routine_passive,
  expire: 0.02
)

class Plugin < Pluggaloid::Plugin
  def _(x) = x
end

RSpec.configure do |config|
  config.before do
    Plugin.vm = Pluggaloid.new(Delayer.default)
  end
end
