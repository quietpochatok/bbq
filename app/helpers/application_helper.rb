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
asset_pack_path('media/images/mangal.png')
end
private
def bootstrap_class_for(flash_type)
  { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-success" }.stringify_keys[flash_type.to_s] || flash_type.to_s
end
end
