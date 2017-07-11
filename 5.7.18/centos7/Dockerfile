FROM samloh84/centos:7

ARG VENDOR=oracle
ARG PRODUCT=mysql
ARG PRODUCT_VERSION=5.7.18
ARG TEMP_DIR_ROOT=/tmp/${VENDOR}-${PRODUCT}
ARG TEMP_DIR=${TEMP_DIR_ROOT}/${PRODUCT_VERSION}
ARG INSTALL_DIR=/usr/local/mysql

ARG MYSQL_BINARIES_TAR_URL="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz"
ARG MYSQL_BINARIES_TAR=mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz
ARG MYSQL_BINARIES_TAR_MD5SUM=ebc8cbdaa9c356255ef82bd989b07cfb
ARG MYSQL_BINARIES_TAR_ASC_URL="https://dev.mysql.com/downloads/gpg/?file=mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz"
ARG MYSQL_BINARIES_TAR_ASC=mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz.asc
ARG MYSQL_GPG_KEYS="5072E1F5"

ARG MYSQL_UID=1001
ARG MYSQL_GID=1001
ARG MYSQL_USERNAME=mysql
ARG MYSQL_GROUPNAME=mysql
ARG MYSQL_DATA_DIR=/var/lib/mysql

ENV APP_UID ${MYSQL_UID}
ENV APP_GID ${MYSQL_GID}
ENV APP_USERNAME ${MYSQL_USERNAME}
ENV APP_GROUPNAME ${MYSQL_GROUPNAME}
ENV MYSQL_DATA_DIR ${MYSQL_DATA_DIR}

USER ${ROOT_UID}

COPY ./entrypoint.sh ${TEMP_DIR}/

RUN \
set -x && \
mkdir -p ${INSTALL_DIR} ${MYSQL_DATA_DIR} && \
groupadd --gid ${MYSQL_GID} ${MYSQL_GROUPNAME} && \
useradd --uid ${MYSQL_UID} --gid ${MYSQL_GID} \
--no-create-home \
--home-dir ${INSTALL_DIR} \
--shell /sbin/nologin \
--comment "MySQL User" \
${MYSQL_USERNAME} && \
yum-install libaio && \
TEMP_DIR=/tmp/${VENDOR}-${PRODUCT}/${PRODUCT_VERSION} && \
pushd ${TEMP_DIR} && \
curl -LjSs ${MYSQL_BINARIES_TAR_URL} -o ${MYSQL_BINARIES_TAR} && \
curl -LjSs ${MYSQL_BINARIES_TAR_ASC_URL} -o ${MYSQL_BINARIES_TAR_ASC} && \
for MYSQL_GPG_KEY in ${MYSQL_GPG_KEYS}; do gpg --keyserver pgp.mit.edu --recv-keys ${MYSQL_GPG_KEY}; done && \
gpg --verify ${MYSQL_BINARIES_TAR_ASC} ${MYSQL_BINARIES_TAR} && \
echo "${MYSQL_BINARIES_TAR_MD5SUM}  ${MYSQL_BINARIES_TAR}" | md5sum -c - && \
tar -xf ${MYSQL_BINARIES_TAR} --strip-components=1 -C ${INSTALL_DIR} && \
mv ${TEMP_DIR}/entrypoint.sh ${INSTALL_DIR}/entrypoint.sh && \
chmod +x ${INSTALL_DIR}/entrypoint.sh && \
fix-ownership ${INSTALL_DIR} ${MYSQL_DATA_DIR} && \
fix-permissions ${INSTALL_DIR} ${MYSQL_DATA_DIR} && \
popd && \
rm -rf ${TEMP_DIR_ROOT}

ENV MYSQL_HOME ${INSTALL_DIR}
ENV PATH ${MYSQL_HOME}/bin:${PATH}
ENV MYSQL_DATA_DIR ${MYSQL_DATA_DIR}

USER ${MYSQL_UID}

WORKDIR ${INSTALL_DIR}

EXPOSE 3306

CMD ./entrypoint.sh
