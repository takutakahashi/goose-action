FROM alpine:latest

# Install necessary tools
RUN apk add --no-cache \
    bash \
    git \
    curl \
    jq \
    ca-certificates

# Install GitHub CLI
RUN apk add --no-cache github-cli

# Install goose CLI
RUN curl -L https://github.com/block/goose/releases/latest/download/goose-linux-amd64 -o /usr/local/bin/goose && \
    chmod +x /usr/local/bin/goose

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]