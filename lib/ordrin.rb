require_relative 'ordrin/api_helper'

module Ordrin
  class APIs
    def initialize(api_key, servers=:test)
      @helper = APIHelper.new(api_key, servers)
    end

    
    # order endpoints
    
    def order_guest(args)
=begin
      Arguments:
    rid--Ordr.in's unique restaurant identifier for the restaurant.
    em--The customer's email address
    tray--Represents a tray of menu items in the format '[menu item id]/[qty],[option id],...,[option id]'
    tip--Tip amount in dollars and cents
    first_name--The customer's first name
    last_name--The customer's last name
    phone--The customer's phone number
    zip--The zip code part of the address
    addr--The street address
    city--The city part of the address
    state--The state part of the address
    card_number--Credit card number
    card_cvc--3 or 4 digit security code
    card_expiry--The credit card expiration date.
    card_bill_addr--The credit card's billing street address
    card_bill_city--The credit card's billing city
    card_bill_state--The credit card's billing state
    card_bill_zip--The credit card's billing zip code
    card_bill_phone--The credit card's billing phone number

    Keyword Arguments:
    addr2--The second part of the street address, if needed
    card_name--Full name as it appears on the credit card
    card_bill_addr2--The second part of the credit card's biling street address.


    Either
    delivery_date--Delivery date
    delivery_time--Delivery time
    OR
    delivery_date--Delivery date
=end
      @helper.call_endpoint(:order, "order_guest", ["rid"], args)
    end
    
    def order_user(args)
=begin
      Arguments:
    rid--Ordr.in's unique restaurant identifier for the restaurant.
    tray--Represents a tray of menu items in the format '[menu item id]/[qty],[option id],...,[option id]'
    tip--Tip amount in dollars and cents
    first_name--The customer's first name
    last_name--The customer's last name
    email -- The user's email
    current_password -- The user's current password

    Keyword Arguments:


    Either
    phone--The customer's phone number
    zip--The zip code part of the address
    addr--The street address
    addr2--The second part of the street address, if needed
    city--The city part of the address
    state--The state part of the address
    OR
    nick--The delivery location nickname. (From the user's addresses)
    Either
    card_name--Full name as it appears on the credit card
    card_number--Credit card number
    card_cvc--3 or 4 digit security code
    card_expiry--The credit card expiration date.
    card_bill_addr--The credit card's billing street address
    card_bill_addr2--The second part of the credit card's biling street address.
    card_bill_city--The credit card's billing city
    card_bill_state--The credit card's billing state
    card_bill_zip--The credit card's billing zip code
    card_bill_phone--The credit card's billing phone number
    OR
    card_nick--The credit card nickname. (From the user's credit cards)
    Either
    delivery_date--Delivery date
    delivery_time--Delivery time
    OR
    delivery_date--Delivery date
=end
      @helper.call_endpoint(:order, "order_user", ["rid"], args)
    end
    
    
    # restaurant endpoints
    
    def delivery_check(args)
=begin
      Arguments:
    datetime--Delivery date and time
    rid--Ordr.in's unique restaurant identifier for the restaurant.
    addr--Delivery location street address
    city--Delivery location city
    zip--The zip code part of the address

    Keyword Arguments:


=end
      @helper.call_endpoint(:restaurant, "delivery_check", ["rid", "datetime", "zip", "city", "addr"], args)
    end
    
    def delivery_list(args)
=begin
      Arguments:
    datetime--Delivery date and time
    addr--Delivery location street address
    city--Delivery location city
    zip--The zip code part of the address

    Keyword Arguments:


=end
      @helper.call_endpoint(:restaurant, "delivery_list", ["datetime", "zip", "city", "addr"], args)
    end
    
    def fee(args)
=begin
      Arguments:
    datetime--Delivery date and time
    rid--Ordr.in's unique restaurant identifier for the restaurant.
    subtotal--The cost of all items in the tray in dollars and cents.
    tip--The tip in dollars and cents.
    addr--Delivery location street address
    city--Delivery location city
    zip--The zip code part of the address

    Keyword Arguments:


=end
      @helper.call_endpoint(:restaurant, "fee", ["rid", "subtotal", "tip", "datetime", "zip", "city", "addr"], args)
    end
    
    def restaurant_details(args)
=begin
      Arguments:
    rid--Ordr.in's unique restaurant identifier for the restaurant.

    Keyword Arguments:


=end
      @helper.call_endpoint(:restaurant, "restaurant_details", ["rid"], args)
    end
    
    
    # user endpoints
    
    def change_password(args)
=begin
      Arguments:
    email--The user's email address
    password--The user's new password
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "change_password", ["email"], args)
    end
    
    def create_account(args)
=begin
      Arguments:
    email--The user's email address
    pw--The user's password
    first_name--The user's first name
    last_name--The user's last name

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "create_account", ["email"], args)
    end
    
    def create_addr(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    phone--The customer's phone number
    zip--The zip code part of the address
    addr--The street address
    city--The city part of the address
    state--The state part of the address
    current_password -- The user's current password

    Keyword Arguments:
    addr2--The second part of the street address, if needed


=end
      @helper.call_endpoint(:user, "create_addr", ["email", "nick"], args)
    end
    
    def create_cc(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    card_number--Credit card number
    card_cvc--3 or 4 digit security code
    card_expiry--The credit card expiration date.
    bill_addr--The credit card's billing street address
    bill_city--The credit card's billing city
    bill_state--The credit card's billing state
    bill_zip--The credit card's billing zip code
    bill_phone--The credit card's billing phone number
    current_password -- The user's current password

    Keyword Arguments:
    bill_addr2--The second part of the credit card's biling street address.


=end
      @helper.call_endpoint(:user, "create_cc", ["email", "nick"], args)
    end
    
    def delete_addr(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "delete_addr", ["email", "nick"], args)
    end
    
    def delete_cc(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "delete_cc", ["email", "nick"], args)
    end
    
    def get_account_info(args)
=begin
      Arguments:
    email--The user's email address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_account_info", ["email"], args)
    end
    
    def get_all_saved_addrs(args)
=begin
      Arguments:
    email--The user's email address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_all_saved_addrs", ["email"], args)
    end
    
    def get_all_saved_ccs(args)
=begin
      Arguments:
    email--The user's email address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_all_saved_ccs", ["email"], args)
    end
    
    def get_order(args)
=begin
      Arguments:
    email--The user's email address
    oid--Ordr.in's unique order id number.
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_order", ["email", "oid"], args)
    end
    
    def get_order_history(args)
=begin
      Arguments:
    email--The user's email address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_order_history", ["email"], args)
    end
    
    def get_saved_addr(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_saved_addr", ["email", "nick"], args)
    end
    
    def get_saved_cc(args)
=begin
      Arguments:
    email--The user's email address
    nick--The nickname of this address
    current_password -- The user's current password

    Keyword Arguments:


=end
      @helper.call_endpoint(:user, "get_saved_cc", ["email", "nick"], args)
    end
    
    
  end
end
