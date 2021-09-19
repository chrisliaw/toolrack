
require 'securerandom'

module Antrapol
  module ToolRack
    module PasswordUtils
      include Antrapol::ToolRack::ConditionUtils
      
      class PasswordUtilsError < StandardError; end

      # complexity
      # 1 : lowercase alphabet
      # 2 : lower + upper alphabet
      # 3 : lower + upper + number
      # 4 : lower + upper + number + symbol
      def generate_random_password(length = 12, opts = { complexity: 4, enforce_quality: true })
       

        length = 12 if is_empty?(length)
        length = length.to_i
        length = 12 if length <= 0

        logger.debug "Length : #{length}"

        if not_empty?(opts)
          complexity = opts[:complexity] || 4
          
          raise PasswordUtilsError, "Password length too short but complexity too high. Not able generate the password with required complexity." if length <= complexity
          
          enforce_quality = opts[:enforce_quality] || true
        end

        complexity = 4 if is_empty?(complexity)
        complexity = 4 if complexity > 4
        complexity = 1 if complexity < 1

        logger.debug "Complexity : #{complexity}"

        enforce_quality = true if is_empty?(enforce_quality) or not is_bool?(enforce_quality)

        res = []
        antropy = [("a".."z"),("A".."Z"),(0..9),("!".."?")]
        selection = antropy[0..complexity-1].map { |s| s.to_a }.flatten

        fres = nil
        loop do

          len = length
          processed = 0
          loop do
            #res += selection.sample(length)
            res += selection.sort_by { SecureRandom.random_number }
            break if res.length >= length
          end

          fres = res[0...length].join

          if enforce_quality
            case complexity
            when 1
              if all_lowercase_alpha?(fres)
                break
              else
                logger.debug "Failed lowercase alpha quality check. #{fres} - Regenerating..."
                res.clear
              end
            when 2
              st, dst = all_alpha?(fres)
              if st
                break
              else
                logger.debug "Failed all alpha quality check. #{dst} - Regenerating..."
                res.clear
              end
            when 3
              st, dst = all_alpha_numeric?(fres)
              if st
                break
              else
                logger.debug "Failed alpha numeric quality check. #{dst} - Regenerating"
                res.clear
              end
            when 4
              st, dst = all_alpha_numeric_and_symbol?(fres)
              if st
                break
              else
                logger.debug "Failed alpha numeric + symbol quality check. #{fres} / #{dst} - Regenerating"
                res.clear
              end
            else
              logger.debug "Unknown complexity?? #{complexity}"
              break
            end
          else
            break
          end

        end

        fres

        #length = 12 if is_empty?(length)
        #length = length.to_i
        #length = 12 if length <= 0

        #antropy = ('!'..'~').to_a
        #antropy.sort_by { SecureRandom.random_number }.join[0...length]
      end
      alias_method :gen_rand_pass, :generate_random_password
      alias_method :gen_pass, :generate_random_password

      def all_lowercase_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        lalpha = ('a'..'z').to_a
      
        (s-lalpha).length == 0
      end

      def has_lowercase_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        lalpha = ('a'..'z').to_a
      
        (s & lalpha).length > 0
      end

      def all_uppercase_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        ualpha = ('A'..'Z').to_a

        (s-ualpha).length == 0
      end

      def has_uppercase_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        ualpha = ('A'..'Z').to_a

        (s & ualpha).length > 0
      end

      def all_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        num = ('0'..'9').to_a
        sym = ('!'..'?').to_a
        
        alpha = [lalpha, ualpha].flatten

        t1 = (alpha-s).length == 0
        t2 = (alpha-s).length == 0

        t3 = (s & num).length > 0
        t4 = (s & sym).length > 0
        
        [!(t1 or t2 or t3 or t4), res = { has_lower_alpha: t1, has_upper_alpha: t2, has_num: t3, has_symbol: t4 }]
      end

      def has_alpha?(str)
        return false if is_empty?(str) or not str.is_a?(String)

        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        alpha = [lalpha, ualpha].flatten

        (alpha & s).length > 0
      end

      def has_number?(str)
        return false if is_empty?(str)

        str = str.to_s if not str.is_a?(String)

        s = str.split("")
        num = ('0'..'9').to_a

        (s & num).length > 0
        
      end

      def all_number?(str)
        return false if is_empty?(str)

        str = str.to_s if not str.is_a?(String)

        s = str.split("")
        num = ('0'..'9').to_a

        !((s-num).length > 0)
        
      end

      def all_symbol?(str)
        return false if is_empty?(str)

        s = str.split("")
        sym = ('!'..'?').to_a
        !((s-sym).length > 0)
        
      end

      def has_symbol?(str)
        return false if is_empty?(str)

        s = str.split("")
        sym = ('!'..'?').to_a
       
        p (s & sym)
        (s & sym).length > 0
      end


      def all_alpha_numeric?(str)
        return false if is_empty?(str)

        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        num = ('0'..'9').to_a
        sym = ('!'..'?').to_a
        sym = sym-num

        t1 = ((s & lalpha).length > 0)
        t2 = ((s & ualpha).length > 0)
        t3 = ((s & num).length > 0)

        t4 = ((s & sym).length > 0)

        [(t1 and t2 and t3 and !t4), res = { has_lower_alpha: t1, has_upper_alpha: t2, has_num: t3, has_symbol: t4 }]
      end

      def has_alpha_numeric?(str)
        return false if is_empty?(str)
        
        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        num = ('0'..'9').to_a
        alphanum = [lalpha, ualpha, num].flatten

        (s & alphanum).length > 0
        
      end

      def all_alpha_numeric_and_symbol?(str)
        return false if is_empty?(str)

        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        num = ('0'..'9').to_a
        sym = ('!'..'?').to_a
        sym = sym-num

        t1 = ((s & lalpha).length > 0)
        t2 = ((s & ualpha).length > 0)
        t3 = ((s & num).length > 0)
        t4 = ((s & sym).length > 0)

        [(t1 and t2 and t3 and t4), res = { has_lower_alpha: t1, has_upper_alpha: t2, has_num: t3, has_symbol: t4 }]
      end

      def has_alpha_numeric_or_symbol?(str)
        return false if is_empty?(str)
        
        s = str.split("")
        lalpha = ('a'..'z').to_a
        ualpha = ('A'..'Z').to_a
        num = ('0'..'9').to_a
        sym = ('!'..'?').to_a
        sym = sym-num

        t1 = ((s & lalpha).length > 0)
        t2 = ((s & ualpha).length > 0)
        t3 = ((s & num).length > 0)
        t4 = ((s & sym).length > 0)
        
        [(t1 or t2 or t3 or t4), res = { has_lower_alpha: t1, has_upper_alpha: t2, has_num: t3, has_symbol: t4 }]
      end

      private
      def logger
        logger = Antrapol::ToolRack::Logger.instance.glogger
        logger.tag = :pass_utils
        logger
      end

    end
  end
end
