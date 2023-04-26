Terraform config that will setup the EKS cluster on AWS using AWS Academy account. It assumes existence of resources such as vpc, subnets, routing and properly configured role on your AWS account (should work out of the box on the lab account).

Requirements:

- terraform cli
- aws cli
- kubectl

# How to run:

1. Start lab on AWS Acadamy and copy `AWS Details -> AWS CLI` (from lab panel) to `~/.aws/credentials`
2. Run `terraform init`
3. Go to AWS IAM (from AWS gui) and copy `LabRole` arn, then run `terraform apply -var lab_role_arn="<your_arn_here>"`, type `yes` when prompted
4. Once its finished (it will take over 10 minutes) run `./configure_kubectl.sh`

If everything went properly `kubectl get nodes` should print info about 2 running nodes.

When you are done using the cluster run `terraform destroy -var lab_role_arn="<your_arn_here>"`, type `yes` when prompted.
