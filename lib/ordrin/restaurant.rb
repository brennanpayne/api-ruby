require_relative 'ordrinapi'
require_relative 'normalize'

module Ordrin
  # This object's methods access the ordr.in restaurant API. All return values
  # are documented at http://ordr.in/developers/restaurant
  class RestaurantApi < OrdrinApi
    # Get a list of dicts representing restaurants that will deliver to the
    # given address at the given time.
    # Arguments:
    # date_time -- Either 'ASAP' or a datetime object in the future
    # address -- the address to deliver to. Should be an Ordrin::Data::Address object
    def get_delivery_list(date_time, address)
      dt = Normalize.normalize(date_time, :datetime)
      return call_api(:get, ['dl', dt, address.zip, address.city, address.addr])
    end

    # Get data about a given restaurant, including whether it will deliver to
    # the specified address at the specified time
    # Arguments:
    # restaurant_id -- Ordr.in's restaurant identifier
    # date_time -- Either 'ASAP' or a datetime object in the future
    # address -- the address to deliver to. Should be an Ordrin::Data::Address object
    def get_delivery_check(restaurant_id, date_time, address)
      dt = Normalize.normalize(date_time, :datetime)
      restauant_id = Normalize.normalize(restaurant_id, :number)
      return call_api(:get, ['dc', restaurant_id, dt, address.zip, address.city, address.addr])
    end

    # Get data about a given restaurant, including whether it will deliver to
    # the specified address at the specified time, and what the fee will be on an
    # order with the given subtotal and tip
    # Arguments:
    # restaurant_id -- Ordr.in's restaurant identifier
    # subtotal -- the subtotal of the order
    # tip -- the tip on the order
    # date_time -- Either 'ASAP' or a datetime object in the future
    # address -- the address to deliver to. Should be an Ordrin::Data::Address object
    def get_fee(restaurant_id, subtotal, tip, date_time, address)
      dt = Normalize.normalize(date_time, :datetime)
      restaurant_id = Normalize.normalize(restaurant_id, :number)
      subtotal = Normalize.normalize(subtotal, :money)
      tip = Normalize.normalize(tip, :money)
      return call_api(:get, ['fee', restaurant_id, subtotal, tip, dt, address.zip, address.city, address.addr])
    end
    
    # Get details of the given restaurant, including contact information and
    # the menu
    # Arguments:
    # restaurant_id -- Ordr.in's restaurant identifier
    def get_details(restaurant_id)
      restaurant_id = Normalize.normalize(restaurant_id, :number)
      return call_api(:get, ['rd', restaurant_id])
    end
  end
end
