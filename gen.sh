#!/bin/bash

# Variables
SSL_PATH="/ssl/certs"

# Menu
echo "========================================================"
echo " Certificates Bash Script"
echo "========================================================"
echo "1. Crear certificado raiz"
echo "2. Crear certificado intermedio"
echo "3. Crear certificado final"
echo "4. Ver certificados generados"
echo "========================================================"
read -p "Selecciona una opcion: " option

# Funciones
create_root_cert() {
    echo ""
    read -p "Escribe el nombre comun (CN): " cn
    read -p "Escribe la razon (O): " o
    read -p "Escribe la Organización (OU): " ou
    read -p "Escribe el pais (C): " c
    read -p "Escribe la duracion del certificado (days): " days
    openssl req -config openssl.cnf -x509 -newkey rsa:2048 -keyout ${SSL_PATH}/ca.key -out ${SSL_PATH}/ca.crt -nodes -days ${days} -subj "/C=${c}/O=${o}/OU=${ou}/CN=${cn}"
}

create_intermediate_cert() {
    echo ""
    read -p "Escribe el nombre comun (CN): " cn
    read -p "Escribe la razon (O): " o
    read -p "Escribe la Organización (OU): " ou
    read -p "Escribe el pais (C): " c
    read -p "Escribe la duracion del certificado (days): " days
    openssl req -config openssl.cnf -newkey rsa:2048 -keyout ${SSL_PATH}/intermediate.key -out ${SSL_PATH}/intermediate.csr -nodes -days ${days} -subj "/C=${c}/O=${o}/OU=${ou}/CN=${cn}"
    openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days ${days} -notext -md sha256 -in ${SSL_PATH}/intermediate.csr -out ${SSL_PATH}/intermediate.crt
    cat ${SSL_PATH}/ca.crt ${SSL_PATH}/intermediate.crt > ${SSL_PATH}/ca-chain.crt
}

create_final_cert() {
    echo ""
    read -p "Escribe el nombre comun (CN): " cn
    read -p "Escribe la razon (O): " o
    read -p "Escribe la Organización (OU): " ou
    read -p "Escribe el pais (C): " c
    read -p "Escribe la duracion del certificado (days): " days
    openssl req -config openssl.cnf -newkey rsa:2048 -keyout ${SSL_PATH}/final.key -out ${SSL_PATH}/final.csr -nodes -days ${days} -subj "/C=${c}/O=${o}/OU=${ou}/CN=${cn}"
    openssl ca -config openssl.cnf -extensions server_cert -days ${days} -notext -md sha256 -in ${SSL_PATH}/final.csr -out ${SSL_PATH}/final.crt
}

# Opciones
case $option in
    1)
        create_root_cert
        ;;
    2)
        create_intermediate_cert
        ;;
    3)
        create_final_cert
        ;;
    4)
        ls -l ${SSL_PATH}
        ;;
    *)
        echo "Opcion no valida"
        ;;
esac
