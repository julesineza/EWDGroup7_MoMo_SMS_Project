import time

from parser import parse  

transactions = parse()

transaction_dict = {t['id']: t for t in transactions}

#  Linear Search function
def linear_search(transactions, search_id):
    for t in transactions:
        if t['id'] == search_id:
            return t
    return None

#  Dictionary Lookup function
def dict_lookup(transaction_dict, search_id):
    return transaction_dict.get(search_id, None)

#  Testing with 20 records
test_ids = [t['id'] for t in transactions[:20]]

print("Comparing search times for 20 records...\n")

for search_id in test_ids:
    # Linear search
    start = time.time()
    linear_search(transactions, search_id)
    linear_time = time.time() - start

    # Dictionary lookup
    start = time.time()
    dict_lookup(transaction_dict, search_id)
    dict_time = time.time() - start

    print(f"Searching ID {search_id}: Linear={linear_time:.8f}s, Dictionary={dict_time:.8f}s")

# 6. Reflection
print("\nReflection:")
print("So this is our findings according to your questions")
print("Why is dictionary lookup faster than linear search?")
print("Dictionary lookup is faster because it uses a hash table internally, allowing direct access by key (O(1)) instead of scanning each element (O(n)).")
print("Can you suggest another data structure or algorithm that could improve search efficiency?")
print("Another data structure that could improve search efficiency for large datasets is a balanced binary search tree (like AVL or Red-Black tree) or using a database index.")

