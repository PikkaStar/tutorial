class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う。
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

   # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
