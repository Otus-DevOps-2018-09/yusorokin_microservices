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

variable "count" {
  description = "Instances count"
  default     = "1"
}

variable docker_disk_image {
  description = "Disk image for reddit base image"
  default     = "reddit-base-docker"
}

variable "do_provision" {
  description = "If true then provisioning will go on"
  default     = true
}
