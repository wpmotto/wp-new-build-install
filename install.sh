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
read projecttitle

echo "Enter your WordPress database name:"
read wpdbname

echo "Enter your WordPress database user:"
read wpdbuser

echo "Enter your WordPress database password:"
read wpdbpass

echo "This project uses a private key for the Metabox package. Please enter it now:"
read METABOX_KEY

# Cleanup initial repo
rm -rf ./README.md ./.git

wp core download
wp config create --dbname=$wpdbname --dbuser=$wpdbuser --dbpass=$wpdbpass
wp core install --url=$projecturl --title="$projecttitle" --admin_user=admin --admin_email="$authorname" --admin_password=admin

echo -e "Username: ${RED}admin${NC} / Password: ${RED}admin${NC}"

mv wp-content wp-content.fresh
git clone git@github.com:wpmotto/wp-fresh-skeleton.git wp-content

# Setup MU-PLUGINS
cd wp-content/mu-plugins

read -p "Will this reside on a Kinsta server? (y/n)" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
kinstaserver=false
then
kinstaserver=true
curl -sS https://kinsta.com/kinsta-tools/kinsta-mu-plugins.zip > kinsta-mu-plugins.zip
unzip kinsta-mu-plugins.zip
rm kinsta-mu-plugins.zip
fi

cd data-structure
composer install

# Install SAGE
cd $wpcontentdir
mkdir themes
cd themes
curl -LSs https://github.com/wpmotto/sage/archive/master.zip > sage-master.zip
unzip sage-master.zip
mv sage-master $projectslug
rm sage-master.zip
cd $projectslug
composer install
yarn && yarn build
wp theme activate $projectslug

# Cleanup
cd $wprootdir
rm install.sh
