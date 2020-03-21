import requests
from flask import Flask, json, request, jsonify
from sql_manager import SQL_Manager


app = Flask(__name__)

sql_manager = SQL_Manager()


YOUR_APP_ID = 'yn857KKanJEoakwv7SkU'
YOUR_APP_CODE = 'I9eURB3TlwHOI50XjsmMGHv1mDxL3xyxomVxhakH-P4'


@app.route('/get_opportunities/', methods=['GET'])
def get_opportyniries():
    data = request.get_json(force=True)
    categories = sql_manager.get_categories(data['users'] + [data['me']])
    location = data['location']
    radius = data['radius']

    result = requests.get(f'https://places.sit.ls.hereapi.com/places/v1/discover/explore',
    {
        'in': f'{location};r={radius}',
        'cat': ','.join(categories),
        'app_id': YOUR_APP_ID,
        'apiKey': YOUR_APP_CODE
    }).json()

    return result, 200


@app.route('/add_task/', methods=['POST'])
def add_task():
    data = request.get_json(force=True)
    phone = data['phone']
    description = data['description']
    categories = data['categories']

    return 200



if __name__ == '__main__':
    app.run()
