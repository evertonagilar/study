# Instalar kind

```bash
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x kind
sudo cp kind /usr/local/bin
```

# Instalar kubectl

Link: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

# Criar mycluster

```bash
kind create cluster --name mycluster --config mycluster-config.yaml
```

# Usar o cluster

```bash
kubectl cluster-info --context kind-mycluster
```

# Se precisar entrar em um pod

```bash
kubectl exec -ti nome_do_pod -- bash
```

# Ver os eventos 

```bash
kubectl events
```

# Consultar os recursos de api que podemos usar e a versão para usar no apiVersion 

```bash
kubectl api-resources
```

# Fazer undo

```bash
kubectl rollout undo deployment web-page
```

# Ver os pods de determinado node

```bash
k get pods -o wide --field-selector spec.nodeName=mycluster-worker2
```

# Definir labels nos nodes

```bash
kubectl label nodes mycluster-worker2 disktype=ssd
```

# Consultar os nodes e seus labels

```bash
kubectl nodes --show-labels
```

# Exclui um recurso pelo arquivo yaml

```bash
kubectl delete -f apache-daemonset-worker2.yaml
```

# Lista os pods e monitorar

```bash
kubectl get pods --watch
```

# Exibir o yaml completo

```bash
kubectl get jobs my-job --output yaml
```

# Suspender um cron-job

```bash
kubectl patch cj my-cron-job -p '{"spec" : { "suspend" : true }}'
```

# Ver se um pod tem algum warning

```bash
kubectl describe pod pod-cm-env | grep Warning
```

# Ver os warnings de forma global 

```bash
kubectl get events | grep -i warning
```

# Criar configmaps com base em arquivo txt e em literal com propriedades

```bash
kubectl create cm my-cm \
> --from-file=my-app-file.txt \
> --from-literal=my-description=testing
```

Obs.: No exemplo de estudo eu mapei no pod um volume. Nesse caso será gerado 2 arquivos

# Importar o configmap profile-replica

```bash
kubectl create configmap profile-replica --from-env-file profile-replica.env
```
# Definindo immutable: true em configmaps proibe que o mesmo sofra alteração

```bash
kubectl apply -f my-cm-props-imutavel.yaml
The ConfigMap "my-cm" is invalid: data: Forbidden: field is immutable when `immutable` is set
```

Obs.: Terá que remover e recriar novamente

# Os valores das secrets devem ser em base64

```bash
kubectl apply -f my-secret.yaml
Error from server (BadRequest): error when creating "my-secret.yaml": Secret in version "v1" cannot be handled as a Secret: illegal base64 data at input byte 2
```

# Encode / decode base64 dos valores

```bash
echo -n 'admin' | base64
YWRtaW4=

echo YWRtaW4= | base64 --decode
admin
```

# Verificar se o serviço está rodando com nc

```bash
nc -v um_ip 6443
```

# Instalar o docker via script

```bash
curl -fsSL https://get.docker.com | sh
```

<pre>
opções:
  -L -> se tiver redirect, segue
  -S -> exibe o erro
  -f -> fail silent
  -s -> silent mode
</pre>

# Ver todos os pods em todos os namespaces

```bash
kubectl get all --all-namespaces
```

# Executar o nginx com 10 réplicas

```bash
kubectl run nginx --image nginx --replicas 10
```

# Fazer port-forward 

```bash
kubectl port-forward  pod/nginx 8083:80
```

# Fazendo export para acessar o nginx em algum node do cluster

```bash
kubectl run nginx2 --image=nginx --port 80
kubectl expose pod nginx2 --type NodePort
kubectl describe pod nginx2
kubectl get nodes -o wide
curl 172.19.0.2:30059
curl 172.19.0.3:30059
```













