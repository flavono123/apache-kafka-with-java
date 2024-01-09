variable "name_prefix" {
  type        = string
  default     = "kafka"
  description = "The names or prefix of names of resources would be created"
}

variable "num_of_brokers" {
  type        = number
  default     = 1
  description = "The number of brokers"
}
