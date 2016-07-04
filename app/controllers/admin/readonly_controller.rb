# A quick wrapper around administrate controllers for readonly models
# Theoretically it shouldn't show the new/edit buttons at all but that would require a lot more work
class Admin::ReadonlyController < Admin::ApplicationController
  def new
    flash[:notice] = 'This model is read only'
    redirect_to action: :index
  end

  def create
    flash[:notice] = 'This model is read only'
    redirect_to action: :index
  end

  def edit
    flash[:notice] = 'This model is read only'
    redirect_to action: :show
  end

  def update
    flash[:notice] = 'This model is read only'
    redirect_to action: :show
  end
end
