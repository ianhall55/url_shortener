# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email:'abc@abc.com')
User.create(email:'b@b.com')
User.create(email:'c@c.com')


ShortenedURL.create(user_id: 1, long_url: 'http://stackoverflow.com/questions/16945795/is-it-possible-to-change-column-index-in-rails-3-migration',
  short_url: 'www.so.com/index')

ShortenedURL.create(user_id: 2, long_url: 'http://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_index',
  short_url: 'www.api.com/idx')

ShortenedURL.create(user_id: 1, long_url: 'http://drwrchrds.github.io/pairing_timer/',
  short_url: 'www.git.com/timer')
