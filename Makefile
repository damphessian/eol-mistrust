# Default service/container name
SERVICE := app
CONTAINER := eol-mistrust

# Helpers
DOCKER_COMPOSE := docker-compose

.PHONY: build start stop shell notebook colima logs ps

# Build the Docker image
build:
	COMPOSE_BAKE=false $(DOCKER_COMPOSE) build

# Start the container(s) in the background
start: build
	$(DOCKER_COMPOSE) up -d

# Stop and remove containers, networks, etc.
stop:
	$(DOCKER_COMPOSE) down

# Open an interactive shell inside the app container
# Ensures build + start have happened first
shell: start
	$(DOCKER_COMPOSE) exec $(SERVICE) bash

# Run Jupyter Lab inside the container
# Ensures services are up before entering
notebook: start
	$(DOCKER_COMPOSE) exec $(SERVICE) \
		jupyter lab --ip=0.0.0.0 --no-browser --allow-root

# Start Colima with large resources (run ONLY on host machine)
colima:
	colima start --cpu 20 --memory 25

# View logs for debugging
logs:
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

# Show running containers
ps:
	$(DOCKER_COMPOSE) ps
