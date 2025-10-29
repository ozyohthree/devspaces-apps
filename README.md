# devspaces-apps
Config files and apps for the DevSpaces quick courses

1. Order Order AWS with OpenShift Open Environment with m6a.4xlarge
2. Update cert, tokens etc on local machine and login as kubeadmin
3. Add regular Users and authentication (admin,userN)
```bash
oc replace -f ocp-auth/authentication.yaml
oc apply -f ocp-auth/secret.yaml
```
4. Delete previous devspaces installs
```bash
dsc server:delete --delete-all --delete-namespace -n openshift-devspaces
```
5. Install with OpenShift GitOps
```bash
oc apply -f gitops-config/devspaces/00-devspaces-operator-cli.yaml
# extract user 'admin' password 
oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-
# add cluster-admin role to ArgoCD
oc adm policy add-cluster-role-to-user cluster-admin \
system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller
# Apply configuration to create argocd application
oc apply -f gitops-install/devspaces-argo-app.yaml
```

## ADD Github OAuth Org
1. Create new [Oauth App](https://github.com/settings/applications/new)
2. Use: 
  - Homepage URL: <openshift_dev_spaces_url>
  - Authorization callback URL: https://<openshift_dev_spaces_url>/api/oauth/callback
3. Create secret and apply secret

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: github-oauth-config
  namespace: openshift-devspaces
  labels:
    app.kubernetes.io/part-of: che.eclipse.org
    app.kubernetes.io/component: oauth-scm-configuration
  annotations:
    che.eclipse.org/oauth-scm-server: github
    che.eclipse.org/scm-server-endpoint: https://github.com
    che.eclipse.org/scm-github-disable-subdomain-isolation: 'false'
type: Opaque
stringData:
  id: <GitHub_OAuth_Client_ID>
  secret: <GitHub_OAuth_Client_Secret>c

```



