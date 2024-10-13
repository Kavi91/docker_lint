FROM alpine:3.14

LABEL Maintainer="Sample Maintainer"
LABEL Version="1.0.0"
LABEL Description="An extended Dockerfile with intentional errors for learning."

# Set environment variable for app
ENV APP_VERSION 1.0.0

# Use ADD instead of COPY (this is generally discouraged)
ADD entrypoint.sh /usr/local/bin/

# Install packages without version pinning and in separate `apk add` commands (inefficient)
RUN apk add --no-cache curl \
    && apk add --no-cache python3 \
    && apk add --no-cache git \
    && mkdir -p /usr/src/app

# Set a working directory with mkdir instead of using WORKDIR (incorrect)
RUN mkdir -p /app \
    && cd /app \
    && touch app.py

# Create a user and group with insecure UID/GID
RUN addgroup -g 9999 appgroup \
    && adduser -D -u 9999 -G appgroup appuser

# Example of a loop with a bad expansion (issue with shellcheck)
RUN for i in 1 2 3; do \
      echo $i; \
    done

# Run application as root (this is insecure)
USER root

# Potential unquoted environment variable that can cause issues
RUN echo Hello, $APP_VERSION!

# Unnecessary cleanup after build
RUN rm -rf /tmp/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["python3", "app.py"]
