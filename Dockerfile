# syntax = docker/dockerfile:1

# Adjust NODE_VERSION as desired
ARG NODE_VERSION=19.7.0
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="Node.js"

# Node.js app lives here
WORKDIR /build

# Set production environment
ENV NODE_ENV="production"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential node-gyp pkg-config python-is-python3 unzip ca-certificates openssh-client

# POCKETBASE
ARG PB_VERSION=0.19.0

# RUN apk add --no-cache \
#     unzip \
#     ca-certificates \
#     # this is needed only if you want to use scp to copy later your pb_data locally
#     openssh

# download and unzip PocketBase 
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/



# END POCKETBASE


# Install node modules
COPY --link package-lock.json package.json patches ./
COPY ./patches ./patches
RUN npm ci --include=dev
RUN npm run postinstall

# Copy application code
COPY --link . .

# Build application
RUN npm run build

# # uncomment to copy the local pb_migrations dir into the container
# COPY ./app/pb_migrations /pb/pb_migrations

# # uncomment to copy the local pb_hooks dir into the container
# COPY ./app/pb_hooks /pb/pb_hooks

# Remove development dependencies
RUN npm prune --prod

# Final stage for app image
FROM base

# Copy built application
COPY --from=build /build /
# COPY --from=build /pb /pb
# COPY --from=build /app/app/pocketbase/pb_migrations /pb/pb_migrations
# COPY --from=build /app/pocketbase/pb_hooks /pb/pb_hooks


# Start the server by default, this can be overwritten at runtime
EXPOSE 8080

ENTRYPOINT ["npm", "run"]
CMD ["start"]