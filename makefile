run:
	echo -n "[entrevista123]" | base64
	echo -n "[us-east1]" | base64
	echo -n "[us-east1-docker.pkg.dev]" | base64


configure:
	k apply -f config-artifact-secret.yaml

deploy:
	k apply -f mongo-deployment.yaml
	k apply -f backend-deployment.yaml
	k apply -f web-deployment.yaml