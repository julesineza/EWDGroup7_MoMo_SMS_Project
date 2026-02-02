import time
from parser import parse  # your parser

# Load transactions
transactions = parse()

# Build dictionary for fast lookup
transaction_dict = {t['id']: t for t in transactions}

# Pick the very last ID to prove the loop can go start-to-finish
target = data[-20]['id']

# Dictionary lookup function
def dict_lookup(transaction_dict, search_id):
    return transaction_dict.get(search_id, None)

# Test with 20 records
test_ids = [t['id'] for t in transactions[:20]]

print("Dictionary Lookup Results:\n")

for search_id in test_ids:
    start = time.time()
    result = dict_lookup(transaction_dict, search_id)
    end = time.time()
    print(f"ID {search_id}: Found={result is not None}, Time={end - start:.8f}s")
