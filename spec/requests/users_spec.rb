require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:admin_user) { FactoryGirl.create(:user, department: department) }
  let!(:user) { FactoryGirl.create(:user, email: 'cat2@example.com', admin: false, department: department) }
  let(:department) { FactoryGirl.create(:department) }

  describe 'GET /users' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
    it 'ユーザー一覧が表示されること' do
      get users_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
    it 'ユーザー情報が表示されること' do
      get user_path user
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/new' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it 'ユーザー登録画面が表示されること' do
        get new_user_path
        expect(response).to have_http_status(200)
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        get new_user_path
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'POST /users' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end

      subject do
        post users_path, params: {
            user: {
                name: 'Example User',
                email: 'user@example.com',
                department_id: department.id,
                password: 'password',
                password_confirmation: 'password'
            }
        }
      end

      it 'ユーザーを登録できること' do
        expect { subject }.to change { User.count }.by(1)
      end
      it 'ユーザー一覧にリダイレクトされること' do
        subject
        expect(response).to redirect_to users_url
      end
      it 'flash[:success]にメッセージが含まれること' do
        subject
        expect(flash[:info]).to include '登録しました'
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        post users_path
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        post users_path
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'GET /users/:id/edit' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '自分のユーザー編集画面が表示されること' do
        get edit_user_path admin_user
        expect(response).to have_http_status(200)
      end
      it '他のユーザーの編集画面が表示されること' do
        get edit_user_path user
        expect(response).to have_http_status(200)
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it '自分のユーザー編集画面が表示されること' do
        get edit_user_path user
        expect(response).to have_http_status(200)
      end
      it '他のユーザー編集ができず、ホーム画面にリダイレクトされること' do
        get edit_user_path admin_user
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'PATCH /users/:id' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
        patch user_path user, user: FactoryGirl.attributes_for(:user, email: 'dog@example.com')
        user.reload
      end
      it 'ユーザー情報を更新できること' do
        expect(user.email).to eq 'dog@example.com'
      end
      it '更新したユーザーの画面にリダイレクトすること' do
        expect(response).to redirect_to user_path
      end
      it 'flash[:success]にメッセージが含まれること' do
        expect(flash[:success]).to eq '更新しました'
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      context '自分のユーザー情報を編集する場合' do
        before do
          patch user_path user, user: FactoryGirl.attributes_for(:user, email: 'dog@example.com')
          user.reload
        end
        it '自分のユーザー情報を更新できること' do
          expect(user.email).to eq 'dog@example.com'
        end
        it '自分のユーザー情報画面にリダイレクトされること' do
          expect(response).to redirect_to user_path
        end
        it 'flash[:success]にメッセージが含まれること' do
          expect(flash[:success]).to eq '更新しました'
        end
      end

      context '他ユーザーの情報を編集する場合' do
        before do
          patch user_path admin_user, admin_user: FactoryGirl.attributes_for(:user, email: 'dog@example.com')
          admin_user.reload
        end
        it 'ホーム画面にリダイレクトされること' do
          expect(response).to redirect_to root_url
        end
        it 'flash[:info]にメッセージが含まれること' do
          expect(flash[:info]).to eq '正しいユーザーではありません'
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it 'ユーザーが削除できること' do
        expect { delete user_path user }.to change { User.count }.by(-1)
      end
      it 'ユーザー一覧にリダイレクトすること' do
        delete user_path user
        expect(response).to redirect_to users_url
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ユーザーが削除できないこと' do
        expect { delete user_path admin_user }.to change { User.count }.by(0)
      end
      it 'ホーム画面にリダイレクトされること' do
        delete user_path admin_user
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        delete user_path admin_user
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end
end
