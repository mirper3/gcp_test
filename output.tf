output "o_vpc" {
    value = google_compute_network.vpc-network-tf.name
}

output "o_subnet" {
    value = google_compute_subnetwork.vpc-subnetwork-tf.name
}

output "o_fw_rule1" {
    value = google_compute_firewall.fw-rule1.name
}

output "o_fw_rule2" {
    value = google_compute_firewall.fw-rule2.name
}

output "o_fw_rule3" {
    value = google_compute_firewall.fw-rule3.name
}

output "o_fw_rule4" {
    value = google_compute_firewall.fw-rule4.name
}

output "o_fw_rule5" {
    value = google_compute_firewall.fw-rule5.name
}


output "o_pip" {
    value = google_compute_global_address.pip.name
}

output "o_vm_pip_01"{
    value = google_compute_address.vm-pip-01.name
}

output "o_vm_pip_02" {
    value = google_compute_address.vm-pip-02.name
}

output "o_vm01" {
    value = google_compute_instance.vm01.name
}

output "o_vm02" {
    value = google_compute_instance.vm01.name
}

output "o_hceck" {
    value = google_compute_http_health_check.hceck.name
}

output "o_ig1"{
    value = google_compute_instance_group.ig1.name
}

output "o_ig2"{
    value = google_compute_instance_group.ig2.name
}

output "o_bckend" {
    value = google_compute_backend_service.bckend.name
}

output "o_httpproxy" {
    value = google_compute_target_http_proxy.httpproxy.name
}

output "o_urlmap" {
    value = google_compute_url_map.urlmap.name
}

output "o_fwd_rule" {
    value = google_compute_global_forwarding_rule.fwd_rule.name
}