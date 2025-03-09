require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }

  describe 'GET /index' do
    it 'カテゴリ一覧ページが表示されること' do
      sign_in user
      get categories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    context 'ユーザーが管理者の場合' do
      it 'カテゴリ作成ページが表示されること' do
        sign_in admin
        get new_category_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者でない場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in user
        get new_category_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /create' do
    context 'ユーザーが管理者の場合' do
      it '新しいカテゴリが作成されること' do
        sign_in admin
        expect {
          post categories_path, params: { category: { name: 'New Category' } }
        }.to change(Category, :count).by(1)
        expect(response).to redirect_to(category_path(Category.last))
      end
    end

    context 'ユーザーが管理者でない場合' do
      it '新しいカテゴリが作成されないこと' do
        sign_in user
        expect {
          post categories_path, params: { category: { name: 'New Category' } }
        }.not.to change(Category, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /show' do
    it 'カテゴリ詳細ページが表示されること' do
      sign_in user
      get category_path(category)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /destroy' do
    context 'ユーザーがオーナーの場合' do
      let(:owner) { create(:user, :owner) }

      it 'カテゴリが削除されること' do
        sign_in owner
        category
        expect {
          delete category_path(category)
        }.to change(Category, :count).by(-1)
        expect(response).to redirect_to(categories_path)
      end
    end

    context 'ユーザーがオーナーでない場合' do
      it 'カテゴリが削除されないこと' do
        sign_in user
        category
        expect {
          delete category_path(category)
        }.not.to change(Category, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
