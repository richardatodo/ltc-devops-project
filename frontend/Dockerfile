# ---- Stage 1: Build ----
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# ---- Stage 2: Serve ----
# Use a lightweight Nginx image to serve the static files
FROM nginx:1.26-alpine

# Copy the custom Nginx configuration
# This replaces the default Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static build artifacts from the 'builder' stage
# Ensure the source path '/app/build' matches your build output directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 (the default Nginx port)
EXPOSE 80

# Default command to start Nginx in the foreground
# (The base Nginx image already includes a suitable CMD or ENTRYPOINT)
# CMD ["nginx", "-g", "daemon off;"] # Usually not needed to specify explicitly