# Use official Python slim image
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

# Copy your forked repo
COPY . .

# Initialize git submodules
RUN git submodule update --init --recursive || true

# Upgrade pip and install llama-cpp-python with server extras
RUN pip install --upgrade pip setuptools wheel && \
    pip install .[server]

# Install Hugging Face CLI to download model
RUN pip install huggingface-hub

# Download the model automatically to /models
RUN mkdir -p /models/7B && \
    python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='TheBloke/7B-llama2-GGUF', filename='7B-llama2.gguf', cache_dir='/models/7B')"

# Expose default server port
EXPOSE 8000

# Start the server, pointing to downloaded model
CMD ["python", "-m", "llama_cpp.server", "--host", "0.0.0.0", "--model", "/models/7B/7B-llama2.gguf"]
