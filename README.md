trade.gov Industry Mapper
==============

### Ruby

You'll need [Ruby 2.0](http://www.ruby-lang.org/en/downloads/) and Rails 4.

### Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install

### MySQL

Copy and modify the database.yml file as needed. The provided database.yml.example file assumes you have
a local [MySQL](http://www.mysql.com/) instance up and running, accessible from user 'root' with no password.

Create and setup your development and test databases and populate them with the seed data:

    rake db:create
    rake db:migrate
    rake db:seed
    rake db:setup RAILS_ENV=test

### Running it

Fire up a server and try it all out.

    bundle exec rails s

Visit `http://localhost:3000/admin` and log in as the default user:

* __User__: admin@example.com
* __Password__: password

From there, you can see the industries and the sectors each one contains, and for each sector you can see the eMenu industry sectors it encapsulates.

Now try a lookup:

<http://localhost:3000/industry_sector.json?emenu=Construction+Eq.>

### Tests

    bundle exec rake

### Code Coverage

We track test coverage of the codebase over time, to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have < 100% coverage to see what lines weren't exercised.
