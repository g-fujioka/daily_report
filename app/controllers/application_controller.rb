class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_request_from

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

# どこのページからリクエストが来たか保存しておく
  def set_request_from
    if session[:request_from]
      @request_from = session[:request_from]
    end
    # 現在のURLを保存しておく
    session[:request_from] = request.original_url
  end

  # 前の画面に戻る
  def return_back
    if request.referer
      redirect_back(fallback_location: root_path) and return true
    elsif @request_from
      redirect_to @request_from and return true
    end
  end
end