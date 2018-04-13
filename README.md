## Building Kubernetes 

This repo contains kubernetes install scripts and various useful builds for self-learning

### Prerequisites

Go to the Install directory and run bash script as root user on you system (CentOS/Ubuntu)

```
$ sudo ./k8s_intall_centos.sh
```

Next swith to the node and perform all kubernetes installation steps except kubeadm init
As root join node to the kube master

```
$ kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash> 
```

### Installing

In order to create a kubernetes object from a YAML file specify a path to desirable file

```
$ kubectl create -f FILENAME
```

And check it out in depends on kind of object you want to create (pod/deployment/service/pv/rc and etc.)

```
$ kubectl get pods
```

or if it deployment

```
$ kubectl get deployments
```

or if it service

```
$ kubectl get services
```



