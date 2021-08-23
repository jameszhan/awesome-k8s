
```bash
$ cfssl genkey csr.json

$ cfssl genkey -initca csr.json | cfssljson -bare ca
```
