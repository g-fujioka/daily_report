require 'rails_helper'

RSpec.describe 'Departments', type: :request do
  let!(:admin_user) { FactoryGirl.create(:user, department: department) }
  let!(:user) { FactoryGirl.create(:user, email: 'cat2@example.com', admin: false, department: department) }
  let!(:department) { FactoryGirl.create(:department) }

  describe 'GET /departments' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '部署一覧が表示されること' do
        get departments_path
        expect(response).to have_http_status(200)
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        get departments_path
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        get departments_path
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'GET /departments/new' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '部署登録画面が表示されること' do
        get new_department_path
        expect(response).to have_http_status(200)
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        get new_department_path
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        get new_department_path
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'POST /departments' do

    subject do
      post departments_path, params: {
          department: {
            name: '管理部',
            state: 'activate'
          }
      }
    end

    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '部署を登録できること' do
        expect { subject }.to change { Department.count }.by(1)
      end
      it '部署一覧にリダイレクトされること' do
        subject
        expect(response).to redirect_to departments_url
      end
      it 'flash[:success]にメッセージが含まれること' do
        subject
        expect(flash[:success]).to include '登録しました'
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        subject
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        subject
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'GET /departments/:id/edit' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '部署編集画面が表示されること' do
        get edit_department_path department
        expect(response).to have_http_status(200)
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        get edit_department_path department
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        get edit_department_path department
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'PATCH /departments/:id' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
        patch department_path department, department: FactoryGirl.attributes_for(:department, name: '企画部', state: 'activate')
        department.reload
      end
      it '部署情報を更新できること' do
        expect(department.name).to eq '企画部'
      end
      it '部署一覧画面にリダイレクトされること' do
        expect(response).to redirect_to departments_path
      end
      it 'flash[:success]にメッセージが含まれること' do
        expect(flash[:success]).to eq '更新しました'
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
        patch department_path department, department: FactoryGirl.attributes_for(:department, name: '企画部', state: 'activate')
        department.reload
      end
      it 'ホーム画面にリダイレクトされること' do
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end

  describe 'DELETE /departments/:id' do
    context '管理者権限を持っている場合' do
      before do
        post login_path, params: { session: { email: admin_user.email, password: admin_user.password } }
      end
      it '部署が削除できること' do
        expect { delete department_path department }.to change { Department.count }.by(-1)
      end
      it '部署一覧にリダイレクトされること' do
        delete department_path department
        expect(response).to redirect_to departments_url
      end
    end

    context '管理者権限を持っていない場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        delete department_path department
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        delete department_path department
        expect(flash[:info]).to include '管理者ではありません'
      end
    end
  end
end