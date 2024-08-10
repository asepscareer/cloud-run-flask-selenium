FROM python:3.8-slim-buster

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Install Chrome (jika belum terinstal)
RUN apt-get update && apt-get install -y \
    chromium \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Unduh ChromeDriver (sesuaikan versi sesuai kebutuhan)
# Pastikan versi ChromeDriver cocok dengan versi Chrome yang Anda gunakan
RUN wget https://chromedriver.storage.googleapis.com/116.0.5845.98/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN rm chromedriver_linux64.zip

# Set environment variables
ENV CHROME_DRIVER_PATH=/usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
