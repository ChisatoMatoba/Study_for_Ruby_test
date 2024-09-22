class AddMemoToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :memo, :text
  end
end
