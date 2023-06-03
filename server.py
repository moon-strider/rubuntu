#!/usr/bin/env python3
import threading
import rospy
import json

from std_msgs.msg import String
from flask import Flask, request
from flask import jsonify


app = Flask(__name__)

talker = rospy.Publisher('talker', String, queue_size=1)

threading.Thread(target=lambda: rospy.init_node('listener', disable_signals=True)).start()

@app.route('/command', methods = ['POST'])
def upload_response():
    data = str(json.loads(request.get_data()).get("text"))
    talker.publish(data)
    return jsonify({"status": "ok"})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)