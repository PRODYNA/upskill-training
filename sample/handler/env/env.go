package env

import (
	"context"
	"encoding/json"
	"github.com/prodyna/kuka-training/sample/telemetry"
	"net/http"
	"os"
	"strings"
)

type EnvVar struct {
	Name  string
	Value string
}

func GetEnvironmentVariables(ctx context.Context) (envVar []EnvVar) {
	ctx, span := telemetry.Tracer().Start(ctx, "GetEnvironmentVariables")
	defer span.End()

	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		envVar = append(envVar, EnvVar{Name: pair[0], Value: pair[1]})
	}
	return
}

func EnvHandler(writer http.ResponseWriter, request *http.Request) {
	ctx, span := telemetry.Tracer().Start(request.Context(), "EnvHandler")
	defer span.End()

	envVars := GetEnvironmentVariables(ctx)
	envVarsJson, err := json.Marshal(envVars)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusInternalServerError)
		return
	}
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write(envVarsJson)
}
