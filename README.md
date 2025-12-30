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

### Currently Installed:
- `en_US-lessac-medium` (default) - Natural female voice

### How to Switch Voices:

**Easy Method (No Code Changes):**
1. Go to Coolify dashboard
2. Open TTS service environment variables
3. Add/change: `PIPER_VOICE=en_US-lessac-medium`
4. Restart the service
5. Done! New voice will be used immediately

### Popular Voice Options:

**Female Voices:**
- `en_US-lessac-medium` - Professional, clear (current)
- `en_US-amy-medium` - Friendly, conversational
- `en_US-kimberly-low` - Warm, approachable
- `en_GB-alba-medium` - British accent

**Male Voices:**
- `en_US-danny-low` - Deep, authoritative
- `en_US-joe-medium` - Neutral, professional
- `en_GB-alan-medium` - British accent

**Browse all 100+ voices:** https://huggingface.co/rhasspy/piper-voices/tree/v1.0.0/en

### To Add a New Voice Model:

1. **Update Dockerfile** to download the voice:
```dockerfile
# Add after the existing voice download
RUN cd /models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/danny/low/en_US-danny-low.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/danny/low/en_US-danny-low.onnx.json
```

2. **Redeploy** the service

3. **Set environment variable** in Coolify:
   - `PIPER_VOICE=en_US-danny-low`

4. **Restart** the service

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
