package metrics

import (
	"github.com/prodyna/kuka-training/sample/telemetry"
	"go.opentelemetry.io/otel/metric"
)

var (
	PiCounter      metric.Int64Counter
	RequestCounter metric.Int64Counter
)

func Init() (err error) {
	meter := telemetry.Meter()

	PiCounter, err = meter.Int64Counter("sample_pi_caluclation", metric.WithDescription("Pi Counter"))
	if err != nil {
		return err
	}

	RequestCounter, err = meter.Int64Counter("sample_request counter", metric.WithDescription("Request Counter"))
	if err != nil {
		return err
	}
	return nil
}
