from hal import hal_keypad as keypad

def get_keypad_value():
    keypad.init()
    while True:
        temperature = keypad.getKey()
        if key is not None:
            return temperature