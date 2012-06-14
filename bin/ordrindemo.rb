#! /usr/bin/env ruby
require 'date'
require 'securerandom'
require 'pp'

begin
  require 'ordrin'
rescue LoadError
  require 'rubygems'
  begin
    require 'ordrin'
  rescue LoadError
    require_relative '../lib/ordrin'
  end
end

#
# Global Variables
#
puts "Please input your API key: "
STDOUT.flush
api_key = gets.chomp

# Create an Address object
address = Ordrin::Data::Address.new('1 Main Street', 'College Station', 'TX', '77840', '(555) 555-5555')
address_nick = 'addr1'

# Create a CreditCard object
first_name = 'Test'
last_name = 'User'
credit_card = Ordrin::Data::CreditCard.new("#{first_name} #{last_name}", '01', Date.today.year.to_s, address, '4111111111111111', '123')
credit_card_nick = 'cc1'

unique_id = SecureRandom.uuid
email = "demo+#{unique_id}_ruby@ordr.in"
password = 'password'
login = Ordrin::Data::UserLogin.new(email, password)
alt_first_name = 'Example'
alt_email = "demo+#{unique_id}_rubyalt@ordr.in"
alt_login = Ordrin::Data::UserLogin.new(alt_email, password)
new_password = 'password1'

#
# Restaurant demo functions
#

def delivery_list_immediate_demo()
  print "Get a list of restaurants that will deliver if you order now"
  delivery_list_immediate = api.restaurant.get_delivery_list('ASAP', address)
  PP.pp(delivery_list_immediate)
  return delivery_list_immediate
end

def delivery_list_future_demo()
  print "Get a list of restaurants that will deliver if you order for 12 hours from now"
  future_datetime = Datetime.now + 0.5 #A timestamp twelve hours in the future
  delivery_list_later = api.restaurant.get_delivery_list(future_datetime, address)
  PP.pp(delivery_list_later)
end

def delivery_check_demo(restaurant_id)
  print "Get whether a particular restaurant will deliver if you order now"
  delivery_check = api.restaurant.get_delivery_check(restaurant_id, 'ASAP', address)
  PP.pp(delivery_check)
end

def fee_demo(restaurant_id)
  print "Get fee and other info for ordering a given amount with a given tip"
  subtotal = "$30.00"
  tip = "$5.00"
  fee_info = api.restaurant.get_fee(restaurant_id, subtotal, tip, 'ASAP', address)
  PP.pp(fee_info)
end

def detail_demo(restaurant_id)
  print "Get detailed information about a single restaurant"
  restaurant_detail = api.restaurant.get_details(restaurant_id)
  PP.pp(restaurant_detail)
  return restaurant_detail
end

def find_deliverable_time(restaurant_id)
  print "Find a time when this restaurant will deliver"
  delivery_check = api.restaurant.get_delivery_check(restaurant_id, 'ASAP', address)
  delivery = delivery_check['delivery']
  if delivery
    return 'ASAP'
  end
  dt = DateTime.now + 1/24.0
  while not delivery
    delivery_check = api.restaurant.get_delivery_check(restaurant_id, dt, address)
    delivery = delivery_check['delivery']
    dt += 1/24.0
  end
  return dt
end    
#
# User demo functions
#

def get_user_demo()
  print "Get information about a user"
  user_info = api.user.get(login)
  PP.pp(user_info)
end

def create_user_demo()
  print "Create a user"
  response = api.user.create(login, first_name, last_name)
  PP.pp(response)
end

def update_user_demo()
  print "Update a user"
  response = api.user.update(login, alt_first_name, last_name)
  PP.pp(response)
end

def get_all_addresses_demo()
  print "Get a list of all saved addresses"
  address_list = api.user.get_all_addresses(login)
  PP.pp(address_list)
end

def get_address_demo()
  print "Get an address by nickname"
  addr = api.user.get_address(login, address_nick)
  PP.pp(addr)
end

def set_address_demo()
  print "Save an address with a nickname"
  response = api.user.set_address(login, address_nick, address)
  PP.pp(response)
end

