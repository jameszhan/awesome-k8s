import socket

# def get_host_ip():
#     """
#     查询本机ip地址
#     :return: ip
#     """
#     try:
#         s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#         s.connect(('8.8.8.8', 80))
#         ip = s.getsockname()[0]
#     except Exception as e:
#         print("Ignore ", e)
#     finally:
#         s.close()

#     return ip

def get_host_ip():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.connect(('8.8.8.8', 80))
        return s.getsockname()[0]

if __name__ == '__main__':
    print(get_host_ip())
