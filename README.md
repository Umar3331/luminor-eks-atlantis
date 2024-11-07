# Luminor EKS Atlantis Deployment

## Overview
This project sets up an Amazon EKS (Elastic Kubernetes Service) cluster integrated with Atlantis, a tool for Terraform pull request automation. The infrastructure is managed using Terraform, configuring an EKS cluster, IAM roles, security groups, VPC, subnets, and necessary setups for a production-ready Kubernetes environment. This README provides guidance on configuration, deployment, and usage.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [Usage Instructions](#usage-instructions)
- [Configuration Parameters](#configuration-parameters)
- [Outputs and Endpoints](#outputs-and-endpoints)
- [Testing and Validation](#testing-and-validation)
- [Troubleshooting](#troubleshooting)
- [Architecture Diagram](#architecture-diagram)
- [Best Practices and Security Considerations](#best-practices-and-security-considerations)
- [Contributing](#contributing)
- [Acknowledgments and References](#acknowledgments-and-references)

## Prerequisites

### System Requirements
- **OS**: Linux/macOS recommended for CLI compatibility.
- **Memory**: Minimum 8GB of RAM.
- **Disk Space**: Minimum 20GB free disk space.

### Tools and Dependencies
- **Terraform** v1.0 or higher – For infrastructure as code.
- **AWS CLI** v2 – For managing AWS resources.
- **kubectl** v1.21 or higher – For Kubernetes management.
- **Git** – For version control and repository management.

### Access and Permissions
- **AWS IAM user**: Requires permissions for EKS, IAM, and VPC management.
- **GitHub Access**: A GitHub token with repository access to enable Atlantis pull request automation.

## Installation and Setup

### Installation Steps

1. **Initialize Terraform**  
   Run `terraform init` to initialize the Terraform working directory. This downloads the required provider plugins and initializes modules.
   ```bash
   terraform init
   ```
2. Plan the Infrastructure
Run `terraform plan -var-file="secrets.tfvars"` to generate an execution plan. This step verifies if the configuration is valid and shows the actions that Terraform will take.
```bash
terraform plan -var-file="secrets.tfvars"
```
3. Deploy the Infrastructure
Run `terraform apply -var-file="secrets.tfvars"` to create the infrastructure on AWS. This command will prompt for confirmation before applying the changes.
```bash
terraform apply -var-file="secrets.tfvars"
```
### Secrets Management
Store sensitive information, such as AWS credentials and GitHub tokens, in environment variables or encrypted secret managers.
Use `.gitignore` to prevent sensitive files from being committed.

## Usage Instructions
### How to Deploy
1. Run the Terraform commands as described above in the Installation Steps.

2. After Deployment:

- Terraform output will display the external IP for Atlantis.
- Copy this DNS or external IP and paste it into your GitHub repository webhook URL.
- Add a webhook secret and configure the events you want to trigger Atlantis on (e.g., pull requests).
- After configuring the webhook, create a pull request in your repository to see Atlantis trigger a Terraform plan automatically.

## Configuration Parameters
The primary parameters defined in variables.tf are as follows:

- region: AWS region for deployment (default: "eu-north-1").
- cluster_name: Name of the EKS cluster (default: "luminor-cluster").
- vpc_cidr: CIDR block for the VPC (default: "10.0.0.0/16").
- private_subnets: CIDR blocks for private subnets (default: ["10.0.1.0/24", "10.0.2.0/24"]).
- public_subnets: CIDR blocks for public subnets (default: ["10.0.101.0/24", "10.0.102.0/24"]).
- desired_worker_count: Desired number of worker nodes (default: 1).
- max_worker_count: Maximum number of worker nodes (default: 2).
- These parameters allow customization of the EKS cluster's region, name, networking, and node count.

## Outputs and Endpoints
The following outputs are generated (from outputs.tf):

- EKS Cluster Endpoint (cluster_endpoint): The endpoint for accessing the EKS API server.
- EKS Cluster CA Data (cluster_certificate_authority_data): Certificate authority data required for authentication with the cluster.
- EKS Cluster ID (cluster_id): The unique ID for the EKS cluster.
- Atlantis External IP (atlantis_external_ip): The external IP address for the Atlantis service, used for GitHub webhooks.

## Testing and Validation
### Expected Results
1. Terraform Output: Displays the external IP or DNS for Atlantis. Use this IP to configure the GitHub webhook.
2. Set up Webhook
- Go to your GitHub repository and navigate to Settings > Webhooks.
- Add the DNS or external IP as the payload URL.
- Set the secret and specify events that should trigger Atlantis (e.g., pull requests).
3. Create a Pull Request
4. When you create a new pull request in your repository, Atlantis should automatically comment on the pull request with a Terraform plan, showing the changes it intends to make.

## Troubleshooting
### Common Issues
- Helm Release Fails: Ensure all prerequisites are met and that necessary permissions are granted.
- Service Account or IAM Role Issues: Verify that the IAM roles and Kubernetes service accounts are configured correctly and associated with the right permissions.

### Logs and Debugging
- Atlantis Logs: Use the following command to monitor Atlantis logs:
```bash
kubectl logs -f <atlantis-pod-name> -n atlantis
```
EKS Cluster Events:
```bash
kubectl get events -A
```
## Best Practices and Security Considerations
### Security Recommendations
- IAM Least Privilege: Ensure IAM roles and policies grant only the minimum required permissions.
- Secrets Management: Use a secret management tool or environment variables for storing sensitive data such as API tokens and credentials.
- Encryption: Enable encryption for sensitive resources and EKS volumes where applicable.
### Cost Optimization
- Use Spot Instances: Configure EKS node groups to use Spot Instances for cost savings.
- Enable Auto-scaling: Use auto-scaling to manage node group capacity based on demand.

## Coding Standards
- Use `terraform fmt` to format Terraform code.
- Follow naming conventions and structure for clarity and maintainability.
- Acknowledgments and References
- Acknowledgments

## References
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)  
- [Terraform Documentation](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)  
- [Atlantis Documentation](https://www.runatlantis.io/docs/deployment.html)
