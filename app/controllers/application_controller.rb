class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ログインしているか確認
  def log_in?
    unless logged_in?
    redirect_to(login_url)
    flash[:info] = 'ログインしてください'
    end
  end

  def admin_user
    unless admin_user?(current_user)
      redirect_to request.referrer || home_url
      flash[:info] = '管理者ではありません'
    end
  end
end
