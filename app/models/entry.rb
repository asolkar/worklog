class Entry < ActiveRecord::Base
  attr_accessible :body, :id, :log_id, :tags

  belongs_to :log
  has_many :tags

  validates_presence_of :body, :on => :create
end
