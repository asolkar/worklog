class Log < ActiveRecord::Base
  attr_accessible :description, :id, :name, :user_id

  belongs_to :user
  has_many :entries
  has_many :tags

  validates_presence_of :name, :on => :create
  validates_presence_of :description, :on => :create
  validates_uniqueness_of :name, :scope => :user_id
  validates_associated :user, :entries
end
