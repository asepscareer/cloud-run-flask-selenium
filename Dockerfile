FROM python:3.8-slim-buster

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY wsgi.py .


# Install ChromeDriver
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-chromedriver \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV CHROME_DRIVER_PATH=/usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
