# Launcher Accessibility — PoC

Una prova de concepte d’un launcher accessible amb:
- frontend en React + Vite
- backend en FastAPI
- gateway Nginx amb HTTPS

## Arrencar

```bash
make up
```

Després obre `https://localhost` al navegador.

## Comprovar

```bash
make check
curl -k https://localhost/health
curl -k https://localhost/api/apps/
```
