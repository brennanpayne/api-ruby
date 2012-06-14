require_relative 'ordrinapi'
require_relative 'normalize'
require_relative 'data'

module Ordrin
  class UserApi < OrdrinApi
    def get(login)
      return call_api(:get, ['u', login.email], login)
    end

    def create(login, first_name, last_name)
      data = {'email' => login.email,
        'first_name' => Normalize.normalize(first_name, :name),
        'last_name' => Normalize.normalize(last_name, :name),
        'pw' => login.password}
      return call_api(:post, ['u', login.email], nil, data)
    end

    def update(login, first_name, last_name)
      data = {'email' => login.email,
        'first_name' => Normalize.normalize(first_name, :name),
        'last_name' => Normalize.normalize(last_name, :name),
        'pw' => login.password}
      return call_api(:post, ['u', login.email], login, data)
    end

    def get_all_addresses(login)
      return call_api(:get, ['u', login.email, 'addrs'], login)
    end

    def get_address(login, addr_nick)
      return call_api(:get, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login)
    end

    def set_address(login, addr_nick, address)
      return call_api(:put, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login, address.make_dict)
    end

    def remove_address(login, addr_nick)
      return call_api(:delete, ['u', login.email, 'addrs', Normalize.normalize(addr_nick, :nick)], login)
    end

    def get_all_credit_cards(login)
      return call_api(:get, ['u', login.email, 'ccs'], login)
    end

    def get_credit_card(login, card_nick)
      return call_api(:get, ['u', login.email, 'ccs', Normalize.normalize(card_nick, :nick)], login)
    end

    def set_credit_card(login, card_nick, credit_card)
      card_nick = Normalize.normalize(card_nick, :nick)
      data = credit_card.make_dict
      data.merge!(login.make_dict)
      data['nick'] = card_nick
      return call_api(:put, ['u', login.email, 'ccs', card_nick], login, data)
    end

    def remove_credit_card(login, card_nick)
      return call_api(:delete, ['u', login.email, 'ccs', Normalize.normalize(card_nick, :nick)], login)
    end

    def get_order_history(login)
      return call_api(:get, ['u', login.email, 'orders'], login)
    end

    def get_order_detail(login, order_id)
      return call_api(:get, ['u', login.email, 'orders', Normalize.normalize(order_id, :alphanum)], login)
    end

    def set_password(login, new_password)
      data = {'email' => login.email,
        'password' => Data::UserLogin.hash_password(new_password),
        'previous_password' => login.password}
      return self.call_api(:put, ['u', login.email, 'password'], login, data)
    end
  end
end
