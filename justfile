set dotenv-load

@_default:
  just --list

# Prepare .env
bootstrap:
  @echo -n "Enter new project name: "
  @read name && sed -i "s/^name = \".*\"/name = \"$name\"/" pyproject.toml
  @echo -n "Enter new description: "
  @read description && sed -i "s/^description = \".*\"/description = \"$description\"/" pyproject.toml
  uv sync
  cp .env.example .env
  .venv/bin/python manage.py generate_secret_key
  .venv/bin/python manage.py tailwind install

# Django runserver
serve:
  python manage.py runserver

# Dev
dev:
  bunx concurrently --names "tailwind,django" -c '#f0db4f,#4B8BBE' "python manage.py tailwind start" "python manage.py runserver"

# Build for production
build:
  python manage.py tailwind build
  python manage.py collectstatic --no-input
