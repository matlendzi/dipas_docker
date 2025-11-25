#!/bin/bash

# Marker to check if drupal was installed already
MARKER="/var/www/html/dipas/htdocs/drupal/sites/default/files/.drupal_installed"

# Check if folder exists (idempotent)
mkdir -p /var/www/html/dipas/htdocs/drupal/sites/default/files || true

# Ensure DRUPAL_SITE_DOMAIN is set and configure ServerName
if [ -z "$DRUPAL_SITE_DOMAIN" ]; then
    echo "Error: DRUPAL_SITE_DOMAIN is not set. Exiting."
    exit 1
else
    echo "ServerName $DRUPAL_SITE_DOMAIN" >> /etc/apache2/apache2.conf
fi

# ===== Marker-Shortcuts: wenn Marker existiert -> direkt Runtime-Path, keine DB-Checks/Install =====
if [ -f "$MARKER" ]; then
    echo "Marker file present ($MARKER). Skipping any installation or DB checks."

    # Substitute environment variables into settings.php and drupal.services.yml (wie gehabt)
    envsubst '${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${DB_HOST} ${DB_PORT} ${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/htdocs/drupal/sites/default/settings.php > /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php
    envsubst '${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/config/drupal.services.yml > /var/www/html/dipas/config/drupal.services.tmp.yml
    mv /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php /var/www/html/dipas/htdocs/drupal/sites/default/settings.php
    mv /var/www/html/dipas/config/drupal.services.tmp.yml /var/www/html/dipas/config/drupal.services.yml

    # Create temporary directory for Drupal
    mkdir -p /var/www/html/tmp && chown www-data:www-data /var/www/html/tmp && chmod 777 /var/www/html/tmp

    # Set correct file permissions
    chown -R www-data:www-data /var/www/html/dipas/htdocs/drupal \
        && chmod 444 /var/www/html/dipas/htdocs/drupal/.htaccess \
        && chmod 644 /var/www/html/dipas/htdocs/drupal/sites/default/settings.php \
        && chmod 644 /var/www/html/dipas/config/drupal.services.yml \
        && chmod 644 /var/www/html/dipas/config/drupal.reverse-proxy-settings.php \
        && chmod -R 755 /var/www/html/dipas/htdocs/drupal/sites/default/files

    echo "DIPAS setup is ready!"
    exec "$@"
fi
# ===== Ende Marker-Shortcut =====

# Check if the admin user exists
if PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -U "${DB_USER}" -d "${DB_NAME}" -c "SELECT 1 FROM users_field_data WHERE name = '${DRUPAL_ADMIN_USER}';" | grep -q "1"; then
    echo "Admin user '${DRUPAL_ADMIN_USER}' exists."
    echo "Skipping Drupal installation."

    # Substitute environment variables into settings.php and drupal.services.yml
    envsubst '${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${DB_HOST} ${DB_PORT} ${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/htdocs/drupal/sites/default/settings.php > /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php
    envsubst '${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/config/drupal.services.yml > /var/www/html/dipas/config/drupal.services.tmp.yml
    mv /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php /var/www/html/dipas/htdocs/drupal/sites/default/settings.php
    mv /var/www/html/dipas/config/drupal.services.tmp.yml /var/www/html/dipas/config/drupal.services.yml

    # Create temporary directory for Drupal
    mkdir -p /var/www/html/tmp && chown www-data:www-data /var/www/html/tmp && chmod 777 /var/www/html/tmp

    # Set correct file permissions
    chown -R www-data:www-data /var/www/html/dipas/htdocs/drupal \
        && chmod 444 /var/www/html/dipas/htdocs/drupal/.htaccess \
        && chmod 644 /var/www/html/dipas/htdocs/drupal/sites/default/settings.php \
        && chmod 644 /var/www/html/dipas/config/drupal.services.yml \
        && chmod 644 /var/www/html/dipas/config/drupal.reverse-proxy-settings.php \
        && chmod -R 755 /var/www/html/dipas/htdocs/drupal/sites/default/files

    # Marker setzen, damit künftige Starts die DB gar nicht mehr anfassen
    touch "$MARKER"

    echo "DIPAS setup is ready!"
    exec "$@"
