<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_instance"></a> [rds\_instance](#module\_rds\_instance) | ../modules/rds/ | n/a |
| <a name="module_sg_rds"></a> [sg\_rds](#module\_sg\_rds) | ../modules/sg | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | n/a | `string` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_allocated_storage"></a> [rds\_instance\_allocated\_storage](#input\_rds\_instance\_allocated\_storage) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_db_name"></a> [rds\_instance\_db\_name](#input\_rds\_instance\_db\_name) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_engine"></a> [rds\_instance\_engine](#input\_rds\_instance\_engine) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_identifier"></a> [rds\_instance\_identifier](#input\_rds\_instance\_identifier) | ############RDS | `string` | n/a | yes |
| <a name="input_rds_instance_kms_key_id"></a> [rds\_instance\_kms\_key\_id](#input\_rds\_instance\_kms\_key\_id) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_multi_az"></a> [rds\_instance\_multi\_az](#input\_rds\_instance\_multi\_az) | n/a | `bool` | n/a | yes |
| <a name="input_rds_instance_parameter_description"></a> [rds\_instance\_parameter\_description](#input\_rds\_instance\_parameter\_description) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_parameter_group"></a> [rds\_instance\_parameter\_group](#input\_rds\_instance\_parameter\_group) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_parameter_group_family"></a> [rds\_instance\_parameter\_group\_family](#input\_rds\_instance\_parameter\_group\_family) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_storage_encrypted"></a> [rds\_instance\_storage\_encrypted](#input\_rds\_instance\_storage\_encrypted) | n/a | `bool` | n/a | yes |
| <a name="input_rds_instance_subnet_group"></a> [rds\_instance\_subnet\_group](#input\_rds\_instance\_subnet\_group) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_tags"></a> [rds\_instance\_tags](#input\_rds\_instance\_tags) | n/a | `map` | <pre>{<br/>  "terraform": "True"<br/>}</pre> | no |
| <a name="input_rds_secret_id"></a> [rds\_secret\_id](#input\_rds\_secret\_id) | n/a | `string` | n/a | yes |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | n/a | `string` | n/a | yes |
| <a name="input_secret_tags"></a> [secret\_tags](#input\_secret\_tags) | n/a | `map` | <pre>{<br/>  "terraform": "True"<br/>}</pre> | no |
| <a name="input_secret_values"></a> [secret\_values](#input\_secret\_values) | n/a | `map` | `{}` | no |
| <a name="input_sg_description"></a> [sg\_description](#input\_sg\_description) | n/a | `any` | n/a | yes |
| <a name="input_sg_ingress_rules"></a> [sg\_ingress\_rules](#input\_sg\_ingress\_rules) | n/a | `map` | n/a | yes |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | ###############security group | `any` | n/a | yes |
| <a name="input_sg_tags"></a> [sg\_tags](#input\_sg\_tags) | n/a | `map(string)` | <pre>{<br/>  "terraform": "True"<br/>}</pre> | no |
| <a name="input_sg_vpc_id"></a> [sg\_vpc\_id](#input\_sg\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br/>  "terraform": "True"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->