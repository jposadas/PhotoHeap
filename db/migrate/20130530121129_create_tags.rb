class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

    	t.integer 	:width
    	t.integer 	:height
    	t.integer	:relx
    	t.integer	:rely

    	t.integer	:user_id


      t.timestamps
    end
  end
end
