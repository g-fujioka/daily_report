require 'rails_helper'

RSpec.describe Report, type: :model do
  context '正常に値が入っている場合' do
    let(:report) { FactoryGirl.create(:report) }
    let!(:comment) { FactoryGirl.create(:comment, user_id: report.user.id, report_id: report.id) }
    it '値の検証が成功すること' do
      expect(report).to be_valid
    end
    it 'ユーザーが取得できること' do
      expect(report.user.name).to eq 'サーバルちゃん'
    end
    it 'コメントを参照できること' do
      expect(report.comments).to include comment
    end
    it '日報を削除するとコメントも削除されること' do
      expect { report.destroy }.to change { Comment.count }.by(-1)
    end
  end

  describe 'report_date' do
    context '報告日が空白の場合' do
      let(:report) { FactoryGirl.build(:report, report_date: '') }
      it 'エラーになること' do
        expect(report).to_not be_valid
      end
      it 'エラーメッセージがセットされていること' do
        expect(report).to have(1).errors_on(:report_date)
        expect(report.errors_on(:report_date)).to include('を入力してください')
      end
    end

    context '報告日が既に存在している場合' do
      before do
        FactoryGirl.create(:report, user: user)
      end
      let(:department) { FactoryGirl.create(:department)}
      let(:user) { FactoryGirl.create(:user, department: department) }
      let(:report) { FactoryGirl.build(:report, user: user) }
      it 'エラーになること' do
        expect(report).to_not be_valid
      end
      it 'エラーメッセージがセットされていること' do
        expect(report).to have(1).errors_on(:report_date)
        expect(report.errors_on(:report_date)).to include('はすでに存在します')
      end
    end
  end

  describe 'title' do
    context 'タイトルが空白の場合' do
      let(:report) { FactoryGirl.build(:report, title: '') }
      it 'エラーになること' do
        expect(report).to_not be_valid
      end
      it 'エラーメッセージがセットされていること' do
        expect(report).to have(1).errors_on(:title)
        expect(report.errors_on(:title)).to include('を入力してください')
      end
    end
  end

  describe 'content' do
    context '内容が空白の場合' do
      let(:report) { FactoryGirl.build(:report, content: '') }
      it 'エラーになること' do
        expect(report).to_not be_valid
      end
      it 'エラーメッセージがセットされていること' do
        expect(report).to have(1).errors_on(:content)
        expect(report.errors_on(:content)).to include('を入力してください')
      end
    end
  end

  describe 'default scope' do
    context 'created_at DESC' do
      let(:department) { FactoryGirl.create(:department) }
      let(:user) { FactoryGirl.create(:user, department: department) }
      before do
        ['2017-06-01 00:00:00', '2017-06-02 00:00:00', '2017-06-03 00:00:00'].each do |time|
          FactoryGirl.create(:report, report_date: time, user: user, created_at: time)
        end
      end
      it '作成日の降順にデータが表示されること' do
        expect(Report.all.pluck(:id)).to eq Report.order('created_at DESC').pluck(:id)
      end
    end
  end
end