def remove_address_demo()
  print "Remove a saved address by nickname"
  response = api.user.remove_address(login, address_nick)
  PP.pp(response)
end

def get_all_credit_cards_demo()
  print "Get a list of all saved credit cards"
  credit_card_list = api.user.get_all_credit_cards(login)
  PP.pp(credit_card_list)
end

def get_credit_card_demo()
  print "Get a saved credit card by nickname"
  credit_card = api.user.get_credit_card(login, credit_card_nick)
  PP.pp(credit_card)
end

def set_credit_card_demo()
  print "Save a credit card with a nickname"
  response = api.user.set_credit_card(login, credit_card_nick, credit_card)
  PP.pp(response)
end

def remove_credit_card_demo()
  print "Remove a saved credit card by nickname"
  response = api.user.remove_credit_card(login, credit_card_nick)
  PP.pp(response)
end

def get_order_history_demo(login)
  print "Get a list of all orders made by this user"
  order_list = api.user.get_order_history(login)
  PP.pp(order_list)
end

def get_order_detail_demo(oid)
  print "Get the details of a particular order made by this user"
  order_detail = api.user.get_order_detail(login, oid)
  PP.pp(order_detail)
end

def set_password_demo()
  print "Set a new password for a user"
  response = api.user.set_password(login, new_password)
  PP.pp(response)
end
  
#
# Order demo functions
#

def anonymous_order_demo(restaurant_id, tray, date_time)
  print "Order food as someone without a user account"
  tip = Random.rand(500)/100.0
  response = api.order.order(restaurant_id, tray, tip, date_time, first_name, last_name, address, credit_card, email=email)
  PP.pp(response)
end

def create_user_and_order_demo(restaurant_id, tray, date_time)
  print "Order food and create an account"
  tip = Random.rand(500)/100.0
  response = api.order.order_create_user(restaurant_id, tray, tip, date_time, first_name, last_name, address, credit_card, alt_email, password)
  PP.pp(response)
end

def order_with_nicks_demo(restaurant_id, tray, date_time)
  print "Order food as a logged in user using previously stored address and credit card"
  tip = Random.rand(500)/100.0
  response = api.order.order(restaurant_id, tray, tip, date_time, first_name, last_name, address_nick, credit_card_nick, login=login)
  PP.pp(response)
  return response
end

def find_item_to_order(item_list)
  for item in item_list
    if item['is_orderable']
      if item['price'].to_f>=5.00
        return item['id']
      end
    else
      if item.has_key?('children')
        item_id = find_item_to_order(item['children'])
        unless item_id.nil?
          return item_id
        end
      end
    end
  end
  return None
end
    

#
# Main
#
def run_demo()
  print "Run through the entire demo sequence"
  # Restaurant functions
  delivery_list = delivery_list_immediate_demo()
  delivery_list_future_demo()
  restaurant_id = delivery_list[0]['id']
  delivery_check_demo(restaurant_id)
  fee_demo(restaurant_id)
  detail = detail_demo(restaurant_id)

  # User functions
  create_user_demo()
  get_user_demo()
  update_user_demo()
  get_user_demo()
  set_address_demo()
  get_address_demo()
  set_credit_card_demo()
  get_credit_card_demo()

  # Order functions
  order_date_time = find_deliverable_time(restaurant_id)
  print "Ordering food at #{order_date_time}"
  item_id = find_item_to_order(detail['menu'])
  item = ordrin.data.TrayItem(item_id, quantity=10)
  tray = ordrin.data.Tray(item)
  anonymous_order_demo(restaurant_id, tray, order_date_time)
  order = order_with_nicks_demo(restaurant_id, tray, order_date_time)
  unless order.nil?
    get_order_detail_demo(order['refnum'])
  end

  create_user_and_order_demo(restaurant_id, tray, order_date_time)
  get_order_history_demo(alt_login)

  # Clean up/removing stuff
  remove_address_demo()
  get_all_addresses_demo()
  remove_credit_card_demo()
  get_all_credit_cards_demo()
  set_password_demo()
  #After changing the password I must change the login object to continue to access user info
end

run_demo()
  
