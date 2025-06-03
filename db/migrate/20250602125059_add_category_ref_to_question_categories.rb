class AddCategoryRefToQuestionCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :question_categories, :category, null: false, foreign_key: true
  end
end
