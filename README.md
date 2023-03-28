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
- Rollback and recovery - all it takes to rollback an update is to revert the state of a git repository, Flux will automatically restore old cluster state;
- Image automation - Flux supports automatic image updates, ensuring that the application always runs on the latest version of the container image, this is particularly useful if we have CI/CD pipelines that build, test and push such images automatically;
- Notifications - Flux can send notifications about cluster state changes to platforms such as Discord or Slack;
- Enhanced security - thanks to the pull model of Flux we don't need to give a cluster administrator level access to CI/CD pipelines that would normally push those changes to the cluster.

---

### How does Flux work?

First we need to install it in the cluster, this process is called bootstrapping and can be performed using the flux CLI. Once installation is finished we can see that flux created a couple of controllers, most importantly:

- **Source Controller** - agent responsible for pulling Commit data (kubernetes manifests such as deployments or services) into the cluster;
- **Kustomize Controller** - agent responsible for reconciling the cluster state with the desired state as defined by Commit manifests retrieved through Source controller;
- **Image Reflector Controller** and **Image Automation Controller** - agents responsible for monitoring image repositories (e.g. DockerHub) and reflecting image metadata in Kubernetes resources.
- **Notification Controller** - agent responsible for handling notifications.

Figure below illustrates one of the functionallities outlined before - image automation.

<img src="images/flux-image-update-to-git.png">

The more important steps include:

- User pushes a new version of a docker image (either manually or through CI/CD pipeline);
- Flux detects that the image tag has changed;
- Flux updates relevant Kubernetes manifests (by changing image version in respective deployment files) and applies those changes to the git repository automatically;
- Flux reconciles the state of the cluster with the desired state of the git repository - in this case it just updates the application.

It works similarly if we update the git repository manually, Flux will detect those changes and reflect them in the cluster.

## 3. Case study concept description

In our project, we will focus on demonstrating the Flux tool by using it to perform GitOps on an examplatory application.

By setting up appropriate configuration, we will use Flux to automatically update the application when any changes appear in it.

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
