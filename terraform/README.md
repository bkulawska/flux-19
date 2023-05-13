Terraform config that will setup the EKS cluster on AWS using AWS Academy account. It assumes existence of resources such as vpc, subnets, routing and properly configured role on your AWS account (should work out of the box on the lab account).

Requirements:

- terraform cli
- aws cli
- kubectl

# How to run:

1. Start lab on AWS Acadamy and copy `AWS Details -> AWS CLI` (from lab panel) to `~/.aws/credentials`
2. Run `terraform init`
3. Run `terraform apply`, type `yes` when prompted
4. Once its finished (it will take over 12 minutes) run `./configure_kubectl.sh`

If everything went properly `kubectl get nodes` should print info about 2 running nodes.

When you are done using the cluster run `terraform destroy`, type `yes` when prompted.
