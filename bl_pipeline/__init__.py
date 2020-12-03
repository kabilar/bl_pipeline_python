from os.path import join, dirname
from dotenv import load_dotenv

try:
    load_dotenv(join(dirname(__file__), '..', '.env'))
except:
    print('Cannot find .env file in the top directory')
