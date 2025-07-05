Fastboot Utility
A menu‑driven helper script for common ADB / Fastboot tasks on Android devices, tailored for Termux (but works in any Bash‑compatible environment).

✨ Features
Stylish ASCII‑art banner & animated loading spinner
Auto‑detects ADB connection (continues gracefully if none)
Flash images: boot / recovery / system / vendor
Unlock ▸ lock bootloader (with data‑wipe warning)
ADB Sideload ZIPs / OTAs
Partition backup (boot, recovery, system, vendor)
ADB Tools sub‑menu
Change / reset screen resolution
Install APKs from local storage
Capture screenshots straight to host
Enable ▸ connect ▸ disconnect wireless debugging
Color‑coded terminal output (green = success, yellow = action, red = warning)

📋 Prerequisites
Requirement
Notes
Termux or any Linux distro
Recommended: latest version
adb & fastboot binaries
Termux: pkg install android-tools
USB Debugging enabled
Developer Options ➜ USB Debugging
Same Wi‑Fi network (for wireless ADB)
Device + host must share LAN

🚀 Installation
# 1. Clone the repository
$ git clone https://github.com/<your-username>/fastboot-utility.git
$ cd fastboot-utility

# 2. Make the script executable
$ chmod +x fastboot-utility.sh

# 3. (Optional) Move it somewhere in $PATH
$ mv fastboot-utility.sh $PREFIX/bin/fastboot-utility

Tip: Rename the script or symlink it for quick access.

▶️ Usage
$ ./fastboot-utility.sh

Choose an action by typing its number and pressing Enter.
Main Menu Options
#
Action
1
Reboot to bootloader
2
Reboot device (from Fastboot)
3
Flash boot.img
4
Flash recovery.img
5
Unlock bootloader ⚠ factory reset
6
Lock bootloader
7
Exit
8
Flash system.img
9
Flash vendor.img
10
ADB Sideload ZIP
11
Backup partitions (boot / recovery / system / vendor)
12
Show connected ADB devices
13
ADB Tools sub‑menu
ADB Tools Sub‑menu
#
Utility
1
Change screen resolution
2
Reset resolution to default
3
Install APK (adb install -r)
4
Take screenshot → host
5
Enable wireless debugging (adb tcpip 5555)
6
Connect via IP:PORT
7
Disconnect all wireless ADB
8
Back to main menu

🤝 Contributing
Pull requests are welcome! Please open an issue to discuss major changes first.

📜 License
This project is licensed under the MIT License. See the LICENSE file for details.

⚠️ Disclaimer
Flashing partitions, unlocking bootloaders, and other low‑level operations can brick your device and void your warranty. Proceed at your own risk. Always back up important data before continuing.

