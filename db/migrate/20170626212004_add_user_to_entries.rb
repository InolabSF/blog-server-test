class AddUserToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :user, :string
  end
end
