FROM python:3.8-slim-buster

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Install dependencies
RUN apt -y update
RUN apt install -y wget curl unzip

# Install libu2f-host library (if needed for your application)
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libu/libu2f-host/libu2f-udev_1.1.4-1_all.deb
RUN dpkg -i libu2f-udev_1.1.4-1_all.deb

# Install Chrome (latest stable version)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Gunakan apt atau apt-get dengan --fix-missing
RUN apt install -y --fix-missing ./google-chrome-stable_current_amd64.deb

# Get latest ChromeDriver version and download
RUN wget -N https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip -P /tmp/

# Unzip and install ChromeDriver
RUN unzip -o /tmp/chromedriver_linux64.zip -d /tmp/
RUN chmod +x /tmp/chromedriver
RUN mv /tmp/chromedriver /usr/local/bin/chromedriver

# Set environment variables
ENV CHROME_DRIVER_PATH=/usr/local/bin/chromedriver
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
