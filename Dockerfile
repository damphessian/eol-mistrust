FROM python:3.6-slim

# System dependencies for numpy/scipy/scikit-learn
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libblas-dev \
    liblapack-dev \
    libpq-dev \
    curl \
    gfortran \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Upgrade pip to last version compatible with Python 3.6
RUN pip install --upgrade "pip<21.0" "setuptools<50" "wheel<0.37"

# Install legacy scientific stack compatible with Python 3.6
COPY requirements_py36.txt /workspace/requirements.txt
RUN pip install -r /workspace/requirements.txt

# Install modified fork of abandoned library (drops mysql dependency)
RUN pip install git+https://github.com/inertialgradient/pattern.git

# Keep container alive
CMD ["tail", "-f", "/dev/null"]
