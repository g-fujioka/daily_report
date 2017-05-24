class UsersController < ApplicationController
  before_action :user_find, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
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
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :department_id, :password, :password_confirmation)
  end

  def user_find
    @user = User.find(params[:id])
  end

end
