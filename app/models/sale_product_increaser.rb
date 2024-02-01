class SaleProductIncreaser < ApplicationRecord
  belongs_to :product
  belongs_to :user
  after_create :increase_product_initial_remaining
  before_destroy :decrease_product_initial_remaining

  private

  def increase_product_initial_remaining
    if product.for_sale
      product.increment!(:initial_remaining, amount)
    else
      product.decrement!(:initial_remaining, amount)
    end
  end

  def decrease_product_initial_remaining
    if product.for_sale
      product.decrement!(:initial_remaining, amount)
    else
      product.increment!(:initial_remaining, amount)
    end
  end
end
