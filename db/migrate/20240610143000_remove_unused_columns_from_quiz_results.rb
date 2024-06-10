class RemoveUnusedColumnsFromQuizResults < ActiveRecord::Migration[7.1]
  def change
    remove_column :quiz_results, :correct, :boolean
    remove_column :quiz_results, :answer_detail, :text
  end
end
