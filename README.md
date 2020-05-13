# Toolrack

Toolrack just the collection of utilities that helps in my code clarity

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

Toolrack is meant to be utilities hence it is prefixed with an entity.
Therefore the two utilities are both packaged in namespace:

```ruby
module Antrapol::MyToolRack::ConditionUtils
end
```

```ruby
module Antrapol::MyToolRack::ExceptionUtils
end
```
 
Besides, all the utilities so far is a module by itself, which means it is meant to be included/extended into application classes.

For example:
```ruby
class EditController
  include Antrapol::MyToolRack::ConditionUtils
  include Antrapol::MyToolRack::ExceptionUtils
end
```

Currently it has only 2 modules:
* Condition Utilities
  * is_empty?(obj) - I find rather effort intensive to call if not (obj.nil? or obj.empty?) for items that I want to check for validity before process. Hence this method shall test for .nil?. If the object also respond to :empty? it shall be called again. For example integer type does not support .empty?

* Exception Utilities
  * raise_if_empty(obj, message, error) - Extension from the is_empty?() above, usually if it is empty, an exception shall be raised. It is just combined the conditions with raise of exception. 
    * obj is the object to test for is_empty
    * message is the one that shall be thrown with the exception. 
    * error is the exception type 
  * raise_if_false(obj, message, error) - As the name implied
  * raise_if_true(obj, message, error) -  As the name implied


 

