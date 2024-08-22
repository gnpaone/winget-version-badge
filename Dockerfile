FROM ruby:3.3

COPY . /app
WORKDIR /app

ENTRYPOINT ["ruby", "/app/winget.rb"]
