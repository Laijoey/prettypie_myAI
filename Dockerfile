FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Build args let you inject production endpoints at build time.
ARG AI_API_BASE_URL=https://mygov-ai-947969904935.asia-southeast1.run.app
ARG BACKEND_API_BASE_URL=https://mygov-backend-947969904935.asia-southeast1.run.app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release \
    --dart-define=AI_API_BASE_URL=${AI_API_BASE_URL} \
    --dart-define=BACKEND_API_BASE_URL=${BACKEND_API_BASE_URL}

FROM node:20-alpine

WORKDIR /app
COPY --from=build /app/build/web ./

RUN npm install -g serve

ENV PORT=8080
EXPOSE 8080

CMD ["sh", "-c", "serve -s /app -l ${PORT}"]
