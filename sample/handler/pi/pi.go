package pi

import (
	"context"
	"encoding/json"
	"github.com/go-chi/chi/v5"
	"github.com/prodyna/kuka-training/sample/telemetry"
	"go.opentelemetry.io/otel/metric"
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

type PiHandlerConfig struct {
	counter metric.Int64Counter
}

func NewPiConfig() (*PiHandlerConfig, error) {
	counter, err := telemetry.Meter().Int64Counter("sample_pi_counter", metric.WithDescription("Pi Counter"))
	if err != nil {
		return nil, err
	}
	return &PiHandlerConfig{
		counter: counter,
	}, nil
}

func (config *PiHandlerConfig) PiHandler(writer http.ResponseWriter, request *http.Request) {
	ctx, span := telemetry.Tracer().Start(request.Context(), "PiHandler")
	defer span.End()

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
			config.counter.Add(ctx, 1)
			calculatePiWithDuration(ctx, duration)
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

func calculatePiWithDuration(ctx context.Context, duration int) {
	ctx, span := telemetry.Tracer().Start(ctx, "calculatePiWithDuration")
	defer span.End()

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

	}
}
