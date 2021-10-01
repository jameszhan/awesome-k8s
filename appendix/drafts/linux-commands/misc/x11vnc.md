

```bash
$ sudo apt -y install x11vnc

$ x11vnc -storepasswd
$ sudo x11vnc -forever -shared -rfbauth ~/.vnc/passwd
```