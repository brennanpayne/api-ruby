require 'digest'
require_relative 'normalize'
module Ordrin
  module Data
    # Base class for objects that can save any data with the constructor and then
    # extract it as a dictionary
    class OrdrinData
      # Return a dictionary of particular fields to values, determined per subclass
      def make_dict
        dict = {}
        fields.map {|f| dict[f.to_s]=self.send(f) unless self.send(f).nil?}
        return dict
      end
    end

    # Represents a street address
    class Address < OrdrinData

      attr_reader :addr, :city, :state, :zip, :phone, :addr2, :fields
      
      # Store the parts of the address as fields in this object.
      # Arguments:
      # addr -- Street address
      # city -- City
      # state -- State
      # zip -- Zip code
      # phone -- Phone number
      # addr2 -- Optional second street address line
      def initialize(addr, city, state, zip, phone, addr2='')
        @fields = [:addr, :city, :state, :zip, :phone, :addr2]
        @addr = addr
        @city = city
        @state = Normalize.normalize(state, :state)
        @zip = Normalize.normalize(zip, :zip)
        @phone = Normalize.normalize(phone, :phone)
      end
    end

    # Represents information about a credit card
    class CreditCard < OrdrinData

      attr_reader :expiry_month, :expiry_year, :number, :cvc, :type, :name, :bill_address, :fields

      # Store the credit card info as fields in this object.
      # Arguments:
      # name -- The name (first and last) on the credit card
      # expiry_month -- The month that the card expires (two digits)
      # expiry_year -- The year that the card expires (four digits)
      # bill_address -- The billing address. Should be an Ordrin::Data::Address object
      # number -- The credit card number
      # cvc -- The card verification number
      def initialize(name, expiry_month, expiry_year, bill_address, number, cvc)
        @fields = [:number, :cvc, :expiry_month, :expiry_year, :expiry,
                   :bill_addr, :bill_addr2, :bill_city, :bill_state, :bill_zip,
                   :phone, :name]
        @expiry_month = Normalize.normalize(expiry_month, :month)
        @expiry_year = Normalize.normalize(expiry_year, :year)
        @number, @cvc, @type = Normalize.normalize([number, cvc], :credit_card)
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

      # A combination of the expiry_month and expiry_date
      def expiry
        "#{expiry_month}/#{expiry_year}"
      end
    end

    #Represents a user's login information
    class UserLogin < OrdrinData
      
      attr_reader :email, :password, :fields

      # Store the email and password in this object. Saves only the hash of the
      # password, not the password itself
      # Arguments:
      # email -- The user's email address
      # password -- The user's password (in plain text)
      def initialize(email, password)
        @fields = [:email, :password]
        @email = email
        @password = UserLogin.hash_password(password)
      end

      def UserLogin.hash_password(password)
        return Digest::SHA256.new.hexdigest(password)
      end
    end

    # Represents a single item in an order
    class TrayItem
      
      # Store the descriptors of an order item in this object.
      # Arguments:
      # item_id -- the restaurants's numerial ID for the item
      # quantity -- the quantity
      # options -- any number of options to apply to the item
      def initialize(item_id, quantity, *options)
        @item_id = Normalize.normalize(item_id, :number)
        @quantity = Normalize.normalize(quantity, :number)
        @options = options.map {|opt| Normalize.normalize(opt, :number)}
      end

      def to_s
        "#{@item_id}/#{@quantity},#{@options*','}"
      end
    end

    # Represents a list of items in an order
    class Tray
      
      # Store the list of items in this object. Each argument should be of type Item
      # Arguments:
      # items -- A list of items to be ordered in this tray
      def initialize(*items)
        @items = items
      end

      def to_s
        return @items*'+'
      end
    end
  end
end
