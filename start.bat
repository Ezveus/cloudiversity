@ECHO off

SET CLOUDIVERSITY=%CD%
SET RUBY_BIN=%CLOUDIVERSITY%\..\..\bin

SET PATH=%RUBY_BIN%;%PATH%

IF EXIST cloudiversity.configured GOTO launch_server

bundle exec rails g cloudi:secret && bundle exec rake db:migrate && bundle exec rake db:seed && ECHO configured > cloudiversity.configured && bundle exec rails server

:launch_server
bundle exec rails server && PAUSE
