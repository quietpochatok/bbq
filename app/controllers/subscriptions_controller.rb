# (с) goodprogrammer.ru
#
# Контроллер вложенного ресурса подписок
class SubscriptionsController < ApplicationController
  # Задаем «родительский» event для подписки
  before_action :set_event, only: [:create, :destroy]

  # Задаем подписку, которую юзер хочет удалить
  before_action :set_subscription, only: [:destroy]

  def create
    # Болванка для новой подписки
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    #if @new_subscription.save && @event.user != @new_subscription.user
    if @new_subscription.save
      # Если сохранилось, отправляем письмо
      # Пишем название класса, потом метода и передаём параметры
      # И доставляем методом .deliver_later
      EventMailSendlerJob.perform_later(@new_subscription)
      # Если сохранилась успешно, редирект на страницу самого события
      redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
    else
      # если ошибки — рендерим здесь же шаблон события
      render 'events/show', alert: I18n.t('controllers.subscriptions.error')
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.subscriptions.destroyed')}

    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = {alert: I18n.t('controllers.subscriptions.error')}
    end

    redirect_to @event, message
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  # на событие может подписываться не только анонимный юзер, но и залогиненный.
  # Когда подписывается залогиненный, то нет смысла показывать форму,
  # мы просто должны показать, что подписка появилась.
  # То есть параметр :subscription необязательный, поэтому вместо require используем метод fetch
  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
