require_relative 'ordrinapi'
require_relative 'normalize'
require_relative 'data'

module Ordrin
  # This class will be used to access the order API. All return values
  # are documented at http://ordr.in/developers/order
  class OrderApi < OrdrinApi

    private

    #Put all of the data that needs to be passed to the POST request normalized into a dict.
    def build_dict(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, login=nil)
      data = {'restaurant_id' => Normalize.normalize(restaurant_id, :number),
        'tray' => tray.to_s,
        'tip' => Normalize.normalize(tip, :money),
        'delivery_date' => Normalize.normalize(delivery_date_time, :date)}
      if data['delivery_date'] != 'ASAP'
        data['delivery_time'] = Normalize.normalize(delivery_date_time, :time)
      end
      data['first_name'] = Normalize.normalize(first_name, :name)
      data['last_name'] = Normalize.normalize(last_name, :name)
      begin
        data.merge!(address.make_dict)
      rescue NoMethodError=>e
        data['nick'] = Normalize.normalize(address, :nick)
      end
      if login.nil?
        data['em'] = Normalize.normalize(email, :email)
      end
      begin
        credit_card.make_dict.each_pair do |key, value|
          data["card_#{key}"] = value
        end
      rescue NoMethodError=>e
        data['card_nick'] = Normalize.normalize(credit_card, :nick)
      end
      data['type'] = 'res'
      return data
    end

    public
    # Place an order, either anonymously or as a logged in user. At least one
    # of email and login must be passed. If both are passed, email will be ignored.
    # Arguments:
    # restaurant_id -- Ordr.in's restaurant identifier
    # tray -- A tray of food to order. Should be an ordrin.data.Tray object
    # tip -- The tip amount
    # delivery_date_time -- Either 'ASAP' or a datetime object in the future
    # first_name -- The orderer's first name
    # last_name -- The orderer's last name
    # address -- An address object (Ordrin::Data::Address) or the nickname of a saved address
    # credit_card -- A credit card object (Ordrin::Data::CreditCard) or the nickname of a saved credit card
    # email -- The email address of an anonymous user
    # login -- The logged in user's login information. Should be an ordrin.data.UserLogin object
    def order(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email=nil, login=nil)
      data = build_dict(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, login)
      return call_api(:post, ['o', restaurant_id], login, data)
    end

    # Place an order and create a user account
    # Arguments:
    # restaurant_id -- Ordr.in's restaurant identifier
    # tray -- A tray of food to order. Should be an ordrin.data.Tray object
    # tip -- The tip amount
    # delivery_date_time -- Either 'ASAP' or a datetime object in the future
    # first_name -- The orderer's first name
    # last_name -- The orderer's last name
    # address -- An address object (Ordrin::Data::Address) or the nickname of a saved address
    # credit_card -- A credit card object (Ordrin::Data::CreditCard) or the nickname of a saved credit card
    # email -- The email address of the user
    # password -- The user's password (in plain text)
    def order_create_user(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, password)
      data = build_dict(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email)
      data['pw'] = Data::UserLogin.hash_password(password)
      return call_api(:post, ['o', restaurant_id], nil, data)
    end
  end
end
