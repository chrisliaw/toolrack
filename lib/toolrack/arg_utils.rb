

module Antrapol
  module ToolRack
    
    module ArgUtils
      include Antrapol::ToolRack::ConditionUtils

      class ArgParsingException < StandardError; end
      class RequiredFieldEmpty < ArgParsingException; end
      class DuplicatedField < ArgParsingException; end
      class InvalidKey < ArgParsingException; end
     
      module ClassMethods
        include Antrapol::ToolRack::ConditionUtils
       
        def arg_spec(&block)
          class_eval(&block) 
        end

        def opt(key, desc, opts = {}, &block)
          raise RequiredFieldEmpty, "Key field cannot be empty" if is_empty?(key)
          raise DuplicatedField, "Given key '#{key}' already exist" if options.keys.include?(key)
          raise RequiredFieldEmpty, "Block is require" if not block

          options[key] = { key: key, desc: desc, options: opts, callback: block }
          required << key if opts[:required] == true
        end

        def opt_alias(existing, new)
          raise InvalidKey, "Existing key '#{existing}'to map to new key '#{new}' not found" if not options.keys.include?(existing)
          aliases[new] = existing 
        end

        def is_all_required_satisfy?(arr)
          if arr.is_a?(Array)
            res = true
            required.each do |f|
              res = arr.include?(f) 
              if not res
                al = aliases.invert[f]
                res = arr.include?(al)
                raise RequiredFieldEmpty, "Required parameter '#{f}' is not given" if not res
              end
            end
            res

          else
            raise ArgParsingException, "Given array to check for required fields is not an array. Got #{arr}"
            if arr.is_a?(ArgParsingException)
              STDERR.puts "Error throwing into the method was : #{arr.message}"
            end

          end
        end

        def callback(evt, opts = {}, &block)
          raise ArgParsingException, "Event should not be nil" if evt.nil? 
          callbacks[evt] = { opts: opts, cb: block }
        end

        def required
          if @_req.nil?
            @_req = []
          end
          @_req
        end

        def options
          if @_options.nil?
            @_options = {}
          end
          @_options
        end

        def aliases
          if @_aliases.nil?
            @_aliases = {}
          end
          @_aliases
        end

        def callbacks
          if @_cb.nil?
            @_cb = {}
          end
          @_cb
        end

        #def value_separator=(val)
        #  logger.debug "Setting value separator #{val}"
        #  @_valSep = val
        #end
        def set_value_separator(val)
          @_valSep = val
        end

        def value_separator
          if @_valSep.nil?
            @_valSep = " "
          end
          @_valSep
        end

        def logger
          Antrapol::ToolRack.logger(:c_arg_utils)
        end

      end # module ClassMethods
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      def parse_argv(argv)
        cb = self.class.callbacks[:pre_processing]
        if not_empty?(cb) and cb[:cb]
          #logger.debug "Calling pre-processing for class #{self}"
          update_argv, val = instance_exec(argv, &cb[:cb])
          #logger.debug "Preprocessing return update flag : #{update_argv} and list #{val} for class #{self}"
          argv = val if update_argv
        end

        if self.class.value_separator == " " and argv.length > 0
          parse_argv_space(argv)
        else
          parse_argv_key_value_mixed(argv)
        end

        cbp = self.class.callbacks[:post_processing]
        if not_empty?(cbp) and cbp[:cb]
          logger.debug "Post processing got #{argv}"
          instance_exec(argv, &cbp[:cb]) 
        end
      end 

      private
      def parse_argv_space(argv)
        logger.debug "got argv (space) : #{argv}"
        cls = self.class
        clear = cls.is_all_required_satisfy?(argv)
        logger.debug "All required fields are there? : #{clear}"
        if clear

          go = true
          i = 0
          while i < argv.length
            a = argv[i]
            logger.debug "Processing : #{a}"

            key = a
            conf = cls.options[key]
            if is_empty?(conf)
              al = cls.aliases[key]
              conf = cls.options[al] if not_empty?(al)
            end

            if is_empty?(conf)
              logger.warn "Given key to select ('#{key}') has not defined before"
              # ignore if the given parameter not recognized
              i += 1
              next
            end

            if not conf[:callback].nil? 
              # expecting parameter
              paramsCount = conf[:callback].arity
              if paramsCount > 0
                # look ahead token to load the parameters
                val = []
                (0...paramsCount).each do |ii|
                  val << argv[i+1+ii]
                end
                val.delete_if { |e| e.nil? }
                logger.debug "Parameter for callback : #{val}"
                raise RequiredFieldEmpty, "Key '#{a}' requires #{paramsCount} parameter(s) but got #{val.length}" if paramsCount != val.length 
                instance_exec(*val, &conf[:callback])
                i += paramsCount+1
              else
                instance_eval(&conf[:callback])
                i += 1
              end

            else
              i += 1

            end

          end # argv.each

        end # if all required satisfy
        
      end

      def parse_argv_key_value_mixed(argv)
        logger.debug "got argv : #{argv}"
        cls = self.class
        if cls.is_all_required_satisfy?(argv)

          argv.each do |a|
            logger.debug "Processing : #{a}"

            key = a
            val = []
            #p a 
            #p cls.value_separator
            #p a =~ /#{cls.value_separator}/
            if (a =~ /#{cls.value_separator}/) != nil
              keys = a.split(cls.value_separator)
              key = keys.first
              val = keys[1..-1]
            end

            logger.debug "After separation : #{key}"

            conf = cls.options[key]
            if is_empty?(conf)
              al = cls.aliases[key]
              conf = cls.options[al] if not_empty?(al)
            end

            if is_empty?(conf)
              logger.warn "Given key to select ('#{key}') has not defined before"
              # ignore if the given parameter not recognized
              next
            end

            if not conf[:callback].nil? 
              # expecting parameter
              paramsCount = conf[:callback].arity
              if paramsCount > 0
                raise RequiredFieldEmpty, "Key '#{conf[:key]}' requires #{paramsCount} value(s) to be given but got #{val.length}." if val.length != paramsCount
                instance_exec(*val, &conf[:callback])
              else
                instance_eval(&conf[:callback])
              end
            end

          end # argv.each

        end # if all required satisfy
      end

      def logger
        Antrapol::ToolRack.logger(:arg_utils) 
      end

    end

  end
end
