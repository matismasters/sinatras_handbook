# Env vars
ENV['MONGOHQ_URL'] ||= 'mongodb://localhost:27017/this_wiki'

configure do
  Mongoid.configure do |config|
    config.sessions = { default: { uri: ENV['MONGOHQ_URL'] } }
  end

  Mongoid.raise_not_found_error = false

  use Rack::Session::Cookie, secret: SecureRandom.hex
  use Rack::Csrf, raise: true
end

class Page
  include Mongoid::Document

  field :name
  field :content
end
