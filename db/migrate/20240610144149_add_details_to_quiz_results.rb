class AddDetailsToQuizResults < ActiveRecord::Migration[7.1]
  def change
    add_column :quiz_results, :selected, :json, null: false
    add_column :quiz_results, :correct, :json, null: false
    add_column :quiz_results, :is_correct, :boolean, null: false
    add_column :quiz_results, :session_ts, :datetime, null: false
  end
end
