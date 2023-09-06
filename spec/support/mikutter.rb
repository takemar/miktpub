class Plugin

  def _(x); x; end

  class << self
    def [](...); new; end
    def call(...); end
    def filtering(event_names, *args); args end
  end
end

module Diva; class Model

  module MessageMixin; end
  module UserMixin; end

  class << self
    def register(...); end
  end

end; end
