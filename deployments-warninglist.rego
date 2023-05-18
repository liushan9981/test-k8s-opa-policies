package kubernetes.admission

opDeploymentWarn = {"CREATE", "UPDATE"}


warn[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentWarn[input.request.operation]
    is_webhook_warning(input.request.object)

    containers := input.request.object.spec.template.spec.containers
    some container
    container_info := containers[container]
    not_set_ness(container_info)
    msg := sprintf("container have not set livenessProbe or readinessProbe: %v", [container_info.name])
}

not_set_ness(container_info) {
    not container_info["livenessProbe"]
}

not_set_ness(container_info) {
    not container_info["readinessProbe"]
}


warn[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentWarn[input.request.operation]
    is_webhook_warning(input.request.object)

    containers := input.request.object.spec.template.spec.containers
    some container
    container_info := containers[container]
    container_info.imagePullPolicy != "IfNotPresent"
    msg := sprintf("container \"%v\" imagePullPolicy should be IfNotPresent or set empty", [container_info.name])
}


warn[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentWarn[input.request.operation]
    is_webhook_warning(input.request.object)

    input.request.object.spec.template.spec.imagePullSecrets
    msg := "field imagePullSecrets should not set"
}


is_webhook_warning(request_object) {
    request_object["metadata"]["labels"]["openpolicyagentwarning"]
}
