# frozen_string_literal: true

Dir.glob(File.expand_path('*/Gemfile', __dir__)) do |gemfile|
  eval(File.read(gemfile), binding, gemfile)
end

source 'https://rubygems.org'

gem 'diva'
gem 'delayer'
gem 'pluggaloid'

group :test do
  gem 'rspec'
  gem 'rack-test'
end
