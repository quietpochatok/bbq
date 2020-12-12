class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Юзер может создавать много событий
  has_many :events

  # Добавим заодно валидации для юзера
  # Имя не не более 35 символов
  validates :name, presence: true, length: {maximum: 35}
  # Уникальный email по заданному шаблону не более 255
  # символов
  # validates :email, presence: true, length: {maximum: 255}
  # validates :email, uniqueness: true
  # validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/
  before_validation :set_name, on: :create

  private

    def set_name
      self.name = "Товарисч №#{rand(777)}" if self.name.blank?
    end
end
