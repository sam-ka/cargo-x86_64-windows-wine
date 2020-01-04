# This dockerfile sets up a cross-compilation environment for 
# x86_64-pc-windows-gnu on Debian 9 "Stretch". Rust 1.40.0.
#
# Copyright (C) 2019 Kutometa SPLC
# License: LGPLv3
# https://www.ka.com.kw


# --- Based on debian 9

    FROM debian:stretch

# --- Add i386 architecture to prevent wine from wining.. ;)
# --- Update and download wine and cross-linker

    RUN dpkg --add-architecture i386
    RUN apt update
    RUN apt upgrade -y
    RUN apt install -y wine64 wine32 libwine fonts-wine gcc-mingw-w64-x86-64 wget gpg tar ca-certificates

# --- Add user 'cargo-user' and set as cargo default user and home dir

    RUN adduser --disabled-password --gecos "" cargo-user
    USER cargo-user:cargo-user
    WORKDIR /home/cargo-user

# --- Download needed Rust standalone installers + pgp signatures 

    RUN wget https://static.rust-lang.org/dist/rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz
    RUN wget https://static.rust-lang.org/dist/rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz.asc
    RUN wget https://static.rust-lang.org/dist/rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz
    RUN wget https://static.rust-lang.org/dist/rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz.asc

# --- Set up cargo configuration 
    
    USER cargo-user:cargo-user
    RUN mkdir /home/cargo-user/.cargo
    COPY container-files/cargo-config /home/cargo-user/.cargo/config

# --- Set up gpg keyring and import Rust keys
    
    USER cargo-user:cargo-user
    COPY container-files/rust-signing-key.pub /home/cargo-user/rust-signing-key.pub
    RUN gpg --yes --always-trust --import < rust-signing-key.pub

# --- Verify pgp signatures

    USER cargo-user:cargo-user
    RUN gpg --verify rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz.asc rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz
    RUN gpg --verify rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz.asc rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz

# --- Untar standalone installers

    USER cargo-user:cargo-user
    RUN tar -xzf rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz
    RUN tar -xzf rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz

# --- Run standalone installers

    USER root:root
    RUN cd rust-1.40.0-x86_64-unknown-linux-gnu && ./install.sh
    RUN cd rust-std-1.40.0-x86_64-pc-windows-gnu && ./install.sh

# --- Set up helper (to check for proper usage)

    USER root:root
    COPY container-files/docker-launcher.sh /usr/local/bin/docker-launcher.sh
    RUN chmod +x /usr/local/bin/docker-launcher.sh

# --- Pre-run wine to avoid even more wine wining.. ... ;)

    USER cargo-user:cargo-user
    RUN wine cmd /c rem

# --- Cleaning up

    USER root:root
    RUN apt clean
    RUN rm -r rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz.asc
    RUN rm -r rust-1.40.0-x86_64-unknown-linux-gnu.tar.gz
    RUN rm -r rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz.asc
    RUN rm -r rust-std-1.40.0-x86_64-pc-windows-gnu.tar.gz
    RUN rm -r rust-1.40.0-x86_64-unknown-linux-gnu
    RUN rm -r rust-std-1.40.0-x86_64-pc-windows-gnu

# --- Entry point
    
    USER cargo-user:cargo-user
    ENTRYPOINT ["docker-launcher.sh"]
    

