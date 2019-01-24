# Bitnami MySQL with Replication

This solution uses multiple instances on OCI to replicate the databases from
the master node to a configurable number of replicas.

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
  - Number of nodes to deploy.
  - Size of the instances.
  - Name of the application database.
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

## How to scale the cluster

To change the number of nodes in your cluster, execute the "apply" command
changing the number of nodes of the deployment:

```bash
terraform apply -var nodes_count=<number_of_nodes>
```

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

The output `ApplicationPassword` is the password for MySQL user 'root'. If the
password is not provided, it is auto-generated. The password is marked
as sensitive information. If you want to show it, execute the following
command:

```bash
terraform output ApplicationPassword
```

## How to access the MySQL database

By default, the database port for the nodes in this solution cannot be accessed
over a public IP address. Connect to the instances through ssh:

```bash
ssh bitnami@<public_ip>
```

Then, execute the MySQL client:

```bash
mysql -uroot -p<application_password>
```

## Maintenance & support

Bitnami provides technical support for installation and setup issues through
[our support center](https://bitnami.com/support/oci).
