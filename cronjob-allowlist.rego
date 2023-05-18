package kubernetes.admission


deny[msg] {
    input.request.kind.kind == "CronJob"
    input.request.operation == "CREATE"
    containers := input.request.object.spec.jobTemplate.spec.template.spec.containers
    some container
    container_info := containers[container]
    container_info.imagePullPolicy != "IfNotPresent"
    msg := sprintf("container \"%v\" imagePullPolicy should be IfNotPresent or set empty", [container_info.name])
}


deny[msg] {
    input.request.kind.kind == "CronJob"
    input.request.operation == "CREATE"
    input.request.object.spec.jobTemplate.spec.template.spec.imagePullSecrets
    msg := "field imagePullSecrets should not set"
}
