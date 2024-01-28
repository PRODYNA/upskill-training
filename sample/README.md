# Sample application

This is a sample application developed in Go that exposes some HTTP services. It has the fowlloing endpoints

* /env: Prints some information about the environment, caution: This will also contain senstive information
* /health: Health endpoint to be used by Kubernetes probes, this endpoint should normally run on a dedicated port
* /pi/{number}: Runs a Pi calculation for {number} seconds to create some load. The purpose is to demonstrate the horizontal pod autoscaler (HPA)
* /metrics: Exposes some metrics in Prometheus compatible format

It is a true cloud native application due to the following facts:

* It starts quickly (just a few milliseconds)
* It logs in JSON format
* It can be configured freely using either parameters or environment variables
* It exposes a health endpoint that can be used to ensure that only load is put on a certain instance if it really able to handle it
* It shuts down cleanly on a SIGTERM or SIGINT
* It is stateless and can therefore run in any number of parallel instances which allows horizontal scaling. Parallel instances with stateful services is possible as well, but in that case the services need to take care of their state e.g. using a cache like Redis
* It exposes metrics using a Prometheus compatible interface. Note: Pusing Metrics using OpenTelemetry is the new preferred way.
* It exposes traces and metrics using OpenTelemetry, if configured to do so.

The following configuration options are possible.


| Parameter                | Enviroment variable    | Default value | Description                                                                                                         |
|--------------------------|------------------------|---------------|---------------------------------------------------------------------------------------------------------------------|
| --port                   | PORT                   | 8000          | The port where the service slistens to                                                                              |
| --verbose                | VERBOSE                |               | The verbosity for logging (not used currently)                                                                      |
| --usage                  |                        |               | Prints usage information                                                                                            |
| --logformat              | LOGFORMAT              | text          | Defines the logging format as text (with color) or JSON. Allowed values are text or json.                           |
| --opentelemetry-endpoint | OPENTELEMETRY_ENDPOINT |               | Defines a gRPC endpoint for sending traces and metrics, usually port 4317. It not defined, this feature is diabled. |
