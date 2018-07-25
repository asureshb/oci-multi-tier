# Bitnami MySQL with Replication

This solution uses multiple instances on OCI to replicate the databases from
the master node to a configurable number of replicas.

## Using this solution

- Install Terraform and Terraform provider for OCI. See
  [Installation](https://github.com/oracle/terraform-provider-oci#installation)
  for instructions.

- Update the `terraform.tfvars` file with the OCI credentials.

- Initialize the Terraform working directory.

```bash
terraform init
```

- Deploy the cluster. You will be prompted to specify some information such as:
  - Name of the deployment.
  - Number of nodes to deploy.
  - Size of the instances.
  - Name of the application database.
  - Size of the data volume in GBs.

  If you don't want to be prompted for those values, add them in the
  `terraform.tfvars` file.

```bash
terraform apply
```

- Wait until the deployment is ready. It can take up to 15 minutes to finish.
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

You can execute the "apply" command. If a new Oracle Linux 7.5 base image is
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
