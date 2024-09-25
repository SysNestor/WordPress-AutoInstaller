# WordPress Installation Script

This script automates the installation and configuration of a WordPress environment on various Linux distributions. It handles the following:

- System update and upgrade
- Installation of necessary packages
- Web server setup (Apache for Ubuntu, HTTPD for CentOS/AlmaLinux/RHEL)
- MariaDB server installation and configuration
- PHP 8.3 installation
- WordPress installation and configuration
- Database setup and configuration

## Supported Operating Systems

- **Ubuntu**
- **CentOS**
- **AlmaLinux**
- **RHEL**

## Prerequisites

- A Linux-based operating system (one of the supported distributions)
- Root or sudo access

## Features

- **Update and Upgrade**: Updates and upgrades the system packages.
- **Web Server**: Installs Apache on Ubuntu/Debian or HTTPD on CentOS/AlmaLinux/RHEL.
- **Database Server**: Installs MariaDB and configures it for WordPress.
- **PHP 8.3**: Installs PHP 8.3 and necessary extensions.
- **WordPress**: Downloads, installs, and configures WordPress.
- **Permissions**: Sets appropriate file permissions for the web server.

## Usage

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/yourusername/your-repo-name.git
    cd your-repo-name
    ```

2. **Make the Script Executable**:
    ```bash
    chmod +x WordPress-AutoInstaller.sh
    ```

3. **Run the Script**:
    ```bash
    sudo ./WordPress-AutoInstaller.sh
    ```

## Script Details

### Update and Upgrade

The script updates and upgrades the system packages based on the detected OS:

- **Ubuntu**: Uses `apt` for package management.
- **CentOS/AlmaLinux/RHEL**: Uses `dnf` for package management.

### Web Server Installation

- **Ubuntu**: Installs and configures Apache.
- **CentOS/AlmaLinux/RHEL**: Installs and configures HTTPD.

### Database Server Installation

- **Ubuntu**: Installs and configures MariaDB.
- **CentOS/AlmaLinux/RHEL**: Installs and configures MariaDB.

### PHP 8.3 Installation

Installs PHP 8.3 along with required extensions:

- `php8.3-mysql`
- `php8.3-gd`
- `php8.3-xml`

### WordPress Installation

- Downloads and extracts the latest WordPress.
- Moves the files to the web server’s root directory.
- Sets appropriate ownership based on the detected OS.

### Permissions and Configuration

- **Ubuntu**: Sets file ownership to `www-data:www-data`.
- **CentOS/AlmaLinux/RHEL**: Sets file ownership to `apache:apache`.

Configures `wp-config.php` with generated database credentials.

## Troubleshooting

- **`chown: invalid user` Error**: Ensure the correct user and group for the web server are used (e.g., `apache` for CentOS/AlmaLinux/RHEL).
- **FTP Credentials Prompt**: Ensure WordPress has direct access to the file system by setting `FS_METHOD` to `direct` in `wp-config.php`.

## License

This script is provided as-is. Use it at your own risk. 

Feel free to contribute or make improvements. For issues or enhancements, please open an issue on the GitHub repository.

## Contact

For any questions or feedback, please contact [git@sysnestor.com](mailto:git@sysnestor.com).
