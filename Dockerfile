# syntax=docker/dockerfile:1

ARG NODE_VERSION=24.12-alpine3.23

# Stage 1: Angular
FROM node:${NODE_VERSION} AS builder

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

COPY frontend/ .
RUN npm run build --prod

# Stage 2: Nginx
FROM nginxinc/nginx-unprivileged:1.29.4-alpine3.23 as runner

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080 8443
CMD ["nginx", "-g", "daemon off;"]