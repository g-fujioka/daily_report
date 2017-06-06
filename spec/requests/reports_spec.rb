require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let!(:user) { FactoryGirl.create(:user, department: department) }
  let!(:other_user) { FactoryGirl.create(:user, email: 'cat2@example.com', department: department) }
  let(:department) { FactoryGirl.create(:department) }
  let!(:report) { FactoryGirl.create(:report, user: user) }

  describe 'GET /' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
    it '日報一覧が表示されること' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /reports/:id' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
    it '日報情報が表示されること' do
      get report_path report
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /reports/new' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
    it '日報登録画面が表示されること' do
      get new_report_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /reports' do
    context '現在のユーザーが自分の日報を登録する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      subject do
        post reports_path, params: {
            report: {
              report_date: '2017-04-02',
              title: 'sample',
              content: 'sample content',
              user_id: user.id
            }
        }
      end

      it '日報を登録できること' do
        expect { subject }.to change { Report.count }.by(1)
      end
      it '登録した日報情報画面にリダイレクトされること' do
        subject
        report = assigns(:report)
        expect(response).to redirect_to report
      end
      it 'flash[:info]にメッセージが含まれること' do
        subject
        expect(flash[:info]).to include '投稿しました'
      end
    end

    context '現在のユーザーが他のユーザーの日報を登録する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      subject do
        post reports_path, params: {
            report: {
                report_date: '2017-04-02',
                title: 'sample',
                content: 'sample content',
                user_id: other_user.id
            }
        }
      end

      it 'ホーム画面にリダイレクトされること' do
        subject
        expect(response).to redirect_to root_url
      end
      it 'flash[:danger]にメッセージが含まれること' do
        subject
        expect(flash[:info]).to include '正しいユーザーではありません'
      end
    end
  end

  describe 'GET /reports/:id/edit' do
    context '現在のユーザーが自分の日報を編集する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it '日報編集画面が表示されること' do
        get edit_report_path report
        expect(response).to have_http_status(200)
      end
    end

    context '現在のユーザーが他のユーザーの日報を編集する場合' do
      before do
        post login_path, params: { session: { email: other_user.email, password: other_user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        get edit_report_path report
        expect(response).to redirect_to root_url
      end
      it 'flash[:danger]にメッセージが含まれること' do
        get edit_report_path report
        expect(flash[:info]).to include '正しいユーザーではありません'
      end
    end
  end

  describe 'PATCH /reports/:id' do
    context '現在のユーザーが自分の日報を更新する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
        patch report_path report, report: FactoryGirl.attributes_for(:report, title: 'test', user_id: user)
        report.reload
      end
      it '日報情報を更新できること' do
        expect(report.title).to eq 'test'
      end
      it '更新した日報情報画面にリダイレクトすること' do
        expect(response).to redirect_to report
      end
      it 'flash[:success]にメッセージが含まれること' do
        expect(flash[:success]).to eq '更新しました'
      end
    end

    context '現在のユーザーが他のユーザーの日報を更新する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
        patch report_path report, report: FactoryGirl.attributes_for(:report, user_id: other_user.id)
        report.reload
      end
        it 'ホーム画面にリダイレクトされること' do
          expect(response).to redirect_to root_url
        end
        it 'flash[:info]にメッセージが含まれること' do
          expect(flash[:info]).to eq '正しいユーザーではありません'
        end
    end
  end

  describe 'DELETE /reports/:id' do
    context '現在のユーザーが自分の日報を削除する場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end
      it '日報を削除できること' do
        expect { delete report_path report }.to change { Report.count }.by(-1)
      end
      it 'ホーム画面にリダイレクトすること' do
        delete report_path report
        expect(response).to redirect_to root_url
      end
    end

    context '現在のユーザーが他のユーザーの日報を削除する場合' do
      before do
        post login_path, params: { session: { email: other_user.email, password: other_user.password } }
      end
      it 'ホーム画面にリダイレクトされること' do
        delete report_path report
        expect(response).to redirect_to root_url
      end
      it 'flash[:info]にメッセージが含まれること' do
        delete report_path report
        expect(flash[:info]).to include '正しいユーザーではありません'
      end
    end
  end
end