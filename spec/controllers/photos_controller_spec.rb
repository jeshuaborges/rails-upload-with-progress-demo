require 'spec_helper'

describe PhotosController, type: :controller do
  describe '#create' do
    it 'claims photos for the current user' do
      fixture = Rails.root.join('spec/fixtures/world-bar.jpeg')

      UploadStore.create(
        :key    => 'world-bar.jpeg',
        :body   => File.read(fixture),
        :public => true
      )

      post :create, filename: 'world-bar.jpeg'

      expect(Photo.last.user_id).to eq(1)
    end
  end
end
