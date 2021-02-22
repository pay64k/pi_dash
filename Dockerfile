# https://kaiwern.com/posts/2020/06/20/building-elixir/phoenix-release-with-docker/
ARG base_image

FROM $base_image as build
RUN apk update && apk add build-base make nodejs npm python3

RUN apk update && apk add erlang erlang-dev elixir

RUN apk add linux-headers --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

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


FROM scratch AS app

WORKDIR /app
COPY --from=build /app/_build/prod/pi_dash-*.tar.gz ./

CMD ["/bin/bash"]

# COPY . .
# RUN rm -rf assets/node_modules/
# RUN mix local.hex --force && mix local.rebar --force
# RUN MIX_ENV=prod mix deps.get
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN MIX_ENV=prod mix release pi_dash