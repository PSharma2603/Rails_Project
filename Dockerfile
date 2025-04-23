# Use an official Ruby base image
FROM ruby:3.2

# Set environment variables
ENV RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

# Set the working directory
WORKDIR /app

# Copy Gemfiles first (for caching)
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy all project files
COPY . .

# Precompile assets (optional if you're using Webpacker/Sprockets in production)
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
