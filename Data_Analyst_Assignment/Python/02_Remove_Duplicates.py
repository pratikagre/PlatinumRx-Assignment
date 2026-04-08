def remove_duplicates(input_string):
    """
    Removes all the duplicate characters from a string while preserving order.
    Uses a loop as per requirements.
    """
    unique_string = ""
    for char in input_string:
        if char not in unique_string:
            unique_string += char
            
    return unique_string

if __name__ == "__main__":
    # Test cases
    test_strings = [
        "programming",
        "hello world",
        "aabbccddeeff",
        "python",
        "abracadabra"
    ]
    
    for s in test_strings:
        print(f"Original: '{s}' -> Unique: '{remove_duplicates(s)}'")
