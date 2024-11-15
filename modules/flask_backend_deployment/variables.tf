variable "name" {}
variable "replicas" { default = 1 }
variable "image" {}
variable "port" {}
variable "flask_server_port" { default = "9091" }
# variable "cpu_requests" { default = "100m" }
# variable "cpu_limits" { default = "500m" }
variable "min_replicas" { default = 1 }
variable "max_replicas" { default = 5 }
variable "cpu_target_utilization" { default = 70 }
variable "backend_container_resources" {
  description = "Resource requests and limits for the backend container"
  type = object({
    requests = map(string)
    limits   = map(string)
  })
}
