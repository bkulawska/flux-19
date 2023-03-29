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

The aim of this project is to conduct a thorough analysis of GitOps technologies and then create a system based on these technologies. The project will utilize the Kubernetes environment to automatically update applications according to the GitOps approach. To achieve this, the Flux tool will be used to deploy and automatically manage application infrastructure in the considered environment. 

The main goal of the project is to develop and implement a system that will automatically update applications based on detected changes in the Git repository while ensuring secure management of the application infrastructure.

## 2. Theoretical background

### GitOps

GitOps is a modern approach to software delivery that emphasizes the use of version control and continuous delivery for managing infrastructure and applications.

GitOps works particularly well with Kubernetes, which is an open-source container orchestration platform that automates many aspects of deploying, scaling, and managing containerized applications. By using GitOps with Kubernetes, organizations can benefit from the declarative infrastructure model that Kubernetes provides, as well as the ability to manage application configuration and deployment using Git.

This approach can help teams move faster, reduce errors, and increase agility by enabling them to manage their infrastructure and applications as code.

Additionally, GitOps makes it easier to enforce best practices and security policies, since all changes to the infrastructure and applications are made through pull requests that are subject to code review and approval.

### Flux

Flux is an open-source tool that enables GitOps workflows for Kubernetes. It works by synchronizing Kubernetes cluster state with a Git repository, making it easy to manage and automate deployments, rollbacks, and other changes to Kubernetes infrastructure.

With Flux, developers can declare their desired state in a Git repository, and Flux will ensure that the Kubernetes cluster matches that state. This means that infrastructure changes can be versioned, audited, and automated in a way that is scalable and reliable.

The main functionalities of Flux include:

- GitOps synchronization and automated deployment - state of a cluster is declared in a git repository and is automatically updated when repositotory content changes. Its easy to see in what state the cluster currently is and what is deployed, we just need to check the main branch of a git repository.
- Rollback and recovery - all it takes to rollback an update is to revert the state of a git repository, Flux will automatically restore old cluster state.
- Image automation - Flux supports automatic image updates, ensuring that the application always runs on the latest version of the container image, this is particularly useful if we have CI/CD pipelines that build, test and push such images automatically.
- Notifications - Flux can send notifications about cluster state changes to platforms such as Discord or Slack.
- Enhanced security - thanks to the pull model of Flux we don't need to give a cluster administrator level access to CI/CD pipelines that would normally push those changes to the cluster.

---

### How does Flux work?

First we need to install it in the cluster, this process is called bootstrapping and can be performed using the flux CLI. Once installation is finished we can see that flux created a couple of controllers, most importantly:

- **Source Controller** - agent responsible for pulling Commit data (kubernetes manifests such as deployments or services) into the cluster.
- **Kustomize Controller** - agent responsible for reconciling the cluster state with the desired state as defined by Commit manifests retrieved through Source controller.
- **Image Reflector Controller** and **Image Automation Controller** - agents responsible for monitoring image repositories (e.g. DockerHub) and reflecting image metadata in Kubernetes resources.
- **Notification Controller** - agent responsible for handling notifications.

Figure below illustrates one of the functionallities outlined before - image automation.

<img src="images/flux-image-update-to-git.png">

The more important steps include:

- User pushes a new version of a docker image (either manually or through CI/CD pipeline).
- Flux detects that the image tag has changed.
- Flux updates relevant Kubernetes manifests (by changing image version in respective deployment files) and applies those changes to the git repository automatically.
- Flux reconciles the state of the cluster with the desired state of the git repository - in this case it just updates the application.

It works similarly if we update the git repository manually, Flux will detect those changes and reflect them in the cluster.

## 3. Case study concept description

In our project, we will focus on demonstrating the Flux tool by using it to perform GitOps on an examplatory application.

1. **Set up a Kubernetes cluster**: First, we need to have a Kubernetes cluster set up. To do so, we are going to use Amazon Web Services as our cloud provider.

2. **Install Flux on the cluster**: Once we have a Kubernetes cluster, the next step is to install Flux. We're going to do this by following the installation guide on the Flux website.

3. **Add examplatory application code to the GitHub repository**: In the next step, in this existing repository that we have here, we are going to add our examplatory application code.

4. **Configure Flux to use the GitHub repository**: Once we have a GitHub repository with application code and manifests, we need to configure Flux to use the repository. To do this, we need to create a GitRepository custom resource in Kubernetes that contains the details of the GitHub repository. This will be done using kubectl or by writing a YAML file and applying it to the cluster.

5. **Add manifests to the GitHub repository**: With Flux configured to use the GitHub repository, we can start adding manifests to the repository. These manifests will define the resources that make up the application, such as deployments, services, and ingresses. We might use tools like kustomize or Helm to generate these manifests.

7. **Deploy the application**: With the manifests in the GitHub repository, Flux will automatically deploy the application to the Kubernetes cluster. Whenever we make changes to the manifests in the GitHub repository, Flux will automatically update the deployment to reflect the changes.

8. **Make changes to the repository**: Now, we will test if the Flux is working correctly.We will make some changes to application; those changes can include updating manifests, adding new resources, or making changes to existing files. Then we will commit and push those changes back to the repository.

9. **Wait for Flux to pick up changes**: Once we push the changes to the repository, we will need to wait for Flux to pick up the changes. Flux typically checks the repository for changes every few minutes, so it may take a few minutes for the changes to be detected.

10. **Check Flux logs**: Finally, we will check the Flux logs and the state of the cluster to see if the changes have been applied.

## 4. Solution architecture

## 5. Environment configuration description

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

- https://www.atlassian.com/git/tutorials/gitops
- https://fluxcd.io/flux/concepts/
- https://fluxcd.io/flux/flux-e2e/
- https://anaisurl.com/full-tutorial-getting-started-with-flux-cd/
