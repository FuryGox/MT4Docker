
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
    docker build -t mt4docker:latest .
    ```

3. **Verify the build:**
    ```bash
    docker images | grep mt4docker
    ```

### Running the Container

```bash
docker run -d --name mt4-container mt4docker:latest
```

### Cappute image

```bash
import -display :99 -window root /app/screenshot.png
```

### Build Options

- **Tag with version:**
  ```bash
  docker build -t mt4docker:v1.0 .
  ```

- **Build with no cache:**
  ```bash
  docker build --no-cache -t mt4docker:latest .
  ```

### Troubleshooting

- Check Dockerfile syntax: `docker build --help`
- View build logs: `docker logs mt4-container`
- Inspect image details: `docker inspect mt4docker:latest`
