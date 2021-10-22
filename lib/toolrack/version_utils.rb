
require_relative 'condition_utils'

module Antrapol
  module ToolRack
    module VersionUtils
      include Antrapol::ToolRack::ConditionUtils

      class VersionUtilsError < StandardError; end

      def is_version_equal?(*args)
        res = true
        target = Gem::Version.new(args.first)
        args.each do |a|
          subj = Gem::Version.new(a)
          res = (subj == target)
          break if not res
          target = subj
        end

        res
      end

      def possible_versions(ver)
        raise VersionUtilsError, "Given version to extrapolate is empty" if is_empty?(ver)
        vv = ver.to_s.split('.')
        tv = vv.clone
        res = []
        cnt = 0
        (0...vv.length).each do |i|
          tv = vv.clone
          tv[i] = tv[i].to_i+1

          j = i
          loop do
            break if j >= (vv.length-1)
            j += 1
            tv[j] = 0
          end
          res << tv.join(".")
        end
        res
      end

    end
  end
end
