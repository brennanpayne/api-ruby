require 'digest'

module Ordrin
  module Mutate
    module_function
    
    def sha256(value)
      Digest::SHA256.new.hexdigest(value)
    end
    
    def state(value)
      value.upcase
    end
    
    def phone(value)
      value.gsub(/\D/, '').gsub(/^(\d{3})(\d{3})(\d{4})$/, '\1-\2-\3');
    end
    
    def identity(value)
      value
    end
  end
end
      
