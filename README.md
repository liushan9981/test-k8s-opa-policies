### 简介
- 使用k8s validatingwebhook 规范k8s资源创建
- 使用策略引擎open policy agent实现，本项目使用该引擎规则

### 功能列表
- 拉取镜像策略的值不为IfNotPresent则拒绝创建
- 拉取镜像字段imagePullSecrets如果不为空则拒绝创建
- deployments资源名字以-stable结尾则拒绝创建
- 测试警告功能
- 没有配置就绪和存活探针则拒绝创建
- service 端口名称不以http- or tcp- or grpc-开头则拒绝创建
- 以上部分规则，同时也对cronjob做了类似的限制

### service端口名字不符合规范的，拒绝创建，打印详细信息
```
root@k8s-node-6:~/manifests/test-opa/service# kubectl -n test-opa create -f test-svc-err-no-name.yaml 
Error from server: error when creating "test-svc-err-no-name.yaml": admission webhook "validating-webhook.openpolicyagent.org" denied the request: service port name should not be empty and must start with http- or tcp- or grpc-

```


### 打印警告信息
```
root@k8s-node-6:~/manifests/test-opa/deployments# kubectl -n test-opa create -f mystatic-deployments-warning.yaml 
Warning: container have not set livenessProbe or readinessProbe: nginx
deployment.apps/mystatic-test created
root@k8s-node-6:~/manifests/test-opa/deployments#
```

