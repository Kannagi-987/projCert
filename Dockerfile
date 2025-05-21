# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install any needed dependencies
RUN npm install

# Copy the rest of the application files to /app
COPY . .

# Expose the app on port 80
EXPOSE 80

# Run the app when the container launches
CMD ["npm", "start"]
