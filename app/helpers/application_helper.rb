module ApplicationHelper
  # здесь только доступно во вьюхах!
  def bootstrap_flash(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do
        concat content_tag(:button, '×', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
  nil
  end

  def user_avatar(user)
    if user.avatar?
      user.avatar.url
    else
      asset_pack_path('media/images/mangal.png')
    end
  end

  # Возвращает миниатюрную версию фотки
  def user_avatar_thumb(user)
    if user.avatar.file.present?
      user.avatar.thumb.url
    else
      asset_pack_path('media/images/mangal.png')
    end
  end

  def event_photo(event)
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.url
    else
      asset_pack_path('media/images/event.jpg')
    end
  end

  # Возвращает миниатюрную версию фотки
  def event_thumb(event)
    # добавлять фотографию к событию можно(есть болванка в контроллере events для этого)
    # persisted нужно для того,чтобы фотка приклеп-я к событию попала в БД
    # persisted - scope прописана в модели Photo, чтобы все это работало
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.thumb.url
    else
      asset_path('event_thumb.jpg')
    end
  end

  def minimum_password_length
    if @minimum_password_length
     "Password #{@minimum_password_length} characters minimum"
    end
  end

  def fa_icon(icon_class)
     content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

private
  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-success" }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
