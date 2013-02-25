class Entry < ActiveRecord::Base
  attr_accessible :body, :id, :log_id

  belongs_to :log
  has_many :tags

  validates_presence_of :body, :on => :create
end
