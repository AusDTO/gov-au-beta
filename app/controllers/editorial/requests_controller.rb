module Editorial
  class RequestsController < EditorialController

    check_authorization

    def new
      @section = Section.find(params[:section])
      @form = RequestForm.new(Request.new(section: @section))
      @owners = User.with_role(:owner, @section)

      if (rq = Request.find_by(section: @section, user: current_user))
        flash[:notice] = 'You have already requested membership to this group'
        redirect_to editorial_request_path(rq)
      end
    end

    def create
      @form = RequestForm.new(Request.new)

      if @form.validate(params[:request])
        section = Section.find(@form.section_id)
        # Check for existing request for the user & section
        request = Request.find_by(user: current_user, section_id: section.id)

        if request.blank?
          @form.save do |hash|
            request = Request.new(hash)
            request.state = 'requested'
            request.user = current_user
            request.save!
          end
        end

        redirect_to editorial_request_path(request)
      else
        redirect_to root_path
      end
    end

    def show
      @rqst = Request.find(params[:id]).decorate
      @requestor = @rqst.user.decorate
      @approver = @rqst.approver.decorate unless @rqst.approver.nil?
      @owners = User.with_role(:owner, @rqst.section)
    end

    def update
      @rqst = Request.find(params[:id])
      authorize! :update, @rqst

      if params[:request][:state] != 'requested' && params[:request][:state].in?(Request.state.values)

        @rqst.transaction do
          if @rqst.state == 'requested'
            @rqst.state = params[:request][:state]
            @rqst.approver = current_user
            @rqst.save!
            @rqst.user.add_role :author, @rqst.section
          end
        end

        flash[:notice] = "You have #{@rqst.state} #{@rqst.user.first_name} access
                          to #{@rqst.section.name}"
      else
        flash[:alert] = 'Unknown approval state'
      end

      redirect_to editorial_root_path

    end

    private

    def request_params
      params.required(:request).permit(:state)
    end

  end
end