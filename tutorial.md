# Code to Production in 3 Minutes on K8s

## Introduction

In this tutorial, we will:

* Deploy a 12 Factor App to Kubernetes in minutes
* Create a MongoDB service instance from a curated catalogue of services
* Connect the app to the service
* Scale the app, and look at its logs
* Take a look at what is running on Kubernetes to make this possible

...and all **without writing any YAML!**

What's more, we'll all be sharing _one_ Kubernetes cluster safely. This is known as multi-tenancy.

### Ready to begin?

When you're ready, click the **Next button** below.

## Getting Started

### Google Cloud Shell

This is Google Cloud Shell. Google Cloud has provisioned a free VM that you can access via this web UI. We've installed the tools and configuration you need into the image of this VM.

### Student Numbers

You should all have been assigned a student number. You'll need this at various points throughout the course. When referring to _your_ student number in instructions, this will be stylised as `${STUDENT_NUMBER}`. This is the same syntax that Bash will use to expand an environment variable, if we set one.

Set an environment variable to the value of _your actual student number_ (**not** 117!).

```bash
export STUDENT_NUMBER=117
```

### Checking Your Work

Check that your environment variable is set correctly using the following command:

```bash
echo ${STUDENT_NUMBER}
```

and you should see your number printed on the next line.

## The `cf` CLI

We're going to use Cloud Foundry to take our code and turn it into a running pods on Kubernetes. Cloud Foundry has a number of components that run in the Kubernetes cluster, and a **command-line interface**: the `cf` CLI.

Let's check that the tool is installed correctly.

```bash
cf version
```

### Checking your work

You should see something similar to:

```bash
cf version 6.44.1+c3b20bfbe.2019-05-08
```

### Logging into Cloud Foundry

Use the following command to log into the Cloud Foundry running on our Kubernetes cluster:

```bash
cf login -a https://api.scf.engineerbetter.com --skip-ssl-validation
```

When prompted, enter:

* Email: `student${STUDENT_NUMBER}@engineerbetter.com` _eg student117@engineerbetter.com_
* Password: `student-${STUDENT_NUMBER}` _eg student-117_

### Targeting Orgs and Spaces

Kubernetes has logical divisions called Namespaces. To differentiate _its_ logical divisions, Cloud Foundry is divided up into Organisations and Spaces. Apps live in spaces, and spaces live in orgs.

Are you already targeting an org and space? If so, how do you think Cloud Foundry knew which one you should target?

Confirm that you're targeting an org and a space:

```bash
cf target
```

#### Checking Your Work

You should see something like the following, featuring _your_ student number:

```bash
api endpoint:   https://api.scf.engineerbetter.com
api version:    2.136.0
user:           student117@engineerbetter.com
org:            students
space:          student117
```
