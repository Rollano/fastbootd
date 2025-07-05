#!/usr/bin/env bash

# =====================================================================
#  Fastboot Utility – menu‑driven helper for common ADB/Fastboot tasks
#  Added: ASCII‑art banner, animated loading screen, consolidated color
#         variables and minor shell‑script best‑practice tweaks.
#         2025‑07‑05  – ADB Tools sub‑menu (resolution, APK, screenshot)
#         2025‑07‑05  – Added wireless debugging options
# =====================================================================

# ──────────────────────────  Colors  ─────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'   # No Color / reset

# ─────────────────────────  Banner  ──────────────────────────────────
banner() {
  echo -e "${GREEN}"
  echo "=============================="
  echo " ███████╗ █████╗ ███████╗████████╗██████╗  ██████╗ "
  echo " ██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗"
  echo " █████╗  ███████║███████╗   ██║   ██████╔╝██║   ██║"
  echo " ██╔══╝  ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║"
  echo " ██║     ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝"
  echo " ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  "
  echo "         Fastboot  Utility          "
  echo "=============================="
  echo -e "${NC}"
}

# ──────────────────────  Animated Loading  ───────────────────────────
loading_screen() {
  local sp='/-\|' i
  echo -ne "${CYAN}Loading "
  for i in {1..24}; do
    printf "\b${sp:i%${#sp}:1}"
    sleep 0.1
  done
  echo -e "${NC}\n"
}

# ──────────────────────  ADB Device Check  ───────────────────────────
check_adb_device() {
  adb devices | grep -w "device" > /dev/null
  if [ $? -ne 0 ]; then
    echo -e "${RED}⚠️  No ADB device detected. Continue anyway...${NC}"
  else
    echo -e "${GREEN}✔ ADB device connected.${NC}"
  fi
}

# ───────────────────  ADB Utilities Sub‑Menu  ────────────────────────
adb_tools_menu() {
  while true; do
    clear
    banner
    echo -e "${CYAN}--- ADB Tools (Utilities) ---${NC}"
    check_adb_device

    echo -e "${CYAN}1.${NC} Change screen resolution"
    echo -e "${CYAN}2.${NC} Reset resolution to default"
    echo -e "${CYAN}3.${NC} Install APK"
    echo -e "${CYAN}4.${NC} Take screenshot (saved locally)"
    echo -e "${CYAN}5.${NC} Enable Wireless Debugging"
    echo -e "${CYAN}6.${NC} Connect via Wireless IP:Port"
    echo -e "${CYAN}7.${NC} Disconnect all Wireless ADB"
    echo -e "${CYAN}8.${NC} Back to Main Menu"
    echo "------------------------------"

    read -rp "🔧 Enter your choice [1-8]: " adb_choice
    echo ""

    case $adb_choice in
      1)
        read -rp "Enter new resolution WxH (e.g., 1080x1920): " res
        echo -e "${YELLOW}Setting resolution to ${res}...${NC}"
        adb shell wm size "$res"
        ;;
      2)
        echo -e "${YELLOW}Resetting resolution to default...${NC}"
        adb shell wm size reset
        ;;
      3)
        read -rp "📦 Enter path to APK: " apkpath
        echo -e "${YELLOW}Installing APK...${NC}"
        adb install -r "$apkpath"
        ;;
      4)
        ts=$(date +%Y%m%d_%H%M%S)
        echo -e "${YELLOW}Capturing screenshot...${NC}"
        adb exec-out screencap -p > "screenshot_${ts}.png"
        echo -e "${GREEN}✅ Saved as screenshot_${ts}.png${NC}"
        ;;
      5)
        echo -e "${YELLOW}Enabling wireless debugging...${NC}"
        adb tcpip 5555
        echo -e "${GREEN}✔ Wireless debugging started on port 5555${NC}"
        ;;
      6)
        read -rp "Enter IP address of device (e.g., 192.168.1.10:5555): " ip
        echo -e "${YELLOW}Connecting to ${ip}...${NC}"
        adb connect "$ip"
        ;;
      7)
        echo -e "${YELLOW}Disconnecting all wireless devices...${NC}"
        adb disconnect
        ;;
      8)
        break
        ;;
      *)
        echo -e "${RED}❌ Invalid choice. Try again.${NC}"
        ;;
    esac
    echo ""
    read -rp "🔁 Press Enter to continue..."
  done
}

