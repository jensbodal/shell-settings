
## MergerFS

Merge multiple drives into one

https://github.com/trapexit/mergerfs

```
# /mnt
# UUIDs just randomly generated

UUID=9547bec5-e016-4e7e-baf1-f19bc143a132 /mnt/virtual-drives/asheron ext4 defaults 0 2
UUID=7c6d1cfb-bf29-4a33-bfee-37170ba06230 /mnt/virtual-drives/baelzharon ext4 defaults 0 2

asheron:baelzharon /mnt/virtual fuse.mergerfs rw,nosuid,nodev,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
```
