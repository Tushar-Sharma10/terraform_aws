# **AWS + Terraform - VPC, EKS, and Kubernetes Deployment Project** 🚀

## **Project Overview**  
This project demonstrates how to use **Terraform** to automate the creation of a **VPC (Virtual Private Cloud)** and **EKS (Elastic Kubernetes Service)** cluster on **AWS**. Additionally, Kubernetes **deployment** and **service** configurations are managed with **Terraform** to automate the deployment of a sample application in the EKS cluster.

## **Objective**  
The objective of this project is to provision a secure and scalable AWS infrastructure using Terraform, deploy a Kubernetes cluster on EKS, and use Terraform's **deployment.tf** and **service.tf** files to manage the deployment and services in the Kubernetes cluster.

## **Technologies Used**  
- **AWS** (VPC, EKS, EC2)
- **Terraform** for Infrastructure as Code
- **Kubernetes** on AWS EKS

## **Project Details**

### **Infrastructure Components:**
- **VPC**: A custom **VPC** was created for the Kubernetes cluster with private and public subnets.
- **EKS (Elastic Kubernetes Service)**: A managed Kubernetes service on AWS used to run containerized applications.
- **EC2 Instances**: These instances are part of the EKS worker node group, where the containers run.
- **Security Groups**: Configured to control access to the EKS cluster and worker nodes.
- **IAM Roles**: Roles for managing the access control between Terraform and AWS services.

### **Terraform Files:**
- **vpc.tf**: Creates a custom VPC, subnets (public/private), internet gateway, and route tables.
- **eks.tf**: Provision an EKS cluster on AWS and configure the node groups to join the cluster.
- **deployment.tf**: Defines the **Kubernetes deployment** for deploying containerized applications in the EKS cluster.
- **service.tf**: Configures a **Kubernetes service** to expose the deployed application to the internet or within the cluster.

