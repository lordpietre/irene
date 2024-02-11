#!/bin/bash

#Dependencias 
#repo 1 i386/amd64
#repo 2 armhf/arm64
repo1=http://es.archive.ubuntu.com/ubuntu/
repo2=http://ports.ubuntu.com/ubuntu-ports/
repo3=https://old-releases.ubuntu.com/releases/
repo_deb=http://deb.debian.org/debian
repo_debold=http://archive.debian.org/debian/
repo_kali=http://http.kali.org/kali
repo_variant="main restricted universe multiverse"
repo_vardeb="main contrib non-free"
repo_varkali=" main contrib non-free non-free-firmware"
dep() {
	apt install debootstrap qemu-user-static
}
qemu_arm64(){ 
	cp /usr/bin/qemu-aarch64-static /$nameiso/usr/bin
	chroot /$nameiso /usr/bin/qemu-aarch64-static /bin/sh -i ./home/config.sh
}
qemu_arm(){ 
	cp /usr/bin/qemu-arm-static /$nameiso/usr/bin
	chroot /$nameiso /usr/bin/qemu-arm-static /bin/sh -i ./home/config.sh
}
qemu_i386(){ 
	cp /usr/bin/qemu-i386-static /$nameiso/usr/bin
	chroot /$nameiso /usr/bin/qemu-i386-static /bin/sh -i ./home/config.sh
}
qemu_x86_64(){ 
	cp /usr/bin/qemu-x86_64-static /$nameiso/usr/bin
	chroot /$nameiso /usr/bin/qemu-x86_64-static /bin/sh -i ./home/config.sh
}
registro() {
echo $nameiso > container.reg
}
arquitectura() {
clear
        echo "Selecciona arquitectura"
        echo "1. Armhf"
        echo "2. Arm64"
        echo "3. i386"
        echo "4. Amd 64"
        echo "Atras"
        read archi
        case $archi in
                1)cpu=armhf
                        origin=$repo2;;
                2)cpu=arm64
                        origin=$repo2;;
                3)cpu=i386
                        origin=$repo1;;
                4)cpu=amd64
                        origin=$repo1;;
                5);;
        esac
}
os_debian() {
    clear
    echo "Debian"
    echo "1. Debian 12 bookworm"
    echo "2. Debian 11 Bullseye"
    echo "3. Debian 10 Buster"
    echo "4. Debian 9  Stretch"
    echo "5  Debian 8  Jessie"
    echo "6  Debian 7  Wheezy"
    echo "7  Debian 6  Squeeze"
    echo "8  Debian 5. Lenny"
    echo "8. Atras"
    echo "9. salir"
    echo -n " Selecciona una opción [1-5]"
    read debian

    case $debian in
        1) imagen=bookworm
	origin=$repo_deb;;
        2) imagen=bullseye
	origin=$repo_deb;;
        3) imagen=buster
	origin=$repo_deb;;
		4) imagen=stretch
	origin=$repo_debold;;
		5) imagen=jessie
	origin=$repo_debold;;
		6) imagen=wheezy
	origin=$repo_debold;;
		7) imagen=squeeze
	origin=$repo_debold;;
		8) imagen=lanny
	origin=$repo_debold;;
        9) os_seleccion;;
        9) exit;;
        *) echo "Opcion no valida";;
    esac
}
os_ubuntu() {
clear
        echo "Ubuntu "
        echo "1. Ubuntu 24.04 (Noble Numbat) "
        echo "2. Ubuntu 23.04 (Lunar Lobster)"
        echo "3. Ubuntu 23.10 (Mantic Minotaur)"
        echo "4. Ubuntu 22.10 (Kinetic Kudu)"
        echo "5. Ubuntu 22.04.3 LTS (Jammy Jellyfish)"
        echo "6. Ubuntu 21.10 (Impish Indri)"
        echo "7. Ubuntu 20.04.6 LTS (Focal Fossa)"
        echo "8. Ubuntu 18.04.6 LTS (Bionic Beaver)"
        echo "9. Ubuntu 16.04.7 LTS (Xenial Xerus)"
		echo "10. Ubuntu 14.04.6 LTS (Trusty Tahr)"
        echo "11. Atras"
        echo "12. Salir"
        echo -n " Selecciona una opción [1-11]"
        read ubuntu
        case $ubuntu in
                1) imagen=noble;;
                2) imagen=lunar;;
                3) imagen=mantic;;
                4) imagen=kinetic;;
                5) imagen=jammy;;
                5) imagen=impish;;
                6) imagen=focal;;
                7) imagen=bionic;;
				8) imagen=xenial;;
				9) imagen=trusty;;
                10) os_seleccion;;
                10) exit;;
                *) echo "Opcion no valida";;
        esac
}
os_kali () {
        clear
        echo "Kali Linux"
        echo "1. Rolling"
		echo "2. Main"
        echo "3. Atrás"
        echo "4. Salir"
        read kali
        case $kali in
        1) imagen=kali-rolling
        origin=$repo_kali;;
		2) imagen=kali-last-snapshot
		origin=$repo_kali;;
		3) os_seleccion;;
        4) exit;;
        esac
}
os_seleccion() {
clear
        echo "Selecciona Sistema operativo"
        echo "1. Ubuntu"
        echo "2. Debian"
        echo "3. Kali"
	echo "4. Atras"
        echo "5. Salir"
        echo -n " Selecciona una opción [1-3]"
        read OS
        case $OS in
        1) os_ubuntu;;
        2) os_debian;;
        3) os_kali;;
        4) arquitectura;;
	5) exit;;
        *) echo "Opcion no valida";;
