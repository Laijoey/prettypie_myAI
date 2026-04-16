# prettypie_myAI
A unified platform that brings multiple government services into one system. Users can perform tasks like renewing driving licenses, paying income tax, and accessing public services without switching between different apps. The goal is to provide a simpler, faster, and more convenient digital experience for citizens.

## AI Integration

The Flutter app uses the Node service in [ai/](ai/) for chatbot, recommendation, and OCR features.

Run the AI service locally before using those features:

```bash
cd ai
npm install
npm run dev
```

If the AI service is not running on `http://127.0.0.1:5001`, launch Flutter with `AI_API_BASE_URL` set to the correct endpoint.
