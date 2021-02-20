variable "AWS_REGION" {    
    default = "eu-west-2"
}

variable "AMI" {
    type = "map"
    
    default {
        eu-west-2 = "replace with id"
    }
}