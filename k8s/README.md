### Consultar os recursos de api que podemos usar e a versão para usar no apiVersion 
kubectl api-resources

### Fazer undo
kubectl rollout undo deployment web-page

### Ver os pods de determinado node
k get pods -o wide --field-selector spec.nodeName=mycluster-worker2

### Definir labels nos nodes

kubectl label nodes mycluster-worker2 disktype=ssd

### Consultar os nodes e seus labels

kubectl nodes --show-labels


### Exclui um recurso pelo arquivo yaml

kubectl delete -f apache-daemonset-worker2.yaml

### Lista os pods e monitorar

kubectl get pods --watch

### Exibir o yaml completo

kubectl get jobs my-job --output yaml

