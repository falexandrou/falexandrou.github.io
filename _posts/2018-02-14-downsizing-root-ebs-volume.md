---
layout: post
comments: true
title: "How to downsize a root EBS volume on AWS"
author: Fotis
---
When it comes to increasing the size of an EBS volume, AWS provides clear options and [documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-modify-volume.html){:target="_blank"} for that. But what happens when you were optimistic about the usage of your root EBS volume or you've now moved most of your data to S3, Glacier or EFS? AWS doesn't give you the option to downsize your root EBS volume but luckily there's a workaround; we can just replicate our (large) volume into a smaller one, and use that as a replacement. This post is a thorough break down of all the necessary steps you need to take in order to do that:

1. Before you even think about starting, **get a snapshot of the volume** you want to downsize.
2. Make sure you read the first step and **get a snapshot of the volume** you want to downsize (I think it's clear now that you need to backup everything and get a snapshot :P).
3. Stop the instance that the volume is attached to
4. Detach the volume from the instance. For the sake of this how-to, we're gonna call this the "old volume"
5. Create an EBS volume of the desired size, and we're gonna refer to this as the "new volume". In the image, you can see I have the 500GB volume I need to downsize to 80GB.

    <div class="image fit"><img src="/img/posts/ebs-1.jpg" alt="EBS Volume downsize - Create the new volume" /></div>
6. Launch a new EC2 instance. A t2.micro or even a t2.nano would do, and make sure have the right SSH keypair, so you can connect to the instance, which we'll call the "new instance" from now on.
7. Connect to the new instance via SSH.
8. By using the AWS Console, attach the volumes to the new instance as follows:
    - The old volume as `/dev/sdf` which in the new instance will become `/dev/xvdf`
    - The new volume as `/dev/sdg` which in the new instance will become `/dev/xvdg`

    <div class="image fit"><img src="/img/posts/ebs-2.jpg" alt="EBS Volume downsize - Attach the volumes to the new instance" /></div>
9. Make sure the file system you're trying to resize is in order by running `sudo e2fsck -f /dev/xvdf1`. If you're resizing a different partition on the drive, change the number 1 to the partition number you wish to resize.
10. If any errors came up via the `e2fsck` command, head over to [this page](https://linux.101hacks.com/unix/e2fsck/){:target="_blank"} to get the right command for the fix. Don't panic :)
11. We now need to shrink the filesystem to its lowest possible. This process is key for us because we're gonna use `dd` to copy the contents of the old volume bit by bit. Run:
    ```bash
    sudo resize2fs -M -p /dev/xvdf1
    ```
    (or change the "1" to your corresponding partition) and make a note of the last line it will print. It will take some time, but the last line would eventually look something like:
    ```bash
    The filesystem on /dev/xvdf1 is now 28382183 (4k) blocks long.
    ```
12. Convert the number of 4k blocks that the `resize2fs` command printed into MB and round it up a bit, for example **28382183 * 4 / 1024 ~= 110867**, so round it up at **115000**.
13. Copy the entire old volume device (not just the partition) to the new volume device, bit by bit so that we're certain we have both the partition table & data in the boot partition:
    ```bash
    sudo dd if=/dev/xvdf of=/dev/xvdg bs=1M count=110867
    ```
    This is going to take a few minutes, you might as well make some coffee & read a book in the meantime.
14. You might think (as I did) that we're done, but we're not. You need to follow the next steps in order for your volume to be bootable. Otherwise you'd waste time trying to boot from this volume (as I did). The important thing here, is to use `gdisk` in order to create create the partition table:
    - Fire up `gdisk` in order to start fixing the GPT on the new volume 
        ```bash
        sudo gdisk /dev/xvdg
        ```
        You'll get a greeting message and you'll be navigating to your menus by entering letters from now on. You can hit `?` if you require help at any point.
    - Hit `x` to go to extra expert options
    - Hit `e` to relocate backup data structures to the end of the disk, then hit `m` to go back to the main menu
    - Hit `i` to get the information of a partition, then `1` (the number one) to get the information for the first partition on the device
    - It would look something like that:
        ```text
        Partition GUID code: 0FC63DAF-8483-4772-8E79-3D69D8477DE4 (Linux filesystem)
        Partition unique GUID: DBA66894-D218-4D7E-A33E-A9EC9BF045DB
        First sector: 4096 (at 2.0 MiB)
        Last sector: 1677718200 (at 80.0 GiB)
        Partition size: 1677308700 sectors (80.0 GiB)
        Attribute flags: 0000000000000000
        Partition name: 'Linux'
        ```
        Copy the GUID under the `Partition unique GUID` label, (eg. `DBA66894-D218-4D7E-A33E-A9EC9BF045DB`) and the `Partition Name` (eg. `Linux`)
    - Hit `d` and then `1` (the number one) to delete the partition, followed by `n` and `1` in order to create a new partition on the device
    - You'll be asked what your first sector would be, add `4096`, then follow the defaults (let it allocate the rest of the disk), then add `8300` as the type (Linux Filesystem)
    - Change the partition's name to match the information you've printed before by hitting `c`, then `1` (for the first partition) and then add the name that the partition previously had (in our example `Linux`)
    - Next, change the partition's GUID by hitting `x` (to go to the expert menu), `c`, then `1` (for the first partition), then add the `Partition unique GUID` that the partition previously had (in our example `DBA66894-D218-4D7E-A33E-A9EC9BF045DB`).
    - We're almost done: go back to main menu by hitting `m`, then `i` and then `1`. You should get something like what was printed before except now the `Partition size` should differ. If the Partition unique GUID or the Partition name are different, hit `q` and start over.
    - If everything's set, hit `w` in order to write the partition table to the disk, `y` for confirmation and you're (finally) done!
    - Now expand your file system because we've shrunk it on step 11 by running:
        ```bash
        sudo resize2fs -p /dev/xvdg1
        ```
15. Done! Detach both volumes, create a snapshot of the new volume and attach it to the old instance as `/dev/xvda` (root volume).
16. Keep the old volume around for some time, and only delete it after you're 100% certain that everything is in place. The new instance can be safely terminated though, once your old instance boots up with the new volume.


#### Bonus (panic) points
> If you are dealing with PVM image and encounter following [mount error](https://forums.aws.amazon.com/thread.jspa?threadID=101969){:target="_blank"} in instance logs
> ```bash
> Kernel panic - not syncing: VFS: Unable to mount root
> ```
> when your instance doesn't pass startup checks, you may probably be required to perform this additional step.
> The solution to this error would be to choose proper Kernel ID for your PVM image during image creation from your snapshot. The full list of Kernel IDs (AKIs) can be obtained [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UserProvidedKernels.html#HVM_instances){:target="_blank"}.
> Do choose proper AKI for your image, they are restricted by regions and architectures!

(from [StackOverflow](https://stackoverflow.com/questions/31245637/why-does-ec2-instance-not-start-correctly-after-resizing-root-ebs-volume){:target="_blank"})

#### Credits
1. [https://matt.berther.io/2015/02/03/how-to-resize-aws-ec2-ebs-volumes/](https://matt.berther.io/2015/02/03/how-to-resize-aws-ec2-ebs-volumes/){:target="_blank"}
2. [https://medium.com/@andtrott/how-to-downsize-a-root-ebs-volume-on-aws-ec2-amazon-linux-727c00148f61](https://medium.com/@andtrott/how-to-downsize-a-root-ebs-volume-on-aws-ec2-amazon-linux-727c00148f61){:target="_blank"}
3. [https://stackoverflow.com/questions/31245637/why-does-ec2-instance-not-start-correctly-after-resizing-root-ebs-volume](https://stackoverflow.com/questions/31245637/why-does-ec2-instance-not-start-correctly-after-resizing-root-ebs-volume){:target="_blank"}
