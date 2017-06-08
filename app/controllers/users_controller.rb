class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin!, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.select(:id, :name, :email).order(name: :asc)
      .paginate page: params[:page], per_page: Settings.user.page.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".updated"
      redirect_to @user
    else
      flash[:danger] = t ".not_updated"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_not_deleted"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".please_log_in"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless @user.is_user? current_user
  end

  def verify_admin!
    redirect_to root_url unless current_user.is_admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    valid_info @user
  end
end
