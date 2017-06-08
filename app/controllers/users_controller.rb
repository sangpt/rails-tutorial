class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin!, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.select(:id, :name, :email).order(name: :asc)
      .paginate page: params[:page], per_page: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def show
    @microposts = @user.microposts
      .select(:id, :content, :picture, :user_id, :created_at).micropost_sort
      .paginate page: params[:page], per_page: Settings.micropost.per_page
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

  def following
    @title = t ".title"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.following.per_page
    render :show_follow
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.follower.per_page
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    load_user
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
