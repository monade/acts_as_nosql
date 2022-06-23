require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

class Article < ActiveRecord::Base
  acts_as_nosql field_name: :data

  def some_column
  end

  nosql_attrs :body, type: String
  nosql_attr :comments_count, type: :Integer, default: 0
  nosql_attr :published, type: :Boolean, default: false
end

module Schema
  def self.create
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :articles, force: true do |t|
        t.string   :title
        t.json     :data
        t.timestamps null: false
      end
    end
  end
end
