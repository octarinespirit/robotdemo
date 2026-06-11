FROM python:3.11-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y curl gnupg build-essential wget xvfb 
libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 
libxcomposite1 libxrandr2 libgbm1 libasound2 libgtk-3-0 libxshmfence1 libglu1 
&& rm -rf /var/lib/apt/lists/*

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 
&& apt-get install -y nodejs

# Install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Browser / Playwright
RUN rfbrowser init

# Project files
COPY . .

RUN mkdir -p /app/results

CMD ["robot", "--console", "verbose", "--outputdir", "/app/results", "tests"]
