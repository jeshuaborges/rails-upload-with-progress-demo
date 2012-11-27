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
    Photo.should_receive(:create!)
    claimer.claim
  end

  it 'assigns attaches uploaded file' do
    tempfile  = double(:tempfile).as_null_object
    uploader  = double(:uploader)
    photo     = double(:photo, file: uploader)

    Photo.stub!(:create!) { photo }
    Tempfile.stub(:new) { tempfile }

    uploader.should_receive(:store!).with(tempfile)
    photo.should_receive(:save!)

    claimer.claim
  end
end
