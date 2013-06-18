class AddLoginColumn < ActiveRecord::Migration
	
	def change

		add_column :users, :login, :string

	  	User.reset_column_information
		
		User.all.each do |user|
			
			login = user.last_name.downcase
			user.update_attributes! :login => login

		end
  
	end

end
