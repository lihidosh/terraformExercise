#ex1

resource "azurerm_policy_assignment" "ex1_assignments" {
  name                 = "ex1_assignments"
  display_name         = "ex1_assignments"
  scope                = var.azurerm_subscription
  policy_definition_id = azurerm_policy_definition.ex1.id
}
resource "azurerm_policy_definition" "ex1" {
  name         = "allowed_role"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "allowed_role"
  metadata     = <<METADATA
    {
      "category": "General"
    }
  METADATA
  policy_rule  = <<POLICY_RULE
 {
     "if": {
      "not": {
        "field": "location",
        "equals": "westeurope"
      },
      "not": {
        "field": "name",
        "capacity":15
      },
      "not": {
        "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIpAddress.id",
        "notLike": "*"
      },
      "then":{
        "efect":"deny"
      }
 }
 POLICY_RULE
}



# ex2
resource "azurerm_policy_assignment" "ex2_assignment" {
  name                 = "ex2_assignment"
  display_name         = "ex2_assignment"
  scope                = var.azurerm_subscription
  policy_definition_id = azurerm_policy_definition.ex2_policy.id
}
resource "azurerm_policy_definition" "ex2_policy" {
  name         = "ex2_policy"
  display_name = "ex2_policy"
  description  = "Enforces that only two subnets in a VNet include the word 'firewall' in their names"
  policy_type  = "Custom"
  mode         = "All"

  metadata    = <<METADATA
    {
    "category" : "Networking"
  }
    METADATA
  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Network/virtualNetworks/subnets"
      },
      {
        "not": {
          "field": "Microsoft.Network/virtualNetworks/subnets[*].name",
          "contains": "firewall"
        }
      }
    ]
  },
  "then": {
    "effect": "auditIfNotExists",
    "details": {
      "type": "Microsoft.Network/virtualNetworks/subnets",
      "name": "firewallSubnetLimit",
      "existenceCondition": {
        "count": {
          "field": "Microsoft.Network/virtualNetworks/subnets[*]",
          "where": {
            "field": "name",
            "contains": "firewall"
          }
        },
        "value": 2
      }
    }
  }
}
POLICY_RULE
}

#ex3
resource "azurerm_policy_assignment" "ex3_assignment" {
  name                 = "ex3_assignment"
  display_name         = "ex3_assignment"
  scope                = var.azurerm_subscription
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
}
resource "azurerm_policy_definition" "allowed_vm_skus" {
  name         = "allowed_vm_skus"
  display_name = "allowed_vm_skus"
  description  = "Enforce allowed VM SKUs"
  policy_type  = "Custom"
  mode         = "All"

  metadata    = <<METADATA
    {
    "category" : "Networking"
  }
    METADATA
  policy_rule = <<POLICY_RULE
{
"if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Compute/virtualMachines"
        },
        {
          "not": {
            "field": "Microsoft.Compute/virtualMachines/sku.name",
            "in": ["Standard_B2s", "Standard_D2s_v3", "Standard_E2s_v3"]
          }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE
}