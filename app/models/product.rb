# initial remaining is changable, it can also be negative, but warn if it is a negative
# NOTE sell_price buy price might be 0
class Product < ApplicationRecord
  include ProtectDestroyable

  validates_presence_of :name
  has_many :product_entries
  has_many :product_remaining_inequalities
  has_many :sale_from_local_services
  enum unit: %i[ шт. кг метр пачка ]
  scope :active, -> { where(:active => true) }
  scope :local, -> { where(:local => true) }
  before_save :set_buy_price
  after_save :process_initial_remaining_change, if: :saved_change_to_initial_remaining?

  def self.generate_code
    rand(100_00..999_99).to_s
  end

  def product_code
    "#{code} #{name}"
  end

  def calculate_product_remaining
    remaining_from_entries = product_entries.sum(:amount) - product_entries.sum(:amount_sold)
    remaining_from_entries + initial_remaining
  end

  private

  def set_buy_price
    self.buy_price = sell_price
    self.unit = 0
  end

  def process_initial_remaining_change
    return if initial_remaining.positive? && !self.product_entries.count.zero?

    SendMessage.run(message: "Остаток товара(#{name}) = #{initial_remaining}", chat: 'warning')
  end
end
