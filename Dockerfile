# Use an official Node.js runtime as a parent image
FROM node:latest

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY src/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY src/ .

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
