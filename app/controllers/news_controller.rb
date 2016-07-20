class NewsController < ApplicationController
  include NodesHelper
  decorates_assigned :node
  before_action :set_section


  def index
    # TODO: show index for section news items
  end


  # News articles are routed by their slug and section. Slugs consist
  # of :release_date-:slug, to ensure that we avoid clashes of news articles
  # between sections as well as within a section over time.
  def show
    @node = NewsArticle.find_by!(
      slug: params[:slug],
      section: @section
    )
    raise ActiveRecord::RecordNotFound unless can? :read, @node
    render_node node
  end


  private
  def set_section
    @section = SectionHome.find_by(slug: params[:section]).section
  end
end