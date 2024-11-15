# Nombre del Namespace
variable "namespace_name" {
  description = "Nombre del namespace"
  type        = string
  default     = "app3"
}

# Nombre del Deployment
variable "deployment_name" {
  description = "Nombre del deployment"
  type        = string
  default     = "backend"
}

# Imagen del contenedor
variable "container_image" {
  description = "Imagen Docker para el backend"
  type        = string
  default     = "us-east1-docker.pkg.dev/entrevista123/go-backend/app:latest"
}

# Número de réplicas
variable "replicas" {
  description = "Número de réplicas para el deployment"
  type        = number
  default     = 1
}

# Puertos del contenedor
variable "container_port" {
  description = "Puerto expuesto por el contenedor"
  type        = number
  default     = 80
}

# Recursos del contenedor
variable "resource_requests" {
  description = "Recursos solicitados por el contenedor"
  type        = map(string)
  default     = {
    cpu    = "200m"
    memory = "256Mi"
  }
}

variable "resource_limits" {
  description = "Límites de recursos para el contenedor"
  type        = map(string)
  default     = {
    cpu    = "1"
    memory = "512Mi"
  }
}

# Configuración del HPA
variable "hpa_min_replicas" {
  description = "Número mínimo de réplicas para el HPA"
  type        = number
  default     = 1
}

variable "hpa_max_replicas" {
  description = "Número máximo de réplicas para el HPA"
  type        = number
  default     = 10
}

variable "hpa_cpu_utilization" {
  description = "Utilización promedio de CPU para el HPA"
  type        = number
  default     = 60
}

variable "hpa_memory_utilization" {
  description = "Utilización promedio de memoria para el HPA"
  type        = number
  default     = 60
}
