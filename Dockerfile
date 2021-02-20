FROM arm64v8/elixir:1.11.3
RUN apt update && apt install -y --no-install-recommends build-essential erlang-dev wget
# RUN apt install -y sudo
# USER root
# RUN curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash && sudo apt install -y nodejs
RUN mkdir /build
WORKDIR /build
COPY . .
RUN rm -rf assets/node_modules/
RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix deps.get
# RUN npm config set registry http://registry.npmjs.org/
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
RUN MIX_ENV=prod mix release pi_dash