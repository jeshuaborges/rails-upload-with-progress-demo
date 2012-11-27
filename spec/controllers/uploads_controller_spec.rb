require 'spec_helper'

describe UploadsController, type: :controller do
  let(:file_fixture) { fixture_file_upload('/world-bar.jpeg', 'image/jpeg') }

  describe '#upload' do
    it 'uploads' do
      post :create, :files => [file_fixture]

      response.should be_success
    end
  end
end
