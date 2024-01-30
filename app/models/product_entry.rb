# total paid might be null, it means provider paid fully at once
# ignored service_price
class ProductEntry < ApplicationRecord
  attr_accessor :excel_data
  attr_accessor :product_category_id

  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty
  has_one :provider, through: :delivery_from_counterparty
  has_one :user, through: :delivery_from_counterparty
  belongs_to :product
  validates :amount, comparison: { greater_than: 0 }
  validates :buy_price, comparison: { greater_than_or_equal_to: 0 }
  validates_presence_of :buy_price, unless: -> { local_entry }

  before_validation :varify_delivery_from_counterparty_is_not_closed
  before_save :set_sell_price
  before_create :set_currency
  before_update :amount_sold_is_not_greater_than_amount
  before_destroy :varify_delivery_from_counterparty_is_not_closed
  after_create :update_delivery_currency
  after_update :notify_on_remaining_inequality, if: :saved_change_to_amount_sold?

  scope :paid_in_uzs, -> { where('paid_in_usd = ?', false) }
  scope :paid_in_usd, -> { where('paid_in_usd = ?', true) }

  private

  def set_sell_price
    self.sell_price = buy_price
  end

  def notify_on_remaining_inequality
    return if amount > amount_sold

    SendMessage.run(
      message: '<b>ERROR</b>\nОстаток товара в минусах\n' \
                "Товар: #{product.name}\n" \
                "Остаток: #{product.calculate_product_remaining}\n"
    )
  end

  def set_currency
    self.paid_in_usd = product.price_in_usd
  end

  def amount_sold_is_not_greater_than_amount
    return errors.add(:base, "amount sold cannot be greater than amount") if amount_sold > amount
  end

  def varify_delivery_from_counterparty_is_not_closed
    throw(:abort) if delivery_from_counterparty.closed? && sell_price == sell_price_before_last_save && amount >= amount_sold
    delivery_from_counterparty.decrement!(:total_price, buy_price)
  end

  def update_delivery_currency
    return if delivery_from_counterparty.nil? || delivery_from_counterparty.price_in_usd == paid_in_usd

    delivery_from_counterparty.update(price_in_usd: paid_in_usd)
  end

  def update_delivery_category
    return if delivery_from_counterparty&.product_category_id == product.product_category_id

    delivery_from_counterparty.update(product_category_id: product.product_category_id)
  end
end
