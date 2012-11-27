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
    photo = create_record

    delete_file

    photo
  end

  private

  def create_record
    photo = Photo.create!(user_id: @user_id)

    # parent model must have identity before saving because the id
    # is used for the file path.
    photo.file.store!(tempfile)
    photo.save!

    photo
  end

  def tempfile
    tmp = Tempfile.new(@file_name)
    tmp.write(uploaded_file.body)
    tmp.rewind
    tmp
  end

  def delete_file
    uploaded_file.destroy
  end

  # Internal: Find the associated uploaded file.
  #
  # Returns: Fog::File instance.
  # Raises FileNotFound error when file cannot be located.
  def uploaded_file
    @uploaded_file ||= UploadStore.get(@file_name)

    raise FileNotFound, "#{@file_name} not found" unless @uploaded_file

    @uploaded_file
  end
end
