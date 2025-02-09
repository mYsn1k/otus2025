ДЗ 5 ДЗ: Работа с LVM

1. Создаем новый LVM /dev/vg_root/lv_root, монтируем в /mnt/rooot, переносим файлы из /, пегенерируем grub

![Screenshot from 2025-02-09 15-20-59](https://github.com/user-attachments/assets/26367265-a330-47cd-9a77-71a312d71e63)

2. Удаляем  старый LVM /, и создаем новый на 8 ГБ, переносим файлы обратно, перегенерируем grub
![Screenshot from 2025-02-09 15-30-21](https://github.com/user-attachments/assets/d1d2e67a-9f0b-4b1a-a49f-a2db6e6082d7)

![Screenshot from 2025-02-09 17-21-46](https://github.com/user-attachments/assets/c4f28f16-3de1-4835-b1da-a3468dd765e2)

3. Создаем зеркальный LVM для var и обычный для home. У LVM home используем не 100% места для возможности создания снапшотов. Монтируем созданные LVM,
   переносим на них файлы из var и home, удаляем старые каталоги, переделываем точки монтирования, правим fstab, првоеряем возможность snapshots

    ![Screenshot from 2025-02-09 22-11-42](https://github.com/user-attachments/assets/449b3326-ef1b-4818-9d12-45c80862047d)
![Screenshot from 2025-02-09 17-21-46](https://github.com/user-attachments/assets/58bac079-b84c-473f-bd36-ce70a52a82d4)
