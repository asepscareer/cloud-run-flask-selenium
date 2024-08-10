import os

from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service

app = Flask(__name__)


@app.route('/scrape', methods=['GET'])
def scrape():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless=new')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.binary_location = os.environ.get("GOOGLE_CHROME_BIN")

    driver = webdriver.Chrome(options=options, service=Service(os.environ.get("CHROMEDRIVER_PATH")))

    try:
        driver.get("https://medium.com/")
        title = driver.title
        driver.quit()

        return jsonify({'title': title})
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
