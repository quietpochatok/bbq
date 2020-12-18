class Event < ApplicationRecord
  belongs_to :user

  # У события много комментариев и подписок
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :photos

  # У события много подписчиков (объекты User), через таблицу subscriptions,
  # по ключу user_id !!!!
  has_many :subscribers, through: :subscriptions, source: :user
  # В Rails 5 связи belongs_to :user валидируются :user  по умолчанию
  # Валидируем заголовок, он не может быть длиннее 255 букв
  validates :title, presence: true, length: {maximum: 255}
  # У события должны быть заполнены место и время
  validates :address, presence: true
  validates :datetime, presence: true

# Метод, который возвращает всех, кто пойдет на событие:
# всех подписавшихся и организатора
  def visitors
    (subscribers + [user]).uniq
  end
def pincode_valid?(pin2chek)
  pincode == pin2chek
end

end
