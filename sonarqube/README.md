# Bitnami SonarQube Multi-Tier

This solution uses two virtual machines, one with the application front-end and
a second with the database.

## Using this solution

The [Get Started Guide with Bitnami Terraform Templates on OCI](https://docs.bitnami.com/oci-templates/get-started-oci-terraform/)
walks you though the process of using the Terraform Provider plugin and the
Terraform CLI to deploy the Bitnami MySQL with replication on an Oracle
Cloud Infrastructure server. You will find there how to configure the
Terraform CLI, the OCI plugin and how to configure it with your OCI account.

# TL;DR;

```bash
terraform init
terraform apply
```

## Initialize the working directory

```bash
terraform init
```

Replace the [OCI account parameters](https://docs.bitnami.com/oci-templates/get-started-oci-terraform/#retrieving-oci-account-parameters)
in the `env-vars` file. Source it before you plan, apply, or destroy the
configuration:

```bash
. env-vars
```

## Deploy the cluster

```bash
terraform apply
```

You can modify some default values of the deployment such as:
  - Name of the deployment.
  - Size of the instances.
  - Size of the data volume in GBs.

For instance, to use a custom name for the deployment add the following line
to the `env-vars` file:

```bash
export TF_VAR_deployment_short_name="a_name"
```

Wait until the deployment is ready. It can take up to 15 minutes to finish.
Then, you will see the Output section of the deployment which contains:
  - Application password (hidden).
  - Instance names.
  - Oracle Linux base image.
  - Private IPs.
  - Public IPs.

## How to upgrade the instances

You can execute the "apply" command. If a new Oracle Linux 7.6 base image is
detected, the instances are destroyed and relaunched. All the data of the
application is persisted in a different volume that is reattached so there is
no data loss.

```bash
terraform apply
```

## How to delete the cluster

You can delete the cluster by executing the "destroy" command.

```bash
terraform destroy
```

## How to get the application password

The output `ApplicationPassword` is the password for SonarQube user 'admin'. If the
password is not provided, it is auto-generated. The password is marked
as sensitive information. If you want to show it, execute the following
command:

```bash
terraform output ApplicationPassword
```

## How to get the database password

The output `DatabasePassword` is the password for PostgreSQL user 'postgres'. If the
password is not provided, it is auto-generated. The password is marked
as sensitive information. If you want to show it, execute the following
command:

```bash
terraform output DatabasePassword
```

## How to access the SonarQube application?

You can go to *http://SERVER-IP* in your browser. The login user is 'admin'.

## Maintenance & support

Bitnami provides technical support for installation and setup issues through
[our support center](https://bitnami.com/support/oci).
