class UsersController < ApplicationController

	# require 'json'

	def index

		@users = User.find(:all)

	end

	def login

		if session[:loggedin] then
			flash[:notice] = "You are already logged in"
			redirect_to "/photos/index/#{session[:loggedin].id}"
		end

	end

	def post_login
		
		@login_user = User.new
		@login_user.login = params[:user][:login]
		input_password = params[:user][:password]

		
		if @login_user.login_fields_present?(input_password) then

			if @login_user.user_exists? then

				if @login_user.password_valid?(input_password) then

					@user = User.find_by_login(@login_user.login)
					session[:loggedin] = @user
					redirect_to "/photos/index/#{@user.id}"
				
				else

					flash[:notice] = "* Wrong Password. Please try again."
					redirect_to :action => "login"

				end

			else

				flash[:notice] = " * User doesn't exist. Please try again."
				redirect_to :action => "login"

			end

		
		else
			
			flash[:notice] = " * Some fields are missing. Please try again."
			redirect_to :action => "login"
		
		end

	end

	def logout
		reset_session
		redirect_to :action => "login"
	end

	def new
		if session[:loggedin] then
			flash[:notice] = "You are already logged in. You cant register a new user."
			redirect_to "/photos/index/#{session[:loggedin].id}"
			return
		end
	end

	def create
		if session[:loggedin] then
			flash[:notice] = "You are already logged in. You cant register a new user."
			redirect_to "/photos/index/#{session[:loggedin].id}"
			return
		end


		@user = params[:user]
		@register = User.new
		@register.first_name = @user[:first_name]
		@register.last_name = @user[:last_name]
		@register.login = @user[:login]

		if @register.fields_present?(@user[:password], @user[:password_confirmation]) then

			if @user[:password] != @user[:password_confirmation] then
				flash[:notice] = "* Passwords don't match. Try again."
				redirect_to :action => "new"
			else

				@register.password = @user[:password]
				@register.save(:validate => false)
				redirect_to :action => "login"
			end

		else
			flash[:notice] = "* Some fields are missing. Try again."
			redirect_to :action => "new"
		end

	


	end

	def search

		query = params[:text].downcase

		photos = Photo.find(:all)

		result = []
		resultTags = []
		resultComm = []
		
		photos.each do |photo| 

			tags = photo.tags
			tags.each do |tag| 
				
				user = tag.user
				if user.fullname.downcase.include? query then		
					
					if !(resultTags.include? tag.forQuery[:filename]) then

						resultTags << tag.forQuery[:filename]
						result << tag.forQuery
					end

				end

			end

			comments = photo.comments


			comments.each do |comment|
				text = comment.comment
				if text.downcase.include? query then

					if !(resultComm.include? comment.forQuery[:filename]) then
						resultComm << comment.forQuery[:filename]
						result << comment.forQuery
					end


				end

			end

		end

		render :json => result
	end

end
