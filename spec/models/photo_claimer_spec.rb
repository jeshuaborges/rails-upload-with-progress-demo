require_relative '../../app/models/photo_claimer'

describe PhotoClaimer do
  let(:claimer) { PhotoClaimer.new(1, 'some/path.jpeg') }

  before do
    stub_const('Tempfile', double(:tempfile_class).as_null_object)
    claimer.photo_source = ->(*) { double(:photo).as_null_object }
    claimer.upload_storage_source = ->(*) { double(:uploadstore_class).as_null_object }
  end

  it 'errors when file cannot be found' do
    claimer.upload_storage_source = ->(*) { nil }
    expect{ claimer.claim }.to raise_error(PhotoClaimer::FileNotFound)
  end

  it 'deletes the uploaded file' do
    file = double(:file).as_null_object
    claimer.upload_storage_source = ->(*) { file }

    file.should_receive(:destroy)
    claimer.claim
  end

  it 'creates a photo record' do
    claimer.claim.should be
  end

  it 'assigns attaches uploaded file' do
    tempfile = double(:tempfile).as_null_object
    Tempfile.stub(:new) { tempfile }

    photo     = double(:photo)
    photo.should_receive(:file_data=).with(tempfile)
    photo.should_receive(:save!)

    claimer.photo_source = ->(*) { photo }

    claimer.claim
  end
end
