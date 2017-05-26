class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ログインしているか確認
  def log_in?
    unless logged_in?
    redirect_to(login_url)
    flash[:info] = t('errors.messages.login')
    end
  end

  # 管理者ユーザーか確認
  def admin_user
    unless admin_user?(current_user)
      redirect_to request.referrer || root_url
      flash[:info] = t('errors.messages.admin')
    end
  end
end
