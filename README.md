tangent
=======

Tangent is an online newspaper that hopes to enable people to write about what they care about.

## Setup
1. Install Ruby (tangent currently uses Ruby 2.0.x)
2. Install Ruby gems ):

    gem install bundler
    bundle

3. Initialize and create the database:

    bundle exec rake db:migrate

4. Set up the following environment variable:

    RACK_ENV=development
    PORT=3000

5. Run the tests:

    bundle exec rake

6. Run the app:

    bundle exec foreman start

7. Open the app [here](http://localhost:3000) :tada:.
