# Use Python 3.13 base image
FROM python:3.13-slim

# Install system build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy repo into container
COPY . /app

# Upgrade pip
RUN pip install --upgrade pip

# Install repo (builds shared library)
RUN pip install .

# Expose the port Render will use
ENV PORT 10000
EXPOSE 10000

# Start server
CMD ["python", "-m", "llama_cpp.server"]
