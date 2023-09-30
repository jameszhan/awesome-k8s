## Install fastapi_poe

### Setup Python Env

```bash
$ conda create -n poe python=3.10

# To activate this environment, use
$ conda activate poe
# To deactivate an active environment, use
$ conda deactivate
```

### Sync Repository

```python
$ git clone git@github.com:jameszhan/fastapi_poe.git
$ cd fastapi_poe
$ git remote add upstream git@github.com:poe-platform/fastapi_poe.git
$ git fetch upstream
$ git checkout main
$ git merge upstream/main
$ git push origin main
```

### Install fastapi_poe by pip

```bash
$ python -m pip install .
```