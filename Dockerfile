
# Build stage
FROM rust:1.85-slim AS builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/target/release/pearl-proxy /app/pearl-proxy

RUN chmod +x /app/pearl-proxy

EXPOSE 8000

CMD ["/app/pearl-proxy"]
