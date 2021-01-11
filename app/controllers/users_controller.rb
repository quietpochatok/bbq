class UsersController < ApplicationController
  # Девайзовский фильтр, который посылает незалогинившихся юзеров
  # Просматривать профили могут и анонимы
  before_action :authenticate_user!, except: [:show]

  # Задаем объект @user для шаблонов и экшенов
  before_action :set_current_user, except: [:show]
  #before_action :set_user, only: [:show, :edit, :update]

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: I18n.t('controllers.users.updated')
    else
      render :edit
    end
  end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  #   redirect_to users_url, notice: 'User was successfully destroyed.'
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_user
  #   @user = User.find(params[:id])
  # end

  def set_current_user
    @user = current_user
  end
  # Only allow a trusted parameter "white list" through.
  def user_params
    #params.fetch(:user, {})
    params.require(:user).permit(:name, :email, :avatar)
  end
end
