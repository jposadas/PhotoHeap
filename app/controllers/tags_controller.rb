class TagsController < ApplicationController

	def new

		if session[:loggedin] == nil then
			flash[:notice] = "* You must be logged in to tag photos"
			redirect_to "/users/login"
			return
		end

		@id = params[:id]
		@photo = Photo.find(@id)
		@user = @photo.user
		users = User.find(:all)
		@selectOptions = [["Select One", nil]]
		
		users.each do |u|
			fullName = [] << u.fullname << u.id
			@selectOptions << fullName
		end
	

	end

	def create

		if session[:loggedin] == nil then
			flash[:notice] = "* You must be logged in to tag photos"
			redirect_to "/users/login"
			return
		end

		form = params[:tag]
		user_id = form["user"]
		@tag = Tag.new



		@tag.user_id = user_id
		@tag.photo_id = params[:id]
		@tag.relx = form[:relX]
		@tag.rely = form[:relY]
		@tag.width = form[:width]
		@tag.height = form[:height]

		if @tag.isUserPresent then
			flash[:notice] = "* You need to specify a person tagged"
			redirect_to :action => "new/#{params[:id]}"
			return
		end

		if @tag.valid? then

			@tag.save(:validate => false)
			redirect_to "/tags/index/#{@tag.photo_id}"
			
		else
			flash[:notice] = "* Please tag someone."
			redirect_to :action => "new/#{params[:id]}"
			return
		end
	end

	def index

		photo_id = params[:id]
		@photo = Photo.find(photo_id);
		@user = @photo.user
		@tags = @photo.tags

	end


end
