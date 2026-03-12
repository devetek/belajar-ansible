package main

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
)

type AnsibleIAC struct {
	Status  string `json:"status,omitempty"`
	Task    string `json:"task,omitempty"`
	Host    string `json:"host,omitempty"`
	File    string `json:"file,omitempty"`
	Stdout  string `json:"stdout,omitempty"`
	Stderr  string `json:"stderr,omitempty"`
	IACType string `json:"iac_type,omitempty"`
}

func main() {
	// init HTTP server
	r := http.NewServeMux()

	// handle incoming post request and print JSON body to console
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		rawBody, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Failed to read request body", http.StatusInternalServerError)
			return
		}
		log.Printf("Received raw JSON body: %s", string(rawBody))

		// 2. Close the original body
		r.Body.Close()

		// copy r.Body to var copyBody
		newBody := io.NopCloser(bytes.NewReader(rawBody))
		defer newBody.Close()

		// structed data from JSON body will be stored in ansibleIAC variable
		var ansibleIAC AnsibleIAC
		json.NewDecoder(newBody).Decode(&ansibleIAC)

		log.Println("ansibleIAC Host:", ansibleIAC.Host)
		log.Println("ansibleIAC Task:", ansibleIAC.Task)
		log.Println("ansibleIAC File:", ansibleIAC.File)
		log.Println("ansibleIAC Status:", ansibleIAC.Status)
		log.Println("ansibleIAC Stdout:", ansibleIAC.Stdout)
		log.Println("ansibleIAC Stderr:", ansibleIAC.Stderr)
		log.Println("ansibleIAC IACType:", ansibleIAC.IACType)
		// structed data from JSON body will be stored in ansibleIAC variable
	})

	log.Println("Starting server on :9000")
	if err := http.ListenAndServe(":9000", r); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
