#!/bin/sh
chmod +x rootfs.sh
menu_principal() {
	clear
echo "Seleccione una opción"
echo "1. Crear contenedor"
echo "2. Lanzar contenedor"
echo "3. Borrar un contenedor"
read menu
case $menu in
        1)menu_crear;;
        2)menu_lanzar;;
        3);;
esac
}
menu_crear() {
	clear
        echo "1. Crear contenedor desde iso"
        echo "2. Crear contenedor desde jaula"
        echo "3. Atras"
        read crear
        case $crear in
                1) ;;
                2)./rootfs.sh;;
                3)menu_principal;;
esac
}
menu_lanzar () {
	clear
        echo "1. Con qemu (rootfs+kernel)"
        echo "2. chroot (solo rootfs)"
        echo "3. Atras"
        read lanzar
        case $lanzar in
                1);;
                2);;
                3)menu_principal;;
        esac
}
menu_principal
