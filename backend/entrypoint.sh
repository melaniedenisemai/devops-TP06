#!/bin/bash
set -e
echo "Esperando a Postgres en $DB_HOST:$DB_PORT..."

python3 -c "
import psycopg2, os, time
for i in range(15):
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST', 'db'),
            port=os.getenv('DB_PORT', '5432'),
            dbname=os.getenv('DB_NAME', 'notesdb'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', 'postgres')
        )
        conn.close()
        print('Postgres listo.')
        break
    except Exception as e:
        print(f'  Esperando DB ({e})...')
        time.sleep(2)
"

python3 -c "import app; app.init_db()" 2>/dev/null || true
exec "$@"
