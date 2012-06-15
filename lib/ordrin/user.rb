require_relative 'ordrinapi'
require_relative 'normalize'
require_relative 'data'

module Ordrin
  # This class will be used to access the user API. All return values
  # are documented at http://ordr.in/developers/user
  class UserApi < OrdrinApi
    # Gets account information for the user associated with login
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    def get(login)
      return call_api(:get, ['u', login.email], login)
    end

    # Creates account for the user associated with login. Throws a relevant exception
    # on failure.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # first_name -- the user's first name
    # last_name -- the user's last name
    def create(login, first_name, last_name)
      data = {'email' => login.email,
        'first_name' => Normalize.normalize(first_name, :name),
        'last_name' => Normalize.normalize(last_name, :name),
        'pw' => login.password}
      return call_api(:post, ['u', login.email], nil, data)
    end

    # Updates account for the user associated with login. Throws a relevant exception
    # on failure.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # first_name -- the user's first name
    # last_name -- the user's last name
    def update(login, first_name, last_name)
      data = {'email' => login.email,
        'first_name' => Normalize.normalize(first_name, :name),
        'last_name' => Normalize.normalize(last_name, :name),
        'pw' => login.password}
      return call_api(:post, ['u', login.email], login, data)
    end

    # Get a list of all saved addresses for the user associated with login.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    def get_all_addresses(login)
      return call_api(:get, ['u', login.email, 'addrs'], login)
    end
    
    # Get a saved address belonging to the logged in user by nickname.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # addr_nick -- the nickname of the address to get
    def get_address(login, addr_nick)
      return call_api(:get, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login)
    end

    # Save an address by nickname for the logged in user
    # Throws a relevant exception on failure
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # addr_nick -- the nickname of the address to save
    # address -- the address to save. Should be an Ordrin::Data::Address object
    def set_address(login, addr_nick, address)
      return call_api(:put, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login, address.make_dict)
    end

    # Remove an address, saved by the logged in user, by nickname
    # Throws a relevant exception on failure.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # addr_nick -- the nickname of the address to remove
    def remove_address(login, addr_nick)
      return call_api(:delete, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login)
    end

    # Get a list of all saved credit cards for the user associated with login.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    def get_all_credit_cards(login)
      return call_api(:get, ['u', login.email, 'ccs'], login)
    end

    # Get a saved credit card belonging to the logged in user by nickname.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # card_nick -- the nickname of the credit card to get
    def get_credit_card(login, card_nick)
      return call_api(:get, ['u', login.email, 'ccs', Normalize.normalize(card_nick, :nick)], login)
    end

    # Save an credit card by nickname for the logged in user
    # Throws a relevant exception on failure
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # card_nick -- the nickname of the credit card to save
    # credit_card -- the credit card to save. Should be an Ordrin::Data::CreditCard object
    def set_credit_card(login, card_nick, credit_card)
      card_nick = Normalize.normalize(card_nick, :nick)
      data = credit_card.make_dict
      data.merge!(login.make_dict)
      data['nick'] = card_nick
      return call_api(:put, ['u', login.email, 'ccs', card_nick], login, data)
    end

    # Remove an credit card, saved by the logged in user, by nickname
    # Throws a relevant exception on failure.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # card_nick -- the nickname of the credit card to remove
    def remove_credit_card(login, card_nick)
      return call_api(:delete, ['u', login.email, 'ccs', Normalize.normalize(card_nick, :nick)], login)
    end

    # Get a list of previous orders by the logged in user.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    def get_order_history(login)
      return call_api(:get, ['u', login.email, 'orders'], login)
    end

    # Get details of a particular previous order by the logged in user.
    # Arguments:
    # login -- the user's login information. Should be an Ordrin::Data::UserLogin object
    # order_id -- The order ID
    def get_order_detail(login, order_id)
      return call_api(:get, ['u', login.email, 'orders', Normalize.normalize(order_id, :alphanum)], login)
    end

    # Change the logged in user's password.
    # Arguments:
    # login -- the user's current login information. Should be an Ordrin::Data::UserLogin object
    # new_password -- the new password (in plain text)
    def set_password(login, new_password)
      data = {'email' => login.email,
        'password' => Data::UserLogin.hash_password(new_password),
        'previous_password' => login.password}
      return self.call_api(:put, ['u', login.email, 'password'], login, data)
    end
  end
end
