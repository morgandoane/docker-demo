# Use a lightweight Node image for building
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install

# Compile TypeScript
COPY src ./src
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

# Install only production deps
COPY package*.json ./
RUN npm install --production

# Copy compiled output
COPY --from=builder /app/dist ./dist

# Expose the port the app will run on
EXPOSE 8080

# Start the app
CMD ["node", "dist/index.js"]
