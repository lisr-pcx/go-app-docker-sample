# go-app-docker-sample

Example of GO application distributed via Docker container for education purpose.

## Setup development environment

> [!NOTE]
> Following steps have been executed on OS Windows 11, please adapt to your OS (online guides are available)

1. Install VS CODE [link](https://code.visualstudio.com/docs/setup/setup-overview)
2. Add specific extension for a better experience:
   + **Go** by Go Team at Google
   + **Docker** by Microsoft
3. Install GO language compiler and resources [link](https://go.dev/learn)
4. Install DOCKER DESKTOP [link](https://docs.docker.com/desktop/install/windows-install)

## Create application

Create a directory for the project, then open it via VS CODE.

Create **go.mod** file, in charge to manage dependencies:

```go
module example/fakeapi
go 1.23.1
```

Create a simple application managing:  
`HTTP REQUEST to "localhost:9000/"     > HTTP RESPONSE hello from LOCALHOST"`  
`HTTP REQUEST to "localhost:9000/time" > HTTP RESPONSE containing the current time inside JSON structure`

The application file is **app.go**

```go
package main

import (
	"encoding/json"
	"fmt"
	"html"
	"log"
	"net/http"
	"time"
)

type Time struct {
	CurrentTime string `json:"current_time"`
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from %q", html.EscapeString(r.URL.Path))
	})

	http.HandleFunc("/time", func(w http.ResponseWriter, r *http.Request) {
		ctime := []Time{
			{CurrentTime: time.Now().Format(http.TimeFormat)},
		}
		json.NewEncoder(w).Encode(ctime)
	})

	fmt.Println("Server is running at LOCALHOST port 9000")
	log.Fatal(http.ListenAndServe(":9000", nil))
}
```

## Create and run the container

Create a file named **Dockerfile** without any extension.

```yaml
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
```

Then build the container image via command (VS CODE terminal):  
`$ docker build --rm -t go-docker-app:alpha`

Check the list of available images:  
`$ docker image list`

Further information on build process [here](https://docs.docker.com/build)

Finally create and run (in detached mode `-d`) the container choosing the desired image:  
`$ docker run -d -p 7000:9000 --name test-app go-docker-app:alpha`

Check container status:  
`$ docker ps --all`

### Optimization

Containers must have a small footprint. Below few best practices.

+ **Use a minimal base image** lightweight distro as Alpine Linux can reduce the final size of the image and improve startup time.
+ **Leverage caching**:** order the instructions in the **Dockerfile** from least likely to change to most likely to change (avoid unnecessary rebuilds).
+ **Use multi-stage builds** Multi-stage builds allow you to create intermediate images during the build process, which can help reduce the size of the final image. This is especially useful when building applications with multiple build dependencies.
+ **Optimize layers** Each instruction in a **Dockerfile** creates a new layer in the image. Minimize the number of layers to reduce size and improve performance.
+ **Use .dockerignore**

## Resources

Information have been collected from other sites and tutorials.

[Learn Docker in 7 Easy Steps](https://youtu.be/gAkwW2tuIqE)  
[100+ Docker concepts you need to know](https://youtu.be/rIrNIzy6U_g)

[Developing GO apps with Docker](https://youtu.be/_0CpkisjPPM)  
[Create Docker container with GO App](https://youtu.be/C5y-14YFs_8)

[Mastering Dockerfile Composition](https://medium.com/@gauravkachariya/mastering-dockerfile-composition-a-comprehensive-guide-to-crafting-efficient-containerization-9cc967ad038c)