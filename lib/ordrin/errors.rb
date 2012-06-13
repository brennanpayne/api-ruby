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
    return "ApiError(msg='#{msg}', text='#{text}')"
  end
end

class ApiInvalidResponseError < OrdrinError
  def to_s
    return "ApiInvalidResponseError(msg='#{msg}')"
  end
end

module Errors
  def state(value)
    ArgumentError.new("State must be a two letter postal code abbreviation: #{value}")
  end

  def money(value)
    ArgumentError.new("Money must be dollars.cents: #{value}")
  end

  def zip(value)
    ArgumentError.new("Zip code must be exactly 5 digits: #{value}")
  end

  def phone(value)
    return ArgumentError.new("Phone numbers must have exactly 10 digits: #{value}")
  end

  def number(value)
    return ArgumentError.new("This value must be only digits: #{value}")
  end

  def month(value)
    return ArgumentError.new("Months must be two digits: #{value}")
  end

  def year(value)
    return ArgumentError.new("Years must be four digits: #{value}")
  end

  def cvc(value)
    return ArgumentError.new("Credit card CVC must be 3 or 4 digits, depending on the card type: #{value}")
  end

  def credit_card(value)
    return ArgumentError.new("Credit card number must be a valid AmEx, Discover, Mastercard, or Visa card number: #{value}")
  end

  def email(value)
    return ArgumentError.new("Bad email format: #{value}")
  end

  def normalizer(value)
    return ArgumentError.new("Unknown validator name: #{value}")
  end

  def nick(value)
    return ArgumentError.new("Nick names can only have letters, nubmers, dashes, and underscores: #{value}")
  end

  def date_time(value)
    return ArgumentError.new("date_time must be a datetime.datetime object or the string 'ASAP': #{value}")
  end

  def date(value)
    return ArgumentError.new("date must be a datetime.datetime or datetime.date object or the string 'ASAP': #{value}")
  end

  def time(value)
    return ArgumentError.new("time must be a datetime.datetime or datetime.time object: #{value}")
  end

  def url(value)
    return ArgumentError.new("url must be a proper url: #{value}")
  end

  def method(value)
    return ArgumentError.new("method must be a word: #{value}")
  end

  def alphanum(value)
    return ArgumentError.new("This value must be alphanumeric: #{value}")
  end

  def request_method(value)
    return ApiError.new("Method not a valid HTTP request method: #{value}")
  end
end
