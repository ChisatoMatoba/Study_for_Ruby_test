require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:general_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:owner_user) { create(:user, :owner) }

  describe 'GET /index' do
    context 'ユーザーがオーナーの場合' do
      it '問題一覧ページが表示されること' do
        sign_in owner_user
        get categories_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('問題一覧')
      end
    end

    context 'ユーザーが管理者の場合' do
      it '問題一覧ページが表示されること' do
        sign_in admin_user
        get categories_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('問題一覧')
      end
    end

    context 'ユーザーが一般の場合' do
      it '問題一覧ページが表示されること' do
        sign_in general_user
        get categories_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('問題一覧')
      end
    end
  end

  describe 'GET /new' do
    context 'ユーザーがオーナーの場合' do
      it 'カテゴリページ作成ページが表示されること' do
        sign_in owner_user
        get new_category_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('カテゴリ作成')
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in admin_user
        get new_category_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end

    context 'ユーザーが一般の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in general_user
        get new_category_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end
  end

  describe 'GET /create' do
    context 'ユーザーがオーナーの場合' do
      it 'カテゴリが作成されること' do
        sign_in owner_user
        expect do
          post categories_path, params: { category: { name: 'Ruby Silver' } }
        end.to change(Category, :count).by(1)
        expect(response).to redirect_to(categories_path)
        expect(flash[:notice]).to eq('カテゴリが正常に作成されました。')
        expect(Category.last.name).to eq('Ruby Silver')
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in admin_user
        post categories_path, params: { category: { name: 'Ruby Silver' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end

    context 'ユーザーが一般の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in general_user
        post categories_path, params: { category: { name: 'Ruby Silver' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end
  end

  describe 'GET /destroy' do
    let!(:category) { create(:category, name: 'Ruby Silver') }

    context 'ユーザーがオーナーの場合' do
      it '問題集がない場合、カテゴリを削除できること' do
        sign_in owner_user
        expect do
          delete category_path(category)
        end
          .to change(Category, :count).by(-1)
        expect(response).to redirect_to(categories_path)
        expect(flash[:notice]).to eq('カテゴリが正常に削除されました。')
        expect(Category.exists?(category.id)).to be_falsey
      end

      it '問題集がある場合、カテゴリを削除できないこと' do
        sign_in owner_user
        create(:question_category, category: category)
        expect do
          delete category_path(category)
        end
          .not_to change(Category, :count)
        expect(response).to redirect_to(categories_path)
        expect(flash[:alert]).to eq('関連する問題集があるため、このカテゴリは削除できません')
        expect(Category.exists?(category.id)).to be_truthy
      end
    end

    context 'ユーザーが管理者の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in admin_user
        delete category_path(category)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end

    context 'ユーザーが一般の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in general_user
        delete category_path(category)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('この操作にはオーナー権限が必要です。')
      end
    end
  end
end
