# Installing Spanish Voices for Piper TTS

## Overview
Your Piper TTS server currently only has English voices. To support bilingual chat, you need to install Spanish voice models.

---

## Spanish Voice Models

**Female Voice (Recommended):**
- Name: `es_ES-mls_10246-low`
- Quality: Low (smaller, faster)
- Use: Bot responses to Spanish customers

**Male Voice (Optional):**
- Name: `es_ES-mls_9972-low`
- Quality: Low (smaller, faster)
- Use: Admin responses to Spanish customers

---

## Installation Steps

### 1. Access TTS Server Container

In Coolify, open Terminal for your `cart_path_tts` container.

### 2. Download Spanish Voice Models

```bash
# Create voices directory if it doesn't exist
mkdir -p /app/voices

# Download Spanish female voice (required)
cd /app/voices
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx.json

# Download Spanish male voice (optional)
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_9972-low.onnx
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_9972-low.onnx.json
```

### 3. Verify Installation

```bash
ls -lh /app/voices/es_ES*
```

You should see:
```
es_ES-mls_10246-low.onnx
es_ES-mls_10246-low.onnx.json
es_ES-mls_9972-low.onnx
es_ES-mls_9972-low.onnx.json
```

### 4. Test Spanish Voice

```bash
# Test Spanish female voice
echo "Hola buenos días" | piper --model /app/voices/es_ES-mls_10246-low.onnx --output_file /tmp/test_es.wav

# Check if file was created
ls -lh /tmp/test_es.wav
```

### 5. Update TTS Server Code (If Needed)

Your TTS server needs to support dynamic voice selection. Check if it accepts a `voice` parameter in the API request.

**Expected API format:**
```json
POST /synthesize
{
  "text": "Hola buenos días",
  "voice": "es_ES-mls_10246-low"
}
```

---

## Alternative: Higher Quality Voices

If you want better quality (but larger files):

**Medium Quality:**
```bash
# Spanish female - medium quality
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-medium.onnx
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-medium.onnx.json
```

Then update the voice name in your code to `es_ES-mls_10246-medium`.

---

## Troubleshooting

### Issue: wget not found
```bash
# Use curl instead
curl -L -o es_ES-mls_10246-low.onnx https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx
curl -L -o es_ES-mls_10246-low.onnx.json https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx.json
```

### Issue: Permission denied
```bash
# Run as root or use sudo
sudo mkdir -p /app/voices
sudo chown -R $(whoami) /app/voices
```

### Issue: TTS server doesn't find voices
Make sure your TTS server is configured to look in `/app/voices/` for voice models.

---

## Testing After Installation

### 1. Test via curl
```bash
curl -X POST https://tts.cartpathcleaning.com/synthesize \
  -H "Content-Type: application/json" \
  -d '{"text":"Hola buenos días","voice":"es_ES-mls_10246-low"}'
```

Expected response:
```json
{
  "audioUrl": "/audio/some-file.wav"
}
```

### 2. Test in Chat
1. Go to your website
2. Click **ES** toggle
3. Open chat
4. Send a message in Spanish
5. Bot should respond in Spanish with audio

---

## Voice Model Sizes

**Low Quality:**
- `es_ES-mls_10246-low.onnx`: ~15 MB
- `es_ES-mls_9972-low.onnx`: ~15 MB

**Medium Quality:**
- `es_ES-mls_10246-medium.onnx`: ~30 MB

**Total storage needed:** ~30-60 MB for both Spanish voices

---

## Persistent Storage

**Important:** If your container restarts, the voices will be lost unless you:

1. **Use Persistent Storage in Coolify:**
   - Add a volume mount: `/app/voices` → persistent storage
   
2. **Or add to Docker image:**
   - Add voice downloads to your Dockerfile
   - Rebuild and redeploy

**Recommended:** Set up persistent storage in Coolify for `/app/voices` directory.

---

## Available Spanish Voices

Piper has multiple Spanish voice options:

| Voice | Gender | Quality | Size | Accent |
|-------|--------|---------|------|--------|
| es_ES-mls_10246-low | Female | Low | 15MB | Spain |
| es_ES-mls_9972-low | Male | Low | 15MB | Spain |
| es_MX-claude-high | Male | High | 60MB | Mexico |
| es_ES-davefx-medium | Male | Medium | 30MB | Spain |

For your use case, `es_ES-mls_10246-low` (female, Spain accent) is perfect.

---

## Next Steps After Installation

1. ✅ Install Spanish voices
2. ✅ Test with curl
3. ✅ Test in chat widget
4. ✅ Deploy backend with translation metadata fix
5. ✅ Update admin dashboard to show Spanish + English

---

**Installation Date:** December 30, 2024
**Estimated Time:** 5-10 minutes
