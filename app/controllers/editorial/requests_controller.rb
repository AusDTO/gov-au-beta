module Editorial
  class RequestsController < Editorial::SectionsController
    decorates_assigned :owners
    decorates_assigned :rqst, with: RequestDecorator
    decorates_assigned :requestor, with: UserDecorator

    check_authorization

    rescue_from ActiveRecord::RecordNotFound do
      redirect_to root_path
    end

    def new
      @form = RequestForm.new(Request.new(section: @section))
      @owners = User.with_role(:owner, @section)

      if (rq = Request.find_by(section: @section, user: current_user))
        flash[:notice] = 'You have already requested membership to this group'
        redirect_to editorial_section_request_path(@section, rq)
      end
    end

    def create
      @form = RequestForm.new(Request.new)

      if @form.validate(request_params)
        # Check for existing request for the user & section
        request = @section.requests.find_by(user: current_user)

        if request.blank?
          request = @section.requests.create!(
            message: @form.message,
            state: 'requested',
            user: current_user
          )
        end
        Notifier.author_request(request).deliver_later
        redirect_to editorial_section_request_path(@section, request)
      else
        redirect_to root_path
      end
    end

    def show
      @rqst = Request.find(params[:id])
      authorize! :show, @rqst
      @requestor = @rqst.user
      @approver = @rqst.approver.decorate unless @rqst.approver.nil?
      @owners = User.with_role(:owner, @rqst.section)
      with_caching([@rqst, @requestor, @approver, *@owners])
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

    protected

    # Users can see requests even if they aren't a collaborator on the section
    def skip_view_section_auth?
      true
    end

    private

    def request_params
      params.required(:request).permit(:message)
    end

  end
end
