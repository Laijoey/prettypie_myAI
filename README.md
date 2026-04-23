# SmartGOV - Prettypie
🚀 Overview

SmartGov is a one-stop government service platform designed to collapse the "Bureaucratic Friction Funnel". It replaces fragmented portals with a Unified Digital Ecosystem that proactively manages civic tasks—from tax payments to welfare eligibility—using Gemini 2.0.

## Deployment GCloud Run Link
https://mygov-frontend-947969904935.asia-southeast1.run.app

## Presentation Slide Link
https://canva.link/aeoo8d7kbnmvgro

## 🏛️ Sovereign Architecture Stack
- **The Brain (AI Orchestration)**: Google AI Studio, Gemini 2.0, and Firebase Genkit.
- **The Engine (Core Backend)**: Node.js/Firebase managing auth and state.
- **The Surface (UI/UX)**: Flutter Web for responsive frontend delivery.
- **The Base (Data Layer)**: Mock JSON APIs simulating LHDN, KWSP, and JPJ pipelines.

## Run Whole App (AI + Backend + Flutter)

From project root:

```bash
npm install
npm run install:services
npm run dev:all
```

Useful scripts:

```bash
# AI only (port 5001)
npm run dev:ai

# Backend only (port 8080)
npm run dev:backend

# AI + Backend
npm run dev:services

# Flutter app (with Cloud Run backend + AI URLs)
npm run dev:flutter
```

## AI Integration

The Flutter app uses the Node service in [ai/](ai/) for chatbot, recommendation, and OCR features.

Run the AI service locally before using those features:

```bash
cd ai
npm install
npm run dev
```

If the AI service URL differs from `https://mygov-ai-947969904935.asia-southeast1.run.app`, launch Flutter with `AI_API_BASE_URL` set to the correct endpoint.

If the backend service URL differs from `https://mygov-backend-947969904935.asia-southeast1.run.app`, launch Flutter with `BACKEND_API_BASE_URL` set to the correct endpoint.

## Notes

- AI features (`/chat`, `/recommend`, `/ocr`) use the Cloud Run AI service by default (`https://mygov-ai-947969904935.asia-southeast1.run.app`).
- Flutter now reads both `AI_API_BASE_URL` and `BACKEND_API_BASE_URL`, so you can point the web app at local services or Cloud Run without changing code.

## Deploy To Google Cloud Run

Prerequisites:

```bash
gcloud auth login
gcloud config set project mygov-ai
gcloud config set run/region asia-southeast1
gcloud services enable run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com
```

### 1) Deploy backend service

From project root:

```bash
gcloud run deploy mygov-backend \
	--source backend \
	--clear-base-image \
	--platform managed \
	--allow-unauthenticated \
	--region asia-southeast1 \
	--project mygov-ai \
	--set-env-vars FIREBASE_PROJECT_ID=mygov-ai,FIREBASE_STORAGE_BUCKET=mygov-ai.firebasestorage.app,SEARCH_PROJECT_ID=mygov-ai,SEARCH_LOCATION=global,DATA_STORE_ID=mygov-gcs-connector_1776179121278
```

### 2) Deploy AI service

Set your Gemini key once, then deploy:

```bash
gcloud run deploy mygov-ai \
	--source ai \
	--clear-base-image \
	--platform managed \
	--allow-unauthenticated \
	--region asia-southeast1 \
	--project mygov-ai \
	--set-env-vars GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

Optional environment variables for AI:

- `GEMINI_MODEL` (default: `googleai/gemini-2.5-flash`)
- `DOCUMENT_AI_ENDPOINT`
- `DOCUMENT_AI_BEARER_TOKEN`
- `VERTEX_SEARCH_ENDPOINT`
- `VERTEX_SEARCH_BEARER_TOKEN`

### 3) Deploy Flutter web frontend

Build the Flutter web app with both service URLs baked in:

```bash
flutter build web \
	--dart-define=AI_API_BASE_URL=https://mygov-ai-947969904935.asia-southeast1.run.app \
	--dart-define=BACKEND_API_BASE_URL=https://mygov-backend-947969904935.asia-southeast1.run.app
```

Then deploy the generated `build/web` folder to your preferred Google Cloud hosting option, or serve it from a separate static Cloud Run container if you want everything under Cloud Run.

### 4) Verify services

```bash
curl https://mygov-frontend-947969904935.asia-southeast1.run.app/
curl https://mygov-backend-947969904935.asia-southeast1.run.app/
curl https://mygov-ai-947969904935.asia-southeast1.run.app/
```

The app points non-AI backend calls to:

- `https://mygov-backend-947969904935.asia-southeast1.run.app`
