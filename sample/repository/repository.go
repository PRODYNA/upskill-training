package repository

import (
	"github.com/go-redis/redis/v8"
	"log/slog"
)

const prefix = "sample"

type Config struct {
	Enabled  bool
	Endpoint string
	client   *redis.Client
}

func (c *Config) Connect() (err error) {
	if c.Enabled {
		c.client = redis.NewClient(&redis.Options{
			Addr: c.Endpoint,
			DB:   0,
		})
		if _, err = c.client.Ping(c.client.Context()).Result(); err != nil {
			return err
		}
	}
	return nil
}

func (c *Config) Disconnect() (err error) {
	if c.Enabled {
		err = c.client.Close()
		if err != nil {
			slog.Error("Failed to disconnect from redis", "error", err)
		}
		return err
	}
	return nil
}
