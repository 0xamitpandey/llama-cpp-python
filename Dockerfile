# Use official Python image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Install system dependencies for building llama_cpp
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        wget \
        ninja-build \
        libopenblas-dev \
        && rm -rf /var/lib/apt/lists/*

# Copy your repo into the container
COPY . .

# Ensure git submodules are initialized
RUN git submodule update --init --recursive || true

# Upgrade pip and install the package with server extras
RUN pip install --upgrade pip setuptools wheel && \
    pip install .[server]

# Expose default server port
EXPOSE 8000

# Start the server (replace with your model path)
CMD ["python", "-m", "llama_cpp.server", "--host", "0.0.0.0", "--model", "models/7B/llama-model.gguf"]
