package logging

import (
	"github.com/lmittmann/tint"
	"log/slog"
	"os"
)

type LoggerConfig struct {
	JSON bool
}

func (config LoggerConfig) ConfigureDefaultLogger() {

	if config.JSON {
		defaultLogger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
		slog.SetDefault(defaultLogger)
	} else {
		defaultLogger := slog.New(tint.NewHandler(os.Stdout, nil))
		slog.SetDefault(defaultLogger)
	}

}
