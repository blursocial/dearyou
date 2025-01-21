class User < ApplicationRecord
  # Associations
  has_many :settings, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Users following this user
  has_many :received_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :received_follows, source: :follower

  # Users this user is following
  has_many :given_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, through: :given_follows, source: :followed

  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Validations
  validates :username, presence: true, uniqueness: true,
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only include letters, numbers, and underscores" }
  validates :name, length: { maximum: 50 }, allow_blank: true
  validates :bio, length: { maximum: 300 }, allow_blank: true
  validates :role, inclusion: { in: %w[ADMIN MODERATOR USER] }

  # Default role
  after_initialize do
    self.role ||= "USER" if new_record?
  end

  # Settings helpers
  def setting(key)
    settings.find_by(key: key)&.value
  end

  def update_setting(key, value)
    setting = settings.find_or_initialize_by(key: key)
    setting.update(value: value)
  end

  # Helper methods
  def following?(user)
    given_follows.exists?(followed: user, status: "accepted")
  end

  def followed_by?(user)
    received_follows.exists?(follower: user, status: "accepted")
  end

  # Role checks
  def admin?
    role == "ADMIN"
  end

  def moderator?
    role == "MODERATOR"
  end

  def user?
    role == "USER"
  end
end
