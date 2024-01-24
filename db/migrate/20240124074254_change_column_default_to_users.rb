class ChangeColumnDefaultToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :introduction, from: nil, to: "紹介文を記入"
  end
end
