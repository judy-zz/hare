Hare
====

A Rails plugin that makes it easier for your models to communicate with RabbitMQ.

[![Build Status](https://travis-ci.org/judy/hare.svg?branch=master)](https://travis-ci.org/judy/hare)
[![Code Climate](https://codeclimate.com/github/judy/hare.png)](https://codeclimate.com/github/judy/hare)
[![Coverage Status](https://coveralls.io/repos/judy/hare/badge.png)](https://coveralls.io/r/judy/hare)

Hare abstracts away queue and exchange creation, so you can focus on the message and subscription side of things in Rails.

Installation
------------

Put this in your `Gemfile`:

    gem 'hare'

Then run `bundle install` to install the gem and its dependencies. Finally, run `rails generate hare:install` to create bin/hare and an amqp.yml.sample file in your config folder.

Copy amqp.yml.sample to amqp.yml, and change it to connect to your local RabbitMQ server. By default, it will connect to the one on your development machine, as long as you haven't changed the settings on it.

Sending Messages
----------------

Run the generator:

    rails generate hare:message MessageName

Then specify the name of the exchange, OR the routing key for the intended queue. To send a message, generate an instance of your new class, add data, and hit send:

    msg = MessageName.new
    msg.data = {key: "value"}
    msg.send

Receiving messages
------------------

Generate a subscription with this command:

    rails generate hare:subscription SubscriptionName

Then tweak the resulting file to attach to the right queue, or use bindings to watch a named exchange. Use a subscribe block to define code that you want run when a message is received:

    class NotifyUserSubscription < Hare::Subscription
      subscribe queue: "notify_user" do |data|
        User.where(id: data[:id]).first.notify
      end
    end

**FYI, this gem does not yet officially support fanout or topic exchanges.** They shouldn't be hard to add to the gem, but there aren't any tests yet.

---

This project uses the ISC license.
