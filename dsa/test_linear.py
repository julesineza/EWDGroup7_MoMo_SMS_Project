# This test for linear search

import time
from parser import parse  # make sure parser_file.py is your parser

# Load transactions
transactions = parse()

# Linear search function
def linear_search(transactions, search_id):
    for t in transactions:
        if t['id'] == search_id:
            return t
    return None

# Test with 20 records (or fewer if your XML has less)
test_ids = [t['id'] for t in transactions[:20]]

print("Linear Search Results:\n")

for search_id in test_ids:
    start = time.time()
    result = linear_search(transactions, search_id)
    end = time.time()
    print(f"ID {search_id}: Found={result is not None}, Time={end - start:.8f}s")
