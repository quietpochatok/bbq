class EventMailSendlerJob < ApplicationJob
  queue_as :default

  def perform(class_object)
    event = class_object.event
    # Собираем всех подписчиков и автора события в массив мэйлов, исключаем повторяющиеся
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [class_object.user&.email]).uniq

    # По адресам из этого массива делаем рассылку
    # Как и в подписках, берём EventMailer и его метод comment с параметрами
    # И отсылаем в том же потоке
    if class_object.is_a?(Comment)
      all_emails.each do |mail|
        EventMailer.comment(event, class_object, mail).deliver_later
      end
    elsif class_object.is_a?(Photo)
      all_emails.each do |mail|
        EventMailer.photo(event, class_object, mail).deliver_later
      end
    else class_object.is_a?(Subscription)
      EventMailer.subscription(event, class_object).deliver_later
    end
  end
end
