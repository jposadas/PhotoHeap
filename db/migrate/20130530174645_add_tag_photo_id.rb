class AddTagPhotoId < ActiveRecord::Migration
  def change
  	add_column :tags, :photo_id, :integer
  end
end
