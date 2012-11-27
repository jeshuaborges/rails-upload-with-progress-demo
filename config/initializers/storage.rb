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
    config.fog_directory   = 'permanent-bucket'
  end

  UploadStore.configure do |config|
    config.fog_credentials = fog_credentials
    config.fog_directory   = 'temporary-bucket'
  end

else
  # Disable image resizing logic for test environments
  def enable_processing?
    !!(Rails.env.test? || Rails.env.cucumber?)
  end

  temp_path = Rails.root.join('tmp')

  # We cannot guarantee ./tmp path exists for all environments
  FileUtils.mkdir_p(temp_path)

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = enable_processing?
  end

  UploadStore.configure do |config|
    config.fog_directory    = 'folder-name'
    config.fog_credentials  = {
      :provider   => 'Local',
      :local_root => temp_path
    }
  end
end
