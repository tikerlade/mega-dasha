import json
import io
import sqlite3
from collections import defaultdict

from flask import jsonify

class SQL_Manager:

    def __init__(self):
        self.connection = sqlite3.connect('tasks.db',
                                          check_same_thread=False)
        self.cursor = self.connection.cursor()

        problems_create_query = '''CREATE TABLE IF NOT EXISTS problems
                          (phone INTEGER,
                           description TEXT,
                           category TEXT)'''

        self.cursor.execute(problems_create_query)

        # self.connection.enable_load_extension(True)
        # self.connection.load_extension("./libsqliteicu.so")


    def get_category(self, users_phones):
        get_query = f'''SELECT category FROM products
                        WHERE phone=?'''
        data = self.cursor.executemany(get_query, [users_phones])
        self.connection.commit()
        print(data)






























    def get_profile(self, user_id):
        get_query = f'''SELECT * FROM users
                       WHERE id = {user_id}'''
        data = self.cursor.execute(get_query).fetchone()

        fields = ['picture_url', 'cash_back', 'user_of_psb']
        output = {}
        if data:
            for i in range(len(fields)):
                output[fields[i]] = data[i+1]

        response = jsonify({'user': output})
        response.status_code = 200
        return response

    def get_product(self, user_id, product_id):
        get_query = f'''SELECT * FROM products
                       WHERE id={product_id}'''
        data = self.cursor.execute(get_query).fetchone()


        fields = ['id', 'photo_url', 'name', 'description', 'price']
        output = {}
        if data:
            for i in range(len(fields)):
                output[fields[i]] = data[i]

        users_fav_query = f'''SELECT favourite FROM users
                                    WHERE id={user_id}'''
        user_fav_data = self.cursor.execute(users_fav_query).fetchone()

        if user_fav_data:
            user_fav_data = list(self.convert_array(user_fav_data[0]))
            output['is_favourite'] = 1 if product_id in user_fav_data else 0
        else:
            output['is_favourite'] = 0
        return output

    def get_user_favourite(self, user_id):
        get_query = f'''SELECT favourite FROM users
                       WHERE id = {user_id}'''
        data = self.cursor.execute(get_query).fetchone()

        if data:
            output = []
            data = self.convert_array(data[0])

            for product in data:
                output.append(self.get_product(user_id, int(product)))
            response = jsonify({'items': output})
            response.status_code = 200

            return response
        response = jsonify({'items': []})
        response.status_code = 200
        return response

    def manage_favourite(self, user_id, product_id, method):
        get_query = f'''SELECT favourite FROM users
                        WHERE id = {user_id}'''
        data = self.cursor.execute(get_query).fetchone()

        if data:
            data = list(self.convert_array(data[0]))
            if method == 0:
                if product_id in data:
                    data.remove(product_id)
            else:
                if product_id not in data:
                    data.append(product_id)
            data = np.array(data)


            insert_query = f'''UPDATE users SET favourite=? WHERE id=?'''

            self.cursor.executemany(insert_query, [[data, user_id]])
            self.connection.commit()

    def search(self, string):
        string = string.lower()

        get_query = f"""SELECT * FROM products
                WHERE LOWER(name) LIKE {"'%" + string + "%'"}
                ORDER BY RANDOM()
                LIMIT 20"""
        data = self.cursor.execute(get_query)

        fields = ['id', 'photo_url', 'name', 'description', 'price']
        output = []
        if data:
            for product in data:
                temp = {}

                for i in range(len(fields)):
                    temp[fields[i]] = product[i]

                output.append(temp)

        response = jsonify({'items': output})
        response.status_code = 200
        return respons