require_relative './upload_store'

class PhotoClaimer

  class FileNotFound < RuntimeError; end

  def initialize(user_id, file_name)
    @user_id    = user_id
    @file_name  = file_name
  end

  # Public: Do it!
  #
  # Returns a Photo instance.
  def claim
    file = get_upload_file

    photo = file.tempfile do |file|
      create_record(file)
    end

    file.destroy

    photo
  end

  private

  def create_record(file)
    Photo.create_from_file!(@user_id, file)
  end

  def get_upload_file
    UploadStore.get(@file_name)
  end
end
