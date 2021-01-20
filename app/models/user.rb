class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Юзер может создавать много событий
  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # has_many :events
  validates :name, presence: true, length: {maximum: 35}
  # Уникальный email по заданному шаблону не более 255 символов
  # validates :email, presence: true, length: {maximum: 255}
  # validates :email, uniqueness: true
  # validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/
  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  mount_uploader :avatar, AvatarUploader


  private

  def set_name
    self.name = "Товарисч №#{rand(777)}" if self.name.blank?
  end

  # этот метод позволяет пользователю после регистрации присвоить комменты и другие данные, которые он оставлял
  # ранее до регистрации и был просто пользователем с именем и почтой в форме подписки на ивент.
  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
      .update_all(user_id: self.id)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
