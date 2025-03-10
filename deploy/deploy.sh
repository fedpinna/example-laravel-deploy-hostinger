#!/bin/bash
set -e

echo "Starting deployment process ..."

cd /laravel_app

LOG_FILE=deploy.log

# Remove log file if exists
if [ -f $LOG_FILE ]; then
    rm $LOG_FILE
fi

export PATH=/root/.config/herd-lite/bin:/root/.local/share/fnm/node-versions/v22.14.0/installation/bin:$PATH

# Install npm dependencies and build assets
echo "Install npm dependencies ..." | tee -a "$LOG_FILE"
npm install >> $LOG_FILE 2>&1

# Install composer dependencies
echo "Install composer dependencies ..." | tee -a "$LOG_FILE"
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader >> $LOG_FILE 2>&1

# Optimize Laravel
echo "Optimizing Laravel ..." | tee -a "$LOG_FILE"
php artisan optimize >> $LOG_FILE 2>&1

# Build assets
echo "Building assets ..." | tee -a "$LOG_FILE"
npm run build >> $LOG_FILE 2>&1

chmod 600 /deploy/id_rsa
chmod 644 /deploy/id_rsa.pub

# Get key of server and add to known_hosts
ssh-keyscan -p $SSH_PORT -H $SERVER_IP >> ~/.ssh/known_hosts 2>> $LOG_FILE

# Initialize ssh-agent
eval "$(ssh-agent -s)" >> $LOG_FILE 2>&1

# Add private key to ssh-agent
ssh-add /deploy/id_rsa >> $LOG_FILE 2>&1

# Replace APP_DOMAIN in .htaccess and copy to public folder
sed "s/APP_DOMAIN/$APP_DOMAIN/g" /deploy/.htaccess.config >> /laravel_app/.htaccess

# Name of the deployment with timestamp
DEPLOY_TIMESTAMP="deploy_$(date +%Y-%m-%d_%H-%M-%S)"

# Compress the application
echo "Compresing aplication ..." | tee -a "$LOG_FILE"
tar --exclude="node_modules" -cf "$DEPLOY_TIMESTAMP.tar.gz" *    

# Transfer files to server
echo "Transfering files to server ..." | tee -a "$LOG_FILE"
scp -P $SSH_PORT "$DEPLOY_TIMESTAMP.tar.gz" \
    "$SSH_USER@$SERVER_IP:/home/$SSH_USER/domains/$APP_DOMAIN"

# Transfer .env file to server public_html folder
scp -P $SSH_PORT /deploy/.env.production \
    $SSH_USER@$SERVER_IP:/home/$SSH_USER/domains/$APP_DOMAIN/public_html/.env

# Deploy the application
echo "Deploying application ..." | tee -a "$LOG_FILE"
ssh -p $SSH_PORT $SSH_USER@$SERVER_IP \
    "cd /home/$SSH_USER/domains/$APP_DOMAIN/public_html && rm -rf * ; \
    tar -xf ../$DEPLOY_TIMESTAMP.tar.gz -C ../public_html/ ; \
    php artisan config:clear >> $LOG_FILE 2>&1 && \
    php artisan config:cache >> $LOG_FILE 2>&1"

rm "$DEPLOY_TIMESTAMP.tar.gz"

echo "Deployment finished!"

