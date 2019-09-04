#!/bin/bash
#Installing dependecies, kubeadm, kubelet and kubectl
apt-get update && apt-get install -y mc ebtables ethtool docker.io apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update && apt-get install -y kubelet kubeadm kubectl


#restart kubelet
echo "########################Restart KUBELET#######################"
systemctl daemon-reload
systemctl restart kubelet

echo "########Check docker,kubectl,kubeadm,kubelet versions#########"
docker -v
kubectl version
kubeadm version
kubelet --version


echo "#########################Kubeadm INIT#####################################"
echo "Kubeadm init for Calico: kubeadm init --pod-network-cidr=192.168.0.0/16"
echo "Kubeadm init for Flannel: kubeadm init --pod-network-cidr=10.244.0.0/16"


echo "#############################CNI##########################################"
#calico
echo "#######################Apply Calico CNI###################"
echo "kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml"
echo "kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml"


#flannel:
echo "#######################Apply Flannel CNI##################"
echo "sysctl net.bridge.bridge-nf-call-iptables=1"
echo "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

