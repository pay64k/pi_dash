# https://kaiwern.com/posts/2020/06/20/building-elixir/phoenix-release-with-docker/
ARG base_image

FROM $base_image
RUN apk update && apk add build-base make nodejs npm python3

RUN apk update && apk add erlang erlang-dev elixir

WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release pi_dash

# COPY . .
# RUN rm -rf assets/node_modules/
# RUN mix local.hex --force && mix local.rebar --force
# RUN MIX_ENV=prod mix deps.get
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN MIX_ENV=prod mix release pi_dash