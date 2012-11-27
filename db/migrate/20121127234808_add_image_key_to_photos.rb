class AddImageKeyToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :path_key, :string
    rename_column :photos, :file, :filename
  end
end
