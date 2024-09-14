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
