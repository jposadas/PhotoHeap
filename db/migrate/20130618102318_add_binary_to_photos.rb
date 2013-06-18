class AddBinaryToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :image, :binary
  end
end
