require 'ordrinapi'
require 'normalize'

class RestaurantApi < OrdrinApi
  def get_delivery_list(date_time, address)
    dt = Normalize.normalize(date_time, :datetime)
    return call_api(:get, ['dl', dt, address.zip, address.city, address.addr])
  end

  def get_delivery_check(restaurant_id, date_time, address)
    dt = Normalize.normalize(date_time, :datetime)
    restauant_id = Normalize.normalize(restaurant_id, :number)
    return call_api(:get, ['dc', restaurant_id, dt, address.zip, address.city, address.addr])
  end

  def get_fee(restaurant_id, subtotal, tip, date_time, address)
    dt = Normalize.normalize(date_time, :datetime)
    restaurant_id = Normalize.normalize(restaurant_id, :number)
    subtotal = Normalize.normalize(subtotal, :money)
    tip = Normalize.normalize(tip, :money)
    return call_api(:get, ['fee', restaurant_id, subtotal, tip, dt, address.zip, address.city, address.addr])
  end

  def get_details(restaurant_id)
    restaurant_id = normalize(restaurant_id, :number)
    return call_api(:get, ['rd', restaurant_id])
  end
end
