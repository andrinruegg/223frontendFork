# Use Node.js 16 Alpine for building
FROM node:16-alpine AS builder

# Set work directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json . 
RUN yarn install --production

# Copy the rest of the project files
COPY . .

# Build the production version of the app
RUN yarn build

# Use Nginx as a lightweight web server
FROM nginx:alpine

# Copy the built React app to Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
