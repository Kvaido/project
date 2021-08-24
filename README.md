# otus-devops-project

### Пререквизиты
* yc - Yandex.Cloud CLI 0.80.0 linux/amd64
* kubectl
* Terraform v1.0.0
* Helm 3.6.2
* gitlab.com account

### Разворачивание кластера
```sh
cd otus-devops-project/kubernetes/terraform/prod
terraform init && terraform apply -auto-approve
yc managed-kubernetes cluster get-credentials otus-cluster --external --force
```
### Настройка GITLAB
Авторизровавщиись в GITLAB, пройти далее:
Добавить ssh ключ 

Создать новый проект 

Settings -- CI/CD -- Variables

И создать следующие переменные:
FOLDER_ID 
```sh
yc config list
```
Ввести в виде переменных логин/пароль от docker hub

CI_REGISTRY - 'index.docker.io'

CI_REGISTRY_USER - логин на hub.docker.io

CI_REGISTRY_PASSWORD - пароль

Получить список сервисных аккаунтов, которые существуют в облаке (Если нет сервисного аккаунта, то его необхоимо [создать](https://cloud.yandex.ru/docs/iam/operations/sa/create))
```sh
yc iam service-account --folder-id <ID каталога> list
```
Создать авторизованный ключ для сервисного аккаунта и сохранить его в файл key.json
```sh
yc iam key create --service-account-name <Название сервисного аккаунта> --output key.json
```
Содержимое файла key.json скопировать и в GITLAB создать переменную DEPLOY_SRV_KEY

```sh
git remote add origin git@gitlab.com:username/projectpath.git
```
После того как пройдут все джобы найти в конце deploy_app вывод команды kubectl get svc -A
и скопивароть внешний IP адрес ingress контроллера 
Далее добавить его в файл /etc/hosts, если это ОС Linux, в C:\Windows\system32\drivers\etc\hosts в случае Windows или /private/etc/hosts в MacOS, в следующем виде.

```sh
EXTERNAL_IP search-engine prometheus-search-engine grafana-search-engine alertmanager-search-engine
```
