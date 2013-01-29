# Code based on http://mikewest.org/2009/11/my-jekyll-fork
# forked from http://github.com/rfelix/my_jekyll_extensions

module Jekyll

  class CategoryIndex < Page
    # Initialize a new CategoryIndex.
    # +base+ is the String path to the <source>
    # +dir+ is the String path between <source> and the file
    #
    # Returns <CategoryIndex>
    def initialize(site, base, category)
      @site = site
      @base = base
      @dir = category
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'autogen_index.html')
      self.data['category'] = category
      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category.capitalize}"
    end
  end
 
  class TagIndex < Page
    # Initialize a new TagIndex.
    # +base+ is the String path to the <source>
    # +dir+ is the String path between <source> and the file
    #
    # Returns <TagIndex>
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'autogen_index.html')
      self.data['tag'] = tag
      # MODIFIED by http://github.com/danc/
      # related tags list ( other tags of any post tagged by 'tag')
      # this code will not be run unless _config.yml declares :
      # related_tags: true
      if @site.config['related_tags']
        related = []
        site.tags[tag].each do |post|
          post.tags.each do |rel|
            related.push(rel) unless rel == tag || related.include?(rel)
          end
        end
        self.data['related'] = related unless related.empty?
      end
      # END MODIFIED
      tag_title_prefix = site.config['tag_title_prefix'] || 'Tag: '
      self.data['title'] = "#{tag_title_prefix}#{tag.capitalize}"
    end
  end

  class Site
    # Write each category page
    #
    # Returns nothing
    def write_category_indexes
      if self.layouts.key? 'autogen_index'
        self.categories.keys.each do |category|
          self.pages << CategoryIndex.new(self, self.source, category)
        end
      end
    end

    # Write each tag page
    #
    # Returns nothing
    def write_tag_indexes
      if self.layouts.key? 'autogen_index'
        self.tags.keys.each do |tag|
          dir = self.config['tag_dir'] || 'tags'
          self.pages << TagIndex.new(self, self.source, File.join(dir, tag), tag)
        end
      end
    end
  end
  
  AOP.before(Site, :generate) do |site_instance, args|
    site_instance.write_tag_indexes
    site_instance.write_category_indexes
  end
end
