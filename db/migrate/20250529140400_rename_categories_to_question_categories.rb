class RenameCategoriesToQuestionCategories < ActiveRecord::Migration[7.1]
  def change
    rename_table :categories, :question_categories
  end
end
