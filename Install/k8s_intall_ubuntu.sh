#!/bin/bash -
#===============================================================================
#
#          FILE: k8s_intall_ubuntu.sh
# 
#         USAGE: ./k8s_intall_ubuntu.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Arseni Dudko (), 
#  ORGANIZATION: 
#       CREATED: 01/31/2018 12:05
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Swith to root
sudo -i
# Install docker
apt install -y docker.io

# Ensure that we use the same systemd driver
cat <<EOF >> /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# Check link
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add sources
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Grap new sources
apt update

# Install 3 pieces of kubernetes
apt install -y kubelet kubeadm kubectl

# Init kubeadm in order to use flannel cni
kubeadm init --pod-network-cidr=10.244.0.0/16
# After above-mentioned command you will get command how to join machine to kube-master

# Check out kubernetes cluster
exit
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Give self onwership to the file
sudo chown $(id -u):$$(id -h) $HOME/.kube/config

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


