README
======

# Costume Closet

A web application designed for 2 types of users, Dance Studios and their Dancers, to...
* Dance Studios
    * Create an account to manage and track their dance studio's costumes and costume assignments
        * Dance Studios can:
            * Create, view, edit, and delete costumes
            * View their dancers (all and current) and add/deactivate dancers
            * Assign costumes to dancers
            * View, edit, and delete dancer costume assignments, including: 
                * dance season
                * song name
                * dance genre
                * hair accessory
                * shoes
                * tights
                * costume size
                * costume condition (new/used)
            * Edit and delete their account
* Dancers
    * Create an account to view their assigned costumes
        * Dancers can:
            * View their assigned costumes for the current season
            * View their costume assignment history
            * Edit and deactivate their account

*Login and signup include Omniauth through Google*

> A Flatiron School Rails Portfolio Project: created with Ruby 2.6.1, Rails 6.0.2.1, and sqlite3 1.4.

## Installation & Set Up

* First `git clone` the repo to your machine

    ```
    $ git clone git@github.com:jamieberrier/costume-closet.git
    ```
* Then, cd into the file

    ```
    $ cd costume-closet
    ```
* Run `bundle install`

    ```
    $ bundle install
    ```
* Run the migrations

    ```
    $ rake db:migrate
    ```
* (Optional) Load seed data

    ```
    $ rake db:seed
    ```

## Usage

* In your terminal, run the server

    ```
    $ rails s
    ```
* In your web browser, go to localhost

    ```
    $ http://localhost:3000/
    ```
* Once the welcome page loads, either:
    * click **Register with email** or **Register via Google** under dance studio or dancer to create a new account and login
    * click **Sign In As A Dance Studio** or **Sign In As A Dancer** to log in as an existing dance studio/dancer from the dance studios and dancers in 'db/seeds.rb'

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jamieberrier/costume-closet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The app is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
