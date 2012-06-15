require_relative 'ordrin/restaurant'
require_relative 'ordrin/user'
require_relative 'ordrin/order'
require_relative 'ordrin/data'

module Ordrin
  class APIs
    
    attr_reader :restaurant, :user, :order
    
    # Sets up this module to make API calls. The first argument is the developer's
    # API key. The other three are the URLs corresponding to the three parts of the api.
    # No API calls will work until this function is called. API objects will only be
    # instantiated for URLs that are passed in.

    # Arguments:
    # api_key -- The developer's API key
    # servers -- How the server URLs should be set. Must be :production, :test, or :custom
    # restaurant_url -- The base url for the restaurant API. Can only be set if servers==:custom.
    # user_url -- The base url for the user API. Can only be set if servers==:custom.
    # order_url -- The base url for the order API. Can only be set if servers==:custom.
    def initialize(api_key, servers, restaurant_url=nil, user_url=nil, order_url=nil)
      @api_key = api_key
      if servers!=:custom
        unless restaurant_url.nil? and user_url.nil? and order_url.nil?
          raise ArgumentError.new("Individual URL parameters can only be set if servers is set to :custom")
        end
      end
      if servers==:production
        restaurant_url = "https://r.ordr.in/"
        user_url = "https://u.ordr.in/"
        order_url = "https://o.ordr.in/"
      elsif servers==:test
        restaurant_url = "https://r-test.ordr.in/"
        user_url = "https://u-test.ordr.in/"
        order_url = "https://o-test.ordr.in/"
      elsif servers!=:custom
        raise ArgumentError.new("servers must be set to :production, :test, or :custom")
      end
      unless restaurant_url.nil?
        @restaurant = RestaurantApi.new(api_key, restaurant_url)
      end
      unless user_url.nil?
        @user = UserApi.new(api_key, user_url)
      end
      unless order_url.nil?
        @order = OrderApi.new(api_key, order_url)
      end
    end

    def config
      return {"API key" => api_key,
        "Restaurant URL" => @restaurant.base_url,
        "User URL" => @user.base_url,
        "Order URL" => @order.base_url}
    end
  end
end
