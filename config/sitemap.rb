# See https://github.com/kjvarga/sitemap_generator for more information on this config file

SitemapGenerator::Sitemap.default_host = root_url

# TODO: Change to true before going live
SitemapGenerator::Sitemap.compress = false

# get access to NodesHelper#public_node_path
SitemapGenerator::Interpreter.send :include, NodesHelper

SitemapGenerator::Sitemap.create do
  group(filename: :public, sitemaps_path: 'sitemaps/') do
    add root_path
    add departments_path
    add ministers_path
    add news_articles_path
    add new_feedback_path

    Category.roots.find_each do |category|
      add category_path(category.slug)
    end
    SectionHome.published.find_each do |section_home|
      add section_news_articles_path(section_home.slug)
    end
    Node.published.find_each do |node|
      unless node.class == RootNode
        add public_node_path(node)
      end
    end
  end

  group(filename: :editorial, sitemaps_path: 'sitemaps/') do
    # TODO populate this properly
    add editorial_root_path
  end
end
