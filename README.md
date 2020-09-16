# Installation Instructions

## Docker:
- Install docker engine for your platform: https://docs.docker.com/get-docker/
- Install docker-compose for your platform: https://docs.docker.com/compose/install/

## Without Docker:
- Install postgres: https://www.postgresql.org/download/
	- You can also install using homebrew if you are using linux or macOS: https://wiki.postgresql.org/wiki/Homebrew
- Install ruby v 2.7.1
	- You can install and use rvm to easily install and manage ruby versions: https://rvm.io/rvm/install

# Run Instructions

- Execute `cd /path/to/url-shortener-api`

## Docker:
- Execute `docker-compose up --build`

## Without Docker:
- Start your local postgres server using: https://www.postgresql.org/docs/9.1/server-start.html
	- If you installed using homebrew use: https://wiki.postgresql.org/wiki/Homebrew
- Execute `createuser -s postgres to create default postgres user`
- Execute `bin/setup`
- Execute `rails s` to start server

# Testing Instructions

- Execute `cd /path/to/url-shortener-api`

## Docker:
- Execute `docker-compose run url-shortener-api rspec`

## Without Docker:
- Start your local postgres server using: https://www.postgresql.org/docs/9.1/server-start.html if it is not running
	- If you installed using homebrew use: https://wiki.postgresql.org/wiki/Homebrew
- Execute `rspec`

# Thought process

For the most part, this is a straightforward, rails api using token authentication. However, there are a few decisions that I'd like to explain a bit more in-depth:
- **Docker:** I believe using docker in development is a great way to get engineers up and running on projects without needing to worry about downloading dependencies to their local environment that could potentially break something, which only slows down the onboarding time for an engineer.
- **Knock/JWT:** I decided to use Knock since it is a lightweight, auth solution using JWTs. Although it isn't difficult to implment your own JWT-based auth, I'd rather not reinvent the wheel!
- **Shortend Url Algorithm:** I wanted to avoid any collision-related issues with generating random, alphanumeric sequences, so I implemented an algorithm that starts with, a. Everytime this service creates an Url record, we increment the sequence, ie, a increments to b, A increments to B, and 0 increments to 1. Once we exhaust all combinations for the current sequence, we append a char to our sequence and reset it. This ensures a worst-case runtime of O(n) when generating a shortened url.
- **Interactors:** I prefer to store all business logic in service objects since doing so decouples your business logic, models, and controllers from each other.
- **Dotenv:** In adherence to security best practices, I typically wouldn't commit an env file with sensitive data, but since this env file doesn't contain any sensitive data and commiting it removes a step to setting up your local environment, I included it. Typically, I would use a service, such as S3, to store it and encrypt it at rest. This way, developers can pull down a development env file when setting up their local environment, and we could include downloading environment-specific env files as a part of our deployment strategy.
