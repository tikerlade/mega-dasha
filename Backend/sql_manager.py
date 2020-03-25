import sqlite3


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

    def get_categories(self, users_phones):
        data = []

        for user in users_phones:
            get_query = f'''SELECT category FROM problems
                            WHERE phone={user}'''
            d = self.cursor.execute(get_query).fetchall()

            if d:
                data += [el[0] for el in d]
        self.connection.commit()
        return list(set(data))

    def add_task(self, phone, description, category):
        params = [phone, description, category]
        sqlite_insert_query = f"""INSERT INTO problems 
                                VALUES 
                                (?,?,?)"""
        # print(sqlite_insert_query)
        self.cursor.execute(sqlite_insert_query, params)
        self.connection.commit()
        # print("Record inserted successfully into tasks table ", cursor.rowcount)


    def get_tasks(self, users_phones):
        labels = ['phone', 'description', 'category']
        data = []

        for user in users_phones:
            get_query = f'''SELECT * FROM problems
                                WHERE phone={user}'''
            d = self.cursor.execute(get_query).fetchall()

            if d:
                for obj in d:
                    data.append({labels[i]: obj[i] for i in range(len(obj))})
        self.connection.commit()
        print(data)
        return data

    def get_tasks_categories(self, users_phones, categories):
        labels = ['phone', 'description', 'category']
        data = []

        for user in users_phones:
            for cat in categories:
                get_query = f'''SELECT * FROM problems
                                WHERE phone={user} AND category=\'{cat}\''''
                d = self.cursor.execute(get_query).fetchall()

                if d:
                    for obj in d:
                        data.append({labels[i]: obj[i] for i in range(len(obj))})
        self.connection.commit()
        print(data)
        return data