FROM node:20-alpine

# Install Piper TTS dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    build-base \
    wget \
    espeak-ng

# Install Piper TTS
WORKDIR /tmp
RUN wget https://github.com/rhasspy/piper/releases/download/v1.2.0/piper_amd64.tar.gz && \
    tar -xzf piper_amd64.tar.gz && \
    mv piper/piper /usr/local/bin/ && \
    chmod +x /usr/local/bin/piper && \
    rm -rf piper piper_amd64.tar.gz

# Download voice model (en_US-lessac-medium - natural female voice)
RUN mkdir -p /models && \
    cd /models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json

# Set up application
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

# Create audio directory
RUN mkdir -p /app/audio

# Set environment variables
ENV PORT=3002
ENV PIPER_MODEL_PATH=/models/en_US-lessac-medium.onnx

EXPOSE 3002

CMD ["node", "src/server.js"]
