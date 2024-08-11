import os

from flask import Flask, jsonify
from selenium import webdriver
import chromedriver_autoinstaller

app = Flask(__name__)
chromedriver_autoinstaller.install()


@app.route('/scrape', methods=['GET'])
def scrape():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless=new')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')

    driver = webdriver.Chrome(options=options)

    try:
        driver.get("https://medium.com/")
        title = driver.title
        driver.quit()

        return jsonify({'title': title})
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
