

# # Añade el repositorio de Istio
# resource "helm_repository" "istio_repo" {
#   name = "istio"
#   url  = "https://istio-release.storage.googleapis.com/charts"
# }




# Instala el chart de Istio
resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  values     = [<<EOF
    gateways:
      istio-ingressgateway:
        enabled: true
  EOF
  ]
  depends_on = [helm_release.istiod]
}
