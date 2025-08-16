# 1. If you follow the instructions in this repository you may potentially brick your precious RCP2!
.
# 2. If you have read 1. and are still following along, you are doing so at your own risk!
.
# 3. Go back to 1. and read again what it says!
.
# News Flash ==> Update of RCP2 Firmware 1.6.5 disables password login

The firmware 1.6.5 released on 30/07/2025 disables password based logins, a line in ```/etc/ssh/sshd_config``` was changed from:

<pre> #PasswordAuthentication no    # <=== this allows logging in with password</pre>

to:

<pre>PasswordAuthentication no      # <=== this disables logging in with password</pre>

The options are to either stay on 1.6.4 or less, or change this line back to contain the `#`, before the new firmware is uploaded to your RCP2.

> Starting with firmware 1.6.5 accessing the RCP2 via SSH (and hence the script in this repository) will not work anymore! Use this at your own risk.

<hr style="height:6px; background-color:#999; border:none; margin:20px 0;" />

# Copy Recordings off RCP2

Are you tired of taking the SD Card out of your RCP2 in order to copy files from the RCP2 to your local machine? Are you tired of using ~~RODE Central~~ the RODECaster App to copy your recordings, waiting for hours? Despite the promises of the high speed on it? Do you also want to automate the process of saving and processing your recordings further?

The wait is over! Here is the solution to all of your problems! This will sync all of your recordings from your RCP2 to a local directory of your choice!

To get this going follow these steps:

<ol type="A">
  <li>Setup SSH key-based authentication.</li>
  <li>Copy the rsync binary to your RCP2.</li>
  <li>Install rsync_script.</li>
</ol>

## A) Setup SSH Key-Based Authentication

### 1. Generate an SSH Key Pair
First, you need to generate a public/private SSH key pair on your local machine (if you haven't already). Open a terminal and run:

```
ssh-keygen -t rsa -b 4096
```

### 2. Copy the Public Key to RCP2
Next, copy your public SSH key to the RCP2. Replace <IP_address> with the IP address of your RCP2:

```
ssh-copy-id root@<IP_address_of_your_RCP2>
```

### 3. Verify that you can now SSH into the RCP2 without a password, try:

```
ssh root@<IP_address>
```

### 4. If the script later is still prompting for a password, you might have to add this to your ~/.ssh/config file:

```
Host <IP_address>
  HostName <IP_address>
  User root
  IdentityFile "/Users/<username>/.ssh/id_ed25519"
```

## B) Install the rsync binary to your RCP2

### 1. Unzip the rsync.zip file
```bash
unzip rsync.zip
```

### 2. SFTP the rsync binary to your RCP2
Use SFTP to copy the extracted rsync binary onto the RCP2 to `/usr/bin/rsync` and make it executable (755) there.

## C) Install the rsync script

### 1. Download
Download the `rsync_script.sh` script and make it executable.

### 2. Run the script
Run the rsync_script.sh like so: `./rsync_script.sh <local_directory>`
Where the `<local_directory>`is the directory, where you want the recordings to go. On the first try it might take a while, as it will copy ALL your recordings. So this depends on how many recordings you have.

### 3. Run regularly (cron job?)
Run this every time you need to sync the recordings to your local drive. I run this off a customised StreamDeck key ;)