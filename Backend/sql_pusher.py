import sqlite3
import io


connection = sqlite3.connect('tasks.db', check_same_thread=False)
cursor = connection.cursor()

problems_create_query = '''CREATE TABLE IF NOT EXISTS problems
                  (phone INTEGER,
                   description TEXT,
                   category TEXT)'''

cursor.execute(problems_create_query)


phone = 777
description = '[RedVerg RD5461C-120A, RedVerg RD5461C-130A, RedVerg RD5461C-150A, RedVerg RD5461C-160B, пластик, 1 шт]'
category = 'shopping'
query = '''INSERT INTO problems VALUES (?, ?, ?)'''


params = [phone, description, category]
print(params)
cursor.execute(query, params)
connection.commit()


params = [phone, description, 'mall']
print(params)
cursor.execute(query, params)
connection.commit()
# for i in range(10):
#     params = [phone, description, category]
#     print(params)
#     cursor.execute(query, params)
#     phone += 1
# connection.commit()

# for i in range(10):
#     params = [phone, description, 'goinig-out']
#     print(params)
#     cursor.execute(query, params)
#     phone += 1
# connection.commit()




# idx = 0
# params = []
# data = pd.read_csv('products_final.csv')
# for row in data.iterrows():
#   idx += 1
#   params.append([idx, row[1][3],  row[1][1], row[1][2], row[1][4], row[1][5]])
# print(idx)
# cursor.executemany(query, params)
# connection.commit()

# cart = np.array([1, 11, 21, 45, 12, 90, 32, 89])
# insert_user = '''INSERT INTO users VALUES (?,?,?,?,?)'''
# params = [0, 'https://images-na.ssl-images-amazon.com/images/I/8166xCVDGnL._SY355_.jpg', 100, 0, cart]

# cursor.executemany(insert_user, [params])
# connection.commit()