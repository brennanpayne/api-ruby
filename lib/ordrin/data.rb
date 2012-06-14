require './digest'
require './normalize'
module Ordrin
  module Data
    class OrdrinData
      def make_dict
        dict = {}
        fields.map {|f| dict[f.to_s]=self.send(f)}
        return dict
      end
    end

    class Address < OrdrinData
      @fields = [:addr, :city, :state, :zip, :phone, :addr2]

      attr_reader :addr, :city, :state, :zip, :phone, :addr2
      
      def initialize(addr, city, state, zip, phone, addr2='')
        @addr = addr
        @city = normalize(city, :city)
        @state = normalize(state, :state)
        @zip = normalize(zip, :zip)
        @phone = normalize(phone, :phone)
      end
    end

    class CreditCard < OrdrinData
      @fields = [:number, :cvc, :expiry_month, :expiry_year, :expiry,
                 :bill_addr, :bill_addr2, :bill_city, :bill_state, :bill_zip,
                 :phone, :name]

      attr_reader :expiry_month, :expiry_year, :number, :cvc, :type, :name, :bill_address

      def initialize(name, expiry_month, expiry_year, bill_address, number, cvc)
        @expiry_month = normalize(expiry_month, :month)
        @expiry_year = normalize(expiry_year, :year)
        @number, @cvc, @type = normalize((number, cvc), :credit_card)
        @name = name
        @bill_address = bill_address
      end

      def bill_addr
        @bill_address.addr
      end

      def bill_addr2
        @bill_address.addr2
      end

      def bill_city
        @bill_address.city
      end

      def bill_state
        @bill_address.state
      end
      
      def bill_zip
        @bill_address.zip
      end

      def phone
        @bill_address.phone
      end

      def expiry
        "#{expiry_month}/#{expiry_year}"
      end
    end

    class UserLogin < OrdrinData
      
      fields = [:email, :password]

      def initialize(email, password)
        @email = email
        @password = UserLogin.hash_password(password)
      end

      def UserLogin.hash_password(password)
        return Digest::SHA256.new.hexdigest(password)
      end
    end

    class TrayItem
      
      def initialize(item_id, quantity, *options)
        @item_id = normalize(item_id, :number)
        @quantity = normalize(quantity, :number)
        @options = options.map {|opt| normalize(opt, :number)}
      end

      def to_s
        "#{@item_id}/#{@quantity},#{options*','}"
      end
    end

    class Tray
      
      def initialize(*items)
        @items = items
      end

      def to_s
        return items*'+'
      end
    end
  end
end
