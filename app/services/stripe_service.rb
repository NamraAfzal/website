require 'stripe'

class StripeService
  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def find_or_create_order(order, user)
    if order.stripe_customer_id.present?
      begin
        stripe_customer = Stripe::Customer.retrieve(order.stripe_customer_id)
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error "Error retrieving Stripe customer: #{e.message}"
        stripe_customer = nil
      end
    end

    if stripe_customer.nil?
      stripe_customer = Stripe::Customer.create({
        name: user.name,
        email: user.email,
        address: {
          line1: order.shipping_address
        }
      })
      order.update!(stripe_customer_id: stripe_customer.id)
    end

    stripe_customer
  end

  def create_card_token(params)
    Stripe::Token.retrieve('tok_mastercard')
  end

  def create_stripe_customer_card(params, stripe_customer)
    token = create_card_token(params)
    Stripe::Customer.create_source(
      stripe_customer.id,
      { source: token.id }
    )
  end

  def create_stripe_charge(amount_to_be_paid, stripe_customer_id, card_id, order_items)
    Stripe::Charge.create({
      amount: amount_to_be_paid,
      currency: 'usd',
      source: card_id,
      customer: stripe_customer_id,
      description: "Amount $#{amount_to_be_paid} charged for #{order_items} "
    })
  end
end
