FROM ruby:2.7

RUN apt-get update && apt-get install -y build-essential

WORKDIR '/app'

COPY Gemfile .

COPY Gemfile.lock .

RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "127.0.0.1"]