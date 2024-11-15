# syntax=docker/dockerfile:1.4
FROM golang:1.18-alpine AS builder

WORKDIR /code

ENV CGO_ENABLED 0
ENV GOPATH /go
ENV GOCACHE /go-build

COPY go.mod go.sum ./
RUN go mod download

# Copiar todo el código fuente
COPY . .

# Construir la aplicación
RUN go build -o bin/backend main.go

CMD ["/code/bin/backend"]

FROM builder as dev-envs

RUN apk update

RUN addgroup -S docker && adduser -S --shell /bin/bash --ingroup docker vscode


# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["go", "run", "main.go"]

FROM scratch
COPY --from=builder /code/bin/backend /usr/local/bin/backend
CMD ["/usr/local/bin/backend"]
