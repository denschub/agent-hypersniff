FROM ruby:latest
COPY . /app
WORKDIR /app
EXPOSE 8000
RUN bundle install
CMD ["ruby", "server.rb"]

