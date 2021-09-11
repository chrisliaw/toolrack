# Toolrack

Toolrack just the collection of utilities that helps in my code clarity and assistance since those utils too small to be a gem on its own.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toolrack'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install toolrack

## Usage

The utilities are those commonly being used that I think should be group together to save some effort in my other projects.

```ruby
module ToolRack::ConditionUtils
end
```

```ruby
module ToolRack::ExceptionUtils
end
```
 
All the utilities so far is a module by itself, which means it is meant to be included/extended into application classes.

For example:
```ruby
class EditController
  # enable instance method to access those uitilities
  include ToolRack::ConditionUtils
  include ToolRack::ExceptionUtils
  include ToolRack::PasswordUtils
  include ToolRack::RuntimeUtils
  include ToolRack::DataConversionUtils

  # there is also shortcut since I write it so often
  include TR::CondUtils
  include TR::ExpUtils
  include TR::PassUtils
  include TR::RTUtils
  include TR::DataConvUtils
end
```

Currently it has 5 modules:

* Condition Utilities
  * is\_empty?(obj) - I found that I've type the condition if not (x.nil? and x.empty?) too frequent that I think this is very best to turn this into a function. The empty test shall take the following test in sequence:
    * First test is x.nil?. If it is return true
    * Then test if x respond\_to? :empty?. If it is call it.
    * Then test if x respond\_to? :length. If it is call it to see if the value is it 0 and return its comparison result
    * Then test if x respond\_to? :size. If it is call it to see if the value is it 0 and return its comparison result
    Once any of the test is successful, it will not proceed to test the subseqent tests and return its' result.
  * not\_empty?(obj) - Reverse of the is\_empty?(obj) above
  * is\_boolean?(obj) - Test given value is it a boolean value. Note this does not test if the obj is a string of 'true' or 'false'. Those shall return false by this API. If you want to test for string, use is\_string\_boolean?(str) or is\_str\_bool?(str) 
  * is\_bool?(obj) - Shorcut to is\_boolean?()
  * is\_string\_boolean?(str) - Test given string is it "true" or "false". Note the comparison is case insensitive. Note that both "true" and "false" shall return with value true from this API. This API does not convert the string value it to boolean. Just a test if the string carry the boolean value. Refers data conversion section if you want to convert string to boolean


* Data Conversion Utilities
  This is meant to convert data from a format to another format
  * to\_b64(bin) - convert given binary to typical RFC 2045 Base64 output which includes line break in specific position
  * to\_b64\_strict(bin) - Convert binary to RFC 4648 Base64 format, means there is no line break in between.
  * from\_b64(str) - Convert given Base64 input into binary back. Tested this with both RFC2045 and RFC4648 Base64 output seems no issue.
  * from\_b64\_strict(str) - Although seems the from\_b64 able to cater the RFC4648 output, prepare this in case...
  * to\_hex(bin) - Convert binary into hex output. Note this function also convert integer into hex.
  * from\_hex(str) - Convert hex string into binary
  * hex\_to\_int(str) - Convert given hex string into integer. Alias method: hex\_to\_num, hex\_to\_integer, hex\_to\_number 
  * string\_to\_boolean(str) - Convert the string into appropriate boolean true/false. Note if the given string is not "true" or "false", nil shall be returned and can test it with is\_empty? 


* Exception Utilities
  * raise\_if\_empty(obj, message, error) - Extension from the is\_empty?() above, usually if it is empty, an exception shall be raised. It is just combined the conditions with raise of exception. 
    * obj is the object to test for is\_empty?()
    * message is the one that shall be thrown with the exception. 
    * error is the exception type 
  * raise\_if\_false(obj, message, error) - As the name implied
  * raise\_if\_true(obj, message, error) -  As the name implied

* Runtime utils - Tired rewriting this in other project. Detect if the running system is on which operating system / runtime. The function is pretty self descriptive
  * RuntimeUtils.on\_windows?
  * RuntimeUtils.on\_mac?
  * RuntimeUtils.on\_linux?
  * RuntimeUtils.on\_ruby?
  * RuntimeUtils.on\_jruby?

* Password utils - Generate random password with designated complexity
  * generate\_random\_password(length, options = { complexity: \<value\>, enforce\_quality: \<true/false\> })
    * length - length of the required generated password
    * options[:complexity]:
      * 1 - lowercase alphabet
      * 2 - lower + upper case alphabet [alpha]
      * 3 - lower + upper + number [alpha numeric]
      * 4 - lower + upper + number + symbol
    * options[:enforce\_quality]
      * true - generated password is guaranteed to contain the required complexity. E.g. if complexity 4 is required, the password MUST contain lower, upper, number and symbol as its output or a new password that comply to the complexity shall be regenerated. This process is repeated until the required complexity is achieved
      * false - The rules of the complexity is relexed. E.g. if complexity 4 is requested, the output might not have symbol in it.
  * gen\_rand\_pass
  * gen\_pass
    * Alias for method generate\_random\_password

  * all\_lowercase\_alpha?(str)
  * all\_uppercase\_alpha?(str)
  * all\_alpha?(str)
  * all\_number?(str)
  * all\_symbol?(str)
  * all\_alpha\_numeric?(str)
  * all\_alpha\_numeric\_and\_symbol?(str)
    * All methods above starts with all_\* is to check for strict compliance to the required output. E.g. if all\_alpha?(str) is used, the input str MUST be all alpha to get a true status

  * has\_lowercase\_alpha?(str)
  * has\_uppercase\_alpha?(str)
  * has\_alpha?(str)
  * has\_number?(str)
  * has\_symbol?(str)
  * has\_alpha\_numeric?(str)
  * has\_alpha\_numeric\_or\_symbol?(str)
    * All methods above start with has_\* is just to check if the given str contains the required specification. E.g string 'abcdE' will still get true status if pass to has\_lowercase\_alpha?(str). But value 1234 or '1234' or '$%^&' pass to has\_lowercase\_alpha?(str) shall return false.


Check out the rspec folder for usage

