## Deskripsi

Repository untuk belajar ansible dalam bahasa Indonesia dengan contoh (_maaf kalau bahasanya berantakan_). Disini akan menjadi playground ansible yang dapat dijalankan di local mesin kalian dengan sedikit sentuhan docker.

Kenapa docker ? dengan docker, kamu tidak perlu melakukan instalasi binary langsung ke mesin. Sehingga dapat dipastikan ini akan berjalan ke semua platform (macOS, Linux, Windows). Namun karena untuk mempermudah commands, repository ini akan dibungkus dengan `Makefile`. Sehingga mungkin tidak akan berjalan dengan lancar di Windows. Untuk pengguna windows mohon menggunakan command `docker compose` secara langsung.

## Sebelum Mulai

Sebelum mulai pastikan kamu sudah memiliki pengetahuan dasar tentang system operasi, Makefile dan docker. Silahkan belajar di [belajar-os](https://github.com/devetek/belajar-os), [belajar-makefile](https://github.com/devetek/belajar-makefile) dan [belajar-docker](https://github.com/devetek/belajar-docker).

Binary Details:

- Ansible Core: 2.15.4

## Bantuan

Untuk mempermudah proses development, di dalam repository ini terdapat beberapa command bantuan yang dapat dijalankan dengan `Makefile`:

```sh
 ____       _        _                   _              _ _     _
| __ )  ___| | __ _ (_) __ _ _ __       / \   _ __  ___(_) |__ | | ___
|  _ \ / _ \ |/ _` || |/ _` | '__|____ / _ \ | '_ \/ __| | '_ \| |/ _ \
| |_) |  __/ | (_| || | (_| | | |_____/ ___ \| | | \__ \ | |_) | |  __/
|____/ \___|_|\__,_|/ |\__,_|_|      /_/   \_\_| |_|___/_|_.__/|_|\___|
                  |__/

Copyright (c) 2023 Devetek Tech. https://devetek.com.
Repo: https://github.com/devetek/belajar-ansible

Use: make <target>

GENERIC
  help                                                Show available commands

DEVELOPMENT
  run                                                 Run playground
  ls                                                  Show containers
  enter-ansible-executor                              Enter to ansible-executor
  enter-ansible-inventory                             Enter to ansible-inventory
  log                                                 Show containers log
  down                                                Shutdown playground

DOCKER
  docker-build-push                                   Build and push ansible master

ANSIBLE
  ansible-create-roles                                Create new role ansible_role_name=<ROLE_NAME>
```

## Daftar Isi

- Kenapa Ansible
- Cara Memulai
- Configurasi Dasar
- Apa Itu Playbook
- Apa Itu Roles
- Apa Itu Collections
- Remote Dependencies
- Praktek Video Youtube

### Kenapa Ansible

Ansible adalah sebuah _provisioning tool_ yang dikembangkan oleh RedHat. Dimana kamu dapat mencatat setiap proses _deployment_ ataupun konfigurasi yang biasa dilakukan berulang - ulang terhadap beberapa _server_ dan membuatnya identik ke semua server.

Bayangkan jika kamu mau melakukan instalasi PHP, MySQL, Apache dan sebagainya. Jika melakukannya ke satu server mungkin hal itu akan mudah dilakukan. Namun jika server yang kamu kelola mulai banyak, ini pasti akan menjadi sangat sulit untuk membuatnya identik.

### Cara Memulai

Untuk memulai menjalankan repository ini cukup dengan menjalankan perintah `make run`. Perintah tersebut akan melakukan beberapa hal:

- Menjalankan docker compose dari file `docker-compose.yml`
- Menjalankan 2 buah container, satu untuk ansible executor kedua merupakan ansible inventory

Selanjutnya kamu dapat mulai melakukan modifikasi file ansible (inventory, playbook, roles, etc) yang ada di repository di dalam folder `ansible`. Untuk bagian ini, kita akan belajar di bagian selanjutnya details tentang ansible.

Kemudian jalankan command `make enter-ansible-executor` di terminal lain untuk masuk ke container `ansible-executor`.

Kemudian jalankan command `make enter-ansible-inventory` di terminal lainnya. Untuk melihat perubahan yang kamu lakukan sudah masuk ke mesin tujuan atau belum.

## Configurasi Dasar

Konfigurasi dasar berada di file `ansible/ansible.cfg`. Akan dibahas lebih jauh selanjutnya.

## Apa Itu Playbook

Playbook adalah tempat penulisan peraturan / langkah-langkah yang akan dijalankan ke dalam server tujuan. Kita akan membahas playbook lebih jauh di chapter lain. Untuk memulai, jalankan perintah di bawah ini didalam container `ansible-executor`:

```sh
cd /executor && ansible-playbook -i inventory/ansible-inventory.ini playbooks/hello-world.yml -vv
```

atau menggunakan golang executor
```sh
cd /executor/ && go run main.go
```

Kemudian lihat di dalam container `ansible-inventory`, akan ada sebuah file baru di `/root/output` yang terbuat.
