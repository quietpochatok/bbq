class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  # здесь перечисляем те экшены, что зайдествованы в event_policy.rb
  # иначе  скажет что не может найти и будет "unable to find policy `NilClassPolicy` for `nil`"
  before_action :set_event, only: [:edit, :update, :destroy, :show]
  #before_action :set_current_user_event, only: [:edit, :update, :destroy]

  # Проверка пин-кода перед отображением события
  before_action :password_guard!, only: [:show]
  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:edit, :update, :destroy, :show]

  # Предохранитель от неиспользования pundit scope в index экшене
  after_action :verify_policy_scoped, only: :index

  # GET /events
  def index
    @events = policy_scope(Event)
  end

  # GET /events/1
  def show
    authorize @event
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
    authorize @event
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
    authorize @event

    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    authorize @event

    @event.destroy
    redirect_to events_path, notice: I18n.t('controllers.events.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  # редактируем параметры события
  def event_params
    # params.fetch(:event, {})
    params.require(:event).permit(:title, :address, :datetime, :description, :pincode)
  end

  def password_guard!
    # Если у события нет пин-кода, то охранять нечего
    # return true if @event.pincode.blank?
    # # Пин-код не нужен автору события
    # return true if signed_in? && current_user == @event.user

    # Если нам передали код и он верный, сохраняем его в куки этого юзера
    # Так юзеру не нужно будет вводить пин-код каждый раз
    if params[:pincode].present? && @event.pincode_valid?(params[:pincode])
      cookies.permanent["events_#{@event.id}_pincode"] = params[:pincode]
    end

    # Проверяем, верный ли в куках пин-код
    # Если нет — ругаемся и рендерим форму ввода пин-кода
    # pincode = cookies.permanent["events_#{@event.id}_pincode"]

    unless policy(@event).show?
      if params[:pincode].present?
        flash.now[:alert] = I18n.t('controllers.events.wrong_pincode')
      end
      render 'password_form'
    end
  end
end
