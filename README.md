
# DIPAS Docker

This project provides a Test Docker setup for the DIPAS (Digital Participation System). The docker-compose.yml was created for initial setup and installation of DIPAS.
For the moment there is only a setup for the DIPAS Community Version (dipas-3.3.1-navigator-3.1.1). A Setup for DIPAS Public Version will be added soon.


## Steps to Get Started

Make sure that you have docker and docker-compose installed 

### Step 1: Clone the Repository
Clone the repository to your host machine:

```bash
git clone https://github.com/matlendzi/dipas_docker.git
```

### Step 2: Customize Configuration Files
- Edit the `.env` file to suit your environment.
- Customize the `./config/apache/yourdomain.de.conf` file with the settings for your domain.
- OPTIONAL: Customize the `./config/drupal/drupal.services.yml` and `./config/drupal/settings.php` file to your needs 


### Step 3: Download the Latest DIPAS Community Version
Download the dipas-3.3.1-navigator-3.1.1.zip version of the **DIPAS Community** as a ZIP file from the [official Bitbucket repository](https://bitbucket.org/geowerkstatt-hamburg/dipas_community/downloads/).


Place the downloaded ZIP file in the `dipas_community_version` folder on your host.

### Step 4: Build and Run the Docker Containers
Run the following command to build the Docker containers and start the services:

```bash
cd dipas_community_version
docker-compose up --build
```

### Step 5: Wait for the Installation to Complete
The installation process, configuration import, and cache rebuild will take some time. Please wait until it's complete.


### Step 6: Access the DIPAS Application
Once the installation is complete, you can log in to the DIPAS system at:

```
http://yourhost.de/drupal
```
### Step 7: Create DIPAS Template Proceeding (default)
Go to --> DIPAS --> Proceedings --> Proceedings and "+ Add Proceeding". In the Interface click on "speichern". The default proceeding is your template from which all new proceedings will be build up.

### Step 8: Administer DIPAS Template Proceeding
Follow these steps: https://wiki.dipas.org/index.php/Verfahrensvorlage_erstellen#Technische_Vorarbeiten

### Step 8: Create DIPAS Test Proceeding
Go to --> DIPAS --> Proceedings --> Proceedings and "+ Add Proceeding". In the Interface type hostname e.g "test" (this will be the subdomain of your new proceeding) and name of your proceeding, e.g. "test". click speichern.

### Step 9: Access your Test Proceeding
go to test.yourdomain.de/drupal and finalize the configuration of your proceeding or go to test.yourdomain.de to see the frontend.


