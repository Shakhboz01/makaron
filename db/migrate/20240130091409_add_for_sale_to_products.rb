class AddForSaleToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :for_sale, :boolean, default: false
  end
end
