USERNAME='myadmin'

set -e

mkdir $USERNAME-dir
cd $USERNAME-dir

openssl genrsa -out $USERNAME.pem
openssl req -new -key $USERNAME.pem -out $USERNAME.csr -subj "/CN=$USERNAME"

OUTPUT=$(cat $USERNAME.csr | base64 | tr -d '\n')

cat <<EOF > $USERNAME-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $USERNAME
spec:
  groups:
  - system:authenticated
  request: $OUTPUT
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 315569260
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF

kubectl create -f $USERNAME-csr.yaml
kubectl certificate approve $USERNAME

kubectl get csr $USERNAME -o jsonpath='{.status.certificate}' | base64 -d > $USERNAME.crt

cat <<EOF
- name: $USERNAME
  user:
    client-certificate-data: $(base64 -w0 < $USERNAME.crt)
    client-key-data: $(base64 -w0 < $USERNAME.pem)
EOF

cat <<EOF > $USERNAME-rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $USERNAME-binding
subjects:
- kind: User
  name: $USERNAME
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl create -f $USERNAME-rbac.yaml
