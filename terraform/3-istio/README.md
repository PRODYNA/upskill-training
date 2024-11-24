# Istio add on with Bookinfo sample application

This step installs Istio with the Bookinfo sample application.

## Prerequisites

- You have completed the previous steps in this guide.
- You are connected to the cluster
- You have the 'tofu' command installed

## Steps

Run

```
tofu apply -auto-approve
```

This will install Istio and the Bookinfo sample application.

## Validation

### Istio and Kiali is installed

```
kubectl -n istio-system get pods
```

should show that the Istio and Kiali pods are running.

```
NAME                      READY   STATUS    RESTARTS   AGE
istiod-6c766c96fd-c997q   1/1     Running   0          62m
kiali-5cc586c4df-cwfnz    1/1     Running   0          62m
```

### Bookinfo application is installed

```
kubectl -n bookinfo get pods
```

should show that the Bookinfo pods are running.

```
NAME                                      READY   STATUS    RESTARTS   AGE
bookinfo-gateway-istio-7b46c6f4d4-g6v2s   1/1     Running   0          21s
details-v1-6cd6d9df6b-ccznm               2/2     Running   0          21s
productpage-v1-57ffb6658c-pxf4f           2/2     Running   0          21s
ratings-v1-794744f5fd-f55ks               2/2     Running   0          21s
reviews-v1-67896867f4-9ftjt               2/2     Running   0          21s
reviews-v2-86d5db4bd6-bdk7k               2/2     Running   0          21s
reviews-v3-77947c4c78-hdv4q               2/2     Running   0          21s
```

#### Ensure that the side is running

If the ready colum shows 1/1 instead of 2/2, then the pods needs to be restarted like this

```
kubectl -n bookinfo get pods | grep -v NAME | awk '{print $1}' | xargs kubectl -n bookinfo delete pod
```

### Find the IP and access the Bookinfo application

```
kubectl -n bookinfo get service
```

should show the external IP of the bookinfo-gateway-istio service.

```
bookinfo-gateway-istio   LoadBalancer   172.18.96.34     72.144.67.172   15021:30847/TCP,80:31970/TCP   67m
details                  ClusterIP      172.18.100.185   <none>          9080/TCP                       67m
productpage              ClusterIP      172.18.91.198    <none>          9080/TCP                       68m
ratings                  ClusterIP      172.18.54.116    <none>          9080/TCP                       67m
reviews                  ClusterIP      172.18.200.195   <none>          9080/TCP                       67m
```

Open this page in the browser:

```
http://<EXTERNAL-IP>/productpage
```

### Open the Kiali dashboard

```
kubectl -n istio-system port-forward service/kiali 20001
```

and open the URL

```
http://localhost:20001
```
