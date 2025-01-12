set dotenv-load

@_default:
  just --list

# Prepare .env
bootstrap:
  @echo -n "Enter new project name: "
  @read name && sed -i "s/^name = \".*\"/name = \"$name\"/" pyproject.toml
  @echo -n "Enter new description: "
  @read description && sed -i "s/^description = \".*\"/description = \"$description\"/" pyproject.toml
  npm install
  uv sync
  cp .env.example .env
  .venv/bin/python manage.py generate_secret_key

# Django runserver
serve:
  python manage.py runserver

# Dev
dev:
  npx concurrently --names "tailwind,django" -c '#f0db4f,#4B8BBE' "npx @tailwindcss/cli -i static/input.css -o static/css/style.css -w" "python manage.py runserver"

# Build for production
build:
  npx @tailwindcss/cli -i static/input.css -o static/css/style.css -m
  python manage.py collectstatic --no-input