esac
}
disco_tamano() {
clear
echo "Selecione el Tamaño del disco"
echo "1. 512 Mb"
echo "2. 1 Gb"
echo "3. 2 Gb"
echo "4. 4 Gb"
echo "5. 8 Gb"
echo "6. 16 Gb"
echo "7. 32 Gb"
echo "8. 64 Gb"
echo -n " Selecciona una opción [1-7]"
read disk
case $disk in
1) disco=512M;;
2) disco=1G;;
3) disco=2G;;
4) disco=4G;;
5) disco=8G;;
6) disco=16G;;
7) disco=32G;;
8) disco=64G;;
9) os_seleccion;;
*) echo "Incorrecto"
esac
}
creacion_imagen() {
	nameiso=$imagen-$cpu-$disco
mkdir /$nameiso
dd if=/dev/zero of=$nameiso.img bs=1 count=0 seek=$disco
mkfs.ext4 $nameiso.img
chmod 777 $nameiso.img
mount -o loop $nameiso.img /$nameiso
debootstrap  --arch=$cpu --foreign $imagen /$nameiso $origin
    case $imagen in
##### Repos de debian###

        buster)
        repos="deb [arch=$cpu] $repo_deb $imagen $repo_vardeb
deb [arch=$cpu] $repo_deb $imagen-security $repo_vardeb
deb [arch=$cpu] $repo_deb $imagen-updates $repo_vardeb" ;;

        bullseye)
        repos="deb [arch=$cpu] $repo_deb bullseye $repo_vardeb
deb [arch=$cpu] $repo_deb bullseye-security $repo_vardeb
deb [arch=$cpu] $repo_deb bullseye-updates $repo_vardeb" ;;

        bookworm)
        repos="deb [arch=$cpu] $repo_deb bookworm $repo_vardeb
deb [arch=$cpu] $repo_deb bookworm-security $repo_vardeb
deb [arch=$cpu] $repo_deb bookworm-updates $repo_vardeb" ;;

		stretch)
		repo="deb [arch=$cpu] $repo_debold stretch $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-security $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-updates $repo_varde";;
	
		jessie)
		repo="deb [arch=$cpu] $repo_debold stretch $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-security $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-updates $repo_varde";;
	
		wheezy)
		repo="deb [arch=$cpu] $repo_debold stretch $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-security $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-updates $repo_varde";;

		lenny)
		repo="deb [arch=$cpu] $repo_debold stretch $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-security $repo_vardeb
deb [arch=$cpu] $repo_debold stretch-updates $repo_varde";;

