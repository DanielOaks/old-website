module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'autogen_index.html')
      self.data['category'] = category
      title_prefix          = site.config['cateogry_title_prefix'] || ''
      self.data['title']    = "#{title_prefix}#{category.capitalize}"
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = File.join('tags', dir)
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'autogen_index.html')
      self.data['tag']   = tag
      title_prefix       = site.config['tag_title_prefix'] || 'Tag: '
      self.data['title'] = "#{title_prefix}#{tag.capitalize}"
    end
  end

  class PageGenerator < Plugin
    # Subclass from Plugin instead of Generator, because we manually call this class
    safe true
    
    # Creates the index pages for each category in the site
    #
    # site - The Site
    def generate(site)
      if site.layouts.key? 'autogen_index'
        site.categories.keys.each do |category|
          site.pages << CategoryPage.new(site, site.source, category, category)
        end
        site.tags.keys.each do |tag|
          site.pages << TagPage.new(site, site.source, tag, tag)
        end
      end
    end
  end

end