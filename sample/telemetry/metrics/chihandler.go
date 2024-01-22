package metrics

import (
	"github.com/prodyna/kuka-training/sample/telemetry"
	"go.opentelemetry.io/otel/metric"
	"log/slog"
	"net/http"
)

type RequestCountHandler struct {
	Counter metric.Int64Counter
}

func NewRequestCountHandler() (*RequestCountHandler, error) {
	counter, err := telemetry.Meter().Int64Counter("sample_request_counter", metric.WithDescription("Request Counter"))
	if err != nil {
		return nil, err
	}
	return &RequestCountHandler{
		Counter: counter,
	}, nil
}

func (rch *RequestCountHandler) RequestCount(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		rch.Counter.Add(ctx, 1)
		slog.Info("Incrementing counter")
		next.ServeHTTP(rw, r.WithContext(ctx))
	})
}
