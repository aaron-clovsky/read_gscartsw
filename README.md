# Read the Current Input of gscartsw from EXT Header via GPIO

## MOTIVATION

The [gscartsw](https://www.retrorgb.com/gscartsw.html)
is an automatic [SCART](https://www.retrorgb.com/scarttodisplay.html) switch
with an EXT header that supports reading and changing the current input.
<br><br>
This script will not change the current input but will read the current input.
<br><br>
This script was written in BASH and tested on Linux, using the latest
32-bit Raspbian (as of 1/12025) on a Raspberry Pi Zero W.

## CREDIT

- superg for making the gscartsw
- [shmups.system11.org](https://shmups.system11.org) for documenting the
EXT header pinout

## EXT HEADER PINOUT

**Pin 1: GND**<br>
**Pin 2: Override**<br>
**Pin 3: N/C**<br>
**Pin 4: +5V**<br>
**Pin 5: IN_BIT0**<br>
**Pin 6: IN_BIT1**<br>
**Pin 7: IN_BIT2**<br>
**Pin 8: N/C**<br>

[source](https://shmups.system11.org/viewtopic.php?t=50851&start=3060)

## RASPBERRY PI PINOUT

[pinout.xyz](https://pinout.xyz)

## BUILD INSTRUCTIONS

- Connect your device's GND to EXT Header Pin 1
- Connect three of your device's GPIO pins to EXT Header Pins 5, 6 and 7
- Modify ```read_gscartsw.sh``` to match your GPIO pins or connect as follows:
  - Connect EXT Header Pin 5 to GPIO 12
  - Connect EXT Header Pin 6 to GPIO 20
  - Connect EXT Header Pin 7 to GPIO 21
- Copy ```read_gscartsw.sh``` to a directory on your device 
- ```cd``` to the directory on your device that you copied
```read_gscartsw.sh``` to
- Run ```chmod +x ./read_gscartsw.sh``` to make the script executable
- Run ```./read_gscartsw.sh``` to run the script

#### NOTES

While the EXT header is intended to accommodate a standard 4x2 pin male
DuPont header (with the help of a soldering iron), the height of the acrylic
top plate on the gscartsw is too low to accommodate standard DuPont wire,
I solved this by using wire cutters to reduce the height of the wire
side of the female DuPont connector by ~4mm. This was tricky, and I do not
necessarily recommend it, but it did work.

#### WARNING

Directly connecting GPIO pins is only safe if the logic level is 3.3v, which
is true of gscartsw v5.2. If you have a different version you should check
the logic level by testing the voltage at EXT Header Pins 5, 6 and 7 when 
a SCART input is active on input 8 (located closest to the SCART output). This
will cause each of the pins to be driven high, allowing for easy
voltage testing.

## SYNOPSIS

```read_gscartsw.sh```

## DESCRIPTION

Simple BASH script to read the current input from the gscartsw. This script
accepts no arguments.

This script may return one of two values:
 - 0 (Success)
 - 1 (Failure)

On success this script will output (to stdout) the currently active
SCART input, or zero if no input is active.

Errors are output to stderr.

## License
This script is licensed under the
[MIT License](https://opensource.org/licenses/MIT).
