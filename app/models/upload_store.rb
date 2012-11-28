require 'active_support/core_ext/module/delegation'
require 'fog'
require 'singleton'

# Public: Uploads are all two stage. First files are uploaded from the client
# to the uploads directory where they are staged until they are processed
# and permanently moved to the photo directory. This is done to achieve the
# most platform flexibility possible. For our initial implementation we will be
# using XHR2 and CORS to upload files to S3 and then processing the uploaded
# files with another process. This means that rails doesn't have to be
# responsible for the connection while transferring the file.
class UploadStore
  include Singleton

  class << self
    delegate :configure, :connection, :directory, :create, :get, to: :instance
  end

  attr_accessor :fog_credentials, :fog_directory

  def configure
    yield self
  end

  def connection
    @connection ||= Fog::Storage.new(fog_credentials)
  end

  # Public: Photo storage directory.
  #
  # Returns a Fog directory object.
  def directory
    @directory ||= get_directory || create_directory
  end

  # Internal: Gets or upload directory
  #
  # Returns a Fog directory object.
  def get_directory
    connection.directories.get(fog_directory)
  end

  # Public: Create file from hash.
  #
  # Returns a Fog file object.
  def create(opts)
    directory.files.create(opts)
  end

  # Public: Retrieve file from location.
  #
  # Returns a FileUpload file object.
  def get(filename)
    file = directory.files.get(filename)

    file ? UploadFile.new(file) : nil
  end

  # Internal: creates upload directory.
  #
  # Returns a Fog directory object.
  def create_directory
    connection.directories.create({
      :key    => fog_directory,
      :public => true
    })
  end
end
