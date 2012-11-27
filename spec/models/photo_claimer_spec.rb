require_relative '../../app/models/photo_claimer'

describe PhotoClaimer do
  let(:claimer) { PhotoClaimer.new(1, 'some/path.jpeg') }

  before do
    stub_const('Photo', double(:photo_class).as_null_object)
    stub_const('Tempfile', double(:tempfile_class).as_null_object)
    stub_const('UploadStore', double(:uploadstore_class).as_null_object)
  end

  it 'errors when file cannot be found' do
    UploadStore.stub(:get) { nil }
    expect{ claimer.claim }.to raise_error(PhotoClaimer::FileNotFound)
  end

  it 'deletes the uploaded file' do
    file = double(:file).as_null_object
    UploadStore.stub(:get) { file }

    file.should_receive(:destroy)
    claimer.claim
  end

  it 'creates a photo record' do
    file = double(:file).as_null_object
    Tempfile.stub(:new) { file }

    Photo.should_receive(:create_from_file!).with(anything, file)
    claimer.claim
  end
end
