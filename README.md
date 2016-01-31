GHStreaks Bot
============================

Command line tool that push notifications [GHStreaks](https://github.com/suer/ghstreaks/)
with [GHStreaks Service](https://github.com/suer/ghstreaks-service/).

Setup
----------------------

  $ bundle install --path .bundle

Preference
----------------------

* environment variables
  - APNS\_PEM

in heroku,

    heroku config:add APNS_PEM="$(cat /path/to/production.pem)"

How to run
----------------------

  % bundle exec foreman start
