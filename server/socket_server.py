#!/usr/bin/env python3
import threading
import rospy
import socket

from std_msgs.msg import String


FAILED = 'INFO: failed'
SUCCESS = 'INFO: success'

NUM_CONNECTED = 0


pub = rospy.Publisher('talker', String, queue_size=1)
threading.Thread(target=lambda: rospy.init_node('talker', disable_signals=True)).start()


def count_connections(f: function):
    global NUM_CONNECTED
    NUM_CONNECTED += 1
    f()
    NUM_CONNECTED -= 1


@count_connections
def on_new_client(client_socket, addr, num):                # dream MUST be connected to the server earlier than the client
    while True:
        data = client_socket.recv(1024).decode('utf-8')

        if not data:
            break

        rospy.loginfo(f'recieved: {data}')
        print(f"{addr} >> {data}")

        pub.publish(data)
        client_socket.sendall(data.encode())

    client_socket.close()
    print(f'connection lost on {addr}')


def main():
    host = '0.0.0.0'                                        # allow any incoming connections
    port = 5000
    s = socket.socket()
    s.bind((host, port))                                    # bind to the port
    s.listen(2)                                             # wait for client connection
    while True:
        conn, addr = s.accept()                             # establish connection with client
        print(f'new connection from {addr}, id={NUM_CONNECTED+1}')
        threading.Thread(target=on_new_client, args=(conn, addr)).start()
    s.close()


if __name__ == '__main__':
    main()