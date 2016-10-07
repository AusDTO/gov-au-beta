class NodesController < ApplicationController
  include NodesHelper
  include NewsHelper

  decorates_assigned :node
  decorates_assigned :menu_nodes, with: NodeDecorator

  def show
    # silence these RecordNotFound exceptions in rollbar as they are generic 404s
    begin
      @node = Node.find_by_path! params[:path] || ''
    rescue ActiveRecord::RecordNotFound => e
      e.instance_variable_set(:@_rollbar_do_not_report, true)
      raise
    end

    raise ActiveRecord::RecordNotFound unless can? :read_public, @node
    @section = @node.section

    if @section
      @news = preload_news_articles(@section.news_articles).limit(3)
    end

    set_menu_nodes
    with_caching([@node, @section, *@news, *@ministers, *@departments, *@agencies, *@categories]) do
      render_node node
    end
  end

  def home
    @news = preload_news_articles.limit(8)
    @ministers = Minister.all
    @departments = Department.all
    @agencies = Agency.all
    @categories = Category.roots.where(:placeholder => false)
    @categories_coming_soon = Category.roots.where(:placeholder => true)
    show
  end

  def preview
    @node = Node.find_by_token!(params[:token])
    @section = @node.section
    set_menu_nodes
    render_node node
  end
end
