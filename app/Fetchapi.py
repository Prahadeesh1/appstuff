from flask import Flask, jsonify
import Light_intensity as Light
app = Flask(__name__)
@app.route('/sensor_data', methods=['GET'])
def get_sensor_data():
    sensor_data = {
        'temperature':30,        # Fixed temperature value
        'ph_level': 60,            # Fixed pH level value
        'humidity': 20,           # Fixed relative humidity value
        'light_intensity': Light.main(),     # Fixed light intensity value
        'ec_level': 50,            # Fixed EC level value
    }
    return jsonify(sensor_data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