##### Repos de ubuntu###
		
		noble)
		repos="deb [arch=$cpu] $origin noble $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;		
		
		lunar)
		repos="deb [arch=$cpu] $origin lunar $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;	
	
		mantic)
		repos="deb [arch=$cpu] $origin mantic $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;		

		kinetic)
		repos="deb [arch=$cpu] $origin kinetic $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;		

		jammy)
        repos="deb [arch=$cpu] $origin jammy $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;
		
		impish)
        repos="deb [arch=$cpu] $repo3 impish $repo_variant
deb [arch=$cpu] $repo3 $imagen-security $repo_variant
deb [arch=$cpu] $repo3 $imagen-updates $repo_variant";;

        focal)
        repos="deb [arch=$cpu] $origin focal $repo_variant
deb [arch=$cpu] $origin $imagen-security $repo_variant
deb [arch=$cpu] $origin $imagen-updates $repo_variant";;

        bionic)
        repos="deb [arch=$cpu] $origin bionic $repo_variant
deb [arch=$cpu] $origin bionic-security $repo_variant
deb [arch=$cpu] $origin bionic-updates $repo_variant";;

        xenial)
        repos="deb [arch=$cpu] $origin xenial $repo_variant
deb [arch=$cpu] $origin xenial-security $repo_variant
deb [arch=$cpu] $origin xenial-updates $repo_variant";;
		
		trusty)
        repos="deb [arch=$cpu] $origin trusty $repo_variant
deb [arch=$cpu] $origin trusty-security $repo_variant
deb [arch=$cpu] $origin trusty-updates $repo_variant";;	

##### Repos de kali###

		kali-rolling)
		repos="deb [arch=$cpu] $origin kali-rolling $repo_varkali";;
	    
		kali-last-snapshot) 
		repos="deb [arch=$cpu] $origin kali-last-snapshot $repo_varkali";;
    	
    	*) echo "Repositorios no definidos para $imagen"; exit 1 ;;
esac

    # Insertar líneas en /etc/apt/sources.list
    echo "$repos" > /$nameiso/etc/apt/sources.list

# aquí se crea el script que se ejecuta dento del contenedor
> config.sh
cat <<+ >> config.sh
#!/bin/sh
echo " Configurando debootstrap segunda fase"
sleep 3
/debootstrap/debootstrap --second-stage
export LANG=C
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "Europe/Berlin" > /etc/timezone
echo "$imagen" >> /etc/hostname
echo "127.0.0.1 $imagen localhost
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" >> /etc/hosts
echo "auto lo
iface lo inet loopback" >> /etc/network/interfaces
echo "/dev/mmcblk0p1 /     ext4     errors=remount-ro,noatime,nodiratime 0 1" >> /etc/fstab
echo "tmpfs    /tmp        tmpfs    nodev,nosuid,mode=1777 0 0" >> /etc/fstab
echo "tmpfs    /var/tmp    tmpfs    defaults    0 0" >> /etc/fstab
$repos
apt-get update
apt-get install locales
echo "Reconfigurando parametros locales"
locale-gen es_ES.UTF-8
export LC_ALL="es_ES.UTF-8"
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
dpkg-reconfigure -f noninteractive tzdata
apt-get upgrade -y
hostnamectl set-hostname $imagen
apt-get -f install
apt-get clean
adduser $usuario
addgroup $usuario sudo
addgroup $usuario adm
addgroup $usuario users
+
}
montaje() {
mount -o bind /dev /$nameiso/dev
mount -o bind /dev/pts /$nameiso/dev/pts
mount -t sysfs /sys /$nameiso/sys
mount -t proc /proc /$nameiso/proc
}
parte_final() {
chmod +x  config.sh
cp  config.sh /$nameiso/home
case $cpu in
	armhf) qemu_arm;;
	arm64) qemu_arm64;;
	i386) qemu_i386;;
	amd64) qemu_x86_64;;
esac

rm config.sh
}
arquitectura
os_seleccion
disco_tamano
dep
creacion_imagen
montaje
parte_final

