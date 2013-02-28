class Entry < ActiveRecord::Base
  attr_accessible :body, :id, :log_id, :tag_list

  belongs_to :log

  has_many :taggings
  has_many :tags, :through => :taggings

  validates_presence_of :body, :on => :create

  def self.tagged_with(name)
    Tag.find_by_name!(name).entries
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
