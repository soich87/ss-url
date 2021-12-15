# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 2.6.5 on Rails 6.1.4.1

* System dependencies

* Configuration

* Database Postgresql
	rails db:create

* Database initialization
	rails db:migrate

* How to run the test suite
	I am using Rspec for unit test
	rspec spec

* Services (job queues, cache servers, search engines, etc.)
	need define a cron job to increase remaining requests of api setting per day

* Algorithm used for generating the URL shortcode
  look like base64 encode 
  [*'0'..'9', *'a'..'z', *'A'..'Z', ['=','+']]
  select ramdon 6 elements of array 64 length
* ...
