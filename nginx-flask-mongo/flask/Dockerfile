# syntax=docker/dockerfile:1.4
FROM python:3.10-alpine AS builder


RUN  apk update

WORKDIR /src
COPY requirements.txt /src
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "server.py"]

FROM builder as dev-envs



RUN addgroup -S docker && adduser -S --shell /bin/bash --ingroup docker vscode

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["python3", "server.py"]
