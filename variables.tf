# Stack Name
variable "project_name" {}

# Jenkisns game type
variable "game_instance_type" {}

# Region
variable "region" {}

# SSH Access
variable "ssh_access" {
  type = list(string)
}

# HTTP Access
variable "http_access" {
  type = list(string)
}

# Desire capacity for game Node
variable "game_desired_capacity" {
  type    = number
  default = 3
}

# Game volume size
variable "game_volume_size" {
  default = 10
}

# Environment
variable "env" {
  type    = string
  default = "Prod"
}

# Type
variable "type" {
  type    = string
  default = "Production"
}

# Key 
variable "key_name" {
  default = "Demo-key"
}