# ──────────────────────────  Main Menu  ──────────────────────────────
while true; do
  clear
  banner
  loading_screen
  check_adb_device

  echo -e "${CYAN}1.${NC}  Reboot to bootloader"
  echo -e "${CYAN}2.${NC}  Reboot device (from fastboot)"
  echo -e "${CYAN}3.${NC}  Flash boot.img"
  echo -e "${CYAN}4.${NC}  Flash recovery.img"
  echo -e "${CYAN}5.${NC}  Unlock bootloader"
  echo -e "${CYAN}6.${NC}  Lock bootloader"
  echo -e "${CYAN}7.${NC}  Exit"
  echo -e "${CYAN}8.${NC}  Flash system.img"
  echo -e "${CYAN}9.${NC}  Flash vendor.img"
  echo -e "${CYAN}10.${NC} ADB Sideload ZIP"
  echo -e "${CYAN}11.${NC} Backup partitions (boot/recovery/system/vendor)"
  echo -e "${CYAN}12.${NC} Show connected ADB devices"
  echo -e "${CYAN}13.${NC} ADB Tools (utilities)"
  echo "------------------------------"

  read -rp "🔧 Enter your choice [1-13]: " choice
  echo ""

  case $choice in
    1)
      echo -e "${YELLOW}Rebooting to bootloader...${NC}"
      adb reboot bootloader || echo -e "${RED}❌ Failed to reboot. No device?${NC}"
      ;;
    2)
      echo -e "${YELLOW}Rebooting device from fastboot...${NC}"
      fastboot reboot
      ;;
    3)
      read -rp "📦 Enter path to boot.img: " bootimg
      echo -e "${YELLOW}Flashing boot image...${NC}"
      fastboot flash boot "${bootimg}"
      ;;
    4)
      read -rp "📦 Enter path to recovery.img: " recoveryimg
      echo -e "${YELLOW}Flashing recovery image...${NC}"
      fastboot flash recovery "${recoveryimg}"
      ;;
    5)
      echo -e "${RED}⚠️  WARNING: Unlocking will erase all data!${NC}"
      read -rp "Proceed to unlock bootloader? [y/N]: " confirm
      if [[ ${confirm,,} == "y" ]]; then
        fastboot oem unlock
      else
        echo "Cancelled."
      fi
      ;;
    6)
      echo -e "${YELLOW}Locking bootloader...${NC}"
      fastboot oem lock
      ;;
    7)
      echo -e "${GREEN}👋 Goodbye!${NC}"
      exit 0
      ;;
    8)
      read -rp "📦 Enter path to system.img: " systemimg
      echo -e "${YELLOW}Flashing system image...${NC}"
      fastboot flash system "${systemimg}"
      ;;
    9)
      read -rp "📦 Enter path to vendor.img: " vendorimg
      echo -e "${YELLOW}Flashing vendor image...${NC}"
      fastboot flash vendor "${vendorimg}"
      ;;
    10)
      echo -e "${YELLOW}Rebooting to sideload mode...${NC}"
      adb reboot sideload || echo -e "${RED}❌ Failed to reboot. No device?${NC}"
      sleep 5
      read -rp "📦 Enter path to ZIP file: " zipfile
      echo -e "${YELLOW}Starting sideload...${NC}"
      adb sideload "${zipfile}"
      ;;
    11)
      backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
      mkdir -p "${backup_dir}"
      echo -e "${YELLOW}Backing up partitions to ${backup_dir}...${NC}"
      adb pull /dev/block/bootdevice/by-name/boot     "${backup_dir}/boot.img"
      adb pull /dev/block/bootdevice/by-name/recovery "${backup_dir}/recovery.img"
      adb pull /dev/block/bootdevice/by-name/system   "${backup_dir}/system.img"
      adb pull /dev/block/bootdevice/by-name/vendor   "${backup_dir}/vendor.img"
      echo -e "${GREEN}✅ Backup complete.${NC}"
      ;;
    12)
      echo -e "${YELLOW}Listing connected ADB devices...${NC}"
      adb devices
      ;;
    13)
      adb_tools_menu
      ;;
    *)
      echo -e "${RED}❌ Invalid choice. Try again.${NC}"
      ;;
  esac

  echo ""
  read -rp "🔁 Press Enter to return to menu..."
  # Loop repeats

done
