class Asset < ActiveRecord::Base
  #belongs_to :uploader, class_name: "User"

  has_attached_file :asset_file,
                    adapter_options: { hash_digest: Digest::SHA1 },
                    styles: { medium: "300x300>", thumb: "125x125>" }, # https://www.imagemagick.org/Usage/resize/#resize
                    storage: :s3,
                    s3_region: ENV['AWS_REGION'],
                    s3_credentials: {:bucket => ENV['AWS_DB_S3UPLOAD_BUCKET'],
                                     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                                     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
                    path: "/assets/:fingerprint-:style.:extension", # path determines location on S3 https://github.com/thoughtbot/paperclip/tree/master/lib/paperclip/interpolations.rb#L159
                    s3_host_alias: "s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_DB_S3UPLOAD_BUCKET']}", # The fully-qualified domain name (FQDN) that is the alias to the S3 domain of your bucket.
                    url: ":s3_alias_url"

   validates_attachment :asset_file,
                        presence: true,
                        content_type: { content_type: /\Aimage\/.*\z/ },
                        size: { in: 0..5.megabytes }
end