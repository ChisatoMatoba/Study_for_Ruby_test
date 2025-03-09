require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:general_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:owner_user) { create(:user, :owner) }

  describe 'GET /index' do
    context 'ユーザーがオーナーの場合' do
      it 'カテゴリ一覧ページが表示されること' do
        sign_in owner_user
        get categories_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'カテゴリ一覧ページが表示されること' do
        sign_in admin_user
        get categories_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが一般の場合' do
      it 'カテゴリ一覧ページが表示されること' do
        sign_in general_user
        get categories_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /new' do
    context 'ユーザーがオーナーの場合' do
      it 'カテゴリ作成ページが表示されること' do
        sign_in owner_user
        get new_category_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'カテゴリ作成ページが表示されること' do
        sign_in admin_user
        get new_category_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが一般の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in general_user
        get new_category_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end

  describe 'POST /create' do
    context 'ユーザーがオーナーの場合' do
      it '新しいカテゴリが作成されること' do
        sign_in owner_user
        expect do
          post categories_path, params: { category: { name: 'New Category' } }
        end.to change(Category, :count).by(1)
        expect(response).to redirect_to(category_path(Category.last))
        expect(flash[:notice]).to eq('カテゴリが正常に作成されました。')
      end
    end

    context 'ユーザーが管理者の場合' do
      it '新しいカテゴリが作成されること' do
        sign_in admin_user
        expect do
          post categories_path, params: { category: { name: 'New Category' } }
        end.to change(Category, :count).by(1)
        expect(response).to redirect_to(category_path(Category.last))
        expect(flash[:notice]).to eq('カテゴリが正常に作成されました。')
      end
    end

    context 'ユーザーが一般の場合' do
      it '新しいカテゴリが作成されないこと' do
        sign_in general_user
        expect do
          post categories_path, params: { category: { name: 'New Category' } }
        end.not_to change(Category, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end

  describe 'GET /show' do
    let(:category) { create(:category) }

    context 'ユーザーがオーナーの場合' do
      it 'カテゴリ詳細ページが表示されること' do
        sign_in owner_user
        get category_path(category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'カテゴリ詳細ページが表示されること' do
        sign_in admin_user
        get category_path(category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが一般の場合' do
      it 'カテゴリ詳細ページが表示されること' do
        sign_in general_user
        get category_path(category)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:category) { create(:category) }

    context 'ユーザーがオーナーの場合' do
      it 'カテゴリが削除されること' do
        sign_in owner_user
        expect do
          delete category_path(category)
        end.to change(Category, :count).by(-1)
        expect(response).to redirect_to(categories_path)
        expect(flash[:notice]).to eq('カテゴリが正常に削除されました。')
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'カテゴリが削除されないこと' do
        sign_in admin_user
        expect do
          delete category_path(category)
        end.not_to change(Category, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end

    context 'ユーザーが一般の場合' do
      it 'カテゴリが削除されないこと' do
        sign_in general_user
        expect do
          delete category_path(category)
        end.not_to change(Category, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end
end
