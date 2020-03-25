import requests
from flask import Flask, json, request, jsonify
from sql_manager import SQL_Manager
import flexpolyline as fp

YOUR_APP_CODE = "sq_ga7ALxZrl8pZBSsomZRHlm6iLHlEXMts6C3_jW1Y"

app = Flask(__name__)

sql_manager = SQL_Manager()


categories = [
    "restaurant", "coffee-tea", "snacks-fast-food", "going-out",
    "sights-museums", "transport", "airport", "accommodation",
    "shopping", "leisure-outdoor", "administrative-areas-buildings",
    "natural-geographical", "petrol-station", "atm-bank-exchange",
    "toilet-rest-area", "hospital-health-care-facility", "petrol-station"
]

rus_categories = [
    "Рестораны", "Кафе", "Фаст-Фуд", "Развлечения", "Достопримечательности",
    "Транспорт", "Аэропорт", "Проживание", "Шоппинг", "Активный Отдых",
    "Учреждения", "Природа", "Заправки", "Банкоматы", "Туалеты", "Больницы", "Заправка"
]

def translate_rus_eng(rus):
    result = []
    for cat in rus:
        result.append(categories[rus_categories.index(cat)])
    return result


def translate_eng_rus(eng):
    result = []
    for cat in eng:
        if cat in rus_categories:
            result.append(rus_categories[categories.index(cat)])
        else:
            result.append(cat)
    return result


YOUR_APP_ID = 'yn857KKanJEoakwv7SkU'
YOUR_APP_CODE = 'I9eURB3TlwHOI50XjsmMGHv1mDxL3xyxomVxhakH-P4'


@app.route('/get_opportunities/', methods=['POST'])
def get_opportunities():
    data = request.get_json(force=True)
    categories = sql_manager.get_categories(data['users'] + [data['me']])
    location = data['location']
    radius = data['radius']
    print(data)
    result = requests.get(f'https://places.sit.ls.hereapi.com/places/v1/discover/explore',
    {
        'in': f'{location};r={radius}',
        'cat': ','.join(categories),
        'app_id': YOUR_APP_ID,
        'apiKey': YOUR_APP_CODE
    }).json()
    print(result)
    return jsonify(result), 200


@app.route('/add_task/', methods=['POST'])
def add_task():
    data = request.get_json(force=True)
    phone = data['phone']
    description = data['description']
    category = translate_rus_eng([data['category']])[0]
    sql_manager.add_task(phone, description, category)
    return jsonify("vse horosho"), 200


@app.route('/get_tasks/', methods=['POST'])
def get_tasks():
    data = request.get_json(force=True)
    tasks = sql_manager.get_tasks(data['users'] + [data['me']])
    for t in tasks:
        t['category'] = translate_eng_rus([t['category']])[0]
    return jsonify({'tasks': tasks}), 200




@app.route('/get_active_tasks/', methods=['POST'])
def get_active_tasks():
    data = request.get_json(force=True)
    categories = sql_manager.get_categories(data['users'] + [data['me']])
    location = data['location']
    radius = data['radius']
    
    print(data)
    result = requests.get(f'https://places.sit.ls.hereapi.com/places/v1/discover/explore',
    {
        'in': f'{location};r={radius}',
        'cat': ','.join(categories),
        'app_id': YOUR_APP_ID,
        'apiKey': YOUR_APP_CODE
    }).json()

    print(result)
    available_categories = set()
    for item in result['results']['items']:
        cat = item['category']['id']
        available_categories.add(cat)

    if len(available_categories) > 0:
        tasks = sql_manager.get_tasks_categories(data['users'] + [data['me']], categories)
        for t in tasks:
            t['category'] = translate_eng_rus([t['category']])[0]

        return jsonify({'tasks': tasks}), 200
    else:
        return jsonify({'tasks': []}), 200







def get_polyline(origin, destination):
    route_endpoint = "https://router.hereapi.com/v8/routes"
    transportMode = "pedestrian"
    params = {"apiKey": YOUR_APP_CODE,
              "transportMode": transportMode,
              "origin": origin,
              "destination": destination,
              "return": "polyline"
              }
    r = requests.get(url=route_endpoint, params=params)
    content = r.json()
    return content["routes"][0]["sections"][0]["polyline"]


def get_route(polyline, width):
    coords = fp.decode(polyline)
    route = "["
    for coord in coords:
        route += f"{coord[0]},{coord[1]}|"
    route = f"{route[:-1]}];w={width}"
    return route


@app.route('/get_places_latlon/', methods=['GET'])
def get_places_latlon():
    origin = request.args.get('origin')
    destination = request.args.get('destination')
    width = request.args.get('width')
    cat = translate_rus_eng([request.args.get('cat')])[0]


    polyline = get_polyline(origin, destination)
    route = get_route(polyline, width)

    corridor_endpoint = "https://places.sit.ls.hereapi.com/places/v1/browse/by-corridor"

    params = {"apiKey": YOUR_APP_CODE,
              "route": route,
              "cat": cat
              }

    r = requests.get(url=corridor_endpoint, params=params)
    content = r.json()
    return json.dumps(content)


@app.route('/get_places_poly/', methods=['GET'])
def get_places_poly():
    polyline = request.args.get('polyline')
    width = request.args.get('width')
    cat = translate_rus_eng([request.args.get('cat')])[0]

    route = get_route(polyline, width)

    corridor_endpoint = "https://places.sit.ls.hereapi.com/places/v1/browse/by-corridor"

    params = {"apiKey": YOUR_APP_CODE,
              "route": route,
              "cat": cat
              }

    r = requests.get(url=corridor_endpoint, params=params)
    content = r.json()
    return json.dumps(content)


@app.route('/get_places_nearby/', methods=['GET'])
def get_places_nearby():
    location = request.args.get('location')
    radius = request.args.get('radius')
    cat = translate_eng_rus([request.args.get('cat')])[0]
    in_ = f"{location};r={radius}"

    corridor_endpoint = "https://places.sit.ls.hereapi.com/places/v1/browse"

    params = {"apiKey": YOUR_APP_CODE,
              "in": in_,
              "cat": cat
              }

    r = requests.get(url=corridor_endpoint, params=params)
    content = r.json()
    return json.dumps(content)


if __name__ == '__main__':
    app.run()
