# Dev Spaces Monitoring

## Collecting Dev Workspace Operator metrics with Prometheus

### Create ServiceMonitor for Dev Workspace Operator

[Openshift Documentation | Dev Spaces v3.23 ](https://docs.redhat.com/en/documentation/red_hat_openshift_dev_spaces/3.23/html-single/administration_guide/index#monitoring-the-dev-workspace-operator-proc_collecting-dev-workspace-operator-metrics-with-prometheus)

1. Create and apply the [ServiceMonitor](./devspaces-controller-sm.yaml).for the Dev Workspace Operator Note default namespace is ```openshift-devspaces```
2. Apply label to Dev Spaces namespace for Prometheus to detect the ServiceMonitor  
   ```bash
   oc label namespace openshift-devspaces openshift.io/cluster-monitoring=true
   ```
3. Validate In the Administrator view of the OpenShift web console, go to Observe → Metrics.

## Create Dashboard

1. Create configmap for dashboard defn in ```openshift-config-managed``` namespace and apply label

  ```bash
    oc create configmap grafana-dashboard-dwo \
    --from-literal=dwo-dashboard.json="$(curl https://raw.githubusercontent.com/devfile/devworkspace-operator/main/docs/grafana/openshift-console-dashboard.json)" \
    -n openshift-config-managed

    # add label to configmap
    oc label configmap grafana-dashboard-dwo console.openshift.io/dashboard=true -n openshift-config-managed
  ```
2. Verify In the Administrator view of the OpenShift web console, go to Observe → Dashboards → Dev Workspace Operator


## Monitoring Dev Spaces Server (JVM metrics)

### Enable and expose Dev Spaces Server Metrics

- Enable and expose Dev Spaces Server Metrics by configuring ```CheCluster``` CR 
  ```yaml
  spec:
  components:
    metrics:
      enable: <boolean> # true or false
  ```

##  Collecting OpenShift Dev Spaces Server metrics with Prometheus 

1. Create and apply the [ServiceMonitor](./devspaces-che-host-sm.yaml) for detecting  Dev Workspace Spaces JVM metrics service.
2. Create a [Role](./devspaces-prometheus-role.yaml) and [RoleBinding](./devspaces-prometheus-monitoring-rb.yaml) to allow Prometheus to view the metrics. Note default namespace is ```openshift-devspaces```
3. Apply label to Dev Spaces namespace for Prometheus to detect the ServiceMonitor  
   ```bash
   oc label namespace openshift-devspaces openshift.io/cluster-monitoring=true
   ```
4. Validate In the Administrator view of the OpenShift web console, go to Observe → Metrics.
5. Run a PromQL query to confirm that the metrics are available. For example, enter ```process_uptime_seconds{job="che-host"}``` and click Run queries.

### Create Dashboard
1. Create configmap
  ```bash
    oc create configmap grafana-dashboard-devspaces-server \
      --from-literal=devspaces-server-dashboard.json="$(curl https://raw.githubusercontent.com/eclipse-che/che-server/main/docs/grafana/openshift-console-dashboard.json)" \
      -n openshift-config-managed

    # add label to configmap
    oc label configmap grafana-dashboard-devspaces-server console.openshift.io/dashboard=true -n openshift-config-managed
  ```
2. Verify In the Administrator view of the OpenShift web console, go to Observe → Dashboards → Che Server JVM


