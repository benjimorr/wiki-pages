class ChargesController < ApplicationController
    def new
        @stripe_btn_data = {
            key: "#{ Rails.configuration.stripe[:publishable_key] }",
            description: "BigMoney Membership - #{current_user.email}",
            amount: Amount.default
        }
    end

    def create
        # Creates a Stripe Customer object
        customer = Stripe::Customer.create(
            email: current_user.email,
            card: params[:stripeToken]
        )

        # Creates the charge object
        charge = Stripe::Charge.create(
            customer: customer.id,
            amount: Amount.default,
            description: "BigMoney Membership - #{current_user.email}",
            currency: 'usd'
        )

        # Upgrades user account
        current_user.premium!

        flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
        redirect_to root_path

        # Catches and displays errors.
    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
    end
end

class Amount
    def initialize
    end

    def default
        15_00
    end
end
