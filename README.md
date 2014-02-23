tangent
=======

We’re going to start a newspaper. Online. Why? Because we’re bored of newspapers but we’re not bored of news.

## Setup
1. Install [Ruby](https://www.ruby-lang.org/en/) (tangent currently uses Ruby 2.0.x).
2. Install [SQLite](http://www.sqlite.org/).
3. Install Ruby gems:

  ```bash
  gem install bundler
  bundle
  ```
  
4. Initialize and create the database:

  ```bash
  bundle exec rake db:migrate
  ```

5. Set up the following environment variable:

  ```bash
  RACK_ENV=development
  PORT=3000
  ```

6. Run the tests:

  ```bash
  bundle exec rake
  ```

7. Run the app:

  ```bash
  bundle exec foreman start
  ```

8. Open the app [here](http://localhost:3000) :tada:.
