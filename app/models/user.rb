class User < ActiveRecord::Base
	attr_accessible  :first_name, :last_name, :login, :password_digest, :salt

	has_many :photos
	has_many :comments
	has_many :tags

	validates :login, :presence => true
	validate :login_in_database



	
	def login_in_database

		checkUser = User.find_by_login(login)
		
		if checkUser == nil then
			errors.add(:login, "not ok")
		end

	end

	#getter
	def password
		@final_password
	end

	#setter
	def password=(password)

		salt = SecureRandom.urlsafe_base64
		@final_password = password << salt

		#set append save

		password_digest = Digest::SHA1.hexdigest @final_password

		self.salt = salt
		self.password_digest = password_digest

	end


	def fields_present? (password, password_confirmation)
		if first_name == "" || last_name == "" || login == "" || password == "" || password_confirmation == "" then
			return false
		end
		return true

	end

	def login_fields_present?(password)
		if login == "" || password == "" then
			return false
		end
		return true
	end

	def password_valid?(password)

		user = User.find_by_login(login)
		salt = user.salt
		password_append = password << salt

		password_digest = Digest::SHA1.hexdigest password_append
		if password_digest == user.password_digest then
			return true
		end
		return false

	end

	def user_exists?
		
		if User.find_by_login(login) == nil then
			return false
		end
		return true
	
	end

	def fullname
  		"#{first_name} #{last_name}"
	end

end






