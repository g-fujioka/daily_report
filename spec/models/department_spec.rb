require 'rails_helper'

RSpec.describe Department, type: :model do
  context '正常に値が入っている場合' do
    let(:department) { FactoryGirl.build(:department) }
    let!(:user) { FactoryGirl.create(:user, department: department) }
    it '値の検証が成功すること' do
      expect(department).to be_valid
    end
    it 'ユーザーを参照できること' do
      expect(department.users).to include user
    end
  end

  describe 'name' do
    context '名前が空白の場合' do
      let(:department) { FactoryGirl.build(:department, name: '') }
      it 'エラーになること' do
        expect(department).to_not be_valid
        expect(department).to have(1).errors_on(:name)
      end
      it 'エラーメッセージがセットされていること' do
        expect(department.errors_on(:name)).to include('を入力してください')
      end
    end
  end
end
