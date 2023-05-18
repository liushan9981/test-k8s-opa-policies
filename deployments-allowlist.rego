package kubernetes.admission

opDeploymentDeny = {"CREATE", "UPDATE"}


deny[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentDeny[input.request.operation]
    is_not_webhook_warning(input.request.object)

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


deny[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentDeny[input.request.operation]
    is_not_webhook_warning(input.request.object)

    containers := input.request.object.spec.template.spec.containers
    some container
    container_info := containers[container]
    container_info.imagePullPolicy != "IfNotPresent"
    msg := sprintf("container \"%v\" imagePullPolicy should be IfNotPresent or set empty", [container_info.name])
}


deny[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentDeny[input.request.operation]
    is_not_webhook_warning(input.request.object)

    input.request.object.spec.template.spec.imagePullSecrets
    msg := "field imagePullSecrets should not set"
}


deny[msg] {
    input.request.kind.kind == "Deployment"
    opDeploymentDeny[input.request.operation]
    is_not_webhook_warning(input.request.object)

    deployment_name := input.request.object.metadata.name
    endswith(deployment_name, "-stable")
    msg := "deployment name should not endswith '-stable'"
}


is_not_webhook_warning(request_object) {
    not request_object["metadata"]["labels"]["openpolicyagentwarning"]
}
