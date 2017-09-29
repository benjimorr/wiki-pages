class ChargesController < ApplicationController
    def new
        @stripe_btn_data = {
            key: "#{ Rails.configuration.stripe[:publishable_key] }",
            description: "Upgrade to Premium",
            amount: charge_amount
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
            amount: charge_amount,
            description: "Upgrade to Premium - #{current_user.email}",
            currency: 'usd'
        )

        # Upgrades user account
        current_user.premium!

        flash[:notice] = "Thanks for upgrading, #{current_user.email}! You are now a premium member."
        redirect_to root_path

        # Catches and displays errors.
    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
    end

    def downgrade
        user_wikis = Wiki.where(user_id = current_user.id)
        user_wikis.each do |wiki|
            wiki.private = false
            wiki.save
        end
        current_user.standard!
        flash[:notice] = "You have been successfully downgraded. You are now a standard member."
        redirect_to root_path
    end

    private
    def charge_amount
        15_00
    end
end
