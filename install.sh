#!/usr/bin/env bash

# Exit if command fails
set -e

# Set variables
RED='\033[0;31m'
NC='\033[0m' # No Color

projectslug=${PWD##*/} 
projecttld=".test"
projecturl="$projectslug$projecttld"
authorname="$(git config user.name)"
authoremail="$(git config user.email)"
wprootdir=$(PWD)
wpcontentdir="$wprootdir/wp-content"

# # Collect project info
echo "What is the public facing title of your project?"
read projecttitle < /dev/tty

echo "Enter your WordPress database name:"
read wpdbname < /dev/tty

echo "Enter your WordPress database user:"
read wpdbuser < /dev/tty

echo "Enter your WordPress database password:"
read wpdbpass < /dev/tty

echo "Enter your WordPress ACF License Pro Key:"
read acfkey < /dev/tty

wp core download
wp config create --dbname=$wpdbname --dbuser=$wpdbuser --dbpass=$wpdbpass --dbhost=127.0.0.1  --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

wp core install --url=$projecturl --title="$projecttitle" --admin_user=admin --admin_email=$authoremail --admin_password=admin

echo -e "Username: ${RED}admin${NC} / Password: ${RED}admin${NC}"

wget https://raw.githubusercontent.com/wpmotto/wp.ignore/master/.gitignore -O wp-content/.gitignore
echo "!/themes/$projectslug" >> wp-content/.gitignore
wget https://raw.githubusercontent.com/wpmotto/wp-sync-cli/master/current/migrate.sh -O wp-content/migrate.sh

# Setup MU-PLUGINS
mkdir wp-content/mu-plugins
cd wp-content/mu-plugins

## Install Kinsta mu plugin
wget https://kinsta.com/kinsta-tools/kinsta-mu-plugins.zip
unzip kinsta-mu-plugins.zip
rm kinsta-mu-plugins.zip

# Install SAGE
cd $wpcontentdir
cd themes
curl -LSs https://github.com/wpmotto/wp-starter-theme/archive/master.zip > sage-master.zip
unzip sage-master.zip
mv sage-master $projectslug
rm sage-master.zip
cd $projectslug
composer install
yarn && yarn build
wp theme activate $projectslug

# Init a Readme
echo "# $projecttitle" > "$wpcontentdir/README.md"

# Install Plugins
wp plugin install formidable --activate
wp plugin install seo-by-rank-math --activate
wp plugin install https://github.com/roots/soil/archive/refs/heads/main.zip --activate
[ ! -z "$acfkey" ] && wp plugin install "https://connect.advancedcustomfields.com/v2/plugins/download?p=pro&k=$acfkey" --activate
