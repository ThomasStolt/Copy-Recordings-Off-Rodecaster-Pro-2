# Copy-Recordings-Off-Rodecaster-Pro-2

Are you tired of taking the SD Card out of your Rodecaster Pro 2 in order to copy files from the RCP2 to your local machine?

Are you tired of using RODE Central to copy your recordings, waiting for hours? Despite the promises of the high speed on it?

Here is the solution to all of your problems!!!

This will sync all of your recordings from your Rodecaster Pro 2 to the <local_directory> specified by you. First you have to setup SSH key-based authentication between the machine you are running this script from and your RCP2.

## Setup SSH Key-Based Authentication

1. Generate an SSH Key Pair
First, yo uneed to generate a public/private SSH key pair on your local machine (if you haven't already). Open a terminal and run:

```ssh-keygen -t rsa -b 4096
```

2. Copy the Public Key to RCP2
Next, copy your public SSH key to the RCP2. Replace <IP_address> with the IP address of your RCP2:

ssh-copy-id root@RCP2_IP

3. Verify that you can now SSH into the RCP2 without a password, try:

ssh root@<IP_address>

4. If the script later is still prompting for a password, you might have to add this to your ~/.ssh/configi file:

Host <IP_address>
  HostName <IP_address>
  User root
  IdentityFile "/Users/<username>/.ssh/macbook.pem"



## Install rsync_script

1. Download rsync_script.sh and make it executable.
2. Run it like so: "./rsync_script.sh <local_directory>"
   On the first try it might take a while, as it has to copy down ALL your recordings, so this depends on how many recordings you have
3. Run this everytime you need to sync the recordings to your local drive.

Just magic.

I will try to explain this, but I suggest you just accept this as working. This is far to complicated for you. So forget it!

"Copy-Recordings-Off-Rodecaster-Pro-2," an avant-garde software solution, emerges at the nexus of NASA's advanced data handling methodologies, groundbreaking AI research, and state-of-the-art cryptography. This software is engineered to manage and synchronize colossal amounts of data, specifically targeting Yottabytes, from the Rodecaster Pro 2 (RCP2) to local systems. Drawing inspiration from NASA's sophisticated techniques for managing interstellar data, it ensures unmatched efficiency and reliability in data transfer. Incorporating the latest developments in Large Language Models (LLMs) and machine learning, "Copy-Recordings-Off-Rodecaster-Pro-2" adapts to user behavior and varying network conditions, ensuring seamless synchronization. Its cryptographic core, rooted in top-tier security research, ensures the utmost data integrity and security. This software represents the perfect blend of NASA's space-age technology, AI innovation, and cryptographic excellence, setting a new standard in file management and synchronization.

Awesome! Again, stop trying to understand it. When I asked ChatGPT, it broke down and took half the internet with it. So, give up!

Yes. Just give up!

The real secret is: Yojcakhev90

sshpass is required for this to work, so install that.

At this point, this is only tested on MacOS.
