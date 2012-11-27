require 'pathname'

class PhotosController < ApplicationController
  # Create isnt pulling in the crsf token (which it probably should do)
  protect_from_forgery except: :create

  def new
  end

  # Public: Take uploaded files, resize, move and create record for indexing
  # images.
  def create
    filename = params[:filename]

    photo = PhotoClaimer.new(current_user.id, filename).claim

    render json: {status: 'success', photo: {id: photo.id} }
  end

  def index
    @photos = Photo.scoped_by_user_id(current_user.id)
  end
end
