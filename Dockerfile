# # Basic image for the container
FROM golang:1.23.1

# # Set working directory inside the container
WORKDIR /app

# # Copy application files
COPY go.mod .
COPY *.go .

# # Install dependencies
RUN go mod download

# # Build application
RUN go build -o /application

# # Enable container network port
EXPOSE 9000

# # Run application
CMD [ "/application" ]