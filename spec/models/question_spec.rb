require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  describe '#session_result(selected_ids)' do
    let!(:choice1_true) { create(:choice, question: question, is_correct: true) }
    let!(:choice2_false) { create(:choice, question: question, is_correct: false) }
    let!(:choice3_true) { create(:choice, question: question, is_correct: true) }

    it '全ての選択肢が正解の場合、正解と判定されること' do
      result = question.session_result([choice1_true.id, choice3_true.id])
      expect(result[:is_correct]).to eq(true)
    end

    it '誤った選択肢が含まれる場合、不正解と判定されること' do
      result = question.session_result([choice2_false.id, choice3_true.id])
      expect(result[:is_correct]).to eq(false)
    end
  end

  describe '#memo_content(user)' do
    let(:user) { create(:user) }
    let!(:memo) { create(:memo, question: question, user: user) }

    it 'メモが存在する場合、メモの内容を返すこと' do
      expect(question.memo_content(user)).to eq(memo.content)
    end

    it 'メモが存在しない場合、nilを返すこと' do
      expect(question.memo_content(create(:user))).to eq(nil)
    end
  end

  describe '#self.import(file, category, overwrite)' do
    let(:category) { create(:category) }
    let(:file) { fixture_file_upload('spec/fixtures/files/valid_file.csv', 'text/csv') }

    it 'CSVファイルの内容をインポートできること' do
      expect { Question.import(file, category, false) }
        .to change(Question, :count)
        .by(3)
        .and change(Choice, :count)
        .by(12)
    end

    it '問題が重複している場合、選択肢を上書きすること' do
      question = create(:question, category: category, number: 1)
      create_list(:choice, 4, question: question)

      expect { Question.import(file, category, true) }
        .to change(Question, :count)
        .by(2)
        .and change(Choice, :count)
        .by(8)
    end

    it '問題番号が足りないcsvの場合、エラーになること' do
      missing_number_file = fixture_file_upload('spec/fixtures/files/missing_number_file.csv', 'text/csv')
      expect { Question.import(missing_number_file, category, false) }
        .to raise_error(RuntimeError, '問題の保存に失敗しました: 問題番号 が入力されていません')
        .and change(Question, :count)
        .by(1)
        .and change(Choice, :count)
        .by(4)
    end

    it '問題文が空欄のcsvの場合、エラーになること' do
      missing_content_file = fixture_file_upload('spec/fixtures/files/missing_content_file.csv', 'text/csv')
      expect { Question.import(missing_content_file, category, false) }
        .to raise_error(RuntimeError, '問題の保存に失敗しました: 問題文 が入力されていません')
        .and change(Question, :count)
        .by(1)
        .and change(Choice, :count)
        .by(4)
    end

    it '解説が空欄のcsvの場合、エラーになること' do
      missing_explanation_file = fixture_file_upload('spec/fixtures/files/missing_explanation_file.csv', 'text/csv')
      expect { Question.import(missing_explanation_file, category, false) }
        .to raise_error(RuntimeError, '問題の保存に失敗しました: 解説 が入力されていません')
        .and change(Question, :count)
        .by(1)
        .and change(Choice, :count)
        .by(4)
    end

    it '選択肢のcontentが空欄の場合、エラーになること' do
      missing_choices_content_file = fixture_file_upload('spec/fixtures/files/missing_choices_content_file.csv', 'text/csv')
      expect { Question.import(missing_choices_content_file, category, false) }
        .to raise_error(RuntimeError, '選択肢の保存に失敗しました: 選択肢 が入力されていません')
        .and change(Question, :count)
        .by(2)
        .and change(Choice, :count)
        .by(5)
    end

    it '選択肢のtrue/falseが正しく入力されていない場合、エラーになること' do
      invalid_choices_file = fixture_file_upload('spec/fixtures/files/invalid_choices_file.csv', 'text/csv')
      expect { Question.import(invalid_choices_file, category, false) }
        .to raise_error(RuntimeError, '選択肢の保存に失敗しました: 選択肢が正解かどうか の値が不正です')
        .and change(Question, :count)
        .by(2)
        .and change(Choice, :count)
        .by(5)
    end

    it 'フォーマットミスしている場合、エラーになること' do
      invalid_format_file = fixture_file_upload('spec/fixtures/files/invalid_format_file.csv', 'text/csv')
      expect { Question.import(invalid_format_file, category, false) }
        .to raise_error(CSV::MalformedCSVError, "Any value after quoted field isn't allowed in line 4.")
    end
  end
end
