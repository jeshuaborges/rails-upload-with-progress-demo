require 'carrierwave'
require 'upload_store'

if Rails.env.production?
  fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"]
  }

  CarrierWave.configure do |config|
    config.storage         = :fog
    config.fog_credentials = fog_credentials
    config.fog_directory   = 'worldly-web-photos'
  end

  UploadStore.configure do |config|
    config.fog_credentials = fog_credentials
    config.fog_directory   = 'worldly-web-uploads'
  end

else
  # Disable image resizing logic for test environments
  def enable_processing?
    !!(Rails.env.test? || Rails.env.cucumber?)
  end

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = enable_processing?
  end

  UploadStore.configure do |config|
    config.fog_directory    = 'worldly-web-uploads'
    config.fog_credentials  = {
      :provider   => 'Local',
      :local_root => Rails.root.join('tmp')
    }
  end
end
