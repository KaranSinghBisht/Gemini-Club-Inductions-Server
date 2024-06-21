# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install mariadb-client for MySQL client usage
RUN apt-get update && apt-get install -y mariadb-client

# Expose the port the app runs on
EXPOSE 5000

# Start the app
CMD ["node", "app.js"]
