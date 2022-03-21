FROM alpine:latest

# Set labels for the image
LABEL maintainer="Leandro C. Trombini."

# Set container arguments
ARG APP_PATH=/app
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_USER_UID=10000
ARG APP_GROUP_GID=10000

# Set default shell call
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Include necessary library
RUN apk add gcompat

# Create app user and group
RUN addgroup --gid $APP_GROUP_GID $APP_GROUP \
 && adduser -u $APP_USER_UID -G $APP_GROUP --disabled-password --gecos "" $APP_USER \
 && mkdir $APP_PATH \
 && chown $APP_USER:$APP_GROUP $APP_PATH

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Set working directory
WORKDIR $APP_PATH

# Set user
USER $APP_USER

# Copy application files
COPY --chown=$APP_USER:$APP_GROUP redis-http-health-check $APP_PATH/
RUN chmod +x $APP_PATH/redis-http-health-check

# Set the entrypoint to the script
ENTRYPOINT ["entrypoint.sh"]

# Set exposed ports
EXPOSE 8000
