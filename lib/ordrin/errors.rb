module Ordrin
  module Errors
    class OrdrinError < Exception
      attr_reader :msg

      def initialize(msg=nil)
        @msg = msg
      end
    end

    class ApiError < OrdrinError
      attr_reader :text
      def initialize(msg=nil, text=nil)
        super(msg)
        @text = text
      end

      def to_s
        "ApiError(msg='#{msg}', text='#{text}')"
      end
    end

    class ApiInvalidResponseError < OrdrinError
      def to_s
        "ApiInvalidResponseError(msg='#{msg}')"
      end
    end

    def state
      lambda do |value|
        ArgumentError.new("State must be a two letter postal code abbreviation: #{value}")
      end
    end

    def money
      lambda do |value|
        ArgumentError.new("Money must be dollars.cents: #{value}")
      end
    end

    def zip
      lambda do |value|
        ArgumentError.new("Zip code must be exactly 5 digits: #{value}")
      end
    end

    def phone
      lambda do |value|
        ArgumentError.new("Phone numbers must have exactly 10 digits: #{value}")
      end
    end

    def number
      lambda do |value|
        ArgumentError.new("This value must be only digits: #{value}")
      end
    end

    def month
      lambda do |value|
        ArgumentError.new("Months must be two digits: #{value}")
      end
    end

    def year
      lambda do |value|
        ArgumentError.new("Years must be four digits: #{value}")
      end
    end

    def cvc
      lambda do |value|
        ArgumentError.new("Credit card CVC must be 3 or 4 digits, depending on the card type: #{value}")
      end
    end

    def credit_card
      lambda do |value|
        ArgumentError.new("Credit card number must be a valid AmEx, Discover, Mastercard, or Visa card number: #{value}")
      end
    end

    def email
      lambda do |value|
        ArgumentError.new("Bad email format: #{value}")
      end
    end

    def normalizer
      lambda do |value|
        ArgumentError.new("Unknown validator name: #{value}")
      end
    end

    def nick
      lambda do |value|
        ArgumentError.new("Nick names can only have letters, nubmers, dashes, and underscores: #{value}")
      end
    end

    def date_time
      lambda do |value|
        ArgumentError.new("date_time must be a datetime.datetime object or the string 'ASAP': #{value}")
      end
    end

    def date
      lambda do |value|
        ArgumentError.new("date must be a datetime.datetime or datetime.date object or the string 'ASAP': #{value}")
      end
    end

    def time
      lambda do |value|
        ArgumentError.new("time must be a datetime.datetime or datetime.time object: #{value}")
      end
    end

    def url
      lambda do |value|
        ArgumentError.new("url must be a proper url: #{value}")
      end
    end

    def method
      lambda do |value|
        ArgumentError.new("method must be a word: #{value}")
      end
    end

    def alphanum
      lambda do |value|
        ArgumentError.new("This value must be alphanumeric: #{value}")
      end
    end

    def request_method
      lambda do |value|
        ApiError.new("Method not a valid HTTP request method: #{value}")
      end

    end
  end
end
