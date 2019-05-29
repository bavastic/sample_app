# HasUniqueIdentifier

Create a character token value for an ActiveRecord object that is unique within the scope of the object's class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_unique_identifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_unique_identifier

## Usage

Call has_unique_identifier in an ActiveRecord class and pass the name of the attribute you wish to be a unique identifier as well as the number of character segments, their size and the delimiter you want to use.

```ruby
class MyThing < ApplicationRecord
  has_unique_identifier :my_identifier, segment_count: 3, segment_size: 2, delimiter: '-'
end
```

This will automatically set the my_identifier attribute of a MyThing record to a string of format AB-CD-EF and make sure that the value is unique within the MyThing class.

Note that it's still possible to generate a race condition in the database.  To deal with this scenario, you could add a unique index in the database.
