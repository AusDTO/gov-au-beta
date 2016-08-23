namespace :db do

  desc 'Dumps the database to file'
  task :dump => :environment do

    url = ActiveRecord::Base.connection_config[:url]
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]

    cmd = "pg_dump --no-owner --no-acl -v -c -f #{dump_file} --no-password "
    # Adapt the app database config for pg_dump. Use the db connection url, or
    # fallback to using a local unix socket.
    cmd += url || "--host #{host} --dbname #{db}"

    puts 'Running pg_dump...'
    unless system cmd
      raise 'Database dump failed'
    end
  end

  desc 'Scrubs database dump file and uploads to S3'
  task :s3upload => :dump do
    begin
      scrubbed_file = File.join(Dir.tmpdir, 'db_scrubbed.sql')
      s3_key = "db_#{ENV['APP_DOMAIN']}.sql"
      s3_bucket = ENV['AWS_DB_S3UPLOAD_BUCKET']

      raise 'AWS_DB_S3UPLOAD_BUCKET cannot be empty' if s3_bucket.blank?

      unless system "#{Rails.root}/bin/scrub.rb #{dump_file} > #{scrubbed_file}"
        raise 'Database scrub failed'
      end

      puts 'Uploading to S3...'
      s3 = Aws::S3::Resource.new
      s3.bucket(s3_bucket).object(s3_key).upload_file(scrubbed_file)
    ensure
      File.delete(dump_file) if File.exist?(dump_file)
      File.delete(scrubbed_file) if File.exist?(scrubbed_file)
    end
  end

  private

  def dump_file
    File.join(Dir.tmpdir, 'db_dump.sql')
  end

end
