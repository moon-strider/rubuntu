#!/usr/bin/env python3
import threading
import rospy
import socket

from std_msgs.msg import String


FAILED = 'INFO: failed'
SUCCESS = 'INFO: success'


pub = rospy.Publisher('talker', String, queue_size=1)
threading.Thread(target=lambda: rospy.init_node('talker', disable_signals=True)).start()


def server():
    host = '0.0.0.0'
    port = 5000

    srv_socket = socket.socket()
    srv_socket.bind((host, port))
    srv_socket.listen(2) # dream and client
    conn, addr = srv_socket.accept()
    rospy.loginfo(f'new socket conn from {addr}')
    while True:
        data = conn.recv(1024).decode()
        if not data:
            break

        rospy.loginfo(f'recieved: {data}')

        if data in [FAILED, SUCCESS]:
            с

        # redirect data to ros and to client
        pub.publish(data)
        conn.sendall(data.encode())

    conn.close()


if __name__ == "__main__":
    server()