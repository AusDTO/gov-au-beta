module Editorial
  class AssetsController < EditorialController

    before_action ->() { authorize! :create, :asset }, only: [:new, :create]

    def index
      @assets = Asset.order(updated_at: :desc).page params[:page]
    end

    def new
      @form = AssetForm.new(Asset.new)
    end

    def create
      @form = AssetForm.new(Asset.new)
      if @form.validate(asset_params)
        @form.sync
        asset = @form.model
        asset.uploader = current_user
        if asset.save
          flash[:notice] = "Asset successfully created"
          redirect_to editorial_assets_path and return
        end
      end

      render :new
    end

    private

    def asset_params
      params.required(:asset).permit(:asset_file)
    end

  end
end
