# syntax=docker/dockerfile:1

ARG NODE_VERSION=24.12-alpine3.23

# Stage 1: Angular
FROM node:${NODE_VERSION} AS builder

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

COPY frontend/ .
RUN npm run build -- --configuration production

# Stage 2: Nginx
FROM nginxinc/nginx-unprivileged:alpine3.22-perl AS runner

USER root
RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist/browser/. /usr/share/nginx/html/

USER nginx

EXPOSE 8080 8443
CMD ["nginx", "-g", "daemon off;"]