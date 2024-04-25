package health

import (
	"encoding/json"
	"github.com/prodyna/upskill-training/sample/meta"
	"net/http"
)

type Status struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Status  string `json:"status"`
}

func HealthHandler(writer http.ResponseWriter, request *http.Request) {
	status := Status{
		Name:    meta.Name,
		Version: meta.Version,
		Status:  "OK",
	}
	statusJson, err := json.Marshal(status)
	if err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		http.Error(writer, err.Error(), http.StatusInternalServerError)
		return
	}
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write(statusJson)
}
