# syntax=docker/dockerfile:1.4  ← Enable BuildKit secret to pass github token
FROM python:3-slim

# Install basic tools
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -Ls https://astral.sh/uv/install.sh | sh

# Add uv to PATH
ENV PATH="/root/.cargo/bin:/root/.local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy dependency befor anythong else (will skip next dependency check if no change)
COPY pyproject.toml uv.lock ./

# Install dependencies using uv.lock (with GitHub Token)
RUN --mount=type=secret,id=gh_token \
    GH_TOKEN=$(cat /run/secrets/gh_token) && \
    sed "s|https://github.com|https://${GH_TOKEN}@github.com|g" uv.lock > uv.lock.tmp && \
    mv uv.lock.tmp uv.lock && \
    uv sync --frozen --verbose

# Copy project code
COPY . /app

# Swap to .venv for running
ENV VIRTUAL_ENV="/app/.venv"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Expose port
EXPOSE 5000

# Run apps
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]

