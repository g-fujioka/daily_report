require 'rails_helper'

RSpec.describe User, type: :model do
  context '正常に値が入っている場合' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:report) { FactoryGirl.create(:report, user_id: user.id) }
    let!(:comment) { FactoryGirl.create(:comment, user_id: user.id, report_id: report.id) }
    it '値の検証が成功すること' do
      expect(user).to be_valid
    end
    it '部署名が取得できること' do
      expect(user.department.name).to eq '開発部'
    end
    it '日報を参照できること' do
      expect(user.reports).to include report
    end
    it 'ユーザーを削除すると日報も削除すること' do
      expect { user.destroy }.to change { Report.count }.by(-1)
    end
    it 'ユーザーを削除するとコメントも削除すること' do
      expect { user.destroy }.to change { Comment.count }.by(-1)
    end
  end

  describe 'name' do
    context '名前が空白の場合' do
      let(:user) { FactoryGirl.build(:user, name: '') }
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:name)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:name)).to include('を入力してください')
      end
    end
  end

  describe 'email' do
    context 'メールアドレスが空白の場合' do
      let(:user) { FactoryGirl.build(:user, email: '') }
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(2).errors_on(:email)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:email)).to include('を入力してください', 'は不正な値です')
      end
    end

    context 'メールアドレスの文字数が256文字以上の場合' do
      email = 'a' * 250 + '@e.com'
      let(:user) { FactoryGirl.build(:user, email: email)}
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:email)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:email)).to include('は255文字以内で入力してください')
      end
    end

    context 'メールアドレスの文字数が255文字以内の場合' do
      email = 'a' * 249 + '@e.com'
      let(:user) { FactoryGirl.build(:user, email: email) }
      it '値の検証が成功すること' do
        expect(user).to be_valid
      end
    end

    context 'メールアドレスのフォーマットが違う場合' do
      let(:user) { FactoryGirl.build(:user, email: 'cat@examplecom')}
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:email)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:email)).to include('は不正な値です')
      end
    end

    context 'メールアドレスが既に存在する場合' do
      let(:department) { FactoryGirl.create(:department) }
      before do
        FactoryGirl.create(:user, department: department)
      end
      let(:user) { FactoryGirl.build(:user, department: department)}
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:email)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:email)).to include('はすでに存在します')
      end
    end
  end

  describe 'password' do
    context 'パスワードが空白の場合' do
      let(:user) { FactoryGirl.build(:user, password: '') }
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:password)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:password)).to include('を入力してください')
      end
    end

    context 'パスワードの文字数が6文字以上の場合' do
      let(:user) { FactoryGirl.build(:user, password: 'foobaa') }
      it '値の検証が成功すること' do
        expect(user).to be_valid
      end
    end

    context 'パスワードの文字数が6文字未満の場合' do
      let(:user) { FactoryGirl.build(:user, password: 'fooba') }
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:password)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:password)).to include('は6文字以上で入力してください')
      end
    end

    context 'パスワードとパスワード再確認の値が違う場合' do
      let(:user) { FactoryGirl.build(:user, password: 'foobar', password_confirmation: 'foobaa') }
      it 'エラーになること' do
        expect(user).to_not be_valid
        expect(user).to have(1).errors_on(:password_confirmation)
      end
      it 'エラーメッセージがセットされていること' do
        expect(user.errors_on(:password_confirmation)).to include('とパスワードの入力が一致しません')
      end
    end
  end

  describe '.digest' do
    subject { User.digest('foobar') }
    context '入力したパスワードが違う場合' do
      let(:user) { FactoryGirl.create(:user) }
      it { is_expected.to_not eq user.password_digest}
    end
  end
end
