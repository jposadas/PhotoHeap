class ChangeSalt < ActiveRecord::Migration
  def change
  	change_column(:users, :salt, :string)
  end
end
