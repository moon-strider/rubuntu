#!/usr/bin/env python3
import requests
import socket


def client():
    host = 'lnsigo.mipt.ru'
    port = 10000

    hostname = "$(hostname).local"
    endpoint = "move"
    method = "POST"
    headers = {}

    cl_socket = socket.socket()
    cl_socket.connect((host, port))

    print(f"connection initiated to {host}:{port}")

    while True:
        data = cl_socket.recv(1024).decode()
        print(f"Recieved: {data}")

        response = requests.request(method, f"http://{hostname}:5002/{endpoint}", headers=headers, data=data)
if __name__ == '__main__':
    client()