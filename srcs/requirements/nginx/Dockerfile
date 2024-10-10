# Dockerfile contains instructions to build the image. Each instruction creates a new layer in the image

# Specify the base image for the container
# Debian is an operating system, but in Docker, it is packaged as an image (a minimal version of the OS) that you can use to build containers. It is not the full OS like you would install on a physical machine or virtual machine.
FROM debian:buster

# install nginx(A web server used to serve web content)
RUN apt update -y && apt upgrade -y
RUN apt install nginx -y

# Optional: Including vim makes it easier to edit inside the container, but it increases the image size.
RUN apt install vim -y

# create a directory to stock the TSL/SSL certificate, which will be used for secure communication (HTTPS)
# HTTP stands for HyperText Transfer Protocol, which is the protocol used by web browsers and servers to communicate and transfer information over the internet. HTTPS (S: Secure, indicating that communication is encrypted using TLS or formerly SSL) 
RUN mkdir -p /etc/nginx/ssl

# install toolkit OpenSSL that creates/manages TSL/SSL certificate
RUN apt install OpenSSL -y

# Generate certificate and private key using OpenSSL
# -x509 flag creates a certificate. -nodes flag ensures that the private key won't be encrypted, allowing Nginx to start  without a passphrase
# -subj flag specifies certificate details in a single command to avoid prompts during generation
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/0=42/OU=42/CN=login.42.fr/UID=login"

# create a runtime directory for Nginx to stock runtime files like process IDs or socket files, especially if the custom configuration file references this directory
RUN mkdir -p /var/run/nginx

# copy custom Nginx configuration file (nginx.conf) from local system to the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wd_data
RUN chmod 755 /var/www/wd_data
#In Linux systems, www-data is a user and group that is commonly created when you install a web server like Nginx. The www-data user is the low-privilege user that the web server process (like Nginx or Apache) runs as.
#Imagine you’re hosting a WordPress website using Nginx, and all your website files are stored in /var/www/wd_data. Nginx needs permission to access those files to serve them to website visitors. By setting the ownership to www-data:www-data, you’re giving Nginx the proper permissions to do this securely.
#Without this: If the files were owned by root or another user, Nginx (running as www-data) might not have the proper permissions to access and serve these files, which would result in errors.
#With this: Nginx can now serve files, process PHP scripts, and access everything it needs in the web directory, but other users on the system won’t have access unless they are part of the www-data group.
RUN chown -R www-data:www-data /var/www/wd_data

# store the command `nginx -g daemon off;` in the image. Whenever we create a container, this cmd will run
# cmd: Start Nginx when the container starts, "-g" "daemon off;" flag keeps Nginx running in the foreground as the main process of the container
CMD [ "nginx", "-g", "daemon off;" ]
