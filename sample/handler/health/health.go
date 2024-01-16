package health

import (
	"encoding/json"
	"net/http"
)

type Status struct {
	Status string `json:"status"`
}

func HealthHandler(writer http.ResponseWriter, request *http.Request) {
	status := Status{Status: "OK"}
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
