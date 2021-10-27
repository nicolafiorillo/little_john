# Build: docker build -t little_john .
# Run:   docker run -e PORT=4000 -p 4000:4000 -t little_john

FROM bitwalker/alpine-elixir:1.12.3 as build

COPY . .

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

RUN rm -Rf _build && \
    MIX_ENV=prod mix do deps.get, deps.compile, compile, release

FROM bitwalker/alpine-erlang:24.0.5

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs
    
COPY --from=build /opt/app/_build/prod/rel/little_john/ .

USER default

ENTRYPOINT ["bin/little_john"]
CMD ["start"]
