class Tag < ActiveRecord::Base
  attr_accessible :id, :name, :user_id

  belongs_to :user

  validates_presence_of :name, :on => :create
  validates_uniqueness_of :name, :scope => :user_id
  validates_associated :user
end
