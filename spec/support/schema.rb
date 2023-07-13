require 'active_record'

if ENV['ACTIVE_RECORD_ADAPTER'] == 'mysql'
  puts 'Running on MySQL...'
  ActiveRecord::Base.establish_connection(
    adapter: 'mysql2',
    host: ENV['DB_HOST'] || '127.0.0.1',
    username: ENV['DB_USERNAME'] || 'root',
    password: ENV['DB_PASSWORD'],
    database: 'acts_as_nosql'
  )
elsif ENV['ACTIVE_RECORD_ADAPTER'] == 'postgresql'
  puts 'Running on PostgreSQL...'
  ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    database: 'acts_as_nosql',
    host: ENV['DB_HOST'] || '127.0.0.1',
    username: ENV['DB_USERNAME'] || ENV['POSTGRES_USER'] || 'postgres',
    password: ENV['DB_PASSWORD'] || ENV['POSTGRES_PASSWORD']
  )
else
  puts 'Running on SQLite...'
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
  )
end

class Article < ActiveRecord::Base
  acts_as_nosql field_name: :data

  def some_column
  end

  nosql_attrs :body, :editor, type: String
  nosql_attr :comments_count, type: :Integer, default: 0
  nosql_attr :published, type: :Boolean, default: false
end

class Setting < ActiveRecord::Base
  acts_as_nosql field_name: :config

  nosql_attrs :user_auth_token, type: String, default: '', path: [:user, :auth, :token]
  nosql_attrs :user_auth_providers, type: Array, default: [], path: [:user, :auth, :providers]
end

class InheritedSetting < Setting
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

      create_table :settings, force: true do |t|
        t.string   :title
        t.json     :config
        t.timestamps null: false
      end

      create_table :inherited_settings, force: true do |t|
        t.string   :title
        t.json     :config
        t.timestamps null: false
      end
    end
  end
end
