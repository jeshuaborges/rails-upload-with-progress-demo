require 'upload_store'

describe UploadStore do
  subject { UploadStore.send(:new) }

  it 'accepts configuration' do
    subject.configure do |config|
      config.fog_credentials = {}
      config.fog_directory = 'something'
    end
  end

  it 'creates a fog storage' do
    stub_const('Fog::Storage', double(:storage_class))
    Fog::Storage.should_receive(:new)
    subject.connection
  end

  it 'it returns the upload directory' do
    subject.stub(:create_directory)
    subject.should_receive(:get_directory)
    subject.directory
  end

  it 'creates the upload directory if it doesnt exist' do
    subject.stub(:get_directory) { nil }
    subject.should_receive(:create_directory)
    subject.directory
  end
end
