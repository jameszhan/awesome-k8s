# pip install fabric
# fab updatesystem

from fabric import Connection
from fabric import task

host_ip = '192.168.1.80'
# host_ip = '192.168.1.90'

@task
def updatesystem(cfg):
    """
    Update System.
    """
    print("cfg = ", cfg)
    c = Connection(host_ip, 'james')
    c.run('sudo apt -y upgrade', pty=True)
    c.run('sudo apt -y dist-upgrade', pty=True)
    c.run('sudo apt -y full-upgrade', pty=True)
    c.run('sudo apt -y autoremove', pty=True)
    c.run('sudo apt -y autoclean', pty=True)