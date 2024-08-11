FROM python:3.8-slim-buster

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

RUN apt -y update
RUN apt install -y wget curl unzip

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libu/libu2f-host/libu2f-udev_1.1.4-1_all.deb
RUN dpkg -i libu2f-udev_1.1.4-1_all.deb

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y --fix-missing ./google-chrome-stable_current_amd64.deb

## Get latest ChromeDriver version and download
#RUN wget https://storage.googleapis.com/chrome-for-testing-public/127.0.6533.99/linux64/chromedriver-linux64.zip
#RUN ls
#RUN unzip chromedriver_linux64.zip
#RUN ls
#RUN mv chromedriver /usr/bin/chromedriver

# Set environment variables
ENV CHROME_DRIVER_PATH=/usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
