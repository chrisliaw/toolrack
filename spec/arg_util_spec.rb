
require_relative '../lib/toolrack'

RSpec.describe TR::ArgUtils do

  it 'parses array for compliance with spec using specified character given by caller' do

    class TClass
      include TR::ArgUtils

      arg_spec do

        set_value_separator("=")

        #opt "ops-jan", "Operation Jan", required: true do 
        #  verify_ops_jan
        #end

        opt "-u", "Unlink the stuff", required: true do 
          unlink
        end
        opt_alias "-u", "--unlink"

        opt "-y", "Yank the given path" do |v|
          yank(v)
        end
        opt_alias "-y", "--yank"

        opt "-l", "Land on the hill"  do |v|
          yank(v)
        end

        opt "-k", "Kill" do |v|
          kill(v)
        end

      end

      def verify_ops_jan
        puts "ops_jan verified"
      end

      def unlink
        puts "unlink called"
      end

      def yank(v)
        puts "Yank #{v}"
      end

      def kill(v)
        puts "Kill #{v}"
      end

    end

    t = TClass.new

    noOpsArgs = ["non-ops"]
    expect {
      t.parse_argv(noOpsArgs)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    args = ["-u", "-y"]
    expect {
      t.parse_argv(args)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    args = ["-u", "-y=/tmp/wahtever", "-l"]
    expect {
      t.parse_argv(args)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    args = ["-u", "-y=/tmp/wahtever", "-l","-k"]
    expect {
      t.parse_argv(args)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)
 
    args = ["-u", "-y=/tmp/wahtever", "-l=tsting","-k=justif"]
    t.parse_argv(args)
  end


  it 'parses array for compliance with spec using space as separator' do

    class TClasse
      include TR::ArgUtils

      arg_spec do

        callback :pre_processing do |a|
          pre_processing(a)
        end

        callback :post_processing do |e|
          post_processing(e)
        end

        opt "-u", "Unlink the stuff", required: true do 
          unlink
        end
        opt_alias "-u", "--unlink"

        opt "-y", "Yank the given path" do |v|
          yank(v)
        end
        opt_alias "-y", "--yank"

        opt "-l", "Land on the hill"  do |v|
          yank(v)
        end

        opt "-k", "Kill" do |v|
          kill(v)
        end

      end

      def verify_ops_jan
        puts "ops_jan verified"
      end

      def unlink
        puts "unlink called"
      end

      def yank(v)
        puts "Yank #{v}"
      end

      def kill(v)
        puts "Kill #{v}"
      end

      def pre_processing(args)
        puts "Pre processing got #{args}"
        #true, args[1..-1]
      end

      def post_processing(args)
        puts "Post processing got #{args}"
      end

    end

    t = TClasse.new

    noOpsArgs = ["non-ops"]
    expect {
      t.parse_argv(noOpsArgs)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    #good = ["-u", "-y=Yes", "-l","Land"]
    args = ["-u", "-y"]
    expect {
      # error because -y requires value
      t.parse_argv(args)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    args = ["-u", "-y","/tmp/wahtever"]
    t.parse_argv(args)

    args = ["-u", "-y","/tmp/wahtever", "-l"]
    expect {
      # error because -l requires value
      t.parse_argv(args)
    }.to raise_exception(TR::ArgUtils::RequiredFieldEmpty)

    args = ["-u", "-y","/tmp/wahtever", "-l","-k"]
    # this should not have error as -k is assumed to be -l
    # parameters therefore system did not see -k as key
    # This scenario shall depending on handler of -l to detect
    # if the given value is valid
    t.parse_argv(args)

    args = ["--unlink"]
    t.parse_argv(args)

    args = ["--unlink","--yank","holy cow"]
    t.parse_argv(args)
 
    args = ["-u","--yank","holy cow"]
    t.parse_argv(args)
 
    args = ["--unlink","-y","holy cow"]
    t.parse_argv(args)
 

  end

  
end
