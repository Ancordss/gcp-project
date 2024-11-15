variable "namespace" {
  description = "Nombre del namespace"
  type        = string
  default     = "app3"
}

variable "configmap_name" {
  description = "Nombre del ConfigMap"
  type        = string
  default     = "nginx-config"
}

variable "deployment_name" {
  description = "Nombre del Deployment"
  type        = string
  default     = "proxy"
}

variable "service_name" {
  description = "Nombre del Service"
  type        = string
  default     = "proxy"
}

variable "hpa_name" {
  description = "Nombre del Horizontal Pod Autoscaler"
  type        = string
  default     = "proxy-hpa"
}

variable "replicas" {
  description = "Número inicial de réplicas del Deployment"
  type        = number
  default     = 1
}

variable "min_replicas" {
  description = "Número mínimo de réplicas para el HPA"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Número máximo de réplicas para el HPA"
  type        = number
  default     = 5
}

variable "image" {
  description = "Imagen del contenedor"
  type        = string
  default     = "nginx"
}

variable "cpu_requests" {
  description = "Cantidad de CPU solicitada por el contenedor"
  type        = string
  default     = "100m"
}

variable "memory_requests" {
  description = "Cantidad de memoria solicitada por el contenedor"
  type        = string
  default     = "128Mi"
}

variable "cpu_limits" {
  description = "Límite de CPU para el contenedor"
  type        = string
  default     = "500m"
}

variable "memory_limits" {
  description = "Límite de memoria para el contenedor"
  type        = string
  default     = "256Mi"
}

variable "loadbalancer_port" {
  description = "Puerto del servicio LoadBalancer"
  type        = number
  default     = 80
}
