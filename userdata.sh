#!/bin/bash

yum update -y
yum install -y aws-cli

#Installing kubectl
curl -o /usr/local/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2021-06-11/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl

#bootstrapping
/etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name}
