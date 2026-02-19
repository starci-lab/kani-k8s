// =========================
// Resource presets (pod requests/limits by size key)
// =========================
// Used by components via coalesce(var.x, try(var.resources_config[preset_key].requests.cpu, "fallback")).

variable "resources_config" {
  type = map(object({
    requests = object({
      cpu               = string
      memory            = string
      ephemeral_storage = string
    })
    limits = object({
      cpu               = string
      memory            = string
      ephemeral_storage = string
    })
  }))
  description = "Pod resource configurations for different sizes (keyed by preset name e.g. 16, 32, 64)"
  default = {
    "16" = {
      requests = {
        cpu               = "16m"
        memory            = "32Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "64m"
        memory            = "128Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "32" = {
      requests = {
        cpu               = "32m"
        memory            = "64Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "128m"
        memory            = "256Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "64" = {
      requests = {
        cpu               = "64m"
        memory            = "128Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "256m"
        memory            = "512Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "128" = {
      requests = {
        cpu               = "128m"
        memory            = "512Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "512m"
        memory            = "2048Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "192" = {
      requests = {
        cpu               = "192m"
        memory            = "384Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "768m"
        memory            = "1536Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "256" = {
      requests = {
        cpu               = "256m"
        memory            = "512Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "1024m"
        memory            = "2048Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "384" = {
      requests = {
        cpu               = "384m"
        memory            = "768Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "1536m"
        memory            = "3072Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "512" = {
      requests = {
        cpu               = "512m"
        memory            = "1024Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "2048m"
        memory            = "4096Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "768" = {
      requests = {
        cpu               = "768m"
        memory            = "1536Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "3072m"
        memory            = "6144Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "1024" = {
      requests = {
        cpu               = "1024m"
        memory            = "2048Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "4096m"
        memory            = "8192Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "1536" = {
      requests = {
        cpu               = "1536m"
        memory            = "3072Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "6144m"
        memory            = "12288Mi"
        ephemeral_storage = "2Gi"
      }
    }
    "2048" = {
      requests = {
        cpu               = "2048m"
        memory            = "4096Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "8192m"
        memory            = "16384Mi"
        ephemeral_storage = "2Gi"
      }
    }
  }
}
