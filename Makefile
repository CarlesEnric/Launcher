COMPOSE := docker compose
CERTS_DIR := certs
CERT_CRT := $(CERTS_DIR)/server.crt
CERT_KEY := $(CERTS_DIR)/server.key

.PHONY: help up down build check backend-check frontend-check clean distclean fclean re certs logs

help:
	@printf '%s\n' \
		'Available targets:' \
		'  make up             Start backend and frontend with Docker Compose' \
		'  make down           Stop the stack' \
		'  make build          Build the Docker images' \
		'  make check          Run backend and frontend build checks in Docker' \
		'  make certs          Generate self-signed SSL certificates for development' \
		'  make clean          Remove frontend dist artifacts in Docker' \
		'  make distclean      Remove frontend/backend generated files' \
		'  make fclean         Remove generated files, images, volumes, and certs' \
		'  make re             Run fclean then up' \
		'  make logs           Follow container logs'

certs:
	@mkdir -p $(CERTS_DIR)
	@if [ ! -f $(CERT_CRT) ] || [ ! -f $(CERT_KEY) ]; then \
		echo "Generating self-signed certificates..."; \
		openssl req -x509 -newkey rsa:2048 -keyout $(CERT_KEY) -out $(CERT_CRT) \
			-days 365 -nodes -subj "/CN=localhost"; \
		echo "✓ Certificates generated in $(CERTS_DIR)/"; \
	else \
		echo "✓ Certificates already exist"; \
	fi

up: certs
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

backend-check:
	$(COMPOSE) run --rm backend python -m compileall app

frontend-check:
	$(COMPOSE) run --rm frontend sh -c "npm ci --no-audit --no-fund && npm run build"

check: backend-check frontend-check

clean:
	$(COMPOSE) run --rm frontend sh -c 'if [ -d dist ]; then rm -rf dist; fi'

distclean:
	$(COMPOSE) run --rm frontend sh -c 'if [ -d dist ]; then rm -rf dist; fi; if [ -d node_modules ]; then rm -rf node_modules; fi'
	$(COMPOSE) run --rm backend sh -c 'find app -type d -name "__pycache__" -prune -exec rm -rf {} +' || true

fclean:
	$(MAKE) distclean
	$(COMPOSE) down --rmi local --volumes --remove-orphans || true
	@rm -rf $(CERTS_DIR)
	@echo "✓ Certificates removed"

re: fclean up

logs:
	$(COMPOSE) logs -f