# Permissive RBAC permissions
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/
resource "kubernetes_cluster_role_binding" "permissive_binding" {
  metadata {
    annotations = {}
    labels      = {}
    name        = "permissive-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "admin"
    namespace = ""
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "kubelet"
    namespace = ""
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:serviceaccounts"
    namespace = ""
  }
}
