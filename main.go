package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	fmt.Println("goweb-boilerplate starting...")

	containerParams := []string{
		"DB_HOST",
		"DB_PORT",
		"DB_USER",
		"DB_PASS",
		"REDIS_HOST",
		"REDIS_PORT",
		"REDIS_PORT",
		"ENVIRONMENT",
	}

	if os.Getenv("ENVIRONMENT") == "local" {
		for _, param := range containerParams {
			fmt.Printf("%v:%v\n", param, os.Getenv(param))
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "goweb-boilerplate...")
	})

	http.ListenAndServe(":8080", nil)
}
