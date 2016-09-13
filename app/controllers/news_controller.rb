class NewsController < ApplicationController
  include NodesHelper
  include NewsHelper

  before_action :set_section, only: [:index, :show]
  before_action :set_filters, only: [:index]

  decorates_assigned :node
  decorates_assigned :articles


  def index
    # TODO: this will be refactored out once node-hierarchy nav is implemented
    # For now, this is the quickest way to get the same outcome
    if params[:section].present?
      set_menu_nodes
      @filters = [@section]
      @articles = preload_news_articles(@section.news_articles)
    else
      @articles = filtered_articles
    end

    with_caching(@articles)
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
    with_caching([@node, @section]) do
      render_node node
    end
  end


  private
  # An array of sections the user is filtering by, loaded by params
  # with section ids
  def set_filters
    @filters = []
    section_ids = Section.pluck(:id)

    [:ministers, :departments].each do |filter_type|
      if params[filter_type].present?
        id_list = params[filter_type].map(&:to_i)

        id_list.reject! do |item|
          !section_ids.include? item
        end

        @filters += Section.where(id: id_list)
      end
    end
  end


  def set_section
    if params[:section].present?
      begin
        @section = SectionHome.find_by!(slug: params[:section]).section
      rescue ActiveRecord::RecordNotFound => e
        e.instance_variable_set(:@_rollbar_do_not_report, true)
        raise
      end
    end
  end


  def filtered_articles
    if @filters.present?
      preload_news_articles
        .references(:sections)
        .where('sections.id IN (?)', @filters.collect(&:id))
    else
      preload_news_articles
    end
  end
end
