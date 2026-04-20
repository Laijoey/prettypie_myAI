# prettypie_myAI
A unified platform that brings multiple government services into one system. Users can perform tasks like renewing driving licenses, paying income tax, and accessing public services without switching between different apps. The goal is to provide a simpler, faster, and more convenient digital experience for citizens.

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

# Flutter app (with local AI URL)
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

If the AI service is not running on `http://127.0.0.1:5001`, launch Flutter with `AI_API_BASE_URL` set to the correct endpoint.

## Notes

- AI features (`/chat`, `/recommend`, `/ocr`) use the local AI service by default (`127.0.0.1:5001`).
- Some non-AI backend calls in Flutter are currently hardcoded to Cloud Run URLs, so those continue to hit cloud backend unless you refactor app API base URLs to local backend.
