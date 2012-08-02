========
Installation
========

It's pretty simple.

Requirements:

* rubygems
  * bundler

Then just run `bundle install`

Usage:

* Get `redis-server` up and running
  * If you're not running on the default, adjust `shortener.rb` accordingly
* Configure the URL and port of your server in `shortener.rb`
* To start the server (and create all necessary files and folders), run:
    `shotgun shortener.rb`
