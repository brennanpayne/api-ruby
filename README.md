Ordr.in Ruby API
==================

A Ruby wrapper for the Restaurant, User, and Order APIs provided by Ordr.in. Everything mentioned here is described in more detail in the documentation in the ruby files. The main API documentation can be found at http://ordr.in/developers.

The demo script (`bin/ordrindemo.rb`) has examples of calling every function and initializing all of the data structures.

Data Structures
---------------

```python
Ordrin::Data::Address(addr, city, state, zip, phone, addr2='')

Ordrin::Data::CreditCard(name, expiry_month, expiry_year, bill_address, number, cvc)

Ordrin::Data::UserLogin(email, password)

Ordrin::Data::TrayItem(item_id, quantity, *options)

Ordrin::Data::Tray(*items)
```

Exceptions
----------

```python
Ordrin::Errors::ApiError(msg, text)

Ordrin::Errors::ApiInvalidResponseError(msg)
```

API Initialization
------------------

```python
api = Ordrin::APIs(developer_key, servers, restaurant_url, user_url, order_url)
```

Restaurant API Functions
------------------------
All of these functions are in the `ordrin.restaurant` module.

```python
api.restaurant.get_delivery_list(date_time, address)

api.restaurant.get_delivery_check(retaurant_id, date_time, address)

api.restaurant.get_fee(restaurant_id, subtotal, tip, date_time, address)

api.restaurant.get_details(restaurant_id)
```

User API Functions
------------------
All of these functions are in the `ordrin.user` module.

```python
api.user.get(login)

api.user.create(login, first_name, last_name)

api.user.update(login, first_name, last_name)

api.user.get_all_addresses(login)

api.user.get_address(login, addr_nick)

api.user.set_address(login, addr_nick, address)

api.user.remove_address(login, addr_nick)

api.user.get_all_credit_cards(login)

api.user.get_credit_card(login, card_nick)

api.user.set_credit_card(login, card_nick, credit_card)

api.user.remove_credit_card(login, card_nick)

api.user.get_order_history(login)

api.user.get_order_detail(login, order_id)

api.user.set_password(login, new_password)
```

Order API Functions
-------------------
All of these functions are in the `ordrin.order` module.

```python
api.order.order(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email=None, login=None)

order_create_user(restaurant_id, tray, tip, delivery_date_time, first_name, last_name, address, credit_card, email, password)
```