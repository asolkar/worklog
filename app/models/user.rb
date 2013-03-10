class User < ActiveRecord::Base
  attr_accessible :created_at, :username, :email, :fullname, :id,
                  :password_digest, :password, :password_confirmation,
                  :avatar, :avatar_cache, :remove_avatar,
                  :gplus_id, :gplus_refresh_token, :gplus_diaplay_name, :gplus_profile_url,
                  :gplus_avatar_url

  has_secure_password

  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_uniqueness_of :gplus_id
  validates_presence_of :email
  validates_uniqueness_of :email

  mount_uploader :avatar, AvatarUploader

  has_one :avatar
  has_many :logs
  has_many :entries, :through => :logs
  has_many :tags

  def to_param
    username
  end

  #
  # Avatar variations
  #
  def gplus_avatar_thumb_url
    self.gplus_avatar_url + "sz=100"
  end
  def gplus_avatar_tiny_url
    self.gplus_avatar_url + "sz=32"
  end
  def gplus_avatar_badge_url
    self.gplus_avatar_url + "sz=16"
  end
end
