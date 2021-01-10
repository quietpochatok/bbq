class CommentsController < ApplicationController
  # Настроим фильтры. Нам нужно, во-первых, задать родительский event
  # чтобы понимал откуда удалять?
  before_action :set_event, only: [:create, :destroy]

  # только для удаления, чтобы знать, какой коммент сносить:
  before_action :set_comment, only: [:destroy]

  # # GET /comments
  # def index
  #   @comments = Comment.all
  # end

  # # GET /comments/1
  # def show
  # end

  # # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end

  # # GET /comments/1/edit
  # def edit
  # end

  # POST /comments
def create
  # Создаём объект @new_comment из @event
  @new_comment = @event.comments.build(comment_params)
  # Проставляем пользователя, если он задан
  @new_comment.user = current_user

  if @new_comment.save
    # уведомляем всех подписчиков о новом комментарии
    notify_subscribers(@event, @new_comment)
    # Если сохранился, редирект на страницу самого события
    redirect_to @event, notice: I18n.t('controllers.comments.created')
  else
    # Если ошибки — рендерим здесь же шаблон события (своих шаблонов у коммента нет)
    render 'events/show', alert: I18n.t('controllers.comments.error')
  end
end

  # # PATCH/PUT /comments/1
  # def update
  #   if @comment.update(comment_params)
  #     redirect_to @comment, notice: 'Comment was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /comments/1
def destroy
  message = {notice: I18n.t('controllers.comments.destroyed')}

  if current_user_can_edit?(@comment)
    @comment.destroy!
  else
    message = {alert: I18n.t('controllers.comments.error')}
  end

  redirect_to @event, message
end

  private

    def set_event
      @event = Event.find(params[:event_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @event.comments.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:body, :user_name)
    end

    def notify_subscribers(event, comment)
      # Собираем всех подписчиков и автора события в массив мэйлов, исключаем повторяющиеся
      all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [comment&.user&.email]).uniq

      # По адресам из этого массива делаем рассылку
      # Как и в подписках, берём EventMailer и его метод comment с параметрами
      # И отсылаем в том же потоке
      all_emails.each do |mail|
        EventMailer.comment(event, comment, mail).deliver_later
      end
    end
end
