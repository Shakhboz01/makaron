class RemoveClientFromProductEntries < ActiveRecord::Migration[7.0]
  def change
    remove_reference :product_entries, :storage, null: false, foreign_key: true
  end
end
