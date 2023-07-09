
## MergerFS

Merge multiple drives into one

https://github.com/trapexit/mergerfs

```
/etc/fstab
# obtain UUID from sudo blkid

UUID=9547bec5-e016-4e7e-baf1-f19bc143a132 /mnt/virtual-drives/asheron ext4 defaults 0 2
UUID=7c6d1cfb-bf29-4a33-bfee-37170ba06230 /mnt/virtual-drives/baelzharon ext4 defaults 0 2

/mnt/virtual-drives/asheron:/mnt/virtual-drives/baelzharon /mnt/virtual fuse.mergerfs cache.files=partial,dropcacheonclose=true,category.create=mfs 0 0
```
