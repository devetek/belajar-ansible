### for testing only ###

# Gunakan base image Ubuntu 22.04
FROM ubuntu:22.04

# Install SSH server dan sudo
RUN apt-get update && apt-get install -y \
    openssh-server sudo vim \
    && rm -rf /var/lib/apt/lists/*

# Buat user baru (selain root) biar lebih aman
RUN useradd -m -s /bin/bash devuser && echo "devuser:devpass" | chpasswd && adduser devuser sudo

# Konfigurasi SSH (izinkan login root dan user)
RUN mkdir /var/run/sshd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Expose port 22 untuk SSH
EXPOSE 22

# Jalankan SSH server
CMD ["/usr/sbin/sshd", "-D"]
