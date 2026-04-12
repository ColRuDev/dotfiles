FROM rust:1.75-alpine

WORKDIR /app

COPY Cargo.toml ./

RUN cargo build --release

COPY . .