class UploadFile
  attr_reader :fog_file

  def initialize(fog_file)
    @fog_file = fog_file
  end

  def tempfile
    tmp = Tempfile.new(fog_file.key)

    begin
      tmp.write(fog_file.body)
      tmp.rewind
      yield tmp
    ensure
      tmp.close
      tmp.unlink
    end
  end

  def destroy
    fog_file.destroy
  end
end
