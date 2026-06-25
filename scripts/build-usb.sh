#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out_dir="$repo_root/artifacts"
usbroot="$out_dir/usbroot"
img_path="$out_dir/dekasigna-usb.img"
zip_path="$out_dir/dekasigna-usb.zip"

mkdir -p "$usbroot/EFI/Boot" "$usbroot/EFI/BOOT" "$usbroot/tools" "$usbroot/lab/mock-uefi-acpi" "$usbroot/lab/hackintosh-9470m" "$usbroot/lab/libreboot" "$usbroot/validation" "$usbroot/validation/ms-uefi-validation" "$usbroot/windows"

cp "$repo_root/tools/uefi/Shell.efi" "$usbroot/EFI/Boot/Bootx64.efi"
cp "$repo_root/tools/uefi/Shell.efi" "$usbroot/EFI/BOOT/BOOTX64.EFI"
cp "$repo_root/tools/uefi/AutoSecureBootFix.nsh" "$usbroot/"
cp "$repo_root/tools/uefi/FactoryFirmwarePatch.nsh" "$usbroot/"
cp "$repo_root/tools/uefi/UpdateKeys.nsh" "$usbroot/"
cp "$repo_root/tools/uefi/usb-layout.txt" "$usbroot/"
cp "$repo_root/generators/hp-customer-keys.sh" "$usbroot/tools/"
cp "$repo_root/generators/usermode-pk.sh" "$usbroot/tools/"
cp "$repo_root/validation/run-validation.ps1" "$usbroot/tools/"
cp "$repo_root/validation/README.md" "$usbroot/validation/"
cp "$repo_root/validation/ms-uefi-validation/README.md" "$usbroot/validation/ms-uefi-validation/"
cp "$repo_root/windows/block-ms-dbx.ps1" "$usbroot/windows/"
cp "$repo_root/windows/fix-secureboot-update.ps1" "$usbroot/windows/"
cp "$repo_root/windows/hp-9470m-secureboot-checklist.ps1" "$usbroot/windows/"
cp "$repo_root/windows/query-version-and-status.ps1" "$usbroot/windows/"
cp "$repo_root/windows/rufus-write-assist.ps1" "$usbroot/windows/"
cp "$repo_root/windows/log-secureboot-memory-integrity.ps1" "$usbroot/windows/"
cp "$repo_root/windows/hackintosh-9470m-lab-report.ps1" "$usbroot/windows/"
cp "$repo_root/windows/local-lab-report.ps1" "$usbroot/windows/"
cp "$repo_root/windows/libreboot-lab-report.ps1" "$usbroot/windows/"
cp "$repo_root/windows/libreboot-risk-score.ps1" "$usbroot/windows/"
cp "$repo_root/windows/verify-secureboot.ps1" "$usbroot/windows/"
cp "$repo_root/README.md" "$usbroot/README.txt"
cp "$repo_root/lab/mock-uefi-acpi/README.md" "$usbroot/lab/mock-uefi-acpi/"
cp "$repo_root/lab/mock-uefi-acpi/mock-device-tree.asl" "$usbroot/lab/mock-uefi-acpi/"
cp "$repo_root/lab/mock-uefi-acpi/mock-uefi-device.json" "$usbroot/lab/mock-uefi-acpi/"
cp "$repo_root/lab/hackintosh-9470m/README.md" "$usbroot/lab/hackintosh-9470m/"
cp "$repo_root/lab/hackintosh-9470m/compatibility-template.md" "$usbroot/lab/hackintosh-9470m/"
cp "$repo_root/lab/libreboot/README.md" "$usbroot/lab/libreboot/"
cp "$repo_root/lab/libreboot/flash-workflow.md" "$usbroot/lab/libreboot/"
cp "$repo_root/lab/libreboot/risk-matrix.md" "$usbroot/lab/libreboot/"

rm -f "$img_path" "$zip_path"

truncate -s 200M "$img_path"

partition_device=""
mount_point="$(mktemp -d)"
trap 'if [ -n "$partition_device" ]; then sudo losetup -d "$partition_device" 2>/dev/null || true; fi; sudo umount "$mount_point" 2>/dev/null || true; rmdir "$mount_point"' EXIT

sudo parted -s "$img_path" mklabel msdos >/dev/null
sudo parted -s "$img_path" mkpart primary fat32 1MiB 100% >/dev/null
sudo parted -s "$img_path" set 1 boot on >/dev/null

partition_offset=$((2048 * 512))
partition_device="$(sudo losetup --find --show --offset "$partition_offset" "$img_path")"
if [ -z "$partition_device" ]; then
  echo "Failed to create loop device for the FAT32 partition" >&2
  exit 1
fi

sudo mkfs.vfat -F32 -n DEKASIGNA "$partition_device" >/dev/null
sudo mount "$partition_device" "$mount_point"
sudo mkdir -p "$mount_point/EFI/Boot" "$mount_point/EFI/BOOT"
sudo cp -r "$usbroot"/. "$mount_point"/
sync
sudo umount "$mount_point"
sudo losetup -d "$partition_device"
partition_device=""
rmdir "$mount_point"
trap - EXIT

(cd "$out_dir" && zip -r "dekasigna-usb.zip" "usbroot" "dekasigna-usb.img" >/dev/null)

echo "Built $img_path and $zip_path"
