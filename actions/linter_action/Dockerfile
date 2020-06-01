FROM ruby:2.5.8-alpine

RUN apk add --update build-base git

RUN gem install bundler
RUN gem install rubocop

COPY lib /action/lib
ENTRYPOINT ["/action/lib/entrypoint.sh"]