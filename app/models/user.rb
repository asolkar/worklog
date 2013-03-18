include ActiveModel::WorklogSecurePassword
class User < ActiveRecord::Base

  attr_accessible :created_at, :username, :email, :fullname, :id,
                  :password_digest, :password, :password_confirmation,
                  :avatar, :avatar_cache, :remove_avatar,
                  :gplus_id, :gplus_refresh_token, :gplus_display_name, :gplus_profile_url,
                  :gplus_avatar_url

  #
  # Validate password only for native accounts, not for Google+ connections
  #
  worklog_has_secure_password :validations => false

  validates_presence_of :password_digest, :on => :create, :if => :is_native_account?
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :fullname
  validates_uniqueness_of :gplus_id, :if => :has_gplus_account?
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
  # 
  #
  def is_native_account?
    logger.debug "GPLUS_ID: #{self.gplus_id}"
    self.gplus_id == nil
  end
  def has_gplus_account?
    logger.debug "GPLUS_ID: #{self.gplus_id}"
    self.gplus_id != nil
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
