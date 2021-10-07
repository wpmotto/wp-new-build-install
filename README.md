# Install WordPress New Build

Script for scaffolding and starting a new WP project. 

## Requirements
Have a WordPress server set up with your database credentials ready, the script will need them for the installation. 

## Usage
Create a directory for your site and run this in your directory that will serve your WordPress installation:
```bash
wget -O - https://raw.githubusercontent.com/wpmotto/wp-new-build-install/master/install.sh | bash
```

## Versioning
Although this script will set your project up for versioning, it doesn't init the actual repo in `./wp-content`. You will need to do that yourself once you're ready. However you can just follow the standard instructions for a new repo and make sure it's done in the wp-content dir. 

## Further Setup
You'll need to update the URL for browser syncing if you are to use `yarn start` in your webpack file `.browserSync('https://sandbox.test');`

### Sample Data
It's usually useful to begin development with some sample data. Use the following to generate some content. 

- Install [wp-cli faker](https://github.com/Yoast/wp-cli-faker) `wp package install git@github.com:Yoast/wp-cli-faker.git`
- `wp faker core content`
