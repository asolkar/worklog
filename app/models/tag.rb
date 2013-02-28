class Tag < ActiveRecord::Base
  attr_accessible :id, :name, :color, :user_id

  belongs_to :user

  has_many :taggings
  has_many :entries, :through => :taggings

  validates_presence_of :name, :on => :create
  validates_uniqueness_of :name, :scope => :user_id
  validates_associated :user

  def to_param
    name
  end
end
