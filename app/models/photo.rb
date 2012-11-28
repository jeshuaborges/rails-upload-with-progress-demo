class Photo < ActiveRecord::Base
  attr_accessible :user_id, :filename

  mount_uploader :file, ImageUploader, mount_on: :filename

  def self.create_from_file!(user_id, file)
    transaction do
      photo = create!(user_id: user_id)
      photo.file.store!(file)
      photo.save!
      photo
    end
  end
end
