#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
WHITE='\033[1;37m'
NC='\033[0m' # No color

# Function to update and upgrade the system
update_and_upgrade() {
    echo "Updating and upgrading the system..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        OS=$(uname -s)
    fi

    case $OS in
        ubuntu)
            sudo apt update && sudo apt upgrade -y
            ;;
        centos|almalinux|rhel)
            sudo dnf update -y
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
    echo "System updated and upgraded."
}

# Function to install Apache or HTTPD
install_web_server() {
    echo "Installing web server..."

    case $OS in
        ubuntu)
            sudo apt install apache2 -y
            sudo systemctl enable apache2
            sudo systemctl restart apache2
            ;;
        centos|almalinux|rhel)
            sudo dnf install httpd -y
            sudo systemctl enable httpd
            sudo systemctl restart httpd
            ;;
        *)
            echo "Unsupported OS for web server installation"
            exit 1
            ;;
    esac
    echo "Web server installed."
}

# Function to install MariaDB (MySQL)
install_database() {
    echo "Installing database server..."
    case $OS in
        ubuntu)
            sudo apt install mariadb-server -y
            sudo systemctl enable mariadb
            sudo systemctl start mariadb
            ;;
        centos|almalinux|rhel)
            sudo dnf install mariadb-server -y
            sudo systemctl enable mariadb
            sudo systemctl start mariadb
            ;;
        *)
            echo "Unsupported OS for database server installation"
            exit 1
            ;;
    esac
    echo "Database server installed."
}

# Function to generate random database credentials
generate_credentials() {
    echo "Generating random database credentials..."
    MYSQL_ROOT_PASS=$(openssl rand -base64 12)
    MYSQL_DB=$(openssl rand -hex 8)
    MYSQL_USER=$(openssl rand -hex 8)
    MYSQL_PASS=$(openssl rand -base64 12)

    echo "Generated credentials:"
    echo "MySQL/MariaDB Root Password: $MYSQL_ROOT_PASS"
    echo "WordPress Database Name: $MYSQL_DB"
    echo "WordPress Database User: $MYSQL_USER"
    echo "WordPress Database Password: $MYSQL_PASS"
}

# Function to set up the database for WordPress
setup_database() {
    echo "Setting up the database for WordPress..."

    # Ensure MariaDB is running
    sudo systemctl start mariadb

    # Create WordPress database and user
    sudo mysql -u root -e "CREATE DATABASE $MYSQL_DB;"
    sudo mysql -u root -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASS';"
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost';"
    sudo mysql -u root -e "FLUSH PRIVILEGES;"

    echo "Database setup complete."
}

# Function to install PHP 8.3 and WordPress
install_wordpress() {
    echo "Installing PHP 8.3 and WordPress..."

    # Install PHP 8.3 and required packages
    case $OS in
        ubuntu)
            sudo add-apt-repository ppa:ondrej/php -y
            sudo apt update
            sudo apt install php8.3 php8.3-mysql php8.3-gd php8.3-xml wget unzip -y
            sudo a2dismod php8.0
            sudo a2enmod php8.3
            sudo systemctl restart apache2
            ;;
        centos|almalinux|rhel)
            sudo dnf module reset php -y
            sudo dnf module install php:8.3 -y
            sudo dnf install php php-mysqlnd php-gd php-xml wget unzip -y
            sudo systemctl restart httpd
            ;;
        *)
            echo "Unsupported OS for PHP 8.3 installation"
            exit 1
            ;;
    esac

    # Download and set up WordPress
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    sudo mv wordpress/* /var/www/html/
    sudo chown -R www-data:www-data /var/www/html
    sudo chown -R apache:apache /var/www/html
    rm -rf /var/www/html/index.html
    echo "WordPress installed successfully."

    # Configure wp-config.php
    configure_wp
}

# Function to configure wp-config.php
configure_wp() {
    echo "Configuring wp-config.php with database details..."

    # Copy the sample config file
    sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    # Update wp-config.php with the generated database credentials
    sudo sed -i "s/database_name_here/$MYSQL_DB/" /var/www/html/wp-config.php
    sudo sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wp-config.php
    sudo sed -i "s|password_here|$MYSQL_PASS|" /var/www/html/wp-config.php

    echo "wp-config.php configured successfully."
}

# Main script execution
update_and_upgrade
install_web_server
install_database
generate_credentials
setup_database
install_wordpress

# Output the database details in green and white
echo -e "${GREEN}WordPress installed successfully.${NC}"
echo -e "${WHITE}Setup complete. Here are the details you provided:${NC}"
echo -e "${GREEN}MySQL/MariaDB Root Password: ${WHITE}$MYSQL_ROOT_PASS${NC}"
echo -e "${GREEN}WordPress Database Name: ${WHITE}$MYSQL_DB${NC}"
echo -e "${GREEN}WordPress Database User: ${WHITE}$MYSQL_USER${NC}"
echo -e "${GREEN}WordPress Database Password: ${WHITE}$MYSQL_PASS${NC}"
echo -e "${GREEN}Script execution completed.${NC}"
