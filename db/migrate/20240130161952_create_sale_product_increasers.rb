class CreateSaleProductIncreasers < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_product_increasers do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :amount, default: 1
      t.references :user, null: false, foreign_key: true
      t.string :comment
      t.timestamps
    end
  end
end
