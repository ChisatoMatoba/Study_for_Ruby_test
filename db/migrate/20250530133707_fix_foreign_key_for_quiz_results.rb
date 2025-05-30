class FixForeignKeyForQuizResults < ActiveRecord::Migration[7.1]
  def up
    # 外部キー制約を削除（旧 categories テーブル向け）
    remove_foreign_key :quiz_results, :categories, if_exists: true

    # カラム名変更
    rename_column :quiz_results, :category_id, :question_category_id

    # 外部キーが使っている可能性のあるものを削除
    remove_foreign_key :quiz_results, column: :question_category_id, if_exists: true

    # インデックス削除（旧名・新名どちらも考慮）
    remove_index :quiz_results, name: 'index_quiz_results_on_category_id', if_exists: true
    remove_index :quiz_results, name: 'index_quiz_results_on_question_category_id', if_exists: true

    # インデックス追加（新しいカラム名に対して）
    add_index :quiz_results, :question_category_id, name: 'index_quiz_results_on_question_category_id'

    # 外部キー追加
    add_foreign_key :quiz_results, :question_categories, column: :question_category_id
  end

  def down
    remove_foreign_key :quiz_results, column: :question_category_id, if_exists: true

    remove_index :quiz_results, name: 'index_quiz_results_on_question_category_id', if_exists: true

    rename_column :quiz_results, :question_category_id, :category_id

    add_index :quiz_results, :category_id, name: 'index_quiz_results_on_category_id'

    # categories テーブルが存在するときだけ外部キー追加
    add_foreign_key :quiz_results, :categories, column: :category_id if table_exists?(:categories)
  end
end
