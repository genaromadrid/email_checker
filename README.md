# Email Checker

Check if an email address is can receive E-mails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'email_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_checker

## How do this gem works

For an email address to receive e-mails, it has to meet the following:

1. The domain must have MX records.
2. The MX records must point to a valid server and
3. That server must have the corresponding A records.

Now, that does not ensure that the email actually exists in the server, for that, we have to *pretend* to send an e-mail and check if the seerver is OK with it (respond with status 250). 
If you want to read more about it you can read the [RFC 821](https://tools.ietf.org/html/rfc821).

For this gem to *pretend* to send an email you have to provide a valid email address from whitch the email "will be sent". If you don't, the server might reject the message without checking if the email exists. In this gem that is the `verifier_email`.

It is noteworthy that this method can result in your server being blacklisted since its known as a spamming technique.

## Usage

You can provide the `verifier_email` by passign it to the `check` method in the second parameter:

```ruby
  EmailChecker.check(email, verifier_email=nil)
```

Or in an initializer:

```ruby
  EmailChecker.config do |config|
    config.verifier_email = 'realname@realdomain.com'
  end

  EmailChecker.check(email)
```

## Contributors

`email_checker` it's inspired on [Kamilc](https://github.com/kamilc) [email_verifier](https://github.com/kamilc/email_verifier) gem. The diference is that `email_checker` validates the domain MX records and its server before it pretends to send an email, this way it is less posible that your server get blacklisted.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/email_checker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
