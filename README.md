Luminor EKS Atlantis Deployment
Overview
This project sets up an Amazon EKS (Elastic Kubernetes Service) cluster integrated with Atlantis, a tool for Terraform pull request automation. The infrastructure is managed using Terraform, setting up an EKS cluster, IAM roles, security groups, VPC, subnets, and necessary configurations for a production-ready Kubernetes environment. This README provides clear guidance on configuration, deployment, and usage.

Table of Contents
Prerequisites
Installation and Setup
Usage Instructions
Configuration Parameters
Outputs and Endpoints
Testing and Validation
Troubleshooting
Architecture Diagram
Best Practices and Security Considerations
Contributing
Acknowledgments and References
Prerequisites
System Requirements
OS: Linux/macOS recommended for compatibility with CLI tools.
Memory: Minimum 8GB of RAM.
Disk Space: Minimum of 20GB free disk space.
Tools and Dependencies
Terraform v1.0 or higher - For infrastructure as code.
AWS CLI v2 - For managing AWS resources.
kubectl v1.21 or higher - For Kubernetes management.
Git - For version control and repository management.
Access and Permissions
AWS IAM user: Requires permissions for EKS, IAM, and VPC management.
GitHub Access: A GitHub token with repository access to enable Atlantis pull request automation.
Installation and Setup
Installation Steps
Initialize Terraform:

Run terraform init to initialize the Terraform working directory. This downloads the required provider plugins and initializes modules.
bash
Copy code
terraform init
Plan the Infrastructure:

Run terraform plan -var-file="secrets.tfvars" to generate an execution plan. This step verifies if the configuration is valid and shows the actions that Terraform will take.
bash
Copy code
terraform plan -var-file="secrets.tfvars"
Deploy the Infrastructure:

Run terraform apply -var-file="secrets.tfvars" to create the infrastructure on AWS. This command will prompt for confirmation before applying the changes.
bash
Copy code
terraform apply -var-file="secrets.tfvars"
Secrets Management
Store sensitive information, such as AWS credentials and GitHub tokens, in environment variables or encrypted secret managers.
Use .gitignore to prevent sensitive files from being committed.
Usage Instructions
How to Deploy
Run Terraform Commands as described above in the Installation Steps.
After Deployment:
Terraform output will display the external IP for Atlantis.
Copy this DNS or external IP and paste it into your GitHub repository webhook URL.
Add a webhook secret and configure the events you want to trigger Atlantis on (e.g., pull requests).
After configuring the webhook, create a pull request in your repository to see Atlantis trigger a Terraform plan automatically.
Configuration Parameters
The primary parameters defined in variables.tf are as follows:

region: AWS region for deployment (default: "eu-north-1").
cluster_name: Name of the EKS cluster (default: "luminor-cluster").
vpc_cidr: CIDR block for the VPC (default: "10.0.0.0/16").
private_subnets: CIDR blocks for private subnets (default: ["10.0.1.0/24", "10.0.2.0/24"]).
public_subnets: CIDR blocks for public subnets (default: ["10.0.101.0/24", "10.0.102.0/24"]).
desired_worker_count: Desired number of worker nodes (default: 1).
max_worker_count: Maximum number of worker nodes (default: 2).
These parameters allow customization of the EKS cluster's region, name, networking, and node count.

Outputs and Endpoints
Based on outputs.tf, the following outputs are generated:

EKS Cluster Endpoint (cluster_endpoint): The endpoint for accessing the EKS API server.
EKS Cluster CA Data (cluster_certificate_authority_data): Certificate authority data required to authenticate with the cluster.
EKS Cluster ID (cluster_id): The unique ID for the EKS cluster.
Atlantis External IP (atlantis_external_ip): The external IP address for the Atlantis service, which can be used in GitHub webhooks.
Testing and Validation
Expected Results
Terraform Output: The Terraform output will display the external IP or DNS for Atlantis. Use this IP to configure the GitHub webhook.
Set up Webhook:
Go to your GitHub repository, navigate to Settings > Webhooks, and add the DNS or external IP as the payload URL.
Set the secret and specify events that should trigger Atlantis (e.g., pull requests).
Create a Pull Request:
Create a new pull request in your repository. Atlantis should automatically comment on the pull request with a Terraform plan, showing the changes it intends to make.
Troubleshooting
Common Issues
Helm Release Fails: If you encounter Helm-related errors, ensure all prerequisites are met and that necessary permissions are granted.
Service Account or IAM Role Issues: Verify that the IAM roles and Kubernetes service accounts are correctly configured and associated with the right permissions.
Logs and Debugging
Atlantis Logs: To monitor Atlantis, use the following command to view logs:
bash
Copy code
kubectl logs -f <atlantis-pod-name> -n atlantis
EKS Cluster Events:
bash
Copy code
kubectl get events -A
Architecture Diagram
Include a visual diagram illustrating:

The EKS cluster with public and private subnets.
Atlantis setup and its integration with GitHub for pull request automation.
AWS resources like VPC, IAM roles, security groups, and Load Balancers.
Add your architecture diagram here.

Best Practices and Security Considerations
Security Recommendations
IAM Least Privilege: Ensure IAM roles and policies grant only the minimum required permissions.
Secrets Management: Use a secret management tool or environment variables for storing sensitive data such as API tokens and credentials.
Encryption: Enable encryption for sensitive resources and EKS volumes where applicable.
Cost Optimization
Use Spot Instances: Configure EKS node groups to use Spot Instances for cost savings.
Enable Auto-scaling: Use auto-scaling to manage node group capacity based on demand.
Contributing
Contribution Guidelines
Fork the repository and create a feature branch for your changes.
Submit a pull request describing your changes in detail.
Follow code formatting standards and use terraform fmt before committing code.
Coding Standards
Use terraform fmt to format Terraform code.
Follow naming conventions and structure for clarity and maintainability.
Acknowledgments and References
Acknowledgments
Thanks to all contributors and the open-source community for the development of tools and modules used in this project.

References
AWS EKS Documentation
Terraform Documentation
Atlantis Documentation
