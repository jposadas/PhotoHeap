class Tag < ActiveRecord::Base
   attr_accessible :relx, :rely, :width, :height, :user_id, :photo_id

  	belongs_to :user
  	belongs_to :photo

  	validates :relx, :rely, :width, :height, :presence => true

  	def isUserPresent

  		if user_id == nil then
  			return true
  		end
  		
  		return false
  	end

    def forQuery


      result = {:name => self.user.fullname, :filename => self.photo.file_name, :photo_id => photo.id, :user_id => photo.user_id}
  
      return result

    end


end
