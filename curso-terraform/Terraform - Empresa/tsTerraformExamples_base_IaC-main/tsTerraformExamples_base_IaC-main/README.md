# IaC Terraform

IaC - despliegue de la infraestructura en Terraform

Ejemplo de Estructura:

```console
CO_ECS_Multiples-Target-Group_base_IaC
├── transversal
│   ├── .azure-pipelines
│   │   └── vars.yml
│   ├── env
│   │   ├── dev
│   │   │   └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │   └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── inputs.tf
│   ├── main.tf
│   └── README.md
├── micro_ecr
│   ├── .azure-pipelines
│   │   └── vars.yml
│   ├── env
│   │   ├── dev
│   │   │   └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │   └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── inputs.tf
│   ├── main.tf
│   └── README.md
├── micro
│   ├── .azure-pipelines
│   │  └── vars.yml
│   ├── env
│   │   ├── dev
│   │   │  └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │  └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── data.tf
│   ├── inputs.tf
│   ├── locals.tf
│   ├── main.tf
│   └── README.md
├── .gitignore
├── azure-pipelines.yml
└── README.md
```
