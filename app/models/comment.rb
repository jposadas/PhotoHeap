class Comment < ActiveRecord::Base
	attr_accessible :date_time, :comment

	belongs_to :photo
	belongs_to :user

end
