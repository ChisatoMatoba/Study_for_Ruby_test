class FixForeignKeyForQuestions < ActiveRecord::Migration[7.1]
  def up
    # 外部キー制約を削除（旧 categories テーブル向け）
    remove_foreign_key :questions, :categories, if_exists: true

    # カラム名変更
    rename_column :questions, :category_id, :question_category_id

    # 外部キーが使っている可能性のあるものを削除
    remove_foreign_key :questions, column: :question_category_id, if_exists: true

    # インデックス削除（旧名・新名どちらも考慮）
    remove_index :questions, name: 'index_questions_on_category_id_and_number', if_exists: true
    remove_index :questions, name: 'index_questions_on_category_id', if_exists: true
    remove_index :questions, name: 'index_questions_on_question_category_id_and_number', if_exists: true
    remove_index :questions, name: 'index_questions_on_question_category_id', if_exists: true

    # インデックス追加（新しいカラム名に対して）
    add_index :questions, [:question_category_id, :number], unique: true, name: 'index_questions_on_question_category_id_and_number'
    add_index :questions, :question_category_id, name: 'index_questions_on_question_category_id'

    # 外部キー追加
    add_foreign_key :questions, :question_categories, column: :question_category_id
  end

  def down
    remove_foreign_key :questions, column: :question_category_id, if_exists: true

    remove_index :questions, name: 'index_questions_on_question_category_id_and_number', if_exists: true
    remove_index :questions, name: 'index_questions_on_question_category_id', if_exists: true

    rename_column :questions, :question_category_id, :category_id

    add_index :questions, [:category_id, :number], unique: true, name: 'index_questions_on_category_id_and_number'
    add_index :questions, :category_id, name: 'index_questions_on_category_id'

    # categories テーブルが存在するときだけ外部キー追加
    if table_exists?(:categories)
      add_foreign_key :questions, :categories, column: :category_id
    end
  end
end
