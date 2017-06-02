require 'rails_helper'

RSpec.describe Report, type: :model do
  context '正常に値が入っている場合' do
    let(:report) { FactoryGirl.build(:report) }
    it "値の検証が成功すること" do
      expect(report).to be_valid
    end
    it "ユーザーが取得できること" do
      expect(report.user.name).to eq "サーバルちゃん"
    end
  end
end