else
    echo "Admin user '${DRUPAL_ADMIN_USER}' does not exist. Proceeding with setup..."

    # Substitute environment variables into settings.php and drupal.services.yml
    envsubst '${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${DB_HOST} ${DB_PORT} ${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/htdocs/drupal/sites/default/settings.php > /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php
    envsubst '${DRUPAL_SITE_DOMAIN}' < /var/www/html/dipas/config/drupal.services.yml > /var/www/html/dipas/config/drupal.services.tmp.yml
    mv /var/www/html/dipas/htdocs/drupal/sites/default/settings.tmp.php /var/www/html/dipas/htdocs/drupal/sites/default/settings.php
    mv /var/www/html/dipas/config/drupal.services.tmp.yml /var/www/html/dipas/config/drupal.services.yml

    # Create temporary directory for Drupal
    mkdir -p /var/www/html/tmp && chown www-data:www-data /var/www/html/tmp && chmod 777 /var/www/html/tmp

    # Set correct file permissions
    chown -R www-data:www-data /var/www/html/dipas/htdocs/drupal \
        && chmod 444 /var/www/html/dipas/htdocs/drupal/.htaccess \
        && chmod 644 /var/www/html/dipas/htdocs/drupal/sites/default/settings.php \
        && chmod 644 /var/www/html/dipas/config/drupal.services.yml \
        && chmod 644 /var/www/html/dipas/config/drupal.reverse-proxy-settings.php \
        && chmod -R 755 /var/www/html/dipas/htdocs/drupal/sites/default/files

    # Run Drush installation and other necessary commands
    cd /var/www/html/dipas/htdocs
    su www-data -s /bin/bash -c "vendor/bin/drush site-install --db-url=pgsql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME} \
    --account-name=${DRUPAL_ADMIN_USER} --account-pass=${DRUPAL_ADMIN_PASS} \
    --site-name='${DRUPAL_SITE_NAME}' --yes --existing-config"

    # Enable locale module before importing translations
    su www-data -s /bin/bash -c "vendor/bin/drush pm-enable locale -y"

    # Import translation files
    su www-data -s /bin/bash -c "vendor/bin/drush locale:import de /var/www/html/dipas/config/de.po --type=not-customized"
    su www-data -s /bin/bash -c "vendor/bin/drush locale:import de /var/www/html/dipas/htdocs/drupal/modules/custom/dipas_stories/files/translations/dipas_stories.de.po --type=not-customized"
    su www-data -s /bin/bash -c "vendor/bin/drush locale:import de /var/www/html/dipas/htdocs/drupal/modules/custom/dipas/files/translations/dipas.de.po --type=not-customized"
    su www-data -s /bin/bash -c "vendor/bin/drush locale:import de /var/www/html/dipas/htdocs/drupal/modules/custom/masterportal/files/translations/masterportal.de.po --type=not-customized"

    # Apply translation updates
    su www-data -s /bin/bash -c "vendor/bin/drush locale:check"
    su www-data -s /bin/bash -c "vendor/bin/drush locale:update"

    # Set correct file permissions after Drush install
    chmod 555 /var/www/html/dipas/htdocs/drupal/sites/default \
        && chmod 444 /var/www/html/dipas/htdocs/drupal/sites/default/settings.php

    # Rebuild caches
    su www-data -s /bin/bash -c "vendor/bin/drush cache-rebuild"

    # Marker setzen – ab jetzt keine Neuinstallation mehr
    touch "$MARKER"

    echo "DIPAS setup is ready!"
fi

# Execute the main CMD (start Apache)
exec "$@"