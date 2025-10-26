# Use full Debian base for C++ build
FROM python:3.13-bullseye

# Install build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    libpthread-stubs0-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy repo contents
COPY . /app

# Initialize git submodules
RUN git submodule update --init --recursive

# Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# Install llama-cpp-python (builds shared library)
RUN pip install .

# Expose port Render will use
ENV PORT 10000
EXPOSE 10000

# Start server
CMD ["python", "-m", "llama_cpp.server"]
