ENV['RACK_ENV'] = 'test'

# changes
# changes

require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../run.rb', __FILE__

include Rack::Test::Methods # To use describe/it

def app
  Sinatra::Application
end

describe 'In this tiny wiki' do
  after(:each) do
    Page.all.delete
  end

  describe 'first time visiting' do
    before(:each) do
      Page.all.delete
    end

    describe '/' do
      it 'should show the edit/create page' do
        get '/'

        assert last_response.body.include?("Create/Edit /")
      end
    end

    describe '/anotherpage' do
      it 'should show the edit/create page' do
        get '/anotherpage'

        assert last_response.body.include?("Create/Edit /")
      end
    end
  end

  describe 'visiting / after it was created' do
    before(:each) do
      Page.create(name: '/', content: '# Fancy title')

      get '/'
    end

    it 'should show its content' do
      assert last_response.body.include?('Fancy title')
    end

    it 'should show its edit link url' do
      assert last_response.body.include?('-edit')
    end
  end

  describe 'visiting /anotherpage-edit after its been created' do
    before(:each) do
      Page.create(name: '/anotherpage', content: '# old content')

      get '/anotherpage-edit'
    end

    it 'should show the edit page with the current content' do
      assert last_response.body.include?('old content')
    end

    it 'should show the edit page with the proper title' do
      assert last_response.body.include?('Create/Edit /anotherpage')
    end
  end

  describe 'should see delete button when visiting' do
    before(:each) do
      content = '# content'
      Page.create(name: '/', content: content)
      Page.create(name: '/anypage', content: content)
      Page.create(name: '/anypage-edit', content: content)
    end

    it 'home page' do
      get '/'

      assert last_response.body.include?('Delete')
    end
    it 'any page' do
      get '/anypage'

      assert last_response.body.include?('Delete')
    end
    it 'editing any page' do
      get '/anypage-edit'

      assert last_response.body.include?('Delete')
    end
  end

  describe 'should see navigation when visiting' do
    before(:each) do
      content = '# content'
      Page.create(name: '/category/nav1', content: content)
      Page.create(name: '/category/nav2', content: content)

      Page.create(name: '/', content: content)
      Page.create(name: '/anypage', content: content)
      Page.create(name: '/anypage-edit', content: content)
    end

    it 'home page' do
      get '/'

      assert last_response.body.include?('Nav1')
      assert last_response.body.include?('Nav2')
    end

    it 'any page' do
      get '/anypage'

      assert last_response.body.include?('Nav1')
      assert last_response.body.include?('Nav2')
    end

    it 'editing any page' do
      get '/anypage-edit'

      assert last_response.body.include?('Nav1')
      assert last_response.body.include?('Nav2')
    end

    it 'a category page' do
      get '/category/nav1'

      assert last_response.body.include?('Nav1')
      assert last_response.body.include?('Nav2')
    end
  end
end
