# NMCLI Basic usage
## Connect to a new network
For example, if you want to connect for the first time to the network named "TELLO-S5" with your network interface wlan1 (WIFI dongle for instance), enter the following instruction:
```bash
nmcli device wifi connect "TELLO-S5" ifname wlan1 --ask
```
You will be asked to enter the corresponding password.

## Connect to a known network
```bash
nmcli connection up "TELLO-S5"
```
or
```bash
nmcli c up "TELLO-S5"
```

## Disconnect from a known network
```bash
nmcli connection down "TELLO-S5"
```
or
```bash
nmcli c down "TELLO-S5"
```

## Delete a known network
```bash
nmcli connection delete "connection_name"
```

