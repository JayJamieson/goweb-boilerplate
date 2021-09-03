package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	environment := []string{
		"DB_HOST",
		"DB_PORT",
		"DB_USER",
		"DB_PASS",
		"REDIS_HOST",
		"REDIS_PORT",
		"REDIS_PORT",
		"ENVIRONMENT",
	}

	fmt.Println("goweb-boilerplate starting...")

	if os.Getenv("ENVIRONMENT") == "local" {
		for _, param := range environment {
			fmt.Printf("%v:%v\n", param, os.Getenv(param))
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "goweb-boilerplate...")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		for _, param := range environment {
			if os.Getenv(param) == "" {
				w.WriteHeader(500)
				fmt.Fprintf(w, "\"%v\" not set", param)
				return
			}
		}

		fmt.Fprint(w, "Good")
	})

	http.ListenAndServe(":8080", nil)
}
