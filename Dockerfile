# Base image
FROM node:12-alpine

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]