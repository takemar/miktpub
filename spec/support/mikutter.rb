class Plugin

  class << self
    def [](...); new; end
    def call(...); end
    def filtering(...); end
  end

  def _(x); x; end
end

module Diva; class Model
  class << self
    def register(...); end
  end
end; end
