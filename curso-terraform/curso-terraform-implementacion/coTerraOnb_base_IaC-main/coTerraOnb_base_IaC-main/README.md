# IaC Terraform

IaC - despliegue de la infraestructura en Terraform

Ejemplo de Estructura:

```console
CO_ACH_base_IaC
├── transversal
│   ├── env
│   │   ├── dev
│   │   │   └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │   └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── inputs.tf
│   ├── main.tf
│   ├── ouputs.tf
│   └── README.md
├── retiro
│   ├── env
│   │   ├── dev
│   │   │   └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │   └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── inputs.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── README.md
├── modelosInternos
│   ├── env
│   │   ├── dev
│   │   │  └── terraform-dev.tfvars
│   │   ├── pdn
│   │   │  └── terraform-pdn.tfvars
│   │   └── qa
│   │       └── terraform-qa.tfvars
│   ├── inputs.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── README.md
├── .gitignore
├── azure-pipelines.yml
└── README.md
```
[Manejo de secretos para las variables](https://dev.azure.com/GrupoBancolombia/Nequi/_wiki/wikis/Nequi.wiki/83748/Pipeline-de-Referencia-IaC?anchor=**manejo-de-secretos-para-las-variables**)
