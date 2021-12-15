variable "project" {
  type        = string
}
variable "solution" {
  type        = string
}
variable "env" {
  type        = string
}
variable "location" {
  type        = string
  default     = "West Europe"
}
variable "event_hub_ns_suffix" {
  type        = string
  description = "name suffix to be added to 'project0solution0env0'"
}
variable "event_hub_ns_capacity" {
  type        = number
  default     = 1
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. 1 throughput unit per day is equivalent to 1 MB per second. Default capacity has a maximum of 20, but can be increased in blocks of 20 on a committed purchase basis."
}
variable "event_hub_ns_max_throughput" {
  type        = number
  default     = 3
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20"
}

#variable "event_hub_ns_2_location" {
#  type        = string
#  default     = "West US 2"
#  description = "alternate eventhub namespace location"
#}

variable "event_hub_suffix" {
  type        = string
  description = "name suffix to be added to 'project0solution0env0'"
}

variable "event_hub_partition_count" {
  type        = number
  default     = 2
  description = "Each partition can only utilize a single throughput unit, partition count controls the maximum parallel consumers that can process messages simultaneously. The minimum is two, which allows for redundancy in the system. "
}

variable "event_hub_message_retention" {
  type        = number
  default     = 1
  description = "message retention in days, between 1 and 7"
}



