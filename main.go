package main

import (
	"fmt"
	"net/http"
)

func main() {
	fmt.Println("goweb-boilerplate...")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "goweb-boilerplate...")
	})

	http.ListenAndServe(":8080", nil)
}
