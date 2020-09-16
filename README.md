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
- Execute `docker-compose up --build` to start api server and db server. Now you can send requests to http://localhost:3000

## Without Docker:
- Start your local postgres server using: https://www.postgresql.org/docs/9.1/server-start.html
	- If you installed using homebrew use: https://wiki.postgresql.org/wiki/Homebrew
- Execute `createuser -s postgres` to create default postgres user
- Execute `bin/setup`
- Execute `rails s` to start server and send requests to http://localhost:3000

# Testing Instructions

- Execute `cd /path/to/url-shortener-api`

## Docker:
- Execute `docker-compose run url-shortener-api rspec`

## Without Docker:
- Start your local postgres server using: https://www.postgresql.org/docs/9.1/server-start.html if it is not running
	- If you installed using homebrew use: https://wiki.postgresql.org/wiki/Homebrew
- Execute `rspec`

# API Docs
- Navigate to `/docs`

# Thought process

For the most part, this is a straightforward, rails api using token authentication. However, there are a few decisions that I'd like to explain a bit more in-depth:
- **Docker:** I believe using docker in development is a great way to get engineers up and running on projects without them needing to worry about downloading dependencies to their local environment that could potentially break something, which only slows down the onboarding time for an engineer.
- **Knock/JWT:** I decided to use Knock since it is a lightweight, auth solution using JWTs. Although it isn't difficult to implment your own JWT-based auth, I'd rather not reinvent the wheel!
- **Shortend Url Algorithm:** I wanted to avoid any collision-related issues with generating random, alphanumeric sequences, so I implemented an algorithm that starts with, a. Everytime this service creates an Url record, we increment the sequence, ie, a increments to b, A increments to B, and 0 increments to 1. Once we exhaust all combinations for the current sequence, we append a char to our sequence and reset it. This ensures a worst-case runtime of O(n) when generating a shortened url.
- **Interactors:** I prefer to store all business logic in service objects since doing so decouples your business logic, models, and controllers from each other.
- **Dotenv:** In adherence to security best practices, I typically wouldn't commit an env file with sensitive data, but since this env file doesn't contain any sensitive data and commiting it removes a step to setting up your local environment, I included it. Typically, I would use a service, such as S3, to store it and encrypt it at rest. This way, developers can pull down a development env file when setting up their local environment, and we could include downloading environment-specific env files as a part of our deployment strategy.
- **Postgres/SQL:** I usually reach for postgres when selecting a RDMS. Postgres allows you to use uuids for primary keys, which is perfect for this service since I use them as client ids. Also, in order to ensure unique shortened urls and mitigate race conditions, I needed to pessimistically lock our single, ShortenedUrl record everytime a client creates an Url record. This might create a bottleneck when creating Urls, since we lock this single ShortenedUrl record whenever a client creates an Url, but I don't anticipate that being an issue since I believe this is more of a read-heavy service, as opposed to a write-heavy one. If this ended up becoming a bottleneck, I could rewrite this logic for generating a shortened url, but would need to implement retry logic for when there is a collision and handle scenarios when clients exhausted all combinations of chars for a given sequence length or even when there is a good chance that there could be a collision based on the length of the generated, alphanumeric sequence. Right now, each element in a sequence can be 1 of 64 chars (0-9, a-z, and A-Z), so the total number of combinations would be 64^n where n is the length of a sequence. If we set the shortened url length to 3, then we only have a total of 262,144 available combinations. Once we exhaust half of those, there would be a 50% chance that we have a collision. I believe going down this route makes generating a shortened url more complex, but if we ended up running into a write bottleneck with Urls, then this could be a reason to introduce the above complexity to the service.
