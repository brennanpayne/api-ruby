require 'ordrin/restaurant'
require 'ordrin/user'
require 'ordrin/order'

PRODUCTION = 0
TEST = 1
CUSTOM = 2

class APIs
  
  attr_reader :restaurant, :user, :order
  
  def initialize(api_key, servers, restaurant_url=nil, user_url=nil, order_url=nil)
    @api_key = api_key
    if servers!=CUSTOM
      unless restaurant_url.nil? and user_url.nil? and order_url.nil?
        raise ArgumentError.new("Individual URL parameters can only be set if servers is set to CUSTOM")
      end
    end
    if servers==PRODUCTION
      restaurant_url = "https://r.ordr.in/"
      user_url = "https://u.ordr.in/"
      order_url = "https://o.ordr.in/"
    elsif servers==TEST
      restaurant_url = "https://r-test.ordr.in/"
      user_url = "https://u-test.ordr.in/"
      order_url = "https://o-test.ordr.in/"
    elsif servers!=CUSTOM
      raise ArgumentError.new("servers must be set to PRODUCTION, TEST, or CUSTOM")
    end
    unless restaurant_url.nil?
      @restaurant = RestaurantApi(api_key, restaurant_url)
    end
    unless user_url.nil?
      @user = UserApi(api_key, user_url)
    end
    unless order_url.nil?
      @order = OrderApi(api_key, order_url)
    end
  end

  def config
    return {"API key" => api_key,
      "Restaurant URL" => @restaurant.base_url,
      "User URL" => @user.base_url,
      "Order URL" => @order.base_url}
end
