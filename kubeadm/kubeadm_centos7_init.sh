#!/bin/bash
hostnamectl set-hostname 'k8s-master'

setenforce 0 ← put SULinux to permissive mode
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

modprobe br_netfilter 

cat <<EOF >  /etc/sysctl.d/kube.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system



cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF


yum update -y && yum upgrade && yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl start docker kubelet && systemctl enable docker kubelet

echo "#########################Kubeadm INIT#####################################"
echo "Kubeadm init for Calico: kubeadm init --pod-network-cidr=192.168.0.0/16"
echo "Kubeadm init for Flannel: kubeadm init --pod-network-cidr=10.244.0.0/"


echo "#############################CNI##########################################"
#calico
echo "#######################Apply Calico CNI###################"
echo "kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml"
echo "kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml"


#flannel:
echo "#######################Apply Flannel CNI##################"
echo "sysctl net.bridge.bridge-nf-call-iptables=1"
echo "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
