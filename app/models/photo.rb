class Photo < ActiveRecord::Base
  attr_accessible :user_id
  mount_uploader :file, ImageUploader
end
