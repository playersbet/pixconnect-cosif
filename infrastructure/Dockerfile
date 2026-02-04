# infrastructure/Dockerfile
FROM elixir:1.16-alpine AS builder

RUN apk add --no-cache build-base git

WORKDIR /app

ENV MIX_ENV=prod

COPY backend/mix.exs backend/mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile

COPY backend/config config/
COPY backend/lib lib/
COPY backend/priv priv/

RUN mix compile
RUN mix release

# Runtime
FROM alpine:3.18

RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/cosif ./

ENV HOME=/app
ENV PORT=4000

EXPOSE 4000

CMD ["bin/cosif", "start"]
