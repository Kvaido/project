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
```
```sh
terraform init && terraform apply -auto-approve
```
```sh
yc managed-kubernetes cluster get-credentials otus-cluster --external --force
```
### Настройка GITLAB
Авторизровавщиись в GITLAB, необходиом создать новый проект и добавить ssh ключ.

Далее необходимо добавить переменные в меню GITLAB.

**Settings** --> **CI/CD** --> **Variables**

И создать следующие переменные:

Для переменой **FOLDER_ID** через CLI необходимо выполнить комманду:
```sh
yc config list
```
Ввести в виде переменных логин/пароль от docker hub

**CI_REGISTRY** - 'index.docker.io'

**CI_REGISTRY_USER** - логин на hub.docker.io

**CI_REGISTRY_PASSWORD** - пароль

В CLI получить список сервисных аккаунтов, которые существуют в облаке (Если нет сервисного аккаунта, то его необхоимо [создать](https://cloud.yandex.ru/docs/iam/operations/sa/create))
```sh
yc iam service-account --folder-id <ID каталога> list
```
Создать авторизованный ключ для сервисного аккаунта и сохранить его в файл key.json
```sh
yc iam key create --service-account-name <Название сервисного аккаунта> --output key.json
```
Содержимое файла **key.json** скопировать и в GITLAB создать переменную **DEPLOY_SRV_KEY**

Далее необхоимо отправить приложение для дальнейшей сборки в GITLAB выполнив в корне каталога проекта комманду:
```sh
git remote add origin git@gitlab.com:username/projectpath.git
```
После того как закончит свою работу pipeline, в левом меню проекта на GITLAB выбрать CD/CD --> Jobs и найти в конце **deploy_app** вывод команды kubectl get svc -A
и скопивароть внешний IP адрес ingress контроллера (**EXTERNAL-IP**).

Далее добавить его в файл **/etc/hosts**, если это ОС Linux, в **C:\Windows\system32\drivers\etc\hosts** в случае Windows или **/private/etc/hosts** в MacOS, в следующем виде.

```sh
EXTERNAL-IP search-engine prometheus-search-engine grafana-search-engine alertmanager-search-engine
```
### Работа приложения
По окончании всех манипуляций необходимо обождать 3-4 минуты, чтобы все контейнеры загрузились, открыть браузер и ввести в адресную строку
```sh
http://search-engine
```
Отроется страница с поиском.

### Настройка монитринга
В браузере открыть страницу http://grafana-search-engine

Авторизоваться используя *admin/password*

В левом меню выбрать **Configuration** --> **Data sources**.

И нажать кнопку [**Add data sources**] --> Выбрать как источник данных **Prometheus**.

В раздел **URL** вписать - <b>http://prometheus-search-engine</b>

В выподающем меню **Access** выбрать Browser и внизу страницы нажать кнопку [**Save & test**]

Далее в левом меню выбрать **Dashboards** --> **Manage** и нажать кнопку [**Import**]

Нажать кнопку [**Upload JSON file**] и выбрать файл project.json находящийся по адресу
```sh
otus-devops-project/helm/grafana/dashboards/project.json
```
