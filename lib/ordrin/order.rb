require_relative 'ordrinapi'
require_relative 'normalize'
require_relative 'data'

module Ordrin
  class OrderApi < OrdrinApi

    private

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

    def order(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email=nil, login=nil)
      data = build_dict(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, login)
      return call_api(:post, ['o', restaurant_id], login, data)
    end

    def order_create_user(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, password)
      data = build_dict(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email)
      data['pw'] = Data::UserLogin.hash_password(password)
      return call_api(:post, ['o', restaurant_id], nil, data)
    end
  end
end
