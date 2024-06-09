class CreateQuizResults < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :correct
      t.text :answer_detail

      t.timestamps
    end
  end
end
