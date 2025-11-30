# ============================
# Stage 1: Build React (Vite)
# ============================
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build Vite project (output is dist/)
RUN npm run build



# ============================
# Stage 2: Serve using Nginx
# ============================
FROM nginx:stable-alpine

# Updated repo name
LABEL org.opencontainers.image.source="https://github.com/Koushik9794/Goderej-devPipeline-repo"

# Copy built frontend
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config (for SPA routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

