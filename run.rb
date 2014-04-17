require 'sinatra'
require 'haml'
require 'redcarpet'
require 'mongoid'
require 'securerandom'
require 'rack/csrf'
require './helpers'
require './persistance'

use Rack::MethodOverride

# Clean path to use as name
before do
  @path = sanitize(request.path_info)
end

# Routes
get '/favicon.ico' do
  status 404
end

get '*-edit' do
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

post '*-delete' do
  Page.find_by(name: @path).destroy

  redirect '/'
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
    %title= title(name) rescue "Sinatra's handbook"
    %link{ rel: 'stylesheet',
      href: '//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css' }
    %link{ rel: 'stylesheet',
      href: '//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css' }
    %script{ src: '//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js' }
    :css
      textarea { width: 100%; height: 80%; }
      .navbar  { margin-bottom: 0; min-height: 0; }

  %body{ role: 'document' }
    .nav.navbar
      #navigation
        - navigation.each do |navigation_item|
          %a{ href: navigation_item.name }= title(navigation_item.name)
          &nbsp;|&nbsp;
      %hr

      #breadcrumb.pull-left
        - breadcrumb(name).each do |name|
          - unless name.empty?
            %a{ href: name }= "&gt; #{ last_path_element(name) }"
      #edit-link.pull-right
        %a{ href: "#{name}-edit" } Edit
      #delete-link.pull-right
        %form{ method: 'post', action: "#{name}-delete" }
          = csrf_tag
          %button Delete

    .container.main{ role: 'main' }
      = yield

    %footer

@@ show
#main-wrapper
  = find_and_preserve markdown(content)

@@ update
%h1= "Create/Edit #{name}"

#main-wrapper
  %form{ method: 'post' }
    = csrf_tag
    #editor
      %textarea{ name: 'content' }= content
    %button Save/Update
