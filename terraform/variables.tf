variable "app_image_tag" {
  type = string
}

variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "mongodb_admin_password" {
  type      = string
  sensitive = true
}

variable "mongodb_admin_username" {
  type = string
}

variable "mongodb_app_db" {
  type = string
}

variable "mongodb_app_password" {
  type      = string
  sensitive = true
}

variable "mongodb_app_username" {
  type = string
}


variable "region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "zone" {
  type = string
}
