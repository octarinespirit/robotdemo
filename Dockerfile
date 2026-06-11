FROM python:3.11-slim

# Set working directory

WORKDIR /app

# Install Linux dependencies for Playwright / Browser library

RUN apt-get update && apt-get install -y 
curl 
gnupg 
build-essential 
wget 
xvfb 
libnss3 
libatk1.0-0 
libatk-bridge2.0-0 
libcups2 
libxkbcommon0 
libxcomposite1 
libxrandr2 
libgbm1 
libasound2 
libgtk-3-0 
libxshmfence1 
libglu1 
&& rm -rf /var/lib/apt/lists/*

# Install Node.js + npm

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 
&& apt-get install -y nodejs

# Copy requirements first (better Docker cache usage)

COPY requirements.txt .

# Install Python dependencies

RUN pip install --no-cache-dir -r requirements.txt

# Install Browser library dependencies

RUN rfbrowser init

# Copy project files

COPY . .

# Create results directory

RUN mkdir -p /app/results

# Default command

CMD ["robot", "--console", "verbose", "--outputdir", "/app/results", "tests"]
