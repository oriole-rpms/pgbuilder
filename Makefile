AUTOMAKEVERSION ?= $(shell automake --version | sed -n '1{s/.* //;p}' | grep -oE '[0-9]+\.[0-9]+')
BISONVERSION ?= 2.3
FLEXVERSION ?= 2.5.39

HW := $(shell uname -m)

all: install

install: buildtools bison flex

bison:
	cd $(shell mktemp -d) && curl http://ftp.gnu.org/gnu/bison/bison-$(BISONVERSION).tar.gz -O && tar -xvzf bison-$(BISONVERSION).tar.gz && cd bison-$(BISONVERSION) && ln -sf /usr/share/automake-$(AUTOMAKEVERSION)/config.guess ./build-aux/config.guess && ./configure --prefix=/usr/local/bison --with-libiconv-prefix=/usr/local/libiconv/ && make all install

flex:
	cd $(shell mktemp -d) && curl -L http://prdownloads.sourceforge.net/flex/flex-$(FLEXVERSION).tar.gz?download -o flex-$(FLEXVERSION).tar.gz && tar -xvzf flex-$(FLEXVERSION).tar.gz && cd flex-$(FLEXVERSION) && ./configure --prefix=/usr/local/flex && make all install

buildtools: linux-buildtools

linux-buildtools:
	dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
	if [ "${HW}" = "aarch64" ]; then\
	  curl https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-AARCH64-RHEL -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-AARCH64-RHEL;\
	fi
	dnf install -y curl epel-release coreutils-single grep readline-devel libicu-devel \
	   clang-devel \
	   e2fsprogs-devel \
	   krb5-devel \
	   libselinux-devel \
	   libuuid-devel \
	   libxml2-devel \
	   libxslt-devel \
	   llvm-devel \
	   lz4-devel \
	   openldap-devel \
	   openssl-devel \
	   pam-devel \
	   perl \
	   perl-ExtUtils-Embed \
	   python3-devel \
	   selinux-policy \
	   systemd-devel \
	   systemtap-sdt-devel \
	   tcl-devel \
	   pgdg-srpm-macros
	dnf -y install --enablerepo=powertools hdf5
	dnf install -y --nogpgcheck curl vim epel-release dos2unix bc rpmdevtools rpm-build
	dnf --enablerepo=powertools install -y perl-IPC-Run hdf5-devel
	dnf groupinstall -y "Development Tools"
