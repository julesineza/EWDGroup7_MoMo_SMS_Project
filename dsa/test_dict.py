# This search way is for using dictionary look up only

from parser import parse

data = parse()
# Create the dictionary
# We map the ID string to the whole dictionary object
data_dict = {item['id']: item for item in data}

# Pick the very last ID to prove the loop can go start-to-finish
target = data[-20]['id']

# Look up is instant O(1)
result = data_dict.get(target)

if result:
    print(f"SUCCESS: Dictionary found {target} instantly!")
    print(f"Data found: {result['sms']['body'][:100]}...") # Print a bit of the message
else:
    print(f"FAILURE: Dictionary is missing {target}.")
