This Linux container provides a self-contained version of `cargo` that is
capable of compiling and running Rust projects for `x86_64-pc-windows-gnu`.
This container uses wine to automatically run compiled executables 
and test harnesses.

Design
------

This container is designed to act as a drop in version of cargo that
only targets `x86_64-pc-windows-gnu`. Aside from automatically injecting 
a `--target` flag and the caveats listed bellow, this container 
supports common usage patterns such as:


```bash
CONTAINER build --release
CONTAINER run
CONTAINER test TEST-NAME
```

`run` and `test` sub-commands run binaries in wine without user intervention.

Caveats
-------

* By default, the container cannot access the filesystem beyond the current working directory.
* By default, Standard IO does not behave identically to native IO. See pitfalls bellow.
* By default, no caching for remote crates is preformed.



Obtaining This Container
------------------------

To obtain this container, you have two options:

* Obtain a prebuilt image from dockerhub
* Build the container from scratch

Dockerhub containers are tied to the version of Rust they ship. 
The major and minor components of the tag correspond directly to their Rust counterparts. 
The patch component is independent of Rust's version, and is used to reflect the version 
of the container instead. For example, `kutometa/cargo-x86_64-windows-wine:1.40.1` is the second version
of an image that ships Rust version 1.40.X.

Instructions on how to build the container are detailed bellow. Instructions on how to run the container follow.


Building This Container
-----------------------

This container is built on top of Debian 9 "Stretch".  During the build process, several 
remote resources must be fetched from the internet. Each of these resource are 
verified against a prepinned public key or a prepinned cryptographic hash. 

These remote resources are:

1. Several packages from Debian's official repositories.
2. A standalone Rust toolchain installer from Rust's official website.
3. A standalone Rust library Installer from Rust's official website. 

To build this container, you have two options. You can either use `docker build` or `make build`. 
If you use `make`, the resulting container image is automatically 
named `kutometa/cargo-x86_64-windows-wine:local` and tested.

Running This Container
----------------------

If docker was used to build the container locally, the container can 
be invoked by issuing the following command:

````bash
docker run -ti --rm \
    -v <CRATE-DIR>:/crate \
    kutometa/cargo-x86_64-windows-wine:local \
    <CARGO-CMD> \
    <ARGS> ...
````

Alternatively, if the container was built using make, a launcher script can be installed on your system using `make install`. Once installed, 
the container can be launched by running `cargo-x86_64-windows-wine-local`:

```bash
cargo-x86_64-windows-wine-local  build
cargo-x86_64-windows-wine-local  test
```

Common Pitfalls
---------------

1. When `docker` is allocated a pseudoterminal (pty),
   an extra carriage return (U+0D) is inserted before the end of each line. Do 
   not include `-t` if unmodified io streams are required.

2. This container can only target `x86_64-pc-windows-gnu` and 
   nothing else.

Copyright
---------
جميع الحقوق المتعلقة في هذا العمل محفوظة لشركة كوتوميتا لبرمجة وتشغيل الكمبيوتر وتصميم وإدارة مواقع الإنترنت (ش.ش.و). سنة النشر ٢٠٢٠.

Copyright (C) 2020 Kutometa SPLC, Kuwait. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the third version of the GNU Lesser General 
Public License as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Lesser General Public 
License along with this work; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.


Links
-----

* Github: https://github.com/sam-ka/cargo-x86_64-windows-wine

* Docker: https://hub.docker.com/r/kutometa/cargo-x86_64-windows-wine


