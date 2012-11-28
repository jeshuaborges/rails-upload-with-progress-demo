require_relative '../../app/models/photo_claimer'

describe PhotoClaimer do
  let(:claimer) { PhotoClaimer.new(1, 'some/path.jpeg') }

  before do
    stub_const('Photo', double(:photo_class).as_null_object)
    stub_const('Tempfile', double(:tempfile_class).as_null_object)
    stub_const('UploadStore', double(:uploadstore_class).as_null_object)
  end

  it 'deletes the uploaded file' do
    file = double(:file).as_null_object
    UploadStore.stub(:get) { file }

    file.should_receive(:destroy)
    claimer.claim
  end

  it 'creates a photo record' do
    file = Class.new do
      def tempfile
        yield 'tempfile'
      end

      def destroy; end
    end.new

    UploadStore.stub(:get) { file }

    Photo.should_receive(:create_from_file!).with(anything, 'tempfile')

    claimer.claim
  end
end
