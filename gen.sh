#!/bin/bash

# Función para generar una clave privada raíz
generar_clave_raiz () {
  echo -e "\nGenerando clave privada raíz...\n"
  openssl genrsa -des3 -out ca.key 4096
  echo -e "\nClave privada raíz generada\n"
}

# Función para generar una solicitud de firma de certificado
generar_solicitud_csr () {
  echo -e "\nGenerando solicitud de firma de certificado...\n"
  openssl req -new -key ca.key -out ca.csr
  echo -e "\nSolicitud de firma de certificado generada\n"
}

# Función para generar un certificado raíz
generar_certificado_raiz () {
  echo -e "\nGenerando certificado raíz...\n"
  openssl x509 -req -days 3650 -in ca.csr -signkey ca.key -out ca.crt
  echo -e "\nCertificado raíz generado\n"
}

# Función para obtener información del certificado raíz
obtener_informacion_certificado_raiz () {
  echo -e "\nObteniendo información del certificado raíz...\n"
  openssl x509 -in ca.crt -text -noout
  echo -e "\nInformación del certificado raíz obtenida\n"
}

# Función para generar claves privadas intermedias
generar_clave_intermedia () {
  echo -e "\nGenerando clave privada intermedia...\n"
  openssl genrsa -des3 -out intermediate.key 4096
  echo -e "\nClave privada intermedia generada\n"
}

# Función para generar una solicitud de firma de certificado para la clave privada intermedia
generar_solicitud_csr_intermedia () {
  echo -e "\nGenerando solicitud de firma de certificado para la clave privada intermedia...\n"
  openssl req -new -key intermediate.key -out intermediate.csr
  echo -e "\nSolicitud de firma de certificado para la clave privada intermedia generada\n"
}

# Función para generar un certificado intermedio
generar_certificado_intermedio () {
  echo -e "\nGenerando certificado intermedio...\n"
  openssl x509 -req -days 3650 -in intermediate.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out intermediate.crt
  echo -e "\nCertificado intermedio generado\n"
}

# Función para obtener información del certificado intermedio
obtener_informacion_certificado_intermedio () {
  echo -e "\nObteniendo información del certificado intermedio...\n"
  openssl x509 -in intermediate.crt -text -noout
  echo -e "\nInformación del certificado intermedio obtenida\n"
}

# Función para generar claves privadas finales
generar_clave_final () {
  echo -e "\nGenerando clave privada final...\n"
  openssl genrsa -des3 -out server.key 4096
  echo -e "\nClave privada final generada\n"
}

# Función para generar una solicitud de firma de certificado para la clave privada final
generar_solicitud_csr_final () {
  echo -e "\nGenerando solicitud de firma de certificado para la clave privada final...\n"
  openssl req -new -key server.key -out server.csr
  echo -e "\nSolicitud de firma de certificado para la clave privada final generada\n"
}

# Función para generar un certificado final
generar_certificado_final () {
  echo -e "\nGenerando certificado final...\n"
  openssl x509 -req -days 3650 -in server.csr -CA intermediate.crt -CAkey intermediate.key -CAcreateserial -out server.crt
  echo -e "\nCertificado final generado\n"
}

# Función para obtener información del certificado final
obtener_informacion_certificado_final () {
  echo -e "\nObteniendo información del certificado final...\n"
  openssl x509 -in server.crt -text -noout
  echo -e "\nInformación del certificado final obtenida\n"
}

# Función para guardar los certificados
guardar_certificados () {
  echo -e "\nGuardando los certificados...\n"
  mkdir certificados
  mv *.crt *.key *.csr *.srl certificados
  echo -e "\nCertificados guardados\n"
}

# Función para mostrar la información de los certificados guardados
mostrar_informacion_certificados () {
  echo -e "\nMostrando la información de los certificados guardados...\n"
  cd certificados
  for i in *.crt; do
    echo -e "\nInformación del certificado $i...\n"
    openssl x509 -in $i -text -noout
  done
  cd ..
  echo -e "\nInformación de los certificados guardados mostrada\n"
}

# Menú
while true; do
  echo -e "\nMenú de certificados:\n
1. Generar clave privada raíz
2. Generar solicitud de firma de certificado
3. Generar certificado raíz
4. Obtener información del certificado raíz
5. Generar clave privada intermedia
6. Generar solicitud de firma de certificado para la clave privada intermedia
7. Generar certificado intermedio
8. Obtener información del certificado intermedio
9. Generar clave privada final
10. Generar solicitud de firma de certificado para la clave privada final
11. Generar certificado final
12. Obtener información del certificado final
13. Guardar los certificados
14. Mostrar la información de los certificados guardados
15. Salir

Elige una opción:"

  read opcion

  case $opcion in
    1)
      generar_clave_raiz
      ;;
    2)
      generar_solicitud_csr
      ;;
    3)
      generar_certificado_raiz
      ;;
    4)
      obtener_informacion_certificado_raiz
      ;;
    5)
      generar_clave_intermedia
      ;;
    6)
      generar_solicitud_csr_intermedia
      ;;
    7)
      generar_certificado_intermedio
      ;;
    8)
      obtener_informacion_certificado_intermedio
      ;;
    9)
      generar_clave_final
      ;;
    10)
      generar_solicitud_csr_final
      ;;
    11)
      generar_certificado_final
      ;;
    12)
      obtener_informacion_certificado_final
      ;;
    13)
      guardar_certificados
      ;;
    14)
      mostrar_informacion_certificados
      ;;
    15)
      echo -e "\nSaliendo del menú...\n"
      break
      ;;
    *)
      echo -e "\nOpción no válida\n"
      ;;
  esac
done
