# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  def self.file?
    storage == CarrierWave::Storage::File
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
