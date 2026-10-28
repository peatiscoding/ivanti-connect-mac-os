package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
)

const listenAddr = "127.0.0.1:7492"

type response struct {
	OK      bool   `json:"ok"`
	Message string `json:"message"`
}

var (
	mu        sync.Mutex
	scriptDir string
)

func connectHandler(w http.ResponseWriter, r *http.Request) {
	totp := r.URL.Query().Get("totp")
	if totp == "" {
		writeJSON(w, http.StatusBadRequest, response{OK: false, Message: "missing totp parameter"})
		return
	}

	mu.Lock()
	defer mu.Unlock()

	scriptPath := filepath.Join(scriptDir, "auto-connect.applescript")
	cmd := exec.Command("/usr/bin/osascript", scriptPath, totp)
	out, err := cmd.CombinedOutput()
	if err != nil {
		writeJSON(w, http.StatusInternalServerError, response{OK: false, Message: fmt.Sprintf("%s: %s", err, out)})
		return
	}

	writeJSON(w, http.StatusOK, response{OK: true, Message: string(out)})
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, response{OK: true, Message: "running"})
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}

func main() {
	exe, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}
	scriptDir = filepath.Dir(exe)

	// Allow override via env for development
	if d := os.Getenv("SCRIPT_DIR"); d != "" {
		scriptDir = d
	}

	http.HandleFunc("/connect", connectHandler)
	http.HandleFunc("/health", healthHandler)

	log.Printf("listening on %s (scripts: %s)", listenAddr, scriptDir)
	log.Fatal(http.ListenAndServe(listenAddr, nil))
}
