class NewsController < ApplicationController
  include NodesHelper
  before_action :set_section, only: [:show]

  decorates_assigned :node
  decorates_assigned :articles

  def index
    @articles = NewsArticle.published.by_release_date.by_published_at

    # TODO: this will be refactored out once node-hierarchy nav is implemented
    # For now, this is the quickest way to get the same outcome
    if params[:section].present?
      set_section
      set_menu_nodes
      @articles = @section.news_articles.published.by_release_date.by_published_at
    end
  end


  # News articles are routed by their slug and section. Slugs consist
  # of :release_date-:slug, to ensure that we avoid clashes of news articles
  # between sections as well as within a section over time.
  def show
    @node = NewsArticle.find_by!(
      slug: params[:slug],
      section: @section
    )
    raise ActiveRecord::RecordNotFound unless can? :read_public, @node
    render_node node
  end


  private
  def set_section
    @section = SectionHome.find_by(slug: params[:section]).section
  end
end