# MySQL Docker Setup with Auto-Init Databases

This project builds a custom MySQL Docker image that automatically initializes any database from `database`.

---

## Prerequisites

- Docker installed
---

## 1. Build the Docker Image

From the project root (where this `Dockerfile` lives), run:

```bash
docker build -t mysql-vscode .
```

This creates an image named `mysql-vscode` that includes your database scripts.

> [!TIP]
> use the VS Code task:
> - Press `Ctrl+Shift+P` → `Tasks: Run Task`
> - Choose `Build Image`

---

## 2. Run the MySQL Container

Start a container with:

```bash
docker run -d \
  --env-file .env \
  --name mysql-template-db \
  -p 127.0.0.1:3307:3306 \
  -v mysql-data:/var/lib/mysql-template \
  mysql-template
```

> [!TIP]
> use the VS Code task:
> - Press `Ctrl+Shift+P` → `Tasks: Run Task`
> - Choose `Run Container`


- `-p 127.0.0.1:3307:3306` maps MySQL’s port 3306 inside the container to port 3307 on your host.
- `-v mysql-data:/var/lib/mysql-template` creates a named volume (`mysql-template`) to persist database files between restarts.
- On first startup, MySQL will automatically execute all `.sql` files in `/docker-entrypoint-initdb.d` (our copied `database/` scripts), creating and populating the databases.

---

## 3. Verify Initialization

Once the container is running, connect and check:

```bash
set -a && source .env && set +a && docker exec -it mysql-template-db mysql -uroot -p$MYSQL_ROOT_PASSWORD
```

Inside the MySQL CLI, run:

```sql
SHOW DATABASES;
```

You should see:

```
+--------------------+
| Database           |
+--------------------+
| Test               |
+--------------------+
```

in general, you can run any sql script with the following command:

```
docker exec -i mysql mysql -uroot -ptest < scripts\test.sql
```

---

## 4. Connect from VS Code

Install the **MySQL** extension by **cweijan**.

![mysql vscode extension](images/extension.png)

Use these connection settings:

| Field       | Value           |
|-------------|-----------------|
| Host        | `127.0.0.1`     |
| Port        | `3307`          |
| Username    | `root`          |
| Password    | `test`          |
| Database    | *(any or leave blank)* |

Open a new query tab and run SQL—results will show up in a nice table view.

---

## Preview of a working state using the extension:

![preview using mysql extension](images/preview.png)

---

## 5. Cleanup / Reset

You can use the VS Code tasks:

- `Stop & Remove MySQL Container`

Or manually run:

```bash
docker stop mysql

docker rm mysql

docker volume rm mysql-data
```

Restarting with the same commands or tasks will reinitialize from scratch.

---

## 6. VS Code Tasks

The `.vscode/tasks.json` file includes these ready-to-use tasks:

- **Build MySQL Docker Image** → builds the Docker image (`mysql-vscode`)
- **Run MySQL Container** → starts MySQL with port 3307 and persistent volume
- **Stop & Remove MySQL Container** → stops and removed the running MySQL container (volume remains unless removed manually)

Launch with `Tasks: Run Task` from the Command Palette.
