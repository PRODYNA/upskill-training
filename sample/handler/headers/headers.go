package headers

import (
	"encoding/json"
	"github.com/prodyna/upskill-training/sample/telemetry"
	"net/http"
	"strings"
)

type HeaderVar struct {
	Name  string
	Value string
}

// createEnvHandler creates a handler that returns the environment variables of the application as JSON structure
func HeadersHandler(writer http.ResponseWriter, request *http.Request) {
	_, span := telemetry.Tracer().Start(request.Context(), "HeadersHandler")
	defer span.End()

	headersVar := make([]HeaderVar, 0)
	for name, value := range request.Header {
		headersVar = append(headersVar, HeaderVar{Name: name, Value: strings.Join(value, ",")})
	}

	headersVarJson, _ := json.Marshal(headersVar)

	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write(headersVarJson)
}
