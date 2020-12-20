class ApplicationController < ActionController::Base
  # Настройка для работы Девайза, когда юзер правит профиль
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?
  helper_method :current_user_can_subscribe?
  helper_method :event_photo_for_email

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  # добавили, чтобы кнопка изменить событие было только у создателя
  def current_user_can_edit?(model)
    # Если у модели есть юзер и он залогиненный, пробуем у неё взять .event
    # Если он есть, проверяем его юзера на равенство current_user.
    user_signed_in? && (
      model.user == current_user ||
      (model.try(:event).present? && model.event.user == current_user)
    )
  end

  def current_user_can_subscribe?(event)
    event.user == current_user
  end

  def event_photo_for_email(event)
    photos = event.photos.persisted

    if photos.any?
      photos.photo.url
    else
      asset_pack_path('media/images/event.jpg')
    end
  end
end
