def convert_minutes(minutes):
    """
    Given number of minutes, converts it into human readable form (hours and minutes).
    Example: 130 becomes "2 hrs 10 minutes"
    """
    if minutes < 0:
        return "Invalid input. Minutes cannot be negative."

    hours = minutes // 60
    remaining_minutes = minutes % 60
    
    # Handling pluralization for better readability
    hr_str = "hr" if hours == 1 else "hrs"
    min_str = "minute" if remaining_minutes == 1 else "minutes"
    
    if hours > 0 and remaining_minutes > 0:
        return f"{hours} {hr_str} {remaining_minutes} {min_str}"
    elif hours > 0:
        return f"{hours} {hr_str}"
    else:
        return f"{remaining_minutes} {min_str}"

if __name__ == "__main__":
    # Test cases
    test_values = [130, 110, 60, 45, 0]
    for val in test_values:
        print(f"{val} becomes \"{convert_minutes(val)}\"")
