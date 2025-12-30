# Cart Path TTS Service

Text-to-Speech microservice using Piper TTS for natural-sounding voice synthesis.

## Features

- 🎙️ **Natural Voice** - Uses Piper TTS with high-quality voice models
- ⚡ **Fast** - Real-time synthesis with low latency
- 🔒 **Self-Hosted** - No external API dependencies or costs
- 🐳 **Docker Ready** - Easy deployment with Coolify
- 🧹 **Auto Cleanup** - Removes old audio files automatically

## API Endpoints

### Health Check
```
GET /health
```

Response:
```json
{
  "status": "ok",
  "service": "cart-path-tts"
}
```

### Synthesize Speech
```
POST /synthesize
Content-Type: application/json

{
  "text": "Hello! How can I help you today?",
  "voice": "en_US-lessac-medium"
}
```

Response:
```json
{
  "success": true,
  "audioUrl": "/audio/abc-123-def.wav",
  "audioId": "abc-123-def",
  "text": "Hello! How can I help you today?"
}
```

## Available Voices

- `en_US-lessac-medium` (default) - Natural female voice
- More voices can be added by downloading from [Piper Voices](https://huggingface.co/rhasspy/piper-voices)

## Deployment on Coolify

1. **Create new application** in Coolify
2. **Connect to GitHub repo:** `Pink-Mahi/cart_path_tts`
3. **Set build pack:** Dockerfile
4. **Configure domain:** `tts.cartpathcleaning.com`
5. **Deploy!**

## Environment Variables

```
PORT=3002
PIPER_MODEL_PATH=/models/en_US-lessac-medium.onnx
```

## Local Development

```bash
# Install dependencies
npm install

# Start server
npm start

# Development mode with auto-reload
npm run dev
```

## Usage Example

```javascript
// Call TTS service
const response = await fetch('https://tts.cartpathcleaning.com/synthesize', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    text: 'Welcome to Cart Path Cleaning!',
    voice: 'en_US-lessac-medium'
  })
});

const { audioUrl } = await response.json();

// Play audio
const audio = new Audio(`https://tts.cartpathcleaning.com${audioUrl}`);
audio.play();
```

## Resource Requirements

- **CPU:** 1-2 cores
- **RAM:** 512MB - 1GB
- **Storage:** ~500MB (for voice models)
- **Network:** Minimal

## Cleanup

Audio files are automatically deleted after 1 hour to save disk space.

## License

MIT
