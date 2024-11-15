

Repositorio para Levantar Infraestructura de Prueba
===================================================

Descripción
-----------

Este repositorio tiene como objetivo facilitar el despliegue de una infraestructura de prueba. Se ha utilizado **Google Cloud** para la nube y **Terraform** para la creación y configuración del cluster GKE. Además, se habilitó **Cloud Monitoring** para monitorear el entorno de manera eficiente.

Implementación
--------------

Se incluyeron varios archivos `yaml`, dos de los cuales fueron convertidos a **Terraform** para automatizar el despliegue. Sin embargo, un archivo quedó pendiente debido a limitaciones de tiempo, pero su implementación no debería requerir mucho esfuerzo adicional.

Este mini proyecto sigue las mejores prácticas recomendadas tanto para Kubernetes como para Terraform. Aunque no fue posible aplicar todas las prácticas debido a limitaciones de tiempo, se realizó el máximo esfuerzo por mantener la calidad en el desarrollo.

Monitoreo y Escalado
--------------------

La infraestructura incluye configuración de **HPA (Horizontal Pod Autoscaler)** y monitoreo centralizado en **Google Cloud Monitoring**. Los dashboards necesarios están marcados como favoritos en la consola de Google.

Dashboards en Cloud Monitoring
------------------------------

Los siguientes dashboards han sido configurados en Google Cloud Monitoring para facilitar la supervisión de la infraestructura. Los dashboards necesarios están marcados como favoritos en la consola de Google:

*   **KE Nodes and Pods - Cluster View** (Google Cloud Platform)
*   **Google Cloud Load Balancers** (Google Cloud Platform)
*   **Kubernetes Infrastructure Prometheus Overview** - Nov 14, 2024 6:51 PM (Custom)
*   **Logs Dashboard** (Google Cloud Platform)
*   **Total Request and 200vs 500**

Estos dashboards brindan una visión detallada del estado del cluster, balanceadores de carga, métricas de infraestructura de Kubernetes y registros, permitiendo un monitoreo eficiente y en tiempo real.

CI/CD
-----

Para CI/CD se utilizó **Google Cloud Build**, que está conectado a GitHub para ejecutar los pipelines respectivos. Cada proyecto cuenta con su pipeline, el cual incluye pruebas básicas de linteo y despliegue continuo.

Mejoras potenciales incluyen la incorporación de herramientas como **External Secrets** o **ArgoCD** para optimizar aún más la implementación.

Acceso
------

El acceso fue otorgado a los correos mencionados previamente. Para cualquier duda o consideración, no dudes en contactarme a través del correo: [maradiaga.l.james@gmail.com](mailto:maradiaga.l.james@gmail.com).

Requisitos
----------

*   Terraform
*   Cuenta en Google Cloud Console
*   Kubectl

Pasos para Levantar la Infraestructura
--------------------------------------

1.  Configura las variables necesarias en un archivo `var.tfvars`.
2.  Valida la configuración con `terraform validate`.
3.  Ejecuta:
    
    `terraform plan --out=tfplan`
    `terraform apply -var-file="var.tfvars"`
                        
    
4.  Terraform activará Cloud Monitoring y configurará el `kubeconfig` para que puedas conectarte al cluster Kubernetes. También desplegará los proyectos de Python y Go.
5.  Para el proyecto Node.js, navega a la carpeta `nginx-node-redis` y ejecuta:
    
    `kubectl apply -f redis.yaml`

    `kubectl apply -f web.yaml`

    `kubectl apply -f web2.yaml`

    `kubectl apply -f nginx.yaml`
                        
    

Una vez completado, prueba las aplicaciones utilizando los comandos descritos en la sección siguiente.

Pruebas
-------

### Primera Aplicación

`kubectl get services`

Obtén la IP externa del LoadBalancer y ejecuta:

`curl <EXTERNAL-IP>`

### Segunda Aplicación

`kubectl get services -n node-redis`

Obtén la IP externa del LoadBalancer y ejecuta:

`curl <EXTERNAL-IP>/web1/`
`curl <EXTERNAL-IP>/web2/`
            

### Tercera Aplicación

`kubectl get services -n app3`

Obtén la IP externa del LoadBalancer y ejecuta:

`curl <EXTERNAL-IP>`

Pruebas con el Deployment Actual
--------------------------------

### Primera Aplicación

`curl <EXTERNAL-IP>`

### Segunda Aplicación

`curl <EXTERNAL-IP>/web1/`
`curl <EXTERNAL-IP>/web2/`
            

### Tercera Aplicación

`curl <EXTERNAL-IP>`