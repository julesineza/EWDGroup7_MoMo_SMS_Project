# Main for implementing data structure and algorithm and compare them
import time
from parser import parse

def momo_dsa():
    all_data = parse() # Getting all data from dictionary list
    
    # Compare efficiency for at least 20 records
    small_data = all_data[:20] 
    large_data = all_data
    
    def test_performance(data_set, label):
        target_id = data_set[-1]['id']
        
        # Linear Search
        start = time.perf_counter()
        for item in data_set:
            if item.get('id') == target_id:
                break
        lin_time = time.perf_counter() - start
        
        # Dictionary Lookup
        data_dict = {item['id']: item for item in data_set}
        start = time.perf_counter()
        data_dict.get(target_id)
        dict_time = time.perf_counter() - start
        
        print(f"--- {label} ({len(data_set)} records) ---")
        print(f"Linear Search: {lin_time:.8f}s")
        print(f"Dictionary: {dict_time:.8f}s")
        print(f"Speed Factor: {lin_time/dict_time:.2f}x faster\n")

    test_performance(small_data, "Small Scale Test")
    test_performance(large_data, "Full Scale Test")

if __name__ == "__main__":
    momo_dsa()
