class CreateMemos < ActiveRecord::Migration[7.1]
  def change
    create_table :memos, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end

    add_index :memos, [:user_id, :question_id], unique: true, name: "index_memos_on_user_question"
  end
end
