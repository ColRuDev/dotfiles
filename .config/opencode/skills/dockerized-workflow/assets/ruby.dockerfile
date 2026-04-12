FROM ruby:3.3-alpine

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .