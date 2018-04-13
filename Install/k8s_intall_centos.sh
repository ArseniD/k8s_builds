#!/bin/bash - 
#===============================================================================
#
#          FILE: k8s_intall_centos.sh
# 
#         USAGE: ./k8s_intall_centos.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Arseni Dudko (), 
#  ORGANIZATION: 
#       CREATED: 01/31/2018 12:37
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Up to root
sudo su

# If use swap take it off
swapoff -a

# Remove any references with swap
nano /etc/fstab
# comment out at the beginning of swap line, swap doesnt come up on next boot

# Update system
yum -y update

# Install docker
yum -y install docker

# Enable and start docker
systemctl enable docker && systemctl start docker

# Add kubernetes repo
cat < /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Disable selinux
setenforce 0

# Config selinux
nano /etc/selinux/config
# change from enforcing to permissive in order to allow docker and kunernetes their needs

# Install 3 picies
yum -y install kubelet kubeadm kubectl

# Enable service kubelet
systemctl enable kubelet && systemctl start kubelet

# Enable network to get working
cat <EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Check out that above changes take effect
sysctl --system

# Create kubernets cluster with flannel cni
kubeadm init --pod-network-cidr=10.244.0.0/16
# after above commad we get command to join other nodes

# Check out kubernetes cluster
exit
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Run kubectl
kubectl get pods --all-namespaces

# Install flannel cni
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# Check out flannel in a pods list as flannel deamon set (flannel-ds)
kubectl get pods --all-namespaces

# Check out kube master node
kubectl get nodes

# Next swith to the node and perform all above steps except kubeadm init
# As root join node to the kube master
# kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>


