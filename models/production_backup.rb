# encoding: utf-8

##
# Backup Generated: production_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t production_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:production_backup, 'Description for production_backup') do
  split_into_chunks_of 250
  compress_with Gzip

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "DATABASE_NAME"
    db.username           = "DATABASE_USERNAME"
    db.password           = "DATABASE_PASSWORD"
    db.host               = "localhost"
    db.port               = 3306
    db.additional_options = ["--quick", "--single-transaction"]
  end

  ##
  # Archive our app
  #
  archive :app_archive do |archive|
    archive.use_sudo
    archive.add '/home/deploy/MYAPP/'
  end

  ##
  # Store on Amazon S3
  #
  store_with S3 do |s3|
    s3.access_key_id = "ACCESS_KEY_ID"
    s3.secret_access_key = "SECRET_ACCESS_KEY"
    s3.region = "us-west-2"
    s3.bucket = "BUCKET_NAME"
    s3.path = "/production/database"
  end

  ##
  # Mail [Notifier]
  #
  notify_by Mail do |mail|
    mail.on_success           = false
    #mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "no-reply@MYDOMAIN.COM"
    mail.to                   = "YOUR_EMAIL_ADDRESS"
    mail.address              = "smtp.mandrillapp.com"
    mail.port                 = 587
    mail.domain               = "YOUR_DOMAIN"
    mail.user_name            = "YOUR_SMTP_USERNAME"
    mail.password             = "YOUR_SMTP_PASSWORD"
    mail.authentication       = "login"
    mail.encryption           = :starttls
  end

end
