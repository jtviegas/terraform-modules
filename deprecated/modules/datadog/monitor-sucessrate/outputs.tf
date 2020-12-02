
output "id" {
    value       = datadog_monitor.service-sucessrate.id
    description = "The monitor id to be used, for instance, in SLO's"
}
