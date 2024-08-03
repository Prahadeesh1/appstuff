import time
import hal.hal_adc as hal_adc
import hal.hal_led as hal_led


def read_light_intensity():
    # Read light intensity from ADC channel 0 (connected to LDR)
    light_intensity = hal_adc.get_adc_value(0)
    return light_intensity


def main():
    hal_adc.init()
    hal_led.init()
    while True:
        light_intensity = read_light_intensity()
        print(f"Light Intensity: {light_intensity}")  # Display light intensity on console
        
        # Control LED based on light intensity
        if light_intensity < 500:  # Adjust the threshold
            hal_led.set_output(1, 1)
        else:
            hal_led.set_output(1, 0)
        
        # Wait before the next reading
        time.sleep(1)

if __name__ == "_main_":
    main()