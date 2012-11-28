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
    stage_file do |file|
      create_record(file)
    end
  end

  private

  def create_record(file)
    Photo.create_from_file!(@user_id, file)
  end

  # Internal: Creates a tempfile to be read for creating the Photo object.
  # Destroys the uploaded file from the UploadStore once block is left.
  #
  # Returns: yielded value.
  def stage_file
    uploaded = retrieve_uploaded_file
    tempfile = create_tempfile(uploaded.body)

    begin
      value = yield tempfile
      uploaded.destroy
      value
    ensure
      tempfile.close
      tempfile.unlink
    end
  end

  def create_tempfile(body)
    tmp = Tempfile.new(@file_name)
    tmp.write(body)
    tmp.rewind
    tmp
  end

  # Internal: Find the associated uploaded file.
  #
  # Returns: Fog::File instance.
  # Raises FileNotFound error when file cannot be located.
  def retrieve_uploaded_file
    file = UploadStore.get(@file_name)

    raise FileNotFound, "#{@file_name} not found" unless file

    file
  end
end
