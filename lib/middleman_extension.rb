require "middleman-blog"
class Middleman::Blog::CalendarPages
  def manipulate_resource_list(resources)
    new_resources = []
    @blog_data.articles.group_by {|p| p.data["category"] }.each do |category, pages|
      next if category.nil?
      pages.group_by {|a| a.date.year }.each do |year, year_articles|
        year_articles.group_by {|a| a.date.month }.each do |month, month_articles|
          new_resources << month_page_resource(category, year, month, month_articles)
        end
      end
    end
    resources + new_resources
  end

  private
  def month_page_resource(category, year, month, month_articles)
    Sitemap::ProxyResource.new(@sitemap, "/#{category}/#{year}/#{month}.html", @month_template).tap do |p|
      p.add_metadata locals: {
        'page_type' => 'month',
        'year' => year,
        'month' => month,
        'articles' => month_articles,
        'blog_controller' => @blog_controller
      }
    end
  end
end
