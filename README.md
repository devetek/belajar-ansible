## Deskripsi

Repository untuk belajar ansible dalam bahasa Indonesia dengan contoh (_maaf kalau bahasanya berantakan_). Disini akan menjadi playground ansible yang dapat dijalankan di local mesin kalian dengan sedikit sentuhan docker.

Kenapa docker ? dengan docker, kamu tidak perlu melakukan instalasi binary langsung ke mesin. Sehingga dapat dipastikan ini akan berjalan ke semua platform (macOS, Linux, Windows). Namun karena untuk mempermudah commands, repository ini akan dibungkus dengan `Makefile`. Sehingga mungkin tidak akan berjalan dengan lancar di Windows. Untuk pengguna windows mohon menggunakan command `docker compose` secara langsung.

## Sebelum Mulai

Sebelum mulai pastikan kamu sudah memiliki pengetahuan dasar tentang system operasi, Makefile dan docker. Silahkan belajar di [belajar-os](https://github.com/devetek/belajar-os), [belajar-makefile](https://github.com/devetek/belajar-makefile) dan [belajar-docker](https://github.com/devetek/belajar-docker).

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

Kemudian jalankan command `make enter-ansible-executor` di terminal lain untuk masuk ke container ansible executor dan jalankan ansible command yang kamu sudah buat / modifikasi.

Jalankan command `make enter-ansible-inventory` di terminal lainnya. Untuk melihat perubahan yang kamu lakukan sudah masuk ke mesin tujuan atau belum.

## Configurasi Dasar

Konfigurasi dasar berada di file `ansible/ansible.cfg`. Akan dibahas lebih jauh selanjutnya.

## Apa Itu Playbook

Playbbok adalah tempat penulisan peraturan / langkah-langkah yang akan dijalankan ke dalam server tujuan. Kita akan membahas playbook lebih jauh selanjutnya. Untuk memulai, jalankan perintah di bawah ini didalam container `ansible-executor`:

```sh
ansible-playbook -i inventory/ansible-inventory.ini playbooks/hello-world.yml -vv
```

Kemudian lihat di dalam container `ansible-inventory`, akan ada sebuah file `/root/output` yang terbuat.
