require_relative 'errors'

module Ordrin
  module Normalize
    class Normalizers
      private
      def regex(regex, error)
        lambda do |value|
          result = value.to_s[regex]
          if result.nil?
            raise error[value]
          else
            result
          end
        end
      end

      public
      def phone(phone_number)
        #strips out everything but digits from the phone number
        phone = phone_number.to_s.gsub(/\D/, '')
        if phone.length == 10
          phone[/^(\d{3})(\d{3})(\d{4})$/]
          "#{$1}-#{$2}-#{$3}"
        else
          raise Errors.phone[phone_number]
        end
      end

      def money(money)
        value = money.to_s.gsub(/,/, '')[/^\$?(\d+(\.\d+)?)$/, 1]
        if value.nil?
          raise Errors.money[money]
        else
          value
        end
      end

      def datetime(date_time)
        if date_time.to_s.upcase == 'ASAP'
          'ASAP'
        else
          begin
            date_time.strftime('%m-%d+%H:%M')
          rescue NoMethodError
            raise Errors.date_time[date_time]
          end
        end
      end

      def date(date)
        if date.to_s.upcase == 'ASAP'
          'ASAP'
        else
          begin
            date.strftime('%m-%d')
          rescue NoMethodError
            raise Errors.date[date_time]
          end
        end
      end

      def time(time)
        if time.to_s.upcase == 'ASAP'
          'ASAP'
        else
          begin
            time.strftime('%m-%d+%H:%M')
          rescue NoMethodError
            raise Errors.time[date_time]
          end
        end
      end

      def url(url)
        url.to_s[/^(https?:\/\/)[-\w.~]+(:\d+)?(\/[-\w.~]+)*/]
      end

      def state(state)
        state = state.to_s[/^[A-Za-z]{2}$/]
        if state.nil?
          raise Errors.state[state]
        else
          state.upcase
        end
      end

      private
      def cc_type(cc_number)
        cc_map = {'American Express' => /^3[47]\d{13}$/,
          'Visa' => /^4\d{12}(?:\d{3})?$/,
          'Mastercard' => /^5[1-5]\d{14}$/,
          'Discover' => /^6(?:011|5\d{2})\d{12}$/}

        type = nil
        cc_map.each {|key, value| type = key unless cc_number[value].nil?}
        type
      end

      def luhn_checksum(card_number)
        digits = card_number.to_s.scan(/./).map(&:to_i)
        checksum = 0
        digits.each_index do |index|
          digit = digits[index]
          if (digits.length-index)%2==1
            checksum += digit
          else
            checksum += 2 * digit
          end
        end
        checksum % 10
      end

      def luhn_valid?(card_number)
        luhn_checksum(card_number) == 0
      end

      public
      def credit_card(values)
        number, cvc = values
        num = number.to_s.gsub(/\D/, '')
        unless luhn_valid?(num)
          raise Errors.credit_card[number]
        end
        card_type = cc_type(num)
        if card_type.nil?
          raise Errors.credit_card[number]
        else
          if card_type=='American Express'
            cvc_length = 4
          else
            cvc_length = 3
          end
          if cvc.length == cvc_length and !cvc.to_s[/^\d+$/].nil?
            [num, cvc, card_type]
          else
            raise Errors.cvc[cvc]
          end
        end
      end

      def unchecked(value)
        value.to_s
      end

      def name(value)
        unchecked(value)
      end

      def zip(zip)
        regex(/^\d{5}$/, Errors.zip)[zip]
      end

      def number(num)
        regex(/^\d+/, Errors.number)[num]
      end

      def year(year)
        regex(/^\d{4}$/, Errors.year)[year]
      end

      def month(mon)
        regex(/^\d{2}$/, Errors.month)[mon]
      end

      def email(email)
        regex(/^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,3}/, Errors.email)[email]
      end

      def nick(nick)
        regex(/^[-\w]+/, Errors.nick)[nick]
      end

      def alphanum(value)
        regex(/^[a-zA-Z\d]+$/, Errors.alphanum)[value]
      end
    end

    @@normalizer = Normalizers.new

    public
    def Normalize.normalize(value, normalizer)
      @@normalizer.send(normalizer, value)
    end
  end
end
