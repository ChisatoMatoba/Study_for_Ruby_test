require 'rails_helper'

RSpec.describe User, type: :model do
  before { ENV['ALLOWED_EMAIL_DOMAIN'] = '@example.com' }
  after { ENV['ALLOWED_EMAIL_DOMAIN'] = nil }

  describe 'バリデーション' do
    it 'name, email, encrypted_password, roleがあれば有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'nameがなければ無効であること' do
      user = build(:user, name: nil)
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('名前 が入力されていません')
    end

    it 'emailがなければ無効であること' do
      user = build(:user, email: nil)
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('Eメール が入力されていません')
    end

    it 'passwordがなければ無効であること' do
      user = build(:user, password: nil)
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('パスワード が入力されていません')
    end

    it 'passwordとpassword_confirmationが一致しなければ無効であること' do
      user = build(:user, password: 'abcabcab', password_confirmation: 'abcabcabc')
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('パスワード（確認用） の入力が一致しません')
    end

    it 'roleがなければ無効であること' do
      user = build(:user, role: nil)
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('役割 が入力されていません')
    end

    it 'emailが会社メールでなければ無効であること' do
      user = build(:user, email: 'abc@abc.com')
      expect(user.valid?).to eq(false)
      expect(user.errors.full_messages).to include('Eメール は会社メールである必要があります')
    end
  end
end
