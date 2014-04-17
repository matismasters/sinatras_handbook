helpers do
  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def sanitize(path)
    path.gsub(/[^\da-zA-Z\-\/]/, '').gsub('-edit', '').gsub('-delete', '')
  end

  def breadcrumb(path)
    words = path.split('/')
    words[0..-1].each_with_index.map { |_, i| words[0..i].join('/') }
  end

  def title(path)
    last_path_element(path).capitalize
  end

  def last_path_element(path)
    path.split('/').last
  end

  def navigation
    Page.all.select { |page| page.name.include?('category') }.sort_by(&:name)
  end
end
