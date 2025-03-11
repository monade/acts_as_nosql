![Tests](https://github.com/monade/acts_as_nosql/actions/workflows/test.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/acts_as_nosql.svg)](https://badge.fury.io/rb/acts_as_nosql)

# acts_as_nosql

This gem allows to handle JSON and JSONB fields as if they are proper database columns, handling default values, type casting and simplifying validation.

## Installation

Add the gem to your Gemfile

```ruby
  gem 'acts_as_nosql'
```

## Example usage

```ruby
class User < ApplicationRecord
  acts_as_nosql field_name: :data

  # You can define multiple attributes at once with the same type
  nosql_attrs :first_name, :last_name, type: :String
  # You can set the default value
  nosql_attr :age, type: :Integer, default: 0
  # You can also pass a :path attribute
  # This is used to decide how to write the attribute as a nested object
  # In this example, `google_oauth_token` will be written in the JSON object as:
  # `"oauth" => { "google_token" => __VALUE__ }`
  nosql_attr :google_oauth_token, type: :String, path: [:oauth, :google_token]

  # You can run standard ActiveRecord validations on these fields
  validates :first_name, :last_name, presence: true
end

user = User.new
# You can use attributes as standard
user.first_name = 'John'
user.last_name 'Doe'
# This picks the default value
user.age # => 0
# This is stored as a nested object
user.google_oauth_token = 'xxxxxxx'
user.save!
# All attributes are stored in the `data` column
user.data # => { "first_name" => "John", "last_name" => "Doe", "age" => 0, "oauth" => { "google_token" => "xxxxxxx" }}

# You can also run basic queries:
User.where(first_name: 'John').to_sql # => SELECT "users".* FROM "users" WHERE "users"."data"->>"first_name" = 'John'
```

## TODO
* Complex querying (`group`, `pluck`, etc...)
* Issue the arrays mutation bug

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

About Monade
----------------

![monade](https://monade.io/wp-content/uploads/2023/02/logo-monade.svg)

active_queryable is maintained by [mònade srl](https://monade.io).

We <3 open source software. [Contact us](https://monade.io) for your next project!
