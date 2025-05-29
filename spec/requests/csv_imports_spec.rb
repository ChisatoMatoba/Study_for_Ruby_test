require 'rails_helper'

RSpec.describe 'CsvImports', type: :request do
  let(:general_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:owner_user) { create(:user, :owner) }

  describe 'POST /categories/:category_id/csv_imports' do
    let(:category) { create(:category) }
    let(:file) { fixture_file_upload('spec/fixtures/files/valid_file.csv', 'text/csv') }

    context 'ユーザーが一般の場合' do
      it 'インポートに失敗すること' do
        sign_in general_user
        post category_csv_imports_path(category)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません。')
      end
    end

    context 'ユーザーが管理者の場合' do
      before { sign_in admin_user }

      context 'ファイルが存在する場合' do
        it '正常にインポートされること' do
          expect { post category_csv_imports_path(category), params: { file: file, overwrite: true } }
            .to change(Question, :count)
            .by(3)
            .and change(Choice, :count)
            .by(12)

          expect(response).to redirect_to(category_path(category))
          expect(flash[:notice]).to eq('正常にインポートできました')
        end

        it '問題が重複している場合、選択肢を上書きすること' do
          question = create(:question, category: category, number: 1)
          create_list(:choice, 4, question: question)
          expect { post category_csv_imports_path(category), params: { file: file, overwrite: true } }
            .to change(Question, :count)
            .by(2)
            .and change(Choice, :count)
            .by(8)

          expect(response).to redirect_to(category_path(category))
          expect(flash[:notice]).to eq('正常にインポートできました')
        end

        it '問題番号が足りないcsvの場合、エラーになること' do
          missing_number_file = fixture_file_upload('spec/fixtures/files/missing_number_file.csv', 'text/csv')
          expect { post category_csv_imports_path(category), params: { file: missing_number_file, overwrite: true } }
            .to change(Question, :count)
            .by(1)
            .and change(Choice, :count)
            .by(4)

          expect(response).to redirect_to(category_path(category))
          expect(flash[:alert]).to eq('問題の保存に失敗しました: 問題番号 が入力されていません')
        end

        it 'フォーマットが正しくない場合、エラーメッセージが表示されること' do
          invalid_format_file = fixture_file_upload('spec/fixtures/files/invalid_format_file.csv', 'text/csv')
          post category_csv_imports_path(category), params: { file: invalid_format_file, overwrite: true }
          expect(response).to redirect_to(category_path(category))
          expect(flash[:alert]).to eq("CSVのフォーマットが不正です: Any value after quoted field isn't allowed in line 4.")
        end
      end

      context 'ファイルが存在しない場合' do
        it 'インポートに失敗すること' do
          post category_csv_imports_path(category)
          expect(response).to redirect_to(category_path(category))
          expect(flash[:alert]).to eq('インポートに失敗しました')
        end
      end
    end

    context 'ユーザーがオーナーの場合' do
      it '正常にインポートされること' do
        sign_in owner_user
        post category_csv_imports_path(category), params: { file: file, overwrite: true }
        expect(response).to redirect_to(category_path(category))
        expect(flash[:notice]).to eq('正常にインポートできました')
      end
    end
  end
end
