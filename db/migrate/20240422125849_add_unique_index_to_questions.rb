class AddUniqueIndexToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_index :questions, [:category_id, :number], unique: true
  end
end
