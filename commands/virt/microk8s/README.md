## [MicroK8s](https://ubuntu.com/blog/deploying-kubernetes-locally-microk8s)你应该知道的一切

#### MicroK8s Add-ons

- DNS: Deploy DNS. This add-on may be required by others, thus we recommend you always enable it.
- Dashboard: Deploy Kubernetes dashboard as well as Grafana and influxdb.
- Cilium: Leverage enhanced networking features, including Kubernetes NetworkPolicy powerful pod-to-pod connectivity management and service load balancing between pods through Cilium.
- Helm: allows you to manage, update, share and rollback Kubernetes applications.
- Storage: Create a default storage class. This storage class makes use of the hostpath-provisioner pointing to a directory on the host.
- Ingress: Create an ingress controller.
- GPU: Expose GPU(s) to MicroK8s by enabling the nvidia-docker runtime and nvidia-device-plugin-daemonset. Requires NVIDIA drivers to be already installed on the host system.
- Istio: Deploy the core Istio services. You can use the microk8s istioctl command to manage your deployments.
- Knative: Knative serving, eventing, monitoring for your MicroK8s.
- Registry: Deploy a Docker private registry and expose it on localhost:32000. The storage add-on will be enabled as part of this.
- Ambassador: Ambassador API Gateway and Ingress
- Fluentd: Elasticsearch-Fluentd-Kibana logging and monitoring
- ha-cluster: Configure high availability on the current node
- host-access: Allow Pods connecting to Host services smoothly
- jaeger: Kubernetes Jaeger operator with its simple config
- keda: Kubernetes-based Event Driven Autoscaling
- kubeflow: Kubeflow for easy ML deployments
- linkerd: Linkerd is a service mesh for Kubernetes and other frameworks
- metallb: Loadbalancer for your Kubernetes cluster
- metrics-server: K8s Metrics Server for API access to service metrics
- multus: Multus CNI enables attaching multiple network interfaces to pods
- OpenEBS: OpenEBS is the open-source storage solution for Kubernetes
- OpenFaaS: openfaas serverless framework
- Portainer: Portainer UI for your Kubernetes cluster
- Prometheus: Prometheus operator for monitoring and logging
- RBAC: Role-Based Access Control for authorisation
- traefik: traefik Ingress controller for external access


#### Best of breed

| Enterprise    | Platforms | Networking | Usability  | Built-in    |
| ------------- | --------- | ---------- | ---------- | ----------- |
| Clustering    | Windows   | CoreDNS    | Dashboard  | Registry    |
| Auto-updating | macOS     | Ingress    | Prometheus | Knative     |
| Confinement   | Intel     | Istio      | Fluentd    | Kubeflow    |
| Storage       | ARM       | Linkerd    | Jaeger     | GPU support |