class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :category, null: false, foreign_key: true
      t.integer :number, null: false
      t.text :content, null: false
      t.text :explanation

      t.timestamps
    end
  end
end
