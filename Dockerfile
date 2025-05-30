# Use official MySQL image
FROM mysql:8

# Copy all SQL scripts into the init directory
COPY database/ /docker-entrypoint-initdb.d/
