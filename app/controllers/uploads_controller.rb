class UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # Public: This receives a binary file and persists it. Use for non production
  # environments only. This is designed to emulate S3 behavior so that
  # functionality can be tested without a S3 dependency.
  def create
    files = params[:files]

    files.each do |file|

      filename  = file.original_filename

      # Rack uploads have `#tempfiles` and test uploads are Tempfile objects. More
      # investigation required.
      file = file.tempfile if file.respond_to?(:tempfile)

      UploadStore.create(
        :key    => filename,
        :body   => file,
        :public => true
      )
    end

    render json: {status: 'success'}
  end
end
