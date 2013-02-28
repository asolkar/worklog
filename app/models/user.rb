class User < ActiveRecord::Base
  attr_accessible :created_at, :username, :email, :fullname, :id,
                  :password_digest, :password, :password_confirmation,
                  :avatar, :avatar_cache, :remove_avatar

  has_secure_password

  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
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
end
