FROM python:3.13-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    libpthread-stubs0-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone your public repo with submodules
RUN git clone --recurse-submodules https://github.com/0xamitpandey/llama-cpp-python.git .

# Upgrade pip and build tools
RUN pip install --upgrade pip setuptools wheel

# Install llama-cpp-python and server dependencies
RUN pip install . uvicorn fastapi

# Expose port
ENV PORT 10000
EXPOSE 10000

# Start the server using uvicorn
CMD ["uvicorn", "llama_cpp.server:app", "--host", "0.0.0.0", "--port", "10000"]
