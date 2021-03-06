class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  before_create :create_from_cart

  enum status: %w(ordered paid cancelled completed)

  attr_accessor :cart_data

  def total
    order_items.inject(0) do |subtotal, order_item|
      subtotal + (order_item.item.final_price * order_item.quantity)
    end
  end

  private

  def create_from_cart
    if cart_data
      cart_data.each do |item_id, quantity|
        order_items.build(quantity: quantity, item_id: item_id.to_i, order_id: id)
      end
    end
  end
end
