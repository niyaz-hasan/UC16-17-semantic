variable "db_name" { 
    type = string 
}
variable "db_username" { 
    type = string 
}
variable "db_password" { 
    type = string 
    sensitive = true 
}
variable "db_instance_class" { 
    type = string 
}
variable "engine_version" { 
    type = string 
    default = "15.9" 
}
variable "allocated_storage" { 
    type = number 
    default = 20 
}
variable "multi_az" { 
    type = bool 
    default = false 
}
variable "storage_encrypted" { 
    type = bool 
    default = true 
}
variable "publicly_accessible" { 
    type = bool 
    default = false 
}
variable "monitoring_interval" { 
    type = number 
    default = 0 
}
variable "subnet_ids" { 
    type = list(string) 
}
variable "vpc_security_group_ids" { 
    type = list(string) 
}
variable "tags" { 
    type = map(string) 
}