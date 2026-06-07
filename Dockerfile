FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY tsconfig.backend.json ./

RUN npm install --ignore-engines --legacy-peer-deps

COPY . .

RUN npx tsc -p tsconfig.backend.json

EXPOSE 5000

ENV NODE_ENV=production
ENV PORT=5000

CMD ["node", "dist-backend/index.js"]
