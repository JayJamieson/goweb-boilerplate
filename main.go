package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	environment := []string{
		"GW_DB_HOST",
		"GW_DB_PORT",
		"GW_DB_USER",
		"GW_DB_PASS",
		"GW_REDIS_HOST",
		"GW_REDIS_PORT",
		"GW_ENV",
	}

	fmt.Println("goweb-boilerplate starting....")

	if os.Getenv("GW_ENV") == "local" {
		for _, param := range environment {
			fmt.Printf("%v:%v\n", param, os.Getenv(param))
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "goweb-boilerplate...")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		for _, param := range environment {
			if os.Getenv(param) == "" && os.Getenv("GW_ENV") != "local" {
				w.WriteHeader(500)
				fmt.Fprintf(w, "\"%v\" not set", param)
				return
			}
		}

		fmt.Fprint(w, "Ok")
	})

	http.ListenAndServe(":8080", nil)
}
