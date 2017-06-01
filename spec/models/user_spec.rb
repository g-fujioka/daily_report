require 'rails_helper'

RSpec.describe User, type: :model do
  context '正常に値が入っている場合' do
    let(:user) { FactoryGirl.build(:user) }
    it "値の検証が成功すること" do
      expect(user).to be_valid
    end
    it "部署名が取得できること" do
      expect(user.department.department_name).to eq "開発部"
    end
  end

  context '名前が空白の場合' do
    let(:user) { FactoryGirl.build(:user, name: '') }
    it "エラーになること" do
      expect(user).to_not be_valid
      expect(user).to have(1).errors_on(:name)
    end
    it "エラーメッセージがセットされていること" do
      expect(user.errors_on(:name)).to include("を入力してください")
    end
  end
end
