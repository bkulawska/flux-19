# Flux-19

## Project created for the Environment of Services Implementation course, 8th semester, academic year 2022/2023

## Authors

- Barbara Kulawska ([@bkulawska](https://github.com/bkulawska))
- Joanna Fortuna ([@Yoanka](https://github.com/Yoanka))
- Hubert Czader ([@HubertCzader](https://github.com/HubertCzader))
- Szymon Stępień ([@Fl0k3n](https://github.com/Fl0k3n))

## Contents list

1. [Introduction](#1-introduction)
2. [Theoretical background](#2-theoretical-background)
3. [Case study concept description](#3-case-study-concept-description)
4. [Solution architecture](#4-solution-architecture)
5. [Environment configuration description](#5-environment-configuration-description)
6. [Installation method](#6-installation-method)
7. [How to reproduce - step by step](#7-how-to-reproduce---step-by-step)
8. [Demo deployment steps](#8-demo-deployment-steps)
9. [Summary – conclusions](#9-summary--conclusions)
10. [References](#10-references)

## 1. Introduction

The aim of this project is to conduct a brief analysis of GitOps technologies and then create a system based on these technologies. The project will utilize the Kubernetes environment to automatically update applications according to the GitOps approach. To achieve this, the Flux tool will be used to deploy and automatically manage application infrastructure in the considered environment. The project will be focused on presenting a practical example with a step-by-step reproduction guide.

## 2. Theoretical background

### GitOps

GitOps is a modern approach to software delivery that emphasizes the use of version control and continuous delivery for managing infrastructure and applications<sup>[[1]](#1-httpswwwatlassiancomgittutorialsgitops)</sup>.

GitOps works particularly well with Kubernetes, which is an open-source container orchestration platform that automates many aspects of deploying, scaling, and managing containerized applications. By using GitOps with Kubernetes, organizations can benefit from the declarative infrastructure model that Kubernetes provides, as well as the ability to manage application configuration and deployment using Git.

This approach can help teams move faster, reduce errors, and increase agility by enabling them to manage their infrastructure and applications as code.

Additionally, GitOps makes it easier to enforce best practices and security policies, since all changes to the infrastructure and applications are made through pull requests that are subject to code review and approval.

### Flux

Flux is an open-source tool that enables GitOps workflows for Kubernetes. It works by synchronizing Kubernetes cluster state with a Git repository, making it easy to manage and automate deployments, rollbacks, and other changes to Kubernetes infrastructure<sup>[[2]](#2-httpsfluxcdiofluxconcepts)</sup>.

With Flux, developers can declare their desired state in a Git repository, and Flux will ensure that the Kubernetes cluster matches that state. This means that infrastructure changes can be versioned, audited, and automated in a way that is scalable and reliable.

The main functionalities of Flux include:

- GitOps synchronization and automated deployment - state of a cluster is declared in a git repository and is automatically updated when repositotory content changes. Its easy to see in what state the cluster currently is and what is deployed, we just need to check the main branch of a git repository.
- Rollback and recovery - all it takes to rollback an update is to revert the state of a git repository, Flux will automatically restore old cluster state.
- Image automation - Flux supports automatic image updates, ensuring that the application always runs on the latest version of the container image, this is particularly useful if we have CI/CD pipelines that build, test and push such images automatically.
- Notifications - Flux can send notifications about cluster state changes to platforms such as Discord or Slack.
- Enhanced security - thanks to the pull model of Flux we don't need to give a cluster administrator level access to CI/CD pipelines that would normally push those changes to the cluster.

---

### How does Flux work?

First we need to install it in the cluster, this process is called bootstrapping and can be performed using the Flux CLI. Once installation is finished we can see that Flux created a couple of controllers<sup>[[3]](#3-httpsfluxcdiofluxflux-e2e)</sup>, most importantly:

- **Source Controller** - agent responsible for pulling Commit data (kubernetes manifests such as deployments or services) into the cluster.
- **Kustomize Controller** - agent responsible for reconciling the cluster state with the desired state as defined by Commit manifests retrieved through Source controller.
- **Image Reflector Controller** and **Image Automation Controller** - agents responsible for monitoring image repositories (e.g. DockerHub) and reflecting image metadata in Kubernetes resources.
- **Notification Controller** - agent responsible for handling notifications.

Figure below illustrates one of the functionallities outlined before - image automation<sup>[[4]](#4-httpsanaisurlcomfull-tutorial-getting-started-with-flux-cd)</sup>.

<img src="images/flux-image-update-to-git.png">

The more important steps include:

- User pushes a new version of a docker image (either manually or through CI/CD pipeline).
- Flux detects that the image tag has changed.
- Flux updates relevant Kubernetes manifests (by changing image version in respective deployment files) and applies those changes to the git repository automatically.
- Flux reconciles the state of the cluster with the desired state of the git repository - in this case it just updates the application.

It works similarly if we update the git repository manually, Flux will detect those changes and reflect them in the cluster.

## 3. Case study concept description

In our project, we will focus on demonstrating the Flux tool by using it to perform GitOps on an examplatory application.

1. **Set up a Kubernetes cluster**: First, we need to have a Kubernetes cluster set up. To do so, we are going to use Amazon Web Services as our cloud provider. We will use our free lab account which has about `100$` resources to spend and configure the cluster automatically with terraform.

2. **Install Flux on the cluster**: Once we have a Kubernetes cluster, the next step is to install Flux. We're going to do this by following the installation guide on the Flux website.

3. **Add examplatory application code to the GitHub repository**: In the next step, in this existing repository that we have here, we are going to add our examplatory application code.

4. **Configure Flux to use the GitHub repository**: Once we have a GitHub repository with application code, we need to configure Flux to use the repository. To do this, we need to create a GitRepository custom resource in Kubernetes that contains the details of the GitHub repository. This will be done using kubectl or by writing a YAML file and applying it to the cluster.

5. **Add manifests to the GitHub repository**: With Flux configured to use the GitHub repository, we can start adding manifests to the repository. These manifests will define the resources that make up the application, such as deployments, services, and ingresses. We might use tools like kustomize or Helm to generate these manifests.

6. **Deploy the application**: With the manifests in the GitHub repository, Flux will automatically deploy the application to the Kubernetes cluster. Whenever we make changes to the manifests in the GitHub repository, Flux will automatically update the deployment to reflect the changes.

7. **Make changes to the repository**: Now, we will test if the Flux is working correctly. We will make some changes to application; those changes can include updating manifests, adding new resources, or making changes to existing files. Then we will commit and push those changes back to the repository.

8. **Wait for Flux to pick up changes**: Once we push the changes to the repository, we will need to wait for Flux to pick up the changes. Flux typically checks the repository for changes every few minutes, so it may take a few minutes for the changes to be detected.

9. **Check if the changes have been applied**: Finally, we will check the Flux logs and the state of the cluster to see if the changes have been applied.

## 4. Solution architecture

The project involves implementing a system solution using Flux and a Kubernetes cluster on AWS, using the GitOps approach. The system architecture consists of several components, including AWS Kubernetes Cluster, GitOps, Elastic Kubernetes Service (EKS), AWS CloudFormation, Docker, Kubernetes, Git repository, Continuous Integration and Delivery (CI/CD) and AWS CloudWatch. Below is a description of each element of architecture: 

- A Kubernetes cluster will be created on AWS, where Flux will act as a GitOps tool. As a result, the state of the cluster will be defined by the Git repository, and Flux will monitor the Git repositories and automatically update the application code.

- Elastic Kubernetes Service (EKS) offered by AWS will be used to create and manage the clusters. 

- AWS CloudFormation will be used to automatically deploy the Kubernetes cluster on AWS.

- Docker will be used to containerize the applications, which will allow them to be isolated from the network and operating system. Kubernetes will serve as the container orchestrator, enabling automation of deployment, scaling, and management of applications in containers.

- The Git repository will be used to store the application code and cluster configuration definitions. A CI/CD pipeline will be installed in the Kubernetes cluster on AWS, allowing Flux to automatically detect changes in the Git repository and update the applications in the cluster.

- AWS CloudWatch will be used to monitor the state of the Kubernetes cluster and applications.

With this system solution, Flux will automatically update the application code to the current state, and AWS will be used to create and manage clusters and monitor applications. The CI/CD pipeline will be used to automate the process of updating applications in the cluster, and Flux will be used to manage the applications in the Kubernetes cluster.

## 5. Environment configuration description

The cluster will be running on AWS, specifically we will configure Amazon EKS (Elastic Kubernetes Service). EKS is a fully-managed container orchestration service that makes it easy to deploy, manage, and scale containerized applications using Kubernetes on Amazon Web Services (AWS). EKS will automatically run and manage infrastructure across multiple availability zones to ensure high availability.

We will use terraform<sup>[[5]](#5-httpsdeveloperhashicorpcomterraformtutorialsaws-get-startedinstall-cli)</sup> tool to create and configure the cluster automatically. It will have to be installed on our local machines.

Our lab account lets us use resources in the `us-east-1` region, so we will choose the following availability zones:

- `us-east-1a`
- `us-east-1b`
- `us-east-1c`

EKS requires at least 2 different availabiliy zones to work. Note that it's recommended to use the region that is geographically closest to the users.

We will also need to configure AWS node groups, which are an abstraction over EC2 instances that supply compute capacity to the cluster. To do that we will need to specify typical EC2 options such as AMI type (Virtual Machine Image), instance types (which define machine resources such as vCPU and RAM amount), and disk size.

EKS creates and manages Kubernetes control plane out of the box so we don't have to worry about that.

Our example will use a simple application that doesn't require much computing resources, so we will pick:

- AMI - `Amazon Linux 2`
- instance type - `t3.medium` - which has 2 vCPUs and 4GB of RAM
- disk size - `20GB` - as this will be enough for all Kubernetes dependencies and our Docker image

Additionaly, we will need to configure node group scaling options, for this demonstration a tiny cluster with 2 nodes should suffice.

To access the newly created cluster we will need to install `aws cli`<sup>[[6]](#6-httpsdocsawsamazoncomclilatestuserguidegetting-started-installhtml)</sup> and `kubectl`<sup><sup>[[7]](#7-httpskubernetesiodocstaskstoolsinstall-kubectl-linux)</sup></sup> locally. Obviously, `flux cli`<sup>[[8]](#8-httpsfluxcdiofluxinstallation)</sup> will have to be installed locally too.

Containers that run our example web application will be run by Flux once all of the configuration is finished. EKS will automatically create security groups (firewall rules) that will allow public access to our application (more specifically, to the load balancer that will forward traffic to our containers), access to other cluster resources will be blocked.

## 6. Installation method

## 7. How to reproduce - step by step

### 7.1 Infrastructure as Code approach

## 8. Demo deployment steps

### 8.1. Configuration set-up

### 8.2. Data preparation

### 8.3. Execution procedure

### 8.4. Results presentation

## 9. Summary – conclusions

## 10. References
###### [1] https://www.atlassian.com/git/tutorials/gitops
###### [2] https://fluxcd.io/flux/concepts/
###### [3] https://fluxcd.io/flux/flux-e2e/
###### [4] https://anaisurl.com/full-tutorial-getting-started-with-flux-cd/
###### [5] https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
###### [6] https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
###### [7] https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
###### [8] https://fluxcd.io/flux/installation/

