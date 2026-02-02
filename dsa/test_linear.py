# This for search using linear method only

from parser import parse

def linear_search(data_list, target_id):
    for item in data_list:
        # We must access the 'id' key in the dictionary
        if item.get('id') == target_id:
            return item
    return None

data = parse()
# Pick the very last ID to prove the loop can go start-to-finish
target = data[-1]['id'] 

result = linear_search(data, target)

if result:
    print(f"SUCCESS: Linear Search found {target}!")
    print(f"Data found: {result['sms']['body'][:100]}...") # Print a bit of the message
else:
    print(f"FAILURE: Linear Search could not find {target}.")

