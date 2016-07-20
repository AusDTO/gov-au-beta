require 'net/http'
namespace :ui_kit do
  desc 'Sets up UI kit with updates'

  task :update do
    def download_asset(name, destination)
      ui_kit_url = "http://gov-au-ui-kit.apps.staging.digital.gov.au/latest/"
      file = File.new "vendor/assets/"+destination, 'wb+'
      file.write  Net::HTTP.get(URI.parse(ui_kit_url+name))
      puts destination
    end

    download_asset("ui-kit.js", "javascripts/ui-kit.js")
    download_asset("_ui-kit.scss", "stylesheets/_ui-kit.scss")
    download_asset("ui-kit-icons.css", "stylesheets/ui-kit-icons.css")
  end
end