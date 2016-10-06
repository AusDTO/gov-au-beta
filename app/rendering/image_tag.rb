class ImageTag < Liquid::Tag

  def initialize(tag_name, image_fingerprint, tokens)
    super
    @image_fingerprint = image_fingerprint.strip!
  end

  def render(context)
    image = Asset.find_by(:asset_file_fingerprint => @image_fingerprint)
    if image
      "<img alt='#{CGI.escapeHTML(image.alttext)}' src='#{image.asset_file.url}/>"
    else
      raise "Unknown image fingerprint: #{@image_fingerprint}"
    end
  end
end