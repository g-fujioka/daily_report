require 'rails_helper'

RSpec.describe Comment, type: :model do
  context '正常に値が入っている場合' do
    let(:department) { FactoryGirl.create(:department) }
    let(:user) { FactoryGirl.create(:user, department: department) }
    let(:report) { FactoryGirl.create(:report, user: user) }
    let(:comment) { FactoryGirl.build(:comment, user: user, report: report) }
    it "値の検証が成功すること" do
      expect(comment).to be_valid
    end
    it "日報が取得できること" do
      expect(comment.report.title).to eq 'こんにちは'
    end
    it "ユーザーが取得できること" do
      expect(comment.user.name).to eq 'サーバルちゃん'
    end
  end
end
