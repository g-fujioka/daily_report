require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:department) { FactoryGirl.create(:department) }
  let(:user) { FactoryGirl.create(:user, department: department) }
  let(:report) { FactoryGirl.create(:report, user: user) }
  context '正常に値が入っている場合' do
    let(:comment) { FactoryGirl.build(:comment, user: user, report: report) }
    it '値の検証が成功すること' do
      expect(comment).to be_valid
    end
    it '日報が取得できること' do
      expect(comment.report.title).to eq 'こんにちは'
    end
    it 'ユーザーが取得できること' do
      expect(comment.user.name).to eq 'サーバルちゃん'
    end
  end

  describe 'content' do
    context '内容が空白の場合' do
      let(:comment) { FactoryGirl.build(:comment, user: user, report: report, content: '') }
      it 'エラーになること' do
      expect(comment).to_not be_valid
      end
      it 'エラーメッセージがセットされていること' do
        expect(comment).to have(1).errors_on(:content)
        expect(comment.errors_on(:content)).to include('を入力してください')
      end
    end
  end
end
