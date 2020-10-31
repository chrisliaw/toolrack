


module Antrapol
  module Utils

    def set_session_exception(exp)
      if not exp.nil?
        @sExp = exp
      end
    end

    def session_exception
      if not @sExp.nil?
        @sExcp
      else
        Antrapol::ToolRack::Error
      end
    end
    alias_method :session_exception, :s_exp

  end
end
