class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    begin
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render file: "public/404.html"
    end
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

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
