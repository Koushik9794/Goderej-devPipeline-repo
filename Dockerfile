# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# Use the build command your project uses (vite -> dist; CRA -> build)
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine
LABEL org.opencontainers.image.source="https://github.com/Harsha463/demo-dev-environment"
# Copy built files (Vite uses dist/, CRA uses build/)
COPY --from=build /app/dist /usr/share/nginx/html
# If CRA: uncomment the following line and comment the Vite line above
# COPY --from=build /app/build /usr/share/nginx/html

# Custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
