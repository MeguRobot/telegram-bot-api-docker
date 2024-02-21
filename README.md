# telegram-bot-api-docker

This repository provides a Docker image for running a Telegram bot API on latest Alpine Linux 3.18.

## Setup

### Prerequisites
Make sure you have Docker and Compose installed on your system before following the steps below.

### Setup Steps
1. **Create a telegram-bot-api volume:**
    ```sh
    docker volume create --name telegram-bot-api
    ```
2. **Run the container using Docker Compose:**

   Create a `docker-compose.yml` file with the following content:

   ```yaml
   version: "3.9"
   
   services:
     telegram-bot-api:
       container_name: telegram-bot-api
       image: megurobot/telegram-bot-api:latest
       ports:
         - "8081:8081"
         - "8082:8082"
       environment:
         USER_UID: 101
         USER_GID: 101
         HTTP_PORT: 8081
         STAT_PORT: 8082
         TELEGRAM_API_ID: 12345
         TELEGRAM_API_HASH: abcdefghijklmnopqrstuvwyz123456789
         TELEGRAM_LOG_FILE: /var/log/telegram-bot-api.log
         TELEGRAM_STAT: true
         TELEGRAM_LOCAL: true
         TELEGRAM_VERBOSITY: 1
       volumes:
         - telegram-bot-api:/var/lib/telegram-bot-api
    
    volumes:
      telegram-bot-api:
        name: telegram-bot-api
        external: true
   ```
   Adjust the port mappings and environment variables as needed.

2. **Run the Docker Compose:**
   ```bash
   docker-compose up -d
   ```

## Environment Variables

- `USER_UID`: (Optional) UID of the telegram-bot-api user (default: 101)
- `USER_GID`: (Optional) GID of the telegram-bot-api group (default: 101)
- `HTTP_PORT`: (Optional) HTTP port for the API (default: 8081)
- `STAT_PORT`: (Optional) HTTP stats port (default: 8082)
- `TELEGRAM_LOG_FILE`: (Optional) Path to the Telegram Bot API log file
- `TELEGRAM_STAT`: (Optional) Enable HTTP stats (true/false)
- `TELEGRAM_LOCAL`: (Optinal) Enable local data storage (true/false)
- `TELEGRAM_FILTER`: (Optional) Filter for Telegram Bot API updates
- `TELEGRAM_MAX_WEBHOOK_CONNECTIONS`: (Optional) Maximum number of webhook connections
- `TELEGRAM_VERBOSITY`: (Optional) Verbosity level of the Telegram Bot API logs
- `TELEGRAM_MAX_CONNECTIONS`: (Optional) Maximum number of Telegram Bot API connections
- `TELEGRAM_PROXY`: (Optional) Proxy configuration for the Telegram Bot API
- `TELEGRAM_HTTP_IP_ADDRESS`: (Optional) HTTP IP address for the Telegram Bot API
