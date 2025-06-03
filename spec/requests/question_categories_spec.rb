require 'rails_helper'

RSpec.describe 'QuestionCategories', type: :request do
  let(:general_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:owner_user) { create(:user, :owner) }
  let(:category) { create(:category) }

  describe 'GET /new' do
    context 'ユーザーがオーナーの場合' do
      it '問題集作成ページが表示されること' do
        sign_in owner_user
        get new_category_question_category_path(category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者の場合' do
      it '問題集作成ページが表示されること' do
        sign_in admin_user
        get new_category_question_category_path(category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが一般の場合' do
      it 'ルートパスにリダイレクトされること' do
        sign_in general_user
        get new_category_question_category_path(category)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end

  describe 'POST /create' do
    context 'ユーザーがオーナーの場合' do
      it '新しい問題集が作成されること' do
        sign_in owner_user
        expect do
          post category_question_categories_path(category), params: { question_category: { name: 'New QuestionCategory' } }
        end.to change(QuestionCategory, :count).by(1)
        expect(response).to redirect_to(category_question_category_path(category, QuestionCategory.last))
        expect(flash[:notice]).to eq('問題集が正常に作成されました。')
      end
    end

    context 'ユーザーが管理者の場合' do
      it '新しい問題集が作成されること' do
        sign_in admin_user
        expect do
          post category_question_categories_path(category), params: { question_category: { name: 'New QuestionCategory' } }
        end.to change(QuestionCategory, :count).by(1)
        expect(response).to redirect_to(category_question_category_path(category, QuestionCategory.last))
        expect(flash[:notice]).to eq('問題集が正常に作成されました。')
      end
    end

    context 'ユーザーが一般の場合' do
      it '新しい問題集が作成されないこと' do
        sign_in general_user
        expect do
          post category_question_categories_path(category), params: { question_category: { name: 'New QuestionCategory' } }
        end.not_to change(QuestionCategory, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end

  describe 'GET /show' do
    let(:question_category) { create(:question_category, category: category) }

    context 'ユーザーがオーナーの場合' do
      it '問題集詳細ページが表示されること' do
        sign_in owner_user
        get category_question_category_path(category, question_category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが管理者の場合' do
      it '問題集詳細ページが表示されること' do
        sign_in admin_user
        get category_question_category_path(category, question_category)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが一般の場合' do
      it '問題集詳細ページが表示されること' do
        sign_in general_user
        get category_question_category_path(category, question_category)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:question_category) { create(:question_category) }

    context 'ユーザーがオーナーの場合' do
      it '問題集が削除されること' do
        sign_in owner_user
        expect do
          delete category_question_category_path(category, question_category)
        end.to change(QuestionCategory, :count).by(-1)
        expect(response).to redirect_to(categories_path)
        expect(flash[:notice]).to eq('問題集が正常に削除されました。')
      end
    end

    context 'ユーザーが管理者の場合' do
      it '問題集が削除されないこと' do
        sign_in admin_user
        expect do
          delete category_question_category_path(category, question_category)
        end.not_to change(QuestionCategory, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end

    context 'ユーザーが一般の場合' do
      it '問題集が削除されないこと' do
        sign_in general_user
        expect do
          delete category_question_category_path(category, question_category)
        end.not_to change(QuestionCategory, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end
  end
end
