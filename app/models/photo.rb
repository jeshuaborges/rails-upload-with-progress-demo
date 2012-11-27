class Photo < ActiveRecord::Base
  attr_accessible :user_id
  mount_uploader :file, ImageUploader

  def file_data=(file)
    self.file.store!(file)
  end
end
