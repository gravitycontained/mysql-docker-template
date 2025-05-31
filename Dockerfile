# Use official MySQL image
FROM mysql:8.0

# Set the authentication plugin in a config file
COPY .cnf /etc/mysql/conf.d/.cnf

# Copy SQL files into init folder
COPY database/ /docker-entrypoint-initdb.d/
