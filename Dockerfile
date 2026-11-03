# ZoomLens backend. Runs on any host that takes a container; secrets come from
# the host's environment, never the image. See docs/deploy.md.
# Trixie, because the RTMS SDK needs GLIBCXX_3.4.31, which bookworm lacks.
FROM node:22-trixie-slim

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY *.js ./
COPY public ./public

ENV NODE_ENV=production
EXPOSE 8080
USER node
CMD ["node", "index.js"]
