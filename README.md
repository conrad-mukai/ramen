# Ramen EKS

* *Boil water, add seasoning packets.*
* *Drop in noodles.*
* *Wait 3 minutes. Enjoy.*

Like instant ramen, [Terraform](https://www.terraform.io/) is indispensable for
developers. This project contains the Terraform code to deploy an
[AWS EKS cluster](https://aws.amazon.com/eks/). Instead of shuffling through
many `aws`, `kubectl`, and `helm` commands from a run book or clicking through
the AWS console, a fully functioning cluster with load balancing and
autoscaling can be brought up and destroyed reliably with just a few
`terraform` commands.

The code found here is based upon the
[Amazon EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/index.html).

## Requirements

To use this code the following is required:
1. admin access to an AWS account;
2. an S3 bucket for terraform state; and
3. an AWS ACM certificate/key pair.

## Contents

This project will create the following:
1. an [AWS VPC](https://aws.amazon.com/vpc/) with public and private subnets;
2. an AWS EKS cluster with managed node groups; and
3. several services for cluster management, including:
   1. a [Metric Server](https://github.com/kubernetes-sigs/metrics-server);
   2. a [Cluster Autoscaler](https://github.com/kubernetes/autoscaler);
   3. a [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) behind
      an [AWS application loadbalancer](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/)
      (no proxy required); and
   4. [Kubernetes namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
      with optional [Fargate profiles](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html).

## Structure

The project has 2 top level directories:
1. `deploy` for Terraform root modules where `terraform` commands are executed;
   and
2. `modules` for child modules where resources are defined.

Documentation can be found in these directories and their sub-directores.
