package root

import (
	"github.com/prodyna/kuka-training/sample/telemetry"
	"net/http"
)

func RootHandler(writer http.ResponseWriter, request *http.Request) {
	_, span := telemetry.Tracer().Start(request.Context(), "RootHandler")
	defer span.End()

	// json response with hello world and status 200
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	writer.Write([]byte(`{"message": "Hello, World!"}`))
}
