module Editorial
  class UsersController < EditorialController

    before_action ->() { authorize! :create, :user }, only: [:new, :create]

    def new
      @form = UserForm.new(User.new)
    end

    def create
      @form = UserForm.new(User.new)
      if @form.validate(user_params)
        @form.sync
        tmp_password = SecureRandom.base64(12)
        user = @form.model
        user.password = tmp_password
        user.password_confirmation = tmp_password
        user.skip_confirmation_notification!
        if user.save
          user.send_invite_email
          flash[:notice] = 'An email has been sent to the user inviting them to join GOV.AU'
          redirect_to editorial_root_path and return
        end
      end
      render :new
    end

    private

    def user_params
      params.required(:user).permit(:email, :first_name, :last_name)
    end

  end
end
