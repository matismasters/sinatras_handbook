require 'sinatra'
require 'haml'
require 'redcarpet'
require 'mongoid'
require 'securerandom'
require 'rack/csrf'

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

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def sanitize(path)
    path.gsub(/[^\da-zA-Z\-\/]/, '').gsub('/edit','')
  end
end

class Page
  include Mongoid::Document

  field :name
  field :content
end

# Clean path to use as name
before do
  @path = sanitize(request.path_info)
end

# Routes
get '*/edit' do
  page = Page.find_by(name: @path)

  if page
    haml :update, locals: { name: page[:name], content: page[:content] }
  else
    status 404
  end
end

get '*' do
  page = Page.find_by(name: @path)

  if page
    haml :show, locals: { name: page[:name], content: page[:content] }
  else
    haml :update, locals: { name: @path, content: '' }
  end
end

post '*' do
  page = Page.find_or_create_by(name: @path)
  page[:content] = params[:content]
  page.save

  redirect "#{page[:name]}"
end

# Views
__END__

@@ layout
%html
  %head
    %title Tinywiki
  %body
    = yield

@@ show
#edit-link
  %a{ href: "#{name}/edit" } Edit
#main-wrapper
  = markdown content

@@ update
%h1= "Create/Edit #{name}"

#main-wrapper
  %form{ method: 'post' }
    = csrf_tag
    %textarea{ name: 'content' }
      = content
    %button Save/Update
