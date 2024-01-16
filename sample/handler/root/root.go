package root

import "net/http"

func RootHandler(writer http.ResponseWriter, request *http.Request) {
	// json response with hello world and status 200
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	writer.Write([]byte(`{"message": "Hello, World!"}`))
}
