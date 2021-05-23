class User < ApplicationRecord
  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:real_time]
  )

  validates :first_name, :last_name, :email, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable

  ROLES = ["User", "Admin"]

  has_many :orders, dependent: :delete_all
  has_many :trades, dependent: :delete_all

  has_rich_text :bio

  has_one_attached :profile_image, dependent: :destroy

  before_create :setup_role

  def full_name
    first_name + " " + last_name
  end

  def setup_role
    self.role = "User"  
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end


  def active_for_authentication?
    super 
  end

  validate :acceptable_profile_image

  def acceptable_profile_image
    return unless profile_image.attached?
    
    unless profile_image.byte_size <= 10.megabyte
        errors.add(:profile_image, "is too big. Must be less than 10 MB")
    end
  end

end
