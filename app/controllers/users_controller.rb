class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :log_in?, only: [:index, :show]
  before_action :admin_user, only: [:new, :create, :destroy]


  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports.paginate(page: params[:page])
  end

  def new
    @user = User.new
    @departments = Department.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "新規ユーザーを登録しました"
      redirect_to users_url
    else
      @departments = Department.all
      render 'users/new'
    end
  end

  def edit
    @departments = Department.all
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      @departments = Department.all
      render 'users/edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :department_id, :password, :password_confirmation)
  end

  # 正しいユーザーか確認
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user) || admin_user?(current_user)
      redirect_to request.referrer || home_url
      flash[:info] = '正しいユーザーではありません'
    end
  end

end
