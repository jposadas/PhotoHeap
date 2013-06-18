class PhotosController < ApplicationController

	def index

		@id = params[:id]

		@user = User.find(@id)

		@photos = Photo.where('user_id = ?', @user).find(:all)		

		@counter = 1

	end

	def new
	
		if session[:loggedin] == nil then
			flash[:notice] = "You must be logged in to upload photos"
			redirect_to "/users/login"
			return
		end

		@photo = Photo.new

	end

	def create

		if session[:loggedin] == nil then
			flash[:notice] = "You must be logged in to upload photos"
			redirect_to "/users/login"
			return
		end

		@photo = params[:photo]
		if @photo == nil then

			flash[:notice] = "*You need to select a picture"
			redirect_to :action => "new"
			return

		else 

			@photo = @photo[:picture]

			File.open(Rails.root.join('public', 'images', @photo.original_filename), 'wb') do |file|
				file.write(@photo.read)
			end

			user_id = session[:loggedin].id

			new_photo = Photo.new
			new_photo.user_id = user_id
			new_photo.date_time = DateTime.now
			new_photo.file_name = @photo.original_filename

			new_photo.save

			redirect_to :action => "index/#{user_id}"

		end


	end


end
