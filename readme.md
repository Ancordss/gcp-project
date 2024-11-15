  README - Test Infrastructure

Repository for Setting Up Test Infrastructure
=============================================

Description
-----------

This repository is aimed at facilitating the deployment of a test infrastructure. **Google Cloud** has been used for the cloud, and **Terraform** for creating and configuring the GKE cluster. Additionally, **Cloud Monitoring** was enabled for efficient environment monitoring.

Implementation
--------------

Several `yaml` files were included, two of which were converted to **Terraform** to automate the deployment. However, one file remained pending due to time constraints, but its implementation should not require much additional effort.

This mini-project follows the best practices recommended for both Kubernetes and Terraform. Although not all practices could be applied due to time limitations, every effort was made to maintain high development quality.

Monitoring and Scaling
----------------------

The infrastructure includes configuration for **HPA (Horizontal Pod Autoscaler)** and centralized monitoring using **Google Cloud Monitoring**. The necessary dashboards are favorited in the Google console.

Dashboards in Cloud Monitoring
------------------------------

The following dashboards have been configured in Google Cloud Monitoring to facilitate infrastructure supervision. The necessary dashboards are favorited in the Google console:

*   **KE Nodes and Pods - Cluster View** (Google Cloud Platform)
*   **Google Cloud Load Balancers** (Google Cloud Platform)
*   **Kubernetes Infrastructure Prometheus Overview** - Nov 14, 2024 6:51 PM (Custom)
*   **Logs Dashboard** (Google Cloud Platform)
*   **Total Request and 200vs 500**

These dashboards provide a detailed view of the cluster's status, load balancers, Kubernetes infrastructure metrics, and logs, enabling efficient real-time monitoring.

CI/CD
-----

**Google Cloud Build** was used for CI/CD, connected to GitHub to run the respective pipelines. Each project has its own pipeline, which includes basic linting and continuous deployment.

Potential improvements include incorporating tools like **External Secrets** or **ArgoCD** to further optimize the implementation.

Access
------

Access was granted to the previously mentioned email addresses. For any questions or considerations, feel free to contact me at: [maradiaga.l.james@gmail.com](mailto:maradiaga.l.james@gmail.com).

Requirements
------------

*   Terraform
*   Google Cloud Console account
*   Kubectl

Steps to Set Up the Infrastructure
----------------------------------

1.  Configure the necessary variables in a `var.tfvars` file.
2.  Validate the configuration with `terraform validate`.
3.  Run:
    
    `terraform plan --out=tfplan`
    `terraform apply -var-file="var.tfvars"`
                        
    
4.  Terraform will enable Cloud Monitoring and configure the `kubeconfig` file so you can connect to the Kubernetes cluster. It will also deploy Python and Go projects.
5.  For the Node.js project, navigate to the `nginx-node-redis` folder and run:
    
    `kubectl apply -f redis.yaml`

    `kubectl apply -f web.yaml`

    `kubectl apply -f web2.yaml`
    
    `kubectl apply -f nginx.yaml`
                        
    

Once completed, test the applications using the commands described in the next section.

Testing
-------

### First Application

`kubectl get services`

Get the external IP of the LoadBalancer and execute:

`curl <EXTERNAL-IP>`

### Second Application

`kubectl get services -n node-redis`

Get the external IP of the LoadBalancer and execute:

`curl <EXTERNAL-IP>/web1/`
`curl <EXTERNAL-IP>/web2/`
            

### Third Application

`kubectl get services -n app3`

Get the external IP of the LoadBalancer and execute:

`curl <EXTERNAL-IP>`

Testing with the Current Deployment
-----------------------------------

### First Application

`curl 34.22.228.145`

### Second Application

`curl 23.251.131.255/web1/`
`curl 23.251.131.255/web2/`
            

### Third Application

`curl 34.78.50.126`

### You can find this readme on spanish in the infra folder