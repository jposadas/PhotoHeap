class Comment < ActiveRecord::Base
	attr_accessible :date_time, :comment

	belongs_to :photo
	belongs_to :user

	validates :comment, :presence => true


	def forQuery


		result = {:name => "comment", :filename => photo.file_name, :photo_id => photo.id, :user_id => photo.user_id}

	end

end


