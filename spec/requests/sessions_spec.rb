require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    let(:user) { FactoryGirl.create(:user) }
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
end
