class RemoveMemoFromQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :memo, :text
  end
end
