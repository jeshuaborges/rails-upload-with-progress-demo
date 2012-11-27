require_relative './upload_store'

class PhotoClaimer
  attr_writer :photo_source
  attr_writer :upload_storage_source

  class FileNotFound < RuntimeError; end

  def initialize(user_id, file_name)
    @user_id    = user_id
    @file_name  = file_name
  end

  # Public: Do it!
  #
  # Returns a Photo instance.
  def claim
    photo_source.call(user_id: @user_id).tap do |photo|
      # parent model must have identity before saving because the id
      # is used for the file path.
      begin
        photo.file_data = tempfile # move `photo.file.store!(tempfile)` into Photo#store_file!
        photo.save!
      rescue Exception => e
        photo.destroy
        # logging?
        raise e
      end
    end
  end

  private

  def photo_source
    @photo_source ||= Photo.public_method(:create!)
  end

  def upload_storage_source
    @upload_storage_source ||= UploadStore.public_method(:get)
  end

  def tempfile
    tmp = Tempfile.new(@file_name)

    stage_file do |file|
      tmp.write(file.body)
    end

    tmp.rewind
    tmp
  end

  # Internal: Find the associated uploaded file.
  #
  # Returns: Fog::File instance.
  # Raises FileNotFound error when file cannot be located.
  def stage_file(&block)
    file = upload_storage_source.call(@file_name)

    raise FileNotFound, "#{@file_name} not found" unless file

    begin
      block.call(file)
    ensure
      file.destroy
    end
  end
end
