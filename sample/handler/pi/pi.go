package pi

import "net/http"

func PiHandler(writer http.ResponseWriter, request *http.Request) {
	// json response with pi value and status 200
	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	writer.Write([]byte(`{"pi": 3.141592653589793}`))
}
