import random
import time

def main():
    # Simulate light intensity data
    sensor_data = {
        'light_intensity': round(random.uniform(0.0, 1000.0), 2),  # Simulate light intensity in lux
    }
    
    return sensor_data
    
# Example usage
if __name__ == "__main__":
    for _ in range(5):
        data = main()
        print(data)
        time.sleep(1000)  # Simulate a delay between readings
