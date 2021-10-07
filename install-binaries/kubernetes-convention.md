#### User Role Binding

| NAME                           | ROLE                                       | USERS                          |
| ------------------------------ | ------------------------------------------ | ------------------------------ |
| system:kube-controller-manager | ClusterRole/system:kube-controller-manager | system:kube-controller-manager |
| system:kube-scheduler          | ClusterRole/system:kube-scheduler          | system:kube-scheduler          |
| system:volume-scheduler        | ClusterRole/system:volume-scheduler        | system:kube-scheduler          |
| system:node-proxier            | ClusterRole/system:node-proxier            | system:kube-proxy              |

#### Group Role Binding

| NAME                                    | ROLE                                                | GROUPS                                       |
| --------------------------------------- | --------------------------------------------------- | -------------------------------------------- |
| cluster-admin                           | ClusterRole/cluster-admin                           | system:masters                               |
| system:basic-user                       | ClusterRole/system:basic-user                       | system:authenticated                         |
| system:discovery                        | ClusterRole/system:discovery                        | system:authenticated                         |
| system:monitoring                       | ClusterRole/system:monitoring                       | system:monitoring                            |
| system:public-info-viewer               | ClusterRole/system:public-info-viewer               | system:authenticated, system:unauthenticated |
| system:service-account-issuer-discovery | ClusterRole/system:service-account-issuer-discovery | system:serviceaccounts                       |
