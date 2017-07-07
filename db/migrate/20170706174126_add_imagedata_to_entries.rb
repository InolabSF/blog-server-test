class AddImagedataToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :imagedata, :bynary
  end
end
