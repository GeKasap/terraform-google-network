# Terraform  - Create a network and setup the firewall rules
This project is an implementation of [Terraform Google Compute Network](https://www.terraform.io/docs/providers/google/r/compute_network.html) and [Terraform Google Compute Firewall](https://www.terraform.io/docs/providers/google/r/compute_firewall.html)
Layouts. It creates a KMS Crypto Key and the respective Keyring. Support also a list of service accounts to grant them permissions.

## Example
```yaml
terraform {
  backend "gcs" {

    bucket  = "my-foo-bucket-tfstate"
    prefix  = "vpc"
  }

  required_version = ">= 0.12"
}

provider "google-beta" {
  project = "my-foo-project"
  region  = "europe-west3"
  zone = "europe-west3-c"
}

module "my_network" {
  source = "./modules/terraform-google-network"
  name = "my-cool-vpc"
  project = var.project_id
  allow_rules = [
    {
      name = "source_tags"
      list = ["my-cool-cluster"]
      rules = [
        {
          protocol = "icmp"
          ports = []
        },
        {
          protocol = "tcp"
          ports = ["0-65535"]
        },
        {
          protocol = "tcp"
          ports = ["0-65535"]
        }
      ]
    },
    {
      name = "source_ranges"
      list = ["0.0.0.0/0"]
      rules = [{ protocol = "tcp", ports = ["22"] }]
    }
  ]
  deny_rules = [
    {
      name = "source_ranges"
      list = ["0.0.0.0/0"]
      rules = [{ protocol = "tcp", ports = ["234"] }]
    }]
}
````

## Variables
<table>
<tr>
<td> Variable name </td><td> Type </td><td> Description </td><td> Default value </td></tr>
<tr> <td> project </td><td> string </td><td> The ID of the project the resource belongs </td><td> </td></tr>
<tr> <td> name </td><td> string </td><td> Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash." </td></tr>
<tr> <td> description </td><td> string </td><td> An optional description for the network"  </td><td> </td></tr> 
<tr> <td> ipv4_range </td><td> string </td><td> (Optional, Deprecated) If this field is specified, a deprecated legacy network is created. You will no longer be able to create a legacy network on Feb 1, 2020. See the legacy network docs for more details. The range of internal addresses that are legal on this legacy network. This range is a CIDR specification, for example: 192.168.0.0/16. The resource must be recreated to modify this field."  </td><td> </td></tr> 
<tr> <td> allow_rules </td><td>
  list(object({
    name = string
    list = list(string)
    rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
   </td><td> A list of rules and tcp/udp ports to be allowed. Valid names are "  </td><td> [] </td></tr>

<tr> <td> deny_rules </td><td>
  list(object({
    name = string
    list = list(string)
    rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
   </td><td> A list of rules and tcp/udp ports to be denied. Valid names are </td><td> [] </td></tr>

<tr> <td> auto_create_subnetworks </td><td> bool </td><td> When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."  </td><td> false </td></tr> 
<tr> <td> routing_mode </td><td> string </td><td> The network-wide routing mode to use. If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with all subnetworks of this network, across regions."  </td><td> "REGIONAL" </td></tr> 
<tr> <td> delete_default_routes_on_create </td><td> bool </td><td> If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false."  </td><td> false </td></tr>
</table>


## Building
### Initialization

```
$ terraform init
```

### Planning

Terraform allows you to "Plan", which allows you to see what it would change
without actually making any changes.

```
$ terraform plan 
```

### Applying

```
$ terraform apply
```

### Modifying

If you want to update the firewall rules, then edit the `terraform.tfvars` file and run again `terraform apply`
```
$ terraform apply
```

### Destroying
```
$ terraform destroy
```

# Author

Georgios Kasapoglou

https://github.com/GeKasap

# License

Copyright 2019 Georgios Kasapoglou

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
