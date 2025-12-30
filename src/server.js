const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const { promisify } = require('util');
const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config();

const execAsync = promisify(exec);
const app = express();
const PORT = process.env.PORT || 3002;

// Middleware
app.use(cors());
app.use(express.json());
app.use('/audio', express.static(path.join(__dirname, '../audio')));

// Ensure audio directory exists
const AUDIO_DIR = path.join(__dirname, '../audio');
fs.mkdir(AUDIO_DIR, { recursive: true }).catch(console.error);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'cart-path-tts' });
});

// Text-to-Speech endpoint
app.post('/synthesize', async (req, res) => {
  try {
    const { text, voice = 'en_US-lessac-medium' } = req.body;

    if (!text) {
      return res.status(400).json({ error: 'Text is required' });
    }

    // Generate unique filename
    const audioId = uuidv4();
    const outputPath = path.join(AUDIO_DIR, `${audioId}.wav`);

    // Run Piper TTS
    // Use full path to piper binary
    const command = `echo "${text.replace(/"/g, '\\"')}" | /usr/local/bin/piper --model /models/${voice}.onnx --output_file ${outputPath}`;

    await execAsync(command);

    // Check if file was created
    await fs.access(outputPath);

    // Return audio URL
    const audioUrl = `/audio/${audioId}.wav`;
    res.json({
      success: true,
      audioUrl,
      audioId,
      text
    });

    // Clean up old audio files (older than 1 hour)
    cleanupOldFiles().catch(console.error);

  } catch (error) {
    console.error('TTS Error:', error);
    res.status(500).json({
      error: 'Failed to synthesize speech',
      details: error.message
    });
  }
});

// Cleanup old audio files
async function cleanupOldFiles() {
  try {
    const files = await fs.readdir(AUDIO_DIR);
    const now = Date.now();
    const oneHour = 60 * 60 * 1000;

    for (const file of files) {
      const filePath = path.join(AUDIO_DIR, file);
      const stats = await fs.stat(filePath);
      
      if (now - stats.mtimeMs > oneHour) {
        await fs.unlink(filePath);
        console.log(`Cleaned up old file: ${file}`);
      }
    }
  } catch (error) {
    console.error('Cleanup error:', error);
  }
}

app.listen(PORT, () => {
  console.log(`TTS service running on port ${PORT}`);
  console.log(`Audio files served from: ${AUDIO_DIR}`);
});
