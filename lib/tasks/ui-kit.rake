require 'net/http'
require 'zip'

namespace :ui_kit do
  desc 'Sets up UI kit with updates. To download from a custom url (eg circleci), define UI_KIT_URL.'

  task :update do
    def download_asset(name, destination)
      ui_kit_url = ENV['UI_KIT_URL'] || "http://gov-au-ui-kit.apps.staging.digital.gov.au/latest/"
      path_to_file = "vendor/assets/"+destination
      File.delete(path_to_file) if File.exist?(path_to_file)
      file = File.new path_to_file, 'wb+'
      file.write Net::HTTP.get(URI.parse(ui_kit_url+name))
      puts destination +" updated"
    end

    def patch_scss(destination)
      file_name = "vendor/assets/"+destination
      text = File.read(file_name)
      # strip out the ui-kit image-url function which overrides the rails one
      text = text.gsub(/@function image-url\(\$url\) {.*?^}/m, '')
      file = File.new file_name, 'wb+'
      file.write text

      puts destination +" patched"
    end

    def unzip(destination)
      file_path = "vendor/assets/"+destination
      Zip::File.open(file_path) { |zip_file|
        zip_file.each { |f|
          f_path=File.join("vendor/assets/images", f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          if File.exist?(f_path) and not File.directory?(f_path)
            File.delete(f_path)
          end
          zip_file.extract(f, f_path)
        }
      }
      puts destination +" unzipped"
    end

    download_asset("ui-kit.js", "javascripts/ui-kit.js")
    download_asset("_ui-kit.scss", "stylesheets/_ui-kit.scss")
    patch_scss("stylesheets/_ui-kit.scss")
    download_asset("images.zip", "images.zip")
    unzip("images.zip")
  end
end
