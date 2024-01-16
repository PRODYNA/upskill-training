package env

import (
	"encoding/json"
	"net/http"
	"os"
	"strings"
)

type EnvVar struct {
	Name  string
	Value string
}

func GetEnvironmentVariables() (envVar []EnvVar) {
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		envVar = append(envVar, EnvVar{Name: pair[0], Value: pair[1]})
	}
	return
}

func EnvHandler(writer http.ResponseWriter, request *http.Request) {
	envVars := GetEnvironmentVariables()
	envVarsJson, err := json.Marshal(envVars)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusInternalServerError)
		return
	}
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write(envVarsJson)
}
