module Editorial
  class AssetsController < EditorialController

    before_action ->() { authorize! :create, :asset }, only: [:new, :create]

    def new
      @form = AssetForm.new(Asset.new)
    end

    def create
      @form = AssetForm.new(Asset.new)
      if @form.validate(asset_params)
        @form.sync
        asset = @form.model
        asset.uploader_id = current_user.id
        if asset.save
          flash[:notice] = "Asset created, available at https:#{asset.asset_file.url}"
          redirect_to editorial_root_path and return
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
