class PhotosController < ApplicationController

	def index

		@id = params[:id]

		@user = User.find(@id)

		@photos = Photo.where('user_id = ?', @user).find(:all)		

	end

end
