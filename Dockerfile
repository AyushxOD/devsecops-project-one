# Stage 1: Build
FROM node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293 AS builder

WORKDIR /app

COPY --chmod=644 package*.json ./
RUN npm install --omit=dev --ignore-scripts

COPY --chmod=644 index.js ./

# Stage 2: Production
FROM node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293

WORKDIR /app
RUN chown -R node:node /app && chmod -R 755 /app

COPY --from=builder --chown=node:node --chmod=555 /app/node_modules ./node_modules
COPY --from=builder --chown=node:node --chmod=444 /app/package*.json ./
COPY --from=builder --chown=node:node --chmod=444 /app/index.js ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

CMD ["node", "index.js"]