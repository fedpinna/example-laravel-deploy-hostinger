# Laravel Deployment Script

This repository contains a deployment script for Laravel projects. The script automates the process of installing dependencies, optimizing the application, and transferring files to the production server.

## Requirements

- Docker and Docker Compose installed.
- SSH access to the production server.
- SSH keys configured for server access. 

## Configuration and Deployment on Hostinger

### Step 1: Clone the repository

```bash
git clone https://github.com/fedpinna/example-laravel-deploy-hostinger
cd example-laravel-deploy-hostinger

```
### Step 2: Configure environment variables

Ensure that the `deploy/.env.production` file contains the following variables:

### Step 3: Configure SSH keys

Ensure that the necessary SSH keys for accessing the server are in the deploy directory:

- `id_rsa`: Private key
- `id_rsa.pub`: Public key

### Step 4: Configure the .htaccess.config file

Ensure that the `deploy/.htaccess.config` file contains the correct configuration for your application.

### Step 5: Build and run the Docker container

The deployment script will run automatically when the container starts.

## Usage in Other Projects

To use this deployment script in your own Laravel project, follow these steps:

### Step 1: Clone your project repository:

```bash
git clone https://github.com/fedpinna/example-laravel-deploy-hostinger
cd your-project

```

### Step 2: Copy the deployment script and configuration files:

Copy the deploy directory and the docker-compose.yml file from this repository to your project.

### Step 3: Configure environment variables:

Ensure that the `deploy/.env.production` file in your project contains the necessary environment variables for your deployment.

### Step 4: Configure SSH keys and the .htaccess.config file:

Ensure that the SSH keys and the .htaccess.config file are correctly configured in the deploy directory of your project.

### Step 5: Build and run the Docker container:
```bash
docker-compose up --build
```

The deployment script will run automatically when the container starts.

## Script Description

The `deploy.sh` script performs the following actions:

1. Changes to the Laravel application directory.
2. Removes the deployment log file if it exists.
3. Installs npm dependencies and builds assets.
4. Installs Composer dependencies.
5. Optimizes the Laravel application.
6. Configures SSH keys and the SSH agent.
7. Replaces the application domain in the .htaccess file.
8. Compresses the application into a .tar.gz file.
9. Transfers the compressed files and the .env.production file to the server.
10. Deploys the application on the server.
11. Removes the compressed file locally.

###  Notes

> Ensure that the production server has the necessary dependencies to run a Laravel application. Review and adjust the `deploy.sh` script according to the specific needs of your project.

## Contributions

Contributions are welcome. Please open an issue or a pull request to discuss any changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.