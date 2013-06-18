class CommentsController < ApplicationController

	def new

		if session[:loggedin] == nil then
			flash[:notice] = "You must be logged in to post comments."
			redirect_to "/users/login"
			return
		end

		
		@photo_id = params[:id]
		@photo = Photo.find(@photo_id)
		@comment = Comment.new
		@photo_owner = User.find(@photo.user_id).first_name



	end

	def create

		if session[:loggedin] == nil then
			flash[:notice] = "You must be logged in to post comments."
			redirect_to "/users/login"
			return
		end
	
		@comment = Comment.new(params[:comment])

		if @comment.valid? then
			
			
			@comment.photo_id = params[:id]
			@comment.user_id = session[:loggedin].id
			@comment.date_time = DateTime.now
			@comment.save

			@photo_owner = Photo.find(@comment.photo_id).user_id

			redirect_to "/photos/index/#{@photo_owner}"

		else

			flash[:notice] = "* You need to enter some text"
			redirect_to :action => "new/#{params[:id]}"
		
		end

	end

end
