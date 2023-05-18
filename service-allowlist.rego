package kubernetes.admission

import data.kubernetes.namespace

opService = {"CREATE"}

deny[msg] {
    input.request.kind.kind == "Service"
    opService[input.request.operation]
    port_name := input.request.object.spec.ports[_].name
    not port_name_matches_any(port_name, {"http-", "tcp-", "grpc-"})
    msg := sprintf("service port's name(%q) is not start with http- or tcp- or grpc-", [port_name])
}

port_name_matches_any(str, prefix) {
    port_name_matches(str, prefix[_])
}

port_name_matches(str, prefix) {
    startswith(str, prefix)
}


deny[msg] {
    input.request.kind.kind == "Service"
    opService[input.request.operation]
    some port
    port_info := input.request.object.spec.ports[port]
    not_set_name(port_info)
    msg := "service port name should not be empty and must start with http- or tcp- or grpc-"
}

not_set_name(port_info) {
    not port_info.name
}
