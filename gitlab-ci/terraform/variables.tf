variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west2"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable "zone" {
  description = "Instance zone"
  default     = "europe-west2-b"
}

variable disk_image {
  description = "Disk image"
  default     = "reddit-base-docker"
}

variable disk_size {
  description = "Disk size"
  default     = 10
}

variable "do_provision" {
  description = "If true then provisioning will go on"
  default     = true
}
