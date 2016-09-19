namespace :db do
  desc 'Uploads a scrubbed database dump to S3'
  task :'s3:upload', [:key] => :environment do |t, args|
    args.with_defaults(:key => "db_#{ENV['APP_DOMAIN']}.sql")

    Tempfile.open(['dump', '.sql']) do |dump_file|
      puts "Dumping database to #{dump_file.path}..."
      cmd = "pg_dump --no-owner --no-acl -v -c -f #{dump_file.path} --no-password #{connection_info}"
      unless system cmd
        raise 'Database dump failed'
      end

      Tempfile.open(['scrub', '.sql']) do |scrub_file|
        puts 'Scrubbing...'
        unless system "#{Rails.root}/bin/scrub.rb #{dump_file.path} > #{scrub_file.path}"
          raise 'Database scrub failed'
        end

        puts "Uploading to S3 as '#{args.key}'..."

        s3 = Aws::S3::Resource.new(:credentials => aws_creds)
        s3.bucket(s3_bucket).object(args.key).upload_file(scrub_file.path)
        puts 'Upload complete'
      end
    end
  end

  desc 'Import a database dump from S3'
  task :'s3:import', [:key] => :environment do |taskname, args|
    unless args.key.present?
      abort "You must specify an S3 key to import e.g. rake #{taskname}[db_gov-au-beta.example.gov.au.sql]"
    end

    s3 = Aws::S3::Client.new(:credentials => aws_creds)

    Tempfile.open(['downloaded', '.sql']) do |file|
      puts "Downloading '#{args.key}' from S3..."
      s3.get_object(response_target: file.path, bucket: s3_bucket, key: args.key)

      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke

      puts 'Running restore...'
      unless system "psql #{connection_info} < #{file.path}"
        raise 'Database restore failed'
      end
    end

    # It is recommended to run Analyze after a restore
    unless system "psql #{connection_info} -c 'ANALYZE'"
      raise 'Analyze failed'
    end

    puts 'Running migrations...'
    Rake::Task['db:migrate'].invoke

    # Passwords should have been sanitized, so reset them all to something valid
    password = ENV['SEED_USER_PASSWORD']
    raise 'SEED_USER_PASSWORD cannot be empty' if password.blank?
    User.all.each { |user| user.update!(password: password,
                                        password_confirmation: password,
                                        bypass_tfa: true) }

    # An Admin user might be handy
    admin = User.create!(email: 'admin@example.gov.au',
                         password: password,
                         confirmed_at: DateTime.now,
                         bypass_tfa: true)
    admin.add_role :admin

    puts 'Restore complete'
  end

  private

  def s3_bucket
    s3_bucket = ENV['AWS_DB_S3UPLOAD_BUCKET']
    raise 'AWS_DB_S3UPLOAD_BUCKET cannot be empty' if s3_bucket.blank?
    s3_bucket
  end

  # Database connection info for psql and pg_dump
  def connection_info
    ENV['DATABASE_URL']
  end

  def aws_creds
    Aws::Credentials.new(ENV['AWS_S3_ACCESS_KEY_ID'], ENV['AWS_S3_SECRET_ACCESS_KEY'])
  end
end
