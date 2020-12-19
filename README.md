## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| aws.ue1 | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| appname | Name of your app, used as name or prefix for resources and applied as tag for cost tracking | `string` | n/a | yes |
| root\_domain | Root domain which this app will be hosted at | `string` | n/a | yes |
| sub\_domain | true: host at $appname.$root\_domain, false: host at $root\_domain | `bool` | `false` | no |

## Outputs

No output.

