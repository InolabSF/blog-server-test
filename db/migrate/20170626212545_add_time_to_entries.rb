class AddTimeToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :time, :timestamp
  end
end
