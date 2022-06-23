![Tests](https://github.com/monade/acts_as_nosql/actions/workflows/test.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/acts_as_nosql.svg)](https://badge.fury.io/rb/acts_as_nosql)

# acts_as_nosql
This gem allows to handle JSON and JSONB fields as if they are proper database columns, handling default values, type casting and easier validation.

** THIS GEM IS UNDER ACTIVE DEVELOPMENT. DON'T USE IT IN PRODUCTION **

## Installation

Add the gem to your Gemfile

```ruby
  gem 'acts_as_nosql', github: 'monade/acts_as_nosql'
```

## Example usage

```ruby
class User < ApplicationRecord
	acts_as_nosql field_name: :data

	nosql_attrs :first_name, :last_name, type: :String
	nosql_attr :age, type: :Integer, default: 0
end
```

## TODO
* Release the Gem
* Handle array types
* Handle nested values
* Querying
