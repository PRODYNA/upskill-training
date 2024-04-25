package root

import (
	_ "embed"
	"github.com/prodyna/upskill-training/sample/telemetry"
	"net/http"
)

var (
	//go:embed index.html
	indexHtml []byte
)

func RootHandler(writer http.ResponseWriter, request *http.Request) {
	_, span := telemetry.Tracer().Start(request.Context(), "RootHandler")
	defer span.End()

	writer.Header().Set("Content-Type", "text/html")
	writer.WriteHeader(http.StatusOK)
	writer.Write(indexHtml)
}
