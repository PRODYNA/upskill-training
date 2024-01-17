package pi

import (
	"encoding/json"
	"github.com/go-chi/chi/v5"
	"math/big"
	"net/http"
	"runtime"
	"strconv"
	"sync"
	"time"
)

type PiResponse struct {
	CpuCores float64 `json:"cpu_cores"`
	Duration int     `json:"duration"`
}

func PiHandler(writer http.ResponseWriter, request *http.Request) {
	durationStr := chi.URLParam(request, "duration")
	duration, err := strconv.Atoi(durationStr)
	if err != nil || duration <= 0 {
		http.Error(writer, "Invalid value for 'duration'", http.StatusBadRequest)
		return
	}

	var wg sync.WaitGroup
	wg.Add(runtime.NumCPU())
	for i := 0; i < runtime.NumCPU(); i++ {
		go func() {
			defer wg.Done()
			calculatePiWithDuration(duration)
		}()
	}
	wg.Wait()

	response := &PiResponse{
		CpuCores: float64(runtime.NumCPU()),
		Duration: duration,
	}

	resonseJson, err := json.Marshal(response)
	if err != nil {
		http.Error(writer, "Error while marshalling response", http.StatusInternalServerError)
		return
	}

	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write(resonseJson)
}

func calculatePiWithDuration(duration int) {
	startTime := time.Now()

	for time.Since(startTime).Seconds() < float64(duration) {
		// Use the Nilakantha Somayaji series to approximate Pi
		result := new(big.Float).SetFloat64(3.0)
		sign := 1.0

		for i := 1; i <= 100000; i++ {
			term := new(big.Float).SetFloat64(1.0 / float64((2*i)*(2*i+1)*(2*i+2)))
			term.Mul(term, new(big.Float).SetFloat64(sign))
			result.Add(result, term)
			sign *= -1
		}

		pi := new(big.Float).SetFloat64(3.0)
		pi.Add(pi, result)

		// The result is not used; this is just to consume CPU resources
		_ = pi
	}
}
