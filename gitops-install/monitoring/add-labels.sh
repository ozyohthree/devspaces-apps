# Add folloiwing labels for monitoring

# 1 - Allow the in-cluster Prometheus instance to detect the ServiceMonitor in the OpenShift Dev Spaces namespace. The default OpenShift Dev Spaces namespace is openshift-devspaces. Verify metrics Administrator view -> Observe -> Metrics -> PromQL -> Run Query -> devworkspace_started_total  
oc label namespace openshift-devspaces openshift.io/cluster-monitoring=true

# 2 Add label for Dev Workspace Operator Dashboard configmap. Verify In the Administrator view -> Observe → Dashboards → Dev Workspace Operator
oc label configmap grafana-dashboard-dwo console.openshift.io/dashboard=true -n openshift-config-managed

# 3 Add label to devspaces grafana dashboard configmap
oc label configmap grafana-dashboard-devspaces-server console.openshift.io/dashboard=true -n openshift-config-managed





