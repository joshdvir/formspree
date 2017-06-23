#! /bin/sh

if [ ! -f migration_error ]; then
  python manage.py db upgrade
  if [ $? -eq 0 ]; then
    gunicorn -w 3 --threads 10 -k gthread --timeout 240 --log-level debug -b 0.0.0.0:5000 formspree:forms_app
  else
    touch migration_error
    echo "migration failed"
    exit 1
  fi
else
  exit 1
fi