Fabricator(:asset) do
  asset_file {
         Rack::Test::UploadedFile.new(
               "./app/assets/images/icons/chevron-black.png",
               "image/png"
         )
       }
end
