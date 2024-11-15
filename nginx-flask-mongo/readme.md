image pushed to 

us-east1-docker.pkg.dev/entrevista123/flask-demo-app1/flask-demo-app1:latest
us-east1-docker.pkg.dev/entrevista123/node-redis-app/app:latest
us-east1-docker.pkg.dev/entrevista123/go-backend/app:latest
auth to google 

gcloud auth configure-docker us-east1-docker.pkg.dev

gcloud container clusters get-credentials elaniin-interview-dev     --region=europe-west1