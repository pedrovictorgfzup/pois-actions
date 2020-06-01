FROM ruby:2.5.8-alpine

RUN apk add --update build-base git

RUN gem install bundler
RUN gem install rubocop
RUN bundle install

COPY lib /action/lib
RUN chmod +x /action/lib/entrypoint.sh

ENTRYPOINT ["/action/lib/entrypoint.sh"]