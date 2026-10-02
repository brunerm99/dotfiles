# System-level performance settings

Files under `etc/` mirror `/etc` on the Omarchy laptop (ThinkPad T480s,
i7-8650U). They need root, so they are installed by hand with the commands
below, run from this directory. One reboot at the end covers the fan and
mitigation changes.

The laptop is limited by heat: under all-core load it reaches 97 °C in about
3 s and settles near 3.0 GHz of a possible 3.9 GHz. The fan and undervolt
settings raise that ceiling; the mitigation setting removes kernel overhead.

## Fan control

`thinkfan` (AUR) drives the fan through `thinkpad_acpi`. Its package ships
`/usr/lib/modprobe.d/thinkpad_acpi.conf` with `fan_control=1`, which takes
effect when the module next loads (at reboot).

```sh
yay -S thinkfan
sudo install -Dm644 etc/thinkfan.yaml /etc/thinkfan.yaml
sudo install -Dm644 etc/systemd/system/thinkfan.service.d/performance.conf \
  /etc/systemd/system/thinkfan.service.d/performance.conf
sudo systemctl daemon-reload
sudo systemctl enable thinkfan.service
```

After the reboot, `cat /sys/module/thinkpad_acpi/parameters/fan_control` should
print `Y` and `systemctl status thinkfan` should be active. If thinkfan stops,
the driver's watchdog hands the fan back to the firmware.

To undo: `sudo systemctl disable --now thinkfan.service`.

## CPU undervolt

`intel-undervolt` writes a voltage offset that lasts until power-off, so a bad
value is cleared by a reboot as long as the service is not enabled yet.

```sh
sudo pacman -S intel-undervolt stress-ng
sudo install -Dm644 etc/intel-undervolt.conf /etc/intel-undervolt.conf
sudo intel-undervolt apply
sudo intel-undervolt read
```

If `read` still shows 0 mV, the firmware blocks undervolting and this section
does not apply. Otherwise test before making it permanent:

```sh
stress-ng --cpu 8 --cpu-method all --verify -t 10m
```

Use the machine normally for a day as well; undervolt crashes often show up at
idle rather than under load. Then enable it for boot and resume:

```sh
sudo systemctl enable intel-undervolt.service
```

To go further, lower `CPU` and `CPU Cache` together by 10 mV in
`etc/intel-undervolt.conf`, reinstall, `apply`, and repeat the tests.

## CPU mitigations

```sh
sudo install -Dm644 etc/limine-entry-tool.d/mitigations.conf \
  /etc/limine-entry-tool.d/mitigations.conf
sudo limine-update
```

After the reboot, `grep -o 'mitigations=off' /proc/cmdline` should match.
Existing Snapper boot entries keep the old command line.

To undo: delete `/etc/limine-entry-tool.d/mitigations.conf`, run
`sudo limine-update`, and reboot.
