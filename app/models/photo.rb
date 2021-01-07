class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :photo, presence: true
  mount_uploader :photo, PhotoUploader

  # Scope нужен, чтобы отделить реальные фотки от болванки,
  # которую мы прописали в контроллере событий
  scope :persisted, -> { where "id IS NOT NULL" }
end
