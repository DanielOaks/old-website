##
# This plugin extends the default Pagination to allow people to
# easily paginate category pages
#
# It does this by modifying the built-in Jekyll Pagination object,
# and is hacked together from the original Pagination code, and
# the plugin {here}[http://www.marran.com/tech/category-pagination-in-jekyll/]

module Jekyll

  class Pagination < Generator
    # This generator is safe from arbitrary code execution.
    safe true

    # Generate paginated pages if necessary.
    #
    # site - The Site.
    #
    # Returns nothing.
    def generate(site)
      # Manually call this here, otherwise this gets called before the page
      # generator, and the category pages don't exist before we paginate
      PageGenerator.new().generate(site)

      site.pages.dup.each do |page|
        paginate(site, page) if Pager.pagination_enabled?(site.config, page.name)
      end
    end

    # Paginates the blog's posts. Renders the index.html file into paginated
    # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
    # site-wide data.
    #
    # site - The Site.
    # page - The index.html Page that requires pagination.
    #
    # {"paginator" => { "page" => <Number>,
    #                   "per_page" => <Number>,
    #                   "posts" => [<Post>],
    #                   "total_posts" => <Number>,
    #                   "total_pages" => <Number>,
    #                   "previous_page" => <Number>,
    #                   "next_page" => <Number> }}
    def paginate(site, page)
      category = page.data['category']
      tag = page.data['tag']

      if category
        posts = site.categories[category].reverse
      elsif tag
        posts = site.tags[tag].reverse
      else
        posts = site.site_payload['site']['posts']
      end

      pages = Pager.calculate_pages(posts, site.config['paginate'].to_i)

      # iterate over the total number of pages and create a physical page for each
      (1..pages).each do |num_page|
        pager = Pager.new(site.config, num_page, posts, File.join(page.dir, paginate_path(site, category, tag)), pages)

        # the first page is the index, so no page needs to be created. However, the subsequent pages need to be generated
        if num_page > 1
          if category
            newpage = CategorySubPage.new(site, site.source, category, page.data['category_layout'])
          elsif tag
            newpage = TagSubPage.new(site, site.source, tag, page.data['tag_layout'])
          else
            newpage = Page.new(site, site.source, page.dir, page.name)
          end

          newpage.pager = pager
          newpage.dir = File.join(page.dir, paginate_path(site, category, tag).sub(':num', num_page.to_s))
          site.pages << newpage
        else
          page.pager = pager
        end
      end
    end

    private
      # Gives us the pagination path to use.
      #
      # site - The Site.
      # category - The category, (default: false).
      # tag = The tag, (default: false).
      #
      # Returns a string that can is used as: returned.sub(':num', number)
      def paginate_path(site, category = false, tag = false)
        if category
          if site.config['paginate_category_path']
            format = site.config['paginate_category_path']
          else
            format = ":category/page/:num"
          end
          format.sub(':category', category)
        elsif tag
          if site.config['paginate_tag_path']
            format = site.config['paginate_tag_path']
          else
            format = "tags/:tag/page/:num"
          end
          format.sub(':tag', tag)
        else
          site.config['paginate_path']
        end
      end
  end

  class Pager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages, :previous_page, :previous_page_url, :next_page, :next_page_url

    # Calculate the number of pages.
    #
    # posts - The Array of Posts.
    # per_page  - The Integer of entries per page.
    #
    # Returns the Integer number of pages.
    def self.calculate_pages(posts, per_page)
      (posts.size.to_f / per_page.to_i).ceil
    end

    # Determine if pagination is enabled for a given file.
    #
    # config - The configuration Hash.
    # file   - The String filename of the file.
    #
    # Returns true if pagination is enabled, false otherwise.
    def self.pagination_enabled?(config, file)
      file == 'index.html' && !config['paginate'].nil?
    end

    # Initialize a new Pager.
    #
    # config    - The Hash configuration of the site.
    # page      - The Integer page number.
    # posts     - The Array of Posts.
    # page_url  - URL to next/prev pages, subbing ':num' for the page number
    # num_pages - The Integer number of pages or nil if you'd like the number
    #             of pages calculated.
    def initialize(config, page, posts, page_url, num_pages = nil)
      @page = page
      @per_page = config['paginate'].to_i
      @total_pages = num_pages || Pager.calculate_pages(posts, @per_page)

      if @page > @total_pages
        raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
      end

      init = (@page - 1) * @per_page
      offset = (init + @per_page - 1) >= posts.size ? posts.size : (init + @per_page - 1)

      @total_posts = posts.size
      @posts = posts[init..offset]
      @previous_page = @page != 1 ? @page - 1 : nil
      @previous_page_url = page_url.sub(':num', @previous_page.to_s)
      @next_page = @page != @total_pages ? @page + 1 : nil
      @next_page_url = page_url.sub(':num', @next_page.to_s)
    end

    # Convert this Pager's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Pager.
    def to_liquid
      {
        'page' => page,
        'per_page' => per_page,
        'posts' => posts,
        'total_posts' => total_posts,
        'total_pages' => total_pages,
        'previous_page' => previous_page,
        'previous_page_url' => previous_page_url,
        'next_page' => next_page,
        'next_page_url' => next_page_url
      }
    end
  end

  # The CategorySubPage class creates a single category page.
  # This class exists to specify the layout to use for pages after the first index page.
  class CategorySubPage < Page
    
    # Initialize the page, and set the appropriate Page variables based on the given
    # category-based input variables.
    #
    # site - The Site.
    # base - The Site's base directory.
    # category - The directory the Page is showing
    # laying - The Layout to use for this page
    def initialize(site, base, category, layout)
      @site = site
      @base = base
      @dir  = category
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), layout || 'autogen_index.html')

      title_prefix       = site.config['cateogry_title_prefix'] || ''
      self.data['title'] = "#{title_prefix}#{category.capitalize}"
    end
  end

  # The TagSubPage class creates a single tag page.
  # This class exists to specify the layout to use for pages after the first index page.
  class TagSubPage < Page
    
    # Initialize the page, and set the appropriate Page variables based on the given
    # category-based input variables.
    #
    # site - The Site.
    # base - The Site's base directory.
    # tag - The directory the Page is showing
    # laying - The Layout to use for this page
    def initialize(site, base, tag, layout)
      @site = site
      @base = base
      @dir  = File.join('tags', tag)
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), layout || 'autogen_index.html')

      title_prefix       = site.config['tag_title_prefix'] || 'Tag: '
      self.data['title'] = "#{title_prefix}#{tag.capitalize}"
    end
  end
end
