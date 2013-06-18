class AddPasswordSalt < ActiveRecord::Migration
 	
	def change

		add_column :users, :password_digest, :string
		add_column :users, :salt, :integer
	end

end
