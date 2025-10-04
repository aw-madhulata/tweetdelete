class AddFieldsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :x_user_id, :string
  end
end
