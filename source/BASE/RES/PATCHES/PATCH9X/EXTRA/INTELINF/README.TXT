======================================================================
          "Slipstreamable" Intel Motherboard Chipset Drivers
                    for Windows 98 Second Edition
                              Version 1.0
                           November 22, 2015
======================================================================

Copyright (c) 2013-2015, Conner McCoy (LoneCrusader)

INF data taken from the Intel Chipset Software Installation Utility,
	Versions 6.3.0.1007, 8.3.1.1009, 9.4.0.1017


This package supersedes the older version of the "Slipstreamable" drivers
in that it provides INF data for newer systems. However, it requires different
handling during installation than the previous package. The previous package
could simply be dropped into the SETUP folder of a new installation and SETUP
would automatically use the files. This package requires some manual steps to
be taken by the user in order to function. Unless you need support for desktop
boards with Intel ICH10 or newer chipsets or server boards with ICH5 or newer
chipsets there is no benefit in using this newer package.


Chances are, if you are downloading and using this package then you already
know what you are doing and will not need detailed instructions or explanations.
If you do need assistance or encounter problems, please ask your question or
report your issue here, on the MSFN Forums.
http://www.msfn.org/board/topic/163405-slipstreamable-intel-chipset-inf-drivers/


These files provide "motherboard chipset drivers" for newer Intel chipset
based systems where no official Windows 9x drivers are available.

"Motherboard chipset drivers" generally are only text INF files that
specifically identify motherboard components by name. While these drivers can
prevent annoying "Unknown devices" from showing up in your Device Manager,
they are not "required" for operating system function. Your system will
most likely not perform any better or worse, with or without these drivers.


To use these files:


If you are setting up a new Windows 98SE installation:

Copy all of the INF files into your SETUP folder (usually \WIN98) on your hard
drive (or, if you prefer to install from CD-ROM, you will need to burn a new CD).

It is usually easier to copy the Windows 98 SETUP files to the hard drive and
install from there, as this prevents Windows 98 from asking for the CD-ROM when
installing new devices or components.

Run SETUP.

When the "first round" of SETUP has completed and your machine reboots, you will
need to press F8 during the reboot and access the Command Prompt before the
"second round" of SETUP begins.

Once you are at the Command Prompt, you will need to manually copy MACHINE3.INF,
MACHINE4.INF, and MACHINE5.INF from your SETUP folder to the \INF folder of your
new installation, (usually WINDOWS\INF).

Once you have done these steps, reboot your machine again and allow the "second
round" of SETUP to continue normally.

When you reach the Desktop, check your Device Manager to verify the devices have
been installed properly. They will show up under the "System devices" category.


If you are moving an existing Windows 98SE installation:

Use the Device Manager to remove all of your previous system's devices before
attempting to move the drive. Some of this may need to be done in Safe Mode.

Copy all of the INF files to your \INF folder (usually WINDOWS\INF).
It is OK to overwrite MACHINE.INF and MACHINE2.INF as an original copy can always
be extracted from your PRECOPY2.CAB file if needed, but you can back them up
using a different file extension if desired.

Move the drive to your new system and boot up Windows 98SE. New devices should
be automatically detected, identified, and installed. Several reboots may be
required in some setups.


LEGAL:

This software is UNOFFICIAL and UNSUPPORTED.

By using this software, you assume all responsibility for its use or misuse and agree
that the author provides no warranty or guarantee of any kind as to the usefulness of
this software for your purpose; and that the author will not be liable for any damages
resulting from the use or misuse of this software.

This package may NOT be distributed without this document attached and intact.
