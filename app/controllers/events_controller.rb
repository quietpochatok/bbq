class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  before_action :set_event, only: [:show]
  before_action :set_current_user_event, only: [:edit, :update, :destroy]

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    # Болванка модели для формы добавления комментария
    @new_comment = @event.comments.build(params[:comment])

    # Болванка модели для формы подписки
    @new_subscription = @event.subscriptions.build(params[:subscription])

    # Болванка модели для формы добавления фотографии views!
    @new_photo = @event.photos.build(params[:photo])
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: I18n.t('controllers.events.created')
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_path, notice: I18n.t('controllers.events.destroyed')
  end

  private
    # Будем искать событие не среди всех,
    # а только у текущего пользователя по id
    def set_current_user_event
      @event = current_user.events.find(params[:id])
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    # редактируем параметры события
    def event_params
      # params.fetch(:event, {})
      params.require(:event).permit(:title, :address, :datetime, :description)
    end
end
