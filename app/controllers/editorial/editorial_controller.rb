
module Editorial
  class EditorialController < ::ApplicationController

    check_authorization

    before_action ->() { authorize! :view, :editorial_page }
    before_action :set_git_vars

    layout 'editorial'

    def index
      authorize! :view, :editorial_page
      @sections = Section
        .all
        .includes(:home_node)
        .order(:name)
        .select{ |section| can? :read, section }

      @news_section = Section.find_by(name: 'news')
      with_caching([*@sections, @news_section])
    end

    class ClientParamError < StandardError
    end

    rescue_from ClientParamError do
      head :bad_request
    end

    private
    def set_git_vars
      @version_tag = Rails.configuration.version_tag
      @version_sha = Rails.configuration.version_sha[0..6]
    end
  end
end
