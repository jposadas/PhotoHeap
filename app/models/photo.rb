class Photo < ActiveRecord::Base
	attr_accessible :date_time, :file_name

	has_many :comments
	belongs_to :user

end
