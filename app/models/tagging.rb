class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :entry
  # attr_accessible :title, :body
end
