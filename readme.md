
# MT4Docker

## Build Container

### Prerequisites
- Docker installed on your system
- Access to the Dockerfile in this directory

### Build Instructions

1. **Navigate to the project directory:**
    ```bash
    cd /D:/docketTrader/docker/MT4Docker
    ```

2. **Build the Docker image:**
    ```bash
    docker build --no-cache -t mt4-beq-auto:latest .
    ```

3. **Verify the build:**
    ```bash
    docker images | grep mt4-beq-auto
    ```

### Running the Container

```bash
docker run -d --name mt4-container mt4-beq-auto:latest <account> <password> <server>
```

**Example:**
```bash
docker run -d --name mt4_bot_200217359 mt4-beq-auto 200217359 mypassword ECMarketsLtd-Demo02
```

### Running with Python

```python
import subprocess

def start_mt4_container(account: str, password: str, server: str) -> str:
    container_name = f"mt4_bot_{account}"
    cmd = [
        "docker", "run", "-d",
        "--name", container_name,
        "mt4-beq-auto",
        account,
        password,
        server,
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"MT4 docker failed: {result.stderr.strip()}")
    return result.stdout.strip()
```

**Usage:**
```python
container_id = start_mt4_container("200217359", "mypassword", "ECMarketsLtd-Demo02")
print(f"Container started: {container_id}")
```

### Cappute image

```bash
import -display :99 -window root /app/screenshot.png
```

### Build Options

- **Tag with version:**
  ```bash
  docker build -t mt4-beq-auto:v1.0 .
  ```

- **Build with no cache:**
  ```bash
  docker build --no-cache -t mt4-beq-auto:latest .
  ```

### Troubleshooting

- Check Dockerfile syntax: `docker build --help`
- View build logs: `docker logs mt4-container`
- Inspect image details: `docker inspect mt4-beq-auto:latest`



