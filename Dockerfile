# Example using multi-stage
FROM golang:1.23.1 AS start_build
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY *.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o /opt/go-docker-multistage
RUN go build -o /application

# Final stage
FROM alpine:latest
COPY --from=start_build /opt/go-docker-multistage /opt/go-docker-multistage
EXPOSE 9000
ENTRYPOINT [ "/opt/go-docker-multistage" ]