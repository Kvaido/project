# otus-devops-project

### Пререквизиты
* yc - Yandex.Cloud CLI 0.80.0 linux/amd64
* kubectl
* git
* Terraform v1.0.0
* Helm 3.6.2
* gitlab.com account

### Подготовка 
Небходимо скачать на локальну машину проект
```sh
git clone git@github.com:Kvaido/project.git
```

### Разворачивание кластера
```sh
cd project/kubernetes/terraform/prod
```
В CLI получить список сервисных аккаунтов, которые существуют в облаке (Если нет сервисного аккаунта, то его необхоимо [создать](https://cloud.yandex.ru/docs/iam/operations/sa/create))
```sh
yc iam service-account --folder-id <ID каталога> list
```
Создать авторизованный ключ для сервисного аккаунта и сохранить его в файл key.json.
Он потребуется далее.
```sh
yc iam key create --service-account-name <Название сервисного аккаунта> --output key.json
```

Запонить файл terraform.tfvars переменными (шаблон terraform.tfvars.example):
```sh
cp terraform.tfvars.example terraform.tfvars
```

cloud_id                 = "идентификатор облака"

folder_id                = "идентификатор каталога"

zone                     = "ru-central1-a""

public_key_path          = "/path/to/ssh/pub_key"

private_key_path         = "/path/to/ssh/private_key"

service_account_key_file = "path_to_key_file.json"

access_key               = "access_key"

secret_key               = "secret_key"

service_account_key_id   = "service_account_key_id"

Переменные **cloud_id** и **folder_id** можно получить из вывода комманды 
```sh
yc config list
```
Переменная **service_account_key_file**, как видно из названия, указывает на авторизованный ключ для сервисного аккаунта срасширением json полученный ранее.

**service_account_key_id**  можно получить выводом команды 
```sh
yc iam service-account list
```
Переменные access_key и secret_key необходимо  [создать](https://cloud.yandex.ru/docs/iam/operations/sa/create-access-key)

Публичный ssh ключ должен быть помещен в облако.
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

Для переменой **FOLDER_ID** через CLI необходимо выполнить комманду:
```sh
yc config list
```
Ввести в виде переменных логин/пароль от docker hub

**CI_REGISTRY** - 'index.docker.io'

**CI_REGISTRY_USER** - логин на hub.docker.io

**CI_REGISTRY_PASSWORD** - пароль

Содержимое ранее полученного файла **key.json** скопировать и в GITLAB создать переменную **DEPLOY_SRV_KEY**

Далее необхоимо отправить приложение для дальнейшей сборки в GITLAB выполнив в корне каталога проекта комманду:
```sh
git remote set-url origin git@gitlab.com:USERNAME/otus-devops-project.git
```
```sh
git push -u origin
```
После того как закончит свою работу pipeline, в левом меню проекта в GITLAB выбрать CD/CD --> Jobs и найти в конце **deploy_app** вывод команды kubectl get svc -A
и скопивароть внешний IP адрес ingress контроллера (**EXTERNAL-IP**).

Далее добавить его в файл **/etc/hosts**, если это ОС Linux или macOS X, в случае Windows файл находится в **C:\Windows\system32\drivers\etc\hosts**.

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

В поле **URL** вписать - <b>http://prometheus-search-engine</b>

В выподающем меню **Access** выбрать Browser и внизу страницы нажать кнопку [**Save & test**]

Далее в левом меню выбрать **Dashboards** --> **Manage** и нажать кнопку [**Import**]

Нажать кнопку [**Upload JSON file**] и выбрать файл project.json находящийся по адресу
```sh
otus-devops-project/helm/grafana/dashboards/project.json
```
