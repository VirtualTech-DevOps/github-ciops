## マニフェストの更新

### イメージタグを変更

`org`と`pkgname`変数は環境に合わせて変更

```
org=virtualtech-devops
pkgname=github-ciops
pkgid=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/$org/packages/container/$pkgname/versions -q '.[0].id')
tag=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/$org/packages/container/$pkgname/versions/$pkgid -q '.metadata.container.tags[] | select(.!="latest")')
kubectl create deployment app --image ghcr.io/$org/$pkgname:$tag -r 1 --dry-run=client -o yaml > manifest/deployment.yaml
```

### ポートなどを変更

```
kubectl create service nodeport app --tcp 80:80 --dry-run=client -o yaml > manifest/service.yaml
```

### 更新されたマニフェストをテスト

- minikubeでK8sのテスト環境を作成

```
minikube start
```

- 更新したマニフェストでデプロイ

```
kubectl apply -k manifest
```

- App podまでのURLを取得

```
minikube service --url app
```

---

環境を削除

- デプロイしたアプリを削除

```
kubectl delete -k manifest
```

- テスト環境を削除

```
minikube delete
```

問題なければGitHubにPush

## GitHub Actionsの設定

```
echo poc | gh variable set cluster_name
```

`terraform`ディレクトリ以下で実行

```
terraform output -raw role | gh variable set assume_role
```

```
terraform output -raw region | gh variable set aws_region
```

```
eksctl create iamidentitymapping --cluster poc --arn $(terraform output -raw role) --group system:masters --username admin
```
