
require 'securerandom'

module Antrapol
  module ToolRack
    module PasswordUtils
      include Antrapol::ToolRack::ConditionUtils

      def generate_random_password(length = 12)
        length = 12 if is_empty?(length)
        length = length.to_i
        length = 12 if length <= 0

        antropy = ('!'..'~').to_a
        antropy.sort_by { SecureRandom.random_number }.join[0...length]
      end
      alias_method :gen_rand_pass, :generate_random_password
      alias_method :gen_pass, :generate_random_password

    end
  end
end
