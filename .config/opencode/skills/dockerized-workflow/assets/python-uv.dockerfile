FROM python:3.14-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uv/bin/uv

ENV PATH="/uv/bin:$PATH"

WORKDIR /app

COPY pyproject.toml ./

RUN uv sync --no-dev

COPY . .