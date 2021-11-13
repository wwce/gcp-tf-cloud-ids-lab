#variable project_id {}

variable cidrs_trust {
  type    = list(string)
}

variable service_scopes {
    type = list(string)
}

variable region {}
variable image_jenkins {}
variable image_kali {}
variable image_juice {}
variable ip_jenkins {}
variable ip_kali {}
variable ip_juice {}