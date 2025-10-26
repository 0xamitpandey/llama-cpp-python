FROM python:3.13-bullseye

# Install system build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    libpthread-stubs0-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone your public repo and submodules
RUN git clone --recurse-submodules https://github.com/0xamitpandey/llama-cpp-python.git . 

# Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# Install llama-cpp-python (builds shared library)
RUN pip install .

# Expose port Render will use
ENV PORT 10000
EXPOSE 10000

# Start server
CMD ["python", "-m", "llama_cpp.server"]
