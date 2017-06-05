require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  describe 'GET /login' do
    it 'ログイン画面が表示されること' do
      get login_path
      expect(response).to have_http_status(200)
    end

    context '正しい値を入力したとき' do
      it 'ログインに成功すること' do
        post login_path, params: { session: { email: user.email, password: user.password } }
        expect(response).to have_http_status(302)
      end
    end

    context 'メールアドレスが空白の場合' do
      it 'ログインに失敗すること' do
        post login_path, params: { session: { email: '', password: user.password } }
        expect(response).to_not have_http_status(302)
      end
      it 'flash[:danger]にメッセージが含まれること' do
        post login_path, params: { session: { email: '', password: user.password } }
        expect(flash[:danger]).to include 'メールアドレス、または、パスワードが違います'
      end
    end

    context 'パスワードが空白の場合' do

      it 'ログインに失敗すること' do
        post login_path, params: { session: { email: user.email, password: '' } }
        expect(response).to_not have_http_status(302)
      end
      it 'flash[:danger]にメッセージが含まれること' do
        post login_path, params: { session: { email: user.email, password: '' } }
        expect(flash[:danger]).to include 'メールアドレス、または、パスワードが違います'
      end
    end
  end

  describe 'Delete /logout' do
    context 'ログアウトボタンを押したとき' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
        delete logout_path
      end
      it 'ログイン画面にリダイレクトすること' do
        expect(response).to redirect_to login_url
      end
      it 'session[user_id]がnilになること' do
        expect(controller.session[:user_id]).to be_nil
      end
      it 'current_userがnilになること' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
