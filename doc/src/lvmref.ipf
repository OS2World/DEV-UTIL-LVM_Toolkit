:userdoc.
:title.Logical Volume Manager Programming Reference


.* ----------------------------------------------------------------------------
.* Introduction
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100% id=about.About This Book
:p.This book describes the application programming interface (API) of the IBM
Logical Volume Manager for OS/2.  This API is contained in the :hp2.LVM
Engine:ehp2. (LVM.DLL), and provides routines for&colon.
:ul compact.
:li.Access to information about both physical and virtual storage devices.
:li.Creation, deletion, and modification of partitions and logical volumes.
:li.Installation, uninstallation, and configuration of the IBM Boot Manager.
:eul.
:p.The information in this book is principally derived from the OS/2 Reference
Code originally released by IBM as part of the Enterprise Volume Management
System project (http&colon.//evms.sourceforge.net).


.* ----------------------------------------------------------------------------
.* About LVM
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100% id=lvm.About the Logical Volume Manager API
:p.The Logical Volume Manager (LVM) is a fixed-disk (DASD) partitioning program
designed to replace older, more primitive systems such as &osq.FDISK&csq..  It
provides many enhanced features, while still remaining compatible with the
traditional PC disk partitioning scheme.
:p.The features provided by LVM include&colon.
:ul compact.
:li.Logical volumes spanning multiple partitions, even on physically separate
disks.
:li.Dynamic volume expansion (when using a file system that supports it).
:li.Drive letters for LVM-managed disk volumes are explicitly assigned by the
user, rather than being determined automatically by the operating system, and
may be changed at any time.
:li.Improved support for new file systems, including bootable file systems.
:li.On-demand repartitioning without requiring a system reboot.
:li.INT13X support to allow booting from partitions that extend past 1024
cylinders.
:li.Customizable logical volume and partition names up to twenty characters in
length.
:eul.

:p.This documentation describes the application programming interface of LVM
version 1, which is included in the following operating systems&colon.
:ul compact.
:li.OS/2 Warp Server for e-business (WSeb)
:li.Convenience Package (1 and 2) for OS/2 Warp Version 4
:li.Convenience Package (1 and 2)for OS/2 Warp Server for e-business
:li.eComStation (all versions)
:eul.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=using.Using the LVM API
:p.Programs written to use the Logical Volume Manager should include the
appropriate header files.  The main header file is :hp2.lvm_intr.h:ehp2.; this
file includes most other header files required to use the LVM API.
:p.Certain definitions related to internal LVM structures require
:hp2.lvm_data.h:ehp2. to be included as well.  These are documented in the
individual data type descriptions.
:nt.All LVM data structures must be aligned on one-byte boundaries.  When using
the IBM C Compiler, you can ensure this by building with the :hp2./Sp1:ehp2.
parameter, or by using the :hp2.#pragma pack:ehp2. preprocessor directive.:ent.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=glossary.Common Terms
:p.This section describes some common terms used by LVM.

:dl break=all.

:dt.Active Partition
:dd.The &osq.active partition&csq. on a disk drive has a special meaning
according to the IBM PC partitioning scheme.  It indicates the partition from
which standard PC BIOS MBR boot code will attempt to boot.  (Note that the OS/2
MBR boot code uses the &osq.Startable&csq. flag for this purpose.)  The active
partition flag applies only to primary partitions, and is indicated by the
value 0x80 as the first byte of the partition's entry in the partition table.

:dt.Bootable
:dd.The term &osq.Bootable&csq. within the context of LVM specifically means a
partition or volume which has an entry on the Boot Manager menu.  Partitions or
volumes may only be designated as Bootable when Boot Manager is present and
active on the system.

:dt.Compatibility Volume
:dd.A compatibility volume is a volume which is compatible with non-LVM-aware
operating systems.  It consists of a single partition (primary or logical)
which is seen simply as a standard partition by other operating systems.

.* :dt.Hidden Partition
.* :dd.

:dt.Hidden Volume
:dd.A &osq.hidden&csq. volume is a volume which does not currently have a drive
letter assigned to it, and which is therefore not accessible by the user.

:dt.Installable
:dd.&osq.Installable&csq. is a special flag which is used only by the OS/2
install program, which uses it to identify the volume onto which OS/2 will be
installed.  This flag should not be set or used at any time other than during
operating system installation.

:dt.Logical Volume
:dd.A logical volume (also simply &osq.volume&csq.) consists of one or more
partitions which are seen by the operating system as a single logical allocation
unit, capable of being assigned a drive letter and formatted with a
filesystem.  Volumes are classified as either Compatibility or LVM volumes.

:dt.LVM Volume
:dd.An LVM volume is a type of volume which is capable of containing multiple
partitions, and of being formatted using the original implementation of the IBM
Journalled File System.  All partitions belonging to an LVM volume have a type
indicator of 0x35, and are not generally usable by non-LVM-aware operating
systems.

:dt.Partition
:dd.LVM uses the term &osq.partition&csq. to refer to any block of disk space
which corresponds either to a standard partition (according to the IBM PC
partitioning scheme) or to a contiguous region of free space.

:dt.Startable
:dd.A partition or volume which is &osq.Startable&csq. is identified as the
startup (boot) partition in the master boot record, to be booted directly when
the system starts.  Only primary partitions (or volumes consisting of one
primary partition) may be set Startable, and only one partition or volume may be
Startable at any one time.

:edl.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=namesize.LVM Name Strings
:p.LVM defines various data fields for name strings that are used to identify
disks, partitions, volumes, and filesystems.
:p.The sizes of these character arrays are defined by the contents described
below.
:p.Note that LVM allows the name to occupy the full length of the array; in
such cases, the string will not have a terminating null character.  The string
will be null-terminated if it is shorter than the total length of the array.

:table cols='25 5 50' rules='none' frame='none'.
:row.
:c.PARTITION_NAME_SIZE
:c.20
:c.Defines the size of a partition name.  Partition names are user defined names
given to a partition.
:row.
:c.VOLUME_NAME_SIZE
:c.20
:c.Defines the size of a volume name.  Volume names are user defined names given
to a volume.
:row.
:c.DISK_NAME_SIZE
:c.20
:c.Defines the size of a disk name.  Disk names are user defined names given to
physical disk drives in the system.
:row.
:c.FILESYSTEM_NAME_SIZE
:c.20
:c.The name of the filesystem in use on a partition.  In practice, a filesystem
name will not be more than 12 characters long (followed by a null terminator).
:etable.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=geometry.Disk Geometry Constants
:p.Several constants relating to basic disk geometry are defined for use
throughout LVM.  These are listed below.

:p.
:p.The number of bytes in a sector on the disk.
:xmp.
 BYTES_PER_SECTOR              512
:exmp.

:p.The maximum number of cylinders, heads, and sectors that a partition table
entry can accomodate.
:table cols='29 7 44' rules='none' frame='none'.
:row.
:c.MAX_CYLINDERS
:c.1024
:c.Cylinders are numbered 0 - 1023, for a maximum of 1024 cylinders.
:row.
:c.MAX_HEADS
:c.256
:c.Heads are numbered 0 - 255, for a maximum of 256 heads.
:row.
:c.MAX_SECTORS
:c.63
:c.Sectors are numbered 1 - 63, for a maximum of 63 sectors per track.
:etable.

:p.The following is used for determining the synthetic geometry reported for
Volumes employing drive linking.
:xmp.
 SYNTHETIC_SECTORS_PER_TRACK   63
:exmp.

:p.The following defines the minimum number of sectors to reserve on the disk
for Boot Manager.
:xmp.
 BOOT_MANAGER_SIZE             2048
:exmp.



.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=bugs.Known Problems
:p.The current OS/2 implementation of the LVM Engine has the following known
problems.
:ul.
:li.The name reported by the File_System_Name field of
:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
is incorrect for filesystem (partition) types 0x81, 0x82 and 0x83.  Specifically,
0x81 (undefined) and 0x82 (Linux swap) are reported as &osq.Linux&csq., and 0x83
(Linux native) is reported as undefined.
:li.A segmentation fault may occur when the
:link reftype=hd refid=FN_boot_manager_is_installed.Boot_Manager_Is_Installed:elink.
function is called.
:li.The latest version of LVM.DLL (shipped with OS2LVM.DMD 14.105 in LVM FixPak
XR0L002, or OS/2 Convenience Package FixPak XR0C006) will alway rewrite the MBR
on commit (with the same effects as if :link reftype=hd refid=FN_new_mbr.New_MBR:elink.
had been called.
:li.LVM does not recognize the four disk signature bytes (used by Windows NT
operating systems) located at offset 0x1B8 in the master boot record, and will
always overwrite them with 0s when committing changes.
:li.A trap is likely when attempting to assign a drive letter which is currently
in use by a NFS drive.
:eul.


.* ----------------------------------------------------------------------------
.* Functions
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100% id=functions.Functions
:p.This section describes the standard 32-bit functions from the LVM Engine
(LVM.DLL) which are available to applications.

:p.Functions relating to the LVM Engine itself&colon.
:sl compact.
:li.:link reftype=hd refid=FN_close_lvm_engine.Close_LVM_Engine:elink.
:li.:link reftype=hd refid=FN_commit_changes.Commit_Changes:elink.
:li.:link reftype=hd refid=FN_open_lvm_engine.Open_LVM_Engine:elink.
:li.:link reftype=hd refid=FN_refresh_lvm_engine.Refresh_LVM_Engine:elink.
:esl.

:p.Functions specific to drives&colon.
:sl compact.
:li.:link reftype=hd refid=FN_get_drive_control_data.Get_Drive_Control_Data:elink.
:li.:link reftype=hd refid=FN_get_drive_status.Get_Drive_Status:elink.
:esl.

:p.Functions specific to partitions&colon.
:sl compact.
:li.:link reftype=hd refid=FN_create_partition.Create_Partition:elink.
:li.:link reftype=hd refid=FN_delete_partition.Delete_Partition:elink.
:li.:link reftype=hd refid=FN_get_partition_handle.Get_Partition_Handle:elink.
:li.:link reftype=hd refid=FN_get_partition_information.Get_Partition_Information:elink.
:li.:link reftype=hd refid=FN_get_partitions.Get_Partitions:elink.
:li.:link reftype=hd refid=FN_set_active_flag.Set_Active_Flag:elink.
:li.:link reftype=hd refid=FN_set_os_flag.Set_OS_Flag:elink.
:esl.

:p.Functions specific to volumes&colon.
:sl compact.
:li.:link reftype=hd refid=FN_assign_drive_letter.Assign_Drive_Letter:elink.
:li.:link reftype=hd refid=FN_create_volume.Create_Volume:elink.
:li.:link reftype=hd refid=FN_delete_volume.Delete_Volume:elink.
:li.:link reftype=hd refid=FN_expand_volume.Expand_Volume:elink.
:li.:link reftype=hd refid=FN_get_installable_volume.Get_Installable_Volume:elink.
:li.:link reftype=hd refid=FN_get_volume_control_data.Get_Volume_Control_Data:elink.
:li.:link reftype=hd refid=FN_get_volume_information.Get_Volume_Information:elink.
:li.:link reftype=hd refid=FN_hide_volume.Hide_Volume:elink.
:li.:link reftype=hd refid=FN_set_installable.Set_Installable:elink.
:esl.

:p.Functions applicable to partitions, drives, and volumes&colon.
:sl compact.
:li.:link reftype=hd refid=FN_get_valid_options.Get_Valid_Options:elink.
:li.:link reftype=hd refid=FN_set_name.Set_Name:elink.
:li.:link reftype=hd refid=FN_set_startable.Set_Startable:elink.
:esl.

:p.Functions relating to Boot Manager&colon.
:sl compact.
:li.:link reftype=hd refid=FN_add_to_boot_manager.Add_To_Boot_Manager:elink.
:li.:link reftype=hd refid=FN_boot_manager_is_installed.Boot_Manager_Is_Installed:elink.
:li.:link reftype=hd refid=FN_get_boot_manager_handle.Get_Boot_Manager_Handle:elink.
:li.:link reftype=hd refid=FN_get_boot_manager_menu.Get_Boot_Manager_Menu:elink.
:li.:link reftype=hd refid=FN_get_boot_manager_options.Get_Boot_Manager_Options:elink.
:li.:link reftype=hd refid=FN_install_boot_manager.Install_Boot_Manager:elink.
:li.:link reftype=hd refid=FN_remove_boot_manager.Remove_Boot_Manager:elink.
:li.:link reftype=hd refid=FN_remove_from_boot_manager.Remove_From_Boot_Manager:elink.
:li.:link reftype=hd refid=FN_set_boot_manager_options.Set_Boot_Manager_Options:elink.
:esl.

:p.Other functions&colon.
:sl compact.
:li.:link reftype=hd refid=FN_changes_pending.Changes_Pending:elink.
:li.:link reftype=hd refid=FN_export_configuration.Export_Configuration:elink.
:li.:link reftype=hd refid=FN_free_engine_memory.Free_Engine_Memory:elink.
:li.:link reftype=hd refid=FN_get_available_drive_letters.Get_Available_Drive_Letters:elink.
:li.:link reftype=hd refid=FN_get_install_flags.Get_Install_Flags:elink.
:li.:link reftype=hd refid=FN_get_lvm_view.Get_LVM_View:elink.
:li.:link reftype=hd refid=FN_get_reboot_flag.Get_Reboot_Flag:elink.
:li.:link reftype=hd refid=FN_get_reserved_drive_letters.Get_Reserved_Drive_Letters:elink.
:li.:link reftype=hd refid=FN_new_mbr.New_MBR:elink.
:li.:link reftype=hd refid=FN_read_sectors.Read_Sectors:elink.
:li.:link reftype=hd refid=FN_reboot_required.Reboot_Required:elink.
:li.:link reftype=hd refid=FN_rediscover_prms.Rediscover_PRMs:elink.
:li.:link reftype=hd refid=FN_set_free_space_threshold.Set_Free_Space_Threshold:elink.
:li.:link reftype=hd refid=FN_set_install_flags.Set_Install_Flags:elink.
:li.:link reftype=hd refid=FN_set_min_install_size.Set_Min_Install_Size:elink.
:li.:link reftype=hd refid=FN_set_reboot_flag.Set_Reboot_Flag:elink.
:li.:link reftype=hd refid=FN_start_logging.Start_Logging:elink.
:li.:link reftype=hd refid=FN_stop_logging.Stop_Logging:elink.
:li.:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink.
:esl.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_add_to_boot_manager.Add_To_Boot_Manager
:p.This function adds a volume or partition to the Boot Manager menu.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Add_To_Boot_Manager(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,      /* (I) Handle of the partition or volume to be added */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml.
:pt.Handle
:pd.The handle of a partition or volume which is to be added to the Boot Manager
menu.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Handle is not a valid handle, a trap may result.
:p.If Handle represents a drive, then this function will abort and an error
condition will occur.
:p.If the partition or volume cannot be added to the Boot Manager menu, no
action is taken and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The Boot Manager menu may be altered.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds ADD_TO_BOOT_MANAGER16(
        CARDINAL32          Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_assign_drive_letter.Assign_Drive_Letter
:p.This function assigns a new drive letter to a volume.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Assign_Drive_Letter(

    :link reftype=hd refid=TYPE_address.ADDRESS:elink.      Volume_Handle,          /* (I) Handle of the volume whose drive letter is to be changed/set */
    char         New_Drive_Preference,   /* (I) The new drive letter to be assigned to the volume */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code              /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume which is to have its assigned drive letter
changed.
:pt.New_Drive_Preference
:pd.The new drive letter to assign to the volume.  This is specified as a literal
character value (e.g 'C', 'F', etc.).
:p.Specifying a non-alphabetic character will cause the volume to be assigned
no drive letter.  A volume with no drive letter is said to be &osq.hidden&csq.;
removing a volume's drive letter in this way therefore has the same effect as
calling the :link reftype=hd refid=FN_hide_volume.Hide_Volume:elink. function
on the volume in question.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the requested drive letter assignment cannot be made, the volume will not
be altered.
:p.If Volume_Handle is not a valid handle, a trap may result.
:p.If Volume_Handle is a partition or drive handle, then this function will
abort and an error condition will occur.
:p.In the event of an error, the value pointed to by Error_Code will be greater
than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A volume may have its drive letter assignment changed.

:p.
:p.:hp7.Notes:ehp7.
:p.If the drive letter being assigned is already in use by a volume which does
not lie on removable media, then the drive letter assignment will :hp2.not:ehp2.
be made.
:p.If the drive letter assignment is changed successfully, it will be reflected
immediately in the :link reftype=fn refid=VIR_letter_preference.Drive_Letter_Preference:elink.
field of the :link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink.
associated with the volume (as returned by any subsequent call to
:link reftype=hd refid=FN_get_volume_information.Get_Volume_Information:elink.).
However, the :link reftype=fn refid=VIR_current_letter.Current_Drive_Letter:elink.
field of the same structure will contain a null ('\0') character until the next
time the :link reftype=hd refid=FN_commit_changes.Commit_Changes:elink. function
is called.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds ASSIGN_DRIVE_LETTER16(
        CARDINAL32          Volume_Handle,
        char                New_Drive_Preference,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_boot_manager_is_installed.Boot_Manager_Is_Installed
:p.This function indicates whether or not Boot Manager is installed on the
first or second hard drives in the system.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink. _System Boot_Manager_Is_Installed(

    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink. *    Active,      /* (O) Address where the Boot Manager active status will be stored */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Active
:pd.Address of a :link reftype=hd refid=TYPE_BOOLEAN.BOOLEAN:elink. which
will indicate whether or not an active copy of Boot Manager was found.  This
value will be TRUE if Boot Manager is installed and active.  If Boot Manager
is installed but inactive, this value will be FALSE.
:p.If Boot Manager is not installed, this value is undefined.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The function returns TRUE if Boot Manager is found on one of the first two
hard drives in the system.  In this case, the value pointed to by Active will
indicate (TRUE or FALSE) whether or not this copy of Boot Manager is active.
:p.FALSE is returned if Boot Manager is not found or if an error occurs.  In
this case, the value pointed to by Active is undefined.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.The current OS/2 implementation of this function is unreliable, and calling
it may cause a segmentation fault in some circumstances.  If an application
needs to determine whether or not Boot Manager is installed, it should use the
:link reftype=hd refid=FN_get_boot_manager_handle.Get_Boot_Manager_Handle:elink.
function instead.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds BOOT_MANAGER_IS_INSTALLED16(
        BOOLEAN * _Seg16    Active,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_changes_pending.Changes_Pending
:p.This function indicates whether or not any changes were made to the system
which have not yet been comitted to disk.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink. _System Changes_Pending( void );
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:p.None.

:p.
:p.:hp7.Returns:ehp7.
:p.The function return value will be TRUE if the Logical Volume Manager has
uncomitted changes to one or more of the drives in the system.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds CHANGES_PENDING16( void );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_close_lvm_engine.Close_LVM_Engine
:p.This function closes the LVM Engine.  Any memory held by the LVM Engine is
freed.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Close_LVM_Engine ( void );
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:p.None.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Any memory held by the LVM Engine is released.

:p.
:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds CLOSE_LVM_ENGINE16( void );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_commit_changes.Commit_Changes
:p.This function saves any changes made to the partitioning information of the
OS2DASD-controlled disk drives in the system.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink. _System Commit_Changes(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code     /* (O) Address where the error code will be stored */

);
:exmp.

:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The return value will be TRUE if all of the partitioning/volume changes made
were successfully written to disk.  Also, if no errors occur, the value pointed
to by Error_Code will be 0 (LVM_ENGINE_NO_ERROR).
:p.If an error occurs, then the return value will be FALSE, and the value
pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than 0.

:p.Disk read and write errors will be indicated by setting the IO_Error field
of the :link reftype=hd refid=TYPE_drive_information_record.Drive_Information_Record:elink.
to TRUE.  Thus, if the function return value is FALSE, and *Error_Code indicates an
I/O error, the caller of this function should call the
:link reftype=hd refid=FN_get_drive_status.Get_Drive_Status:elink. function on each
drive to determine which drives had I/O errors.

:p.If a read or write error occurs, then the engine may not have been able to
create a partition or volume.  Thus, the caller may want to refresh all
partition and volume data to see what the engine was and was not able to
create.
:p.

:p.:hp7.Side Effects:ehp7.
:p.The partitioning information of the disk drives in the system may be altered.
:p.

:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds COMMIT_CHANGES16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_create_partition.Create_Partition
:p.This function creates a new partition on an LVM-controlled disk drive.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_address.ADDRESS:elink. _System Create_Partition(

    :link reftype=hd refid=TYPE_address             .ADDRESS:elink.               Handle,                        /* (I) Handle to disk or free space block */
    :link reftype=hd refid=TYPE_cardinal            .CARDINAL32:elink.            Size,                          /* (I) Partition size, in sectors */
    char                  Name[ PARTITION_NAME_SIZE ],   /* (I) Partition name */
    :link reftype=hd refid=TYPE_allocation_algorithm.Allocation_Algorithm:elink.  Algorithm,                     /* (I) Free space selection algorithm */
    :link reftype=hd refid=TYPE_boolean             .BOOLEAN:elink.               Bootable,                      /* (I) TRUE if partition must be bootable */
    :link reftype=hd refid=TYPE_boolean             .BOOLEAN:elink.               Primary_Partition,             /* (I) TRUE if partition must be primary */
    :link reftype=hd refid=TYPE_boolean             .BOOLEAN:elink.               Allocate_From_Start,           /* (I) TRUE to allocate from start of free space */
    :link reftype=hd refid=TYPE_cardinal            .CARDINAL32:elink. *          Error_Code                     /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of either a disk drive, or a block of free space.
:p.In the event that a disk handle is provided, the LVM Engine will
automatically determine which block of free space, out of those available on
the disk, should be used to create the new partition.  In this case, the
Algorithm parameter will govern how this determination is to be made.
:pt.Size
:pd.The size, in sectors, of the partition to create.
:pt.Name
:pd.The name to give to the newly-created partition.
:pt.Algorithm
:pd.If Handle is the handle of a disk drive, this parameter tells the LVM Engine
which algorithm should be used to find a suitable block of free space for the
new partition.  The available algorithms are described under the
:link reftype=hd refid=TYPE_allocation_algorithm.Allocation_Algorithm:elink.
type.
:pt.Bootable
:pd.If TRUE, then the new partition must be made bootable.  This means
that&colon.
:ul compact.
:li.If Boot Manager is installed on the system, then the partition is to be
added to the Boot Manager menu.
:li.If Boot Manager is not installed, and the Primary_Partition parameter
is set to TRUE, then the partition is to be made startable (i.e. marked as
the bootable partition in the Master Boot Record).
:eul.
:p.If the partition cannot be made bootable according to the above criteria,
the partition will not be created, and the value pointed to by Error_Code
will be non-zero.
:p.If the Primary_Partition parameter is set to FALSE, then it is assumed that
OS/2 is the operating system that will be booted.
:pt.Primary_Partition
:pd.If TRUE, then a primary partition will be created.
.br
If FALSE, then the engine will create a logical partition.
:pt.Allocate_From_Start
:pd.If TRUE, then the engine will allocate the new partition from the
beginning of the selected block of free space.  If FALSE, then the
partition will be allocated from the end of the block of free space.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The function return value will be the handle of the partition created.  If
the partition could not be created, then NULL will be returned, and the value
pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.
:p.If the partition cannot be created, then any memory allocated by this
function will be freed, and the partitioning of the disk in question will be
unchanged.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A partition may be created on a disk drive.

:p.
:p.:hp7.Notes:ehp7.
:p.If Handle is not a valid handle, then a trap may result.
:p.If Handle is the handle of a partition or volume, then the function will
abort, and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
CARDINAL32 _Far16 _Pascal _loadds CREATE_PARTITION16(
        CARDINAL32           Handle,
        CARDINAL32           Size,
        char  *     _Seg16   Name,
        Allocation_Algorithm Algorithm,
        BOOLEAN              Bootable,
        BOOLEAN              Primary_Partition,
        BOOLEAN              Allocate_From_Start,
        CARDINAL32 * _Seg16  Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_create_volume.Create_Volume
:p.This function creates a volume from a list of partitions.  The partitions
are specified by their corresponding handles.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Create_Volume(

    char         Name[ VOLUME_NAME_SIZE ],   /* (I) The name to assign to the volume */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Create_LVM_Volume,          /* (I) TRUE to create an LVM Volume, FALSE to create a Compatibility Volume */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Bootable,                   /* (I) TRUE if the new volume must be bootable */
    char         Drive_Letter_Preference,    /* (I) The drive letter to assign to the volume */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   FeaturesToUse,              /* (I) Reserved field, must be 0 */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Partition_Count,            /* (I) The number of partition handles being specified */
    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handles[ ],       /* (I) Array of partition handles */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code                  /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Name
:pd.The name to assign to the newly created volume.
:pt.Create_LVM_Volume
:pd.If TRUE, then an LVM volume is created; otherwise, a compatibility volume
is created.
:pt.Bootable
:pd.If TRUE, the volume will not be created unless OS/2 can be booted from
it.
:p.If this value is TRUE and Boot Manager is not installed, then the volume
must consist of a primary partition on the first drive in the system.  In
this event, the volume will be set as Startable.
:p.If Boot Manager is installed, setting this value to TRUE will cause the
newly-created volume to be added to the Boot Manager menu automatically.
:p.Note that if this value is TRUE, Create_LVM_Volume must be set to FALSE,
otherwise the volume creation will fail.
:pt.Drive_Letter_Preference
:pd.This is the drive letter to use for accessing the newly created
volume, specified as a literal character (e.g. &osq.C&csq., &osq.F&csq.,
etc.).  Specifying a non-alphabetic character will cause the volume to be
created without a drive letter (i.e. &osq.hidden&csq.).
:pt.FeaturesToUse
:pd.This is currently reserved for future use and should always be set to 0.
:pt.Partition_Count
:pd.The number of partition handles being specified in the Partition_Handles
array.  This indicates the total number of partitions that will be linked
together to form the volume being created.
:pt.Partition_Handles
:pd.An array of partition handles, each one specifying a partition that is to
become part of the volume being created.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Drive_Letter_Preference specifies a drive letter which is already in use
by a non-LVM-controlled drive (such as a network drive), then a trap is likely.
:p.If any of the handles specified in Partition_Handles is not a valid
handle, then a trap is likely.  If any of the handles are not partition handles,
then the volume will not be created, and an error condition will result.
:p.If Partition_Count is greater than the number of items in Partition_Handles,
then a trap is likely.
:p.The volume will not be created if any of the specified requirements cannot be
met.
:p.If the volume cannot be created, then the existing partition/volume structure
of the disk will be unchanged, any memory allocated by this function will be
freed, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A volume may be created.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds CREATE_VOLUME16(
        char   *     _Seg16 Name,
        BOOLEAN             Create_LVM_Volume,
        BOOLEAN             Bootable,
        char                Drive_Letter_Preference,
        CARDINAL32          FeaturesToUse,
        CARDINAL32          Partition_Count,
        CARDINAL32 * _Seg16 Partition_Handles,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_delete_partition.Delete_Partition
:p.This function deletes the specified partition.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Delete_Partition(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handle,    /* (I) Handle of the partition to be deleted */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code           /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Partition_Handle
:pd.The handle associated with the partition to be deleted.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the partition cannot be deleted, then the value pointed to by Error_Code
will be greater than 0.
:p.If Partition_Handle is not a valid handle, a trap may result.
:p.If Partition_Handle is the handle of a volume or disk, then this function
will abort, and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A partition on a disk drive may be deleted.

:p.
:p.:hp7.Notes:ehp7.
:p.A partition cannot be deleted if it is part of a volume.  The
:link reftype=hd refid=FN_delete_volume.Delete_Volume:elink. function must
be used in that case instead.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds DELETE_PARTITION16(
        CARDINAL32          Partition_Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_delete_volume.Delete_Volume
:p.This function deletes the specified volume and its constituent partitions.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Delete_Volume(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Volume_Handle,   /* (I) Handle of the volume to be deleted */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume to delete.  All partitions which are part of the
specified volume will also be deleted.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Volume_Handle is not a valid handle, a trap may result.
:p.If Volume_Handle is the handle of a partition or drive, then this function
will abort and an error condition will occur.
:p.If the volume or any of its partitions can not be deleted, then this function
will make no changes to the system.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A volume and its partitions may be deleted.  System memory may be freed as
the internal structures used to track the deleted volume are no longer required.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds DELETE_VOLUME16(
        CARDINAL32          Volume_Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_expand_volume.Expand_Volume
:p.This function expands an existing volume by linking additional partitions
into it.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Expand_Volume(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Volume_Handle,          /* (I) Handle of the volume to be expanded */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Partition_Count,        /* (I) The number of handles being specified */
    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handles[ ],   /* (I) Array of partition and/or volume handles */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code              /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume to be expanded.
:pt.Partition_Count
:pd.The number of handles specified in the Partition_Handles array.  This
indicates the number of partitions or volumes to be added to the volume
being expanded.
:pt.Partition_Handles
:pd.An array of handles.  Each handle in the array is the handle of a
partition or volume which is to be added to the volume being expanded.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Volume_Handle is not a valid handle, a trap may result.
:p.If Volume_Handle is a partition or drive handle, then this function will
abort and a error condition will occur.
:p.If any of the handles in the Partition_Handles array are not valid handles,
a trap may result.
:p.If any of the handles in the Partition_Handles array are drive handles, then
this function will abort and an error condition will occur.
:p.If Partition_Count is greater than the number of entries in the
Partition_Handles array, a trap may result.
:p.If the volume cannot be expanded, the state of the volume is unchanged
and any memory allocated by this function is freed.
:p.In the event of an error, the value pointed to by Error_Code will be greater
than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A volume may be expanded.  If the volume is expanded using another volume,
the partitions on the second volume will be linked to those of the first
volume and all data on the second volume will be lost.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds EXPAND_VOLUME16(
        CARDINAL32          Volume_Handle,
        CARDINAL32          Partition_Count,
        CARDINAL32 * _Seg16 Partition_Handles,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_export_configuration.Export_Configuration
:p.This function creates a file containing all of the LVM.EXE commands necessary
to recreate or replicate all of the current system's partitions and volumes.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Export_Configuration(

    char       * Filename,      /* (I) Filespec of the file to be created */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code     /* (O) Address where the error code will be stored */

);
:exmp.

:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Filename
:pd.The path and filename of the configuration file to be created.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the output file cannot be created, or some other error occurs, the value
pointed to by Error_Code will be greater than 0.
:p.

:p.:hp7.Side Effects:ehp7.
:p.A file containing LVM commands may be created.
:p.

:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds EXPORT_CONFIGURATION16(
    char *       _Seg16 Filename,
    CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_free_engine_memory.Free_Engine_Memory
:p.This function frees a memory object which was previously allocated and
returned by the LVM Engine.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Free_Engine_Memory(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink. Object   /* (I) Memory object to be freed */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Object
:pd.The memory object to be freed.  This could be the Drive_Control_Data field of a
:link reftype=hd refid=TYPE_drive_control_array.Drive_Control_Array:elink., the
Partition_Array field of a
:link reftype=hd refid=TYPE_partition_information_array.Partition_Information_Array:elink.
structure, or any other dynamically allocated memory object created and returned
by a function in LVM.DLL.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.A trap or exception could occur if a bad address is passed to this function.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds FREE_ENGINE_MEMORY16( ADDRESS _Seg16 Object );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_available_drive_letters.Get_Available_Drive_Letters
:p.This function returns a bitmap indicating which drive letters are available
for use.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. _System Get_Available_Drive_Letters(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.This function returns a bitmap of the available drive letters.
:p.Drive letters &osq.A&csq. through &osq.Z&csq. are represented in the bitmap
from right to left.  In other words, &osq.A&csq. is 0x00000001 and &osq.Z&csq.
is 0x02000000.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be > 0, and the
returned bitmap will have all bits set to 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.A drive letter is available if it is not associated with a volume located on
a disk drive controlled by OS2DASD.  This includes drive letters which are
currently assigned to non-LVM devices, such as CD-ROM and network drives.
:p.You can use the :link reftype=hd refid=FN_get_reserved_drive_letters.Get_Reserved_Drive_Letters:elink.
function to determine which drive letters are currently in use by non-LVM
devices.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
CARDINAL32 _Far16 _Pascal _loadds GET_AVAILABLE_DRIVE_LETTERS16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_boot_manager_handle.Get_Boot_Manager_Handle
:p.This function returns the handle of the partition which contains Boot Manager.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_address.ADDRESS:elink. _System Get_Boot_Manager_Handle(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.If Boot Manager is installed (whether it is active or not), the handle of
the partition which it resides in is returned.
:p.If Boot Manager is not installed, NULL is returned.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by  Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
ADDRESS _Far16 _Pascal _loadds GET_BOOT_MANAGER_HANDLE16( CARDINAL32 * _Seg16 Error_Code);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_boot_manager_menu.Get_Boot_Manager_Menu
:p.This function returns an array containing the handles of the partitions and
volumes which appear on the Boot Manager menu.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boot_manager_menu.Boot_Manager_Menu:elink.  _System Get_Boot_Manager_Menu(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The function returns a
:link reftype=hd refid=TYPE_boot_manager_menu.Boot_Manager_Menu:elink.
structure.  This structure contains two items: a pointer to an array of
:link reftype=hd refid=TYPE_boot_manager_menu_item.Boot_Manager_Menu_Item:elink.
structures, and a Count field indicating the number of items in the array.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the Count field in the returned structure will be 0
and the Menu_Items pointer will be NULL.  Any memory allocated by this function
will be freed, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_BOOT_MANAGER_MENU16(
        Boot_Manager_Menu_Item * _Seg16 * _Seg16 Menu_Items,
        CARDINAL32 *                      _Seg16 Count,
        CARDINAL32 *                      _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_boot_manager_options.Get_Boot_Manager_Options
:p.This function returns the current Boot Manager settings.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Get_Boot_Manager_Options(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.    * Handle,             /* (O) Handle of the default volume/partition */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    * Handle_Is_Volume,   /* (O) TRUE if Handle represents a volume */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    * Timer_Active,       /* (O) TRUE if the timeout timer is active */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Time_Out_Value,     /* (O) Timeout interval in seconds */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    * Advanced_Mode,      /* (O) TRUE if menu will display in advanced mode */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code          /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the default boot volume or partition.
:pt.Handle_Is_Volume
:pd.If TRUE, then Handle represents a volume.  If FALSE, then Handle represents
a partition.
:pt.Timer_Active
:pd.If TRUE, then the timeout timer is active.  If FALSE, then the timeout timer
is not active.
:pt.Time_Out_Value
:pd.If the timeout timer is active, then this is the number of seconds that Boot
Manager will wait for user input before booting the default volume/partition.
:pt.Advanced_Mode
:pd.If TRUE, then Boot Manager is operating in advanced mode.  If FALSE, then
Boot Manager is operating in normal mode.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If any of the parameters is invalid, then a trap is likely.  If Boot Manager
is not installed, or any other error occurs, then the value pointed to by
Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.The values pointed to by each of the parameters will be set by this function.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_BOOT_MANAGER_OPTIONS16(
        CARDINAL32 * _Seg16 Handle,
        BOOLEAN    * _Seg16 Handle_Is_Volume,
        BOOLEAN    * _Seg16 Timer_Active,
        CARDINAL32 * _Seg16 Time_Out_Value,
        BOOLEAN    * _Seg16 Advanced_Mode,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_drive_control_data.Get_Drive_Control_Data
:p.This function returns an array of drive control records.  These records
provide important information about the drives in the system, including the
handles required to access them.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_drive_control_array.Drive_Control_Array:elink. _System Get_Drive_Control_Data(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.A :link reftype=hd refid=TYPE_drive_control_array.Drive_Control_Array:elink.
structure is returned.  If no errors occur, the Drive_Control_Data field will
be non-NULL, the Count field will be greater than 0, and the value pointed to
by Error_Code will be 0 (LVM_ENGINE_NO_ERROR).
:p.If an error does occur, the Drive_Control_Data field will be NULL, the
Count field will be 0, and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Errors:ehp7.
If an error occurs, the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Memory for the returned array is allocated.

:p.
:p.:hp7.Notes:ehp7.
:p.The caller becomes responsible for the memory allocated for the array of
records pointed to by the Drive_Control_Data pointer in the Drive_Control_Array
structure returned by this function.  The caller should free this memory
using the :link reftype=hd refid=FN_free_engine_memory.Free_Engine_Memory:elink.
function once it is no longer needed.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_DRIVE_CONTROL_DATA16(
        Drive_Control_Record * _Seg16 * _Seg16 Drive_Control_Data,
        CARDINAL32 *                    _Seg16 Count,
        CARDINAL32 *                    _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_drive_status.Get_Drive_Status
:p.This function returns the
:link reftype=hd refid=TYPE_drive_information_record.Drive_Information_Record:elink.
structure for the specified disk.  This structure contains variant data for a
physical disk drive.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_drive_information_record.Drive_Information_Record:elink. _System Get_Drive_Status(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Drive_Handle,  /* (I) Handle of the disk to be queried */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code     /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Drive_Handle
:pd.The handle of the disk drive whose data is being queried.  Drive handles may
be obtained through the :link reftype=hd refid=FN_get_drive_control_data.Get_Drive_Control_Data:elink.
function.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.This function returns the
:link reftype=hd refid=TYPE_drive_information_record.Drive_Information_Record:elink.
for the drive whose handle is specified in Drive_Handle.

:p.
:p.:hp7.Error Handling:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_DRIVE_STATUS16(
        CARDINAL32                          Drive_Handle,
        Drive_Information_Record *   _Seg16 Drive_Status,
        CARDINAL32 *                 _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_install_flags.Get_Install_Flags
:p.This function returns the value of the Install Flags.  The Install Flags
reside in a 32-bit field in the LVM dataspace.  These flags are not used by LVM,
thereby leaving the OS/2 install program free to use them for whatever it wants.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. _System Get_Install_Flags(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The function returns the current value of the Install Flags.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds Get_Install_Flags16(
        CARDINAL32 * _Seg16 Install_Flags,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_installable_volume.Get_Installable_Volume
:p.This function returns information for the volume which is currently marked as
Installable.
:p.The Installable flag is used by the OS/2 installation program (RSPINST).  It
is set for only one volume in the system, and only at OS install time.  It
designates the volume onto which OS/2 will be installed.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink. _System Get_Installable_Volume (

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.If a volume is marked Installable, its information will be returned and the
value pointed to by Error_Code will be LVM_ENGINE_NO_ERROR (0).
:p.If there is no volume marked Installable, then the value pointed to by
Error_Code will be greater than 0.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_INSTALLABLE_VOLUME16(
        Volume_Information_Record * _Seg16  Volume_Information,
        CARDINAL32 *                _Seg16  Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_lvm_view.Get_LVM_View
:p.This function gets the OS2LVM data for the specified drive letter.  This
allows the actual drive letter as seen by the IFS Manager to be correlated to
the LVM drive letter assignments, which may be different in the event of a
conflict or a drive letter preference of '*'.

:xmp.

#include &lt.lvm_intr.h&gt.

BOOLEAN _System Get_LVM_View(

    char         IFSM_Drive_Letter,   /* (I) The IFSM drive letter whose OS2LVM data is requested */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Drive_Number,        /* (O) The drive number of the drive's first partition */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Partition_LBA,       /* (O) The LBA of the drive's first partition */
    char *       LVM_Drive_Letter,    /* (O) The LVM drive letter associated with the drive */
    :link reftype=hd refid=TYPE_byte    .BYTE:elink. *       UnitID               /* (O) The OS2LVM unit ID of the volume */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.IFSM_Drive_Letter
:pd.The drive letter for which the OS2LVM data is requested.  This is the
actual drive letter as seen by the Installable File System Manager.
:pt.Drive_Number
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to return the OS/2 drive number of the drive containing the first
partition of the volume currently assigned to the requested drive letter.
:pt.Partition_LBA
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to return the Logical Block Address of the first partition of the volume
currently assigned to the requested drive letter.
:pt.LVM_Drive_Letter
:pd.The address of a char in which to return the drive letter that OS2LVM thinks
the volume assigned to the requested drive letter should have.
:pt.UnitID
:pd.The address of a BYTE in which to return the OS2LVM unit ID for the volume
associated with the requested drive letter.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The return value will be TRUE if the function completed successfully.
:p.The return value will be FALSE if the specified drive letter is either not
in use, or is in use by a device not controlled by OS2LVM.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.This function can be used with the LVM Engine open or
closed.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds GET_LVM_VIEW16(
        char                IFSM_Drive_Letter,
        CARDINAL32 * _Seg16 Drive_Number,
        CARDINAL32 * _Seg16 Partition_LBA,
        char *       _Seg16 LVM_Drive_Letter,
        BYTE *       _Seg16 UnitID
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_partition_handle.Get_Partition_Handle
:p.This function returns the handle of the partition whose serial number
matches the one provided.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_address.ADDRESS:elink. _System Get_Partition_Handle(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Serial_Number,   /* (I) Partition serial number being queried */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Serial_Number
:pd.This is the serial number to look for.  If a partition with a matching
serial number is found, its handle will be returned.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.If a partition with a matching serial number is found, then the function
return value will be the handle of the partition found.  If no matching
partition is found, then the function return value will be NULL.

:p.
:p.:hp7.Errors:ehp7.
:p.If no errors occur, the value pointed to by Error_Code will be 0
(LVM_ENGINE_NO_ERROR).  If an error occurs, then the value pointed to by
Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_PARTITION_HANDLE16(
        CARDINAL32          Serial_Number,
        CARDINAL32 * _Seg16 Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_partition_information.Get_Partition_Information
:p.This function returns the
:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
for the specified partition.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink. _System Get_Partition_Information(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handle,   /* (I) Handle of the partition to be queried */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code          /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Partition_Handle
:pd.The handle associated with the partition whose information is desired.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.A :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
is returned.

:p.
:p.:hp7.Errors:ehp7.
:p.If Partition_Handle is not a valid handle, a trap could result.  If it
is a handle for something other than a partition, an error condition will result.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds  GET_PARTITION_INFORMATION16(
        CARDINAL32                            Partition_Handle,
        Partition_Information_Record * _Seg16 Partition_Information,
        CARDINAL32 *                   _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_partitions.Get_Partitions
:p.This function returns an array of partitions associated with the object whose
handle is specified.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_partition_information_array.Partition_Information_Array:elink. _System Get_Partitions(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,       /* (I) Handle of a drive or volume */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the object whose partitions are to be queried.  This is the
handle of a drive or volume.
:p.Drive handles may be obtained using the
:link reftype=hd refid=FN_get_drive_control_data.Get_Drive_Control_Data:elink.
function.  Volume handles may be obtained using the
:link reftype=hd refid=FN_get_volume_control_data.Get_Volume_Control_Data:elink. function.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.This function returns a :link reftype=hd refid=TYPE_partition_information_array.Partition_Information_Array:elink.
structure.  This structure has two fields&colon. an array of partition
information records, and the number of entries in the array.
:p.If Handle is the handle of a disk drive, then the returned array will contain
a partition information record for each partition and block of free space on
that drive.  If Handle is the handle of a volume, then the returned array will
contain a partition information record for each partition which is part of the
specified volume.

:p.
:p.:hp7.Errors:ehp7.
:p.If Handle is non-NULL and is invalid, a trap is likely.
:p.In the event of an error, any memory allocated for the return value will be
freed; the Partition_Information_Array returned by this function will contain
a NULL pointer for Partition_Array field, and the Count field will be 0.
:p.Additionally, if an error occurs, the value pointed to by Error_Code will be
greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Memory will be allocated to hold the array returned by this function.

:p.
:p.:hp7.Notes:ehp7.
:p.The caller becomes responsible for the memory allocated for the array of
records pointed to by the Partition_Array field of the Partition_Information_Array
structure returned by this function.  The caller should free this memory using the
:link reftype=hd refid=FN_free_engine_memory.Free_Engine_Memory:elink. function
as soon as it is no longer needed.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_PARTITIONS16(
        CARDINAL32                                     Handle,
        Partition_Information_Record * _Seg16 * _Seg16 Partition_Array,
        CARDINAL32 *                            _Seg16 Count,
        CARDINAL32 *                            _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_reboot_flag.Get_Reboot_Flag
:p.This function returns the value of the Reboot Flag.  The Reboot Flag is a
special flag on the boot disk used by the OS/2 install program to keep track of
whether or not the system was just rebooted.  It is used by the various phases
of install.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink. _System Get_Reboot_Flag(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The function return value will be TRUE if no errors occur and the Reboot
Flag is set.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the function return value will be FALSE and the value
pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds GET_REBOOT_FLAG16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_reserved_drive_letters.Get_Reserved_Drive_Letters
:p.This function returns a bitmap indicating which drive letters are reserved
for use by devices :hp2.not:ehp2. under the control of LVM.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. _System Get_Reserved_Drive_Letters(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.This function returns a bitmap of the drive letters which are being used by
devices which are :hp2.not:ehp2. controlled by LVM.  While a volume :hp2.can:ehp2.
be assigned a drive letter from this list, a reboot will almost always be
required in order for the assignment to take place.
:p.Drive letters &osq.A&csq. through &osq.Z&csq. are represented in the bitmap
from right to left.  In other words, &osq.A&csq. is 0x00000001 and &osq.Z&csq.
is 0x02000000.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be > 0, and
the returned bitmap will have all bits set to 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.Devices which are assigned drive letters but which are NOT under LVM control
include&colon. CD-ROM, Network drives, parallel port attached devices, and any DASD
devices not controlled by OS2DASD.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
CARDINAL32 _Far16 _Pascal _loadds GET_RESERVED_DRIVE_LETTERS16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_valid_options.Get_Valid_Options
:p.This function returns a bitmap indicating which LVM operations are valid on
the object whose handle is specified.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. _System Get_Valid_Options(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,       /* (I) Handle of a drive, volume, or partition */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the object being queried.  This may be any valid drive,
volume, or partition handle.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.The :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. returned by this
function represents a bitmap where each bit corresponds to a possible operation
that the LVM Engine can perform on the object in question.  If the operation in
question is allowed, the corresponding bit will be set to 1.
:p.The defined operations are listed below.  These are defined in
:hp2.lvm_intr.h:ehp2..
:table cols='30 10 40' rules='none' frame='none'.
:row.
:c.CREATE_PRIMARY_PARTITION
:c.0x1
:c.A primary partition can be created from this block of free space.
:row.
:c.CREATE_LOGICAL_DRIVE
:c.0x2
:c.A logical partition can be created from this block of free space.
:row.
:c.DELETE_PARTITION
:c.0x4
:c.The partition can be deleted.  This implies that it is not part of a volume.
:row.
:c.SET_ACTIVE_PRIMARY
:c.0x8
:c.The partition can be the active primary partition for the disk drive on
which it resides, if its Active flag is set.
:row.
:c.SET_PARTITION_ACTIVE
:c.0x10
:c.The partition can have its Active flag set.
:row.
:c.SET_PARTITION_INACTIVE
:c.0x20
:c.The partition can have its Active flag cleared.
:row.
:c.SET_STARTABLE
:c.0x40
:c.The partition or volume can be set Startable.
:row.
:c.INSTALL_BOOT_MANAGER
:c.0x80
:c.Boot Manager can be installed.  (This is a system-wide property, and is
independent of the object specified by Handle.)
:row.
:c.REMOVE_BOOT_MANAGER
:c.0x100
:c.Boot Manager can be removed.  (This is a system-wide property, and is
independent of the object specified by Handle.)
:row.
:c.SET_BOOT_MANAGER_DEFAULTS
:c.0x200
:c.Boot Manager options can be configured.  (This is a system-wide property,
and is independent of the object specified by Handle.)
:row.
:c.ADD_TO_BOOT_MANAGER_MENU
:c.0x400
:c.The partition or volume can be added to the Boot Manager menu.
:row.
:c.REMOVE_FROM_BOOT_MANAGER_MENU
:c.0x800
:c.The partition or volume can be removed from the Boot Manager menu.
:row.
:c.DELETE_VOLUME
:c.0x1000
:c.The volume can be deleted.
:row.
:c.HIDE_VOLUME
:c.0x2000
:c.The volume can be hidden.
:row.
:c.EXPAND_VOLUME
:c.0x4000
:c.The volume can be expanded.
:row.
:c.SET_VOLUME_INSTALLABLE
:c.0x8000
:c.The volume can be set installable.
:row.
:c.ASSIGN_DRIVE_LETTER
:c.0x10000
:c.The volume's drive letter assignment can be set.
:row.
:c.CAN_BOOT_PRIMARY
:c.0x20000
:c.The primary partition, or one created from this block of free space, can be made bootable
(either by making it Startable, or by adding it to the Boot Manager menu).
:row.
:c.CAN_BOOT_LOGICAL
:c.0x40000
:c.The logical partition, or one created from this block of free space, can be made bootable
(by adding it to the Boot Manager menu).
:row.
:c.CAN_SET_NAME
:c.0x80000
:c.A partition, volume, or drive name can be set.
:row.
:c.SET_BOOT_MANAGER_STARTABLE
:c.0x100000
:c.The Boot Manager partition may be set Startable.  (This is a system-wide
property, and is independent of the object specified by Handle.)
:etable.

:p.
:p.:hp7.Errors:ehp7.
:p.If Handle is not valid, a trap will be likely.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
CARDINAL32 _Far16 _Pascal _loadds GET_VALID_OPTIONS16(
        CARDINAL32          Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_volume_control_data.Get_Volume_Control_Data
:p.This function returns a structure containing an array of volume control
records.  These records contain invariant information about each volume &emdash.
that is, information which will not change for as long as the volume exists.
:p.This data includes the handle for each volume, which must be used on all
access to that volume.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_volume_control_array.Volume_Control_Array:elink. _System Get_Volume_Control_Data(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.


:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.A :link reftype=hd refid=TYPE_volume_control_array.Volume_Control_Array:elink.
structure is returned.
:p.If there are no errors, then the Volume_Control_Data field will be non-NULL, the
Count field will be &gt.= 0, and the value pointed to by Error_Code will be
LVM_ENGINE_NO_ERROR (0).
:p.If an error does occur, then the Volume_Control_Data field will be NULL, the
Count field will be 0, and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, then any memory allocated by this function will be
freed, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Memory for the returned array is allocated.

:p.
:p.:hp7.Notes:ehp7.
:p.The caller becomes responsible for the memory allocated for the array of
records pointed to by Volume_Control_Data field in the Volume_Control_Array
structure returned by this function.  The caller should free this memory using
the :link reftype=hd refid=FN_free_engine_memory.Free_Engine_Memory:elink.
function once it is no longer needed.


:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_VOLUME_CONTROL_DATA16(
        Volume_Control_Record * _Seg16 * _Seg16 Volume_Control_Data,
        CARDINAL32 *                     _Seg16 Count,
        CARDINAL32 *                     _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_get_volume_information.Get_Volume_Information
:p.This function returns the
:link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink.
for the specified volume.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink. _System Get_Volume_Information(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Volume_Handle,   /* (I) Handle of the volume to be queried */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume whose information is desired.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.A :link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink.
containing information about the specified volume is returned.

:p.
:p.:hp7.Errors:ehp7.
:p.If Volume_Handle is not a valid handle, a trap will be likely.  If
Volume_Handle is a drive or partition handle, an error condition will occur.
:p.If an error occurs, then any memory allocated by this function will be
freed, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds GET_VOLUME_INFORMATION16(
        CARDINAL32                         Volume_Handle,
        Volume_Information_Record * _Seg16 Volume_Information,
        CARDINAL32 *                _Seg16 Error_Code

);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_hide_volume.Hide_Volume
:p.This function &osq.hides&csq. a volume from OS/2 by removing its drive
letter assignment.  Without a drive letter assignment, OS/2 can not access
the volume.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Hide_Volume(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Volume_Handle,   /* (I) Handle of the volume to be hidden */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume which is to be hidden.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Volume_Handle is not a valid handle, a trap may result.
:p.If Volume_Handle is a partition or drive handle, then this function will
abort and the value pointed to by Error_Code will be non-zero.
:p.If the volume cannot be hidden, then nothing will be altered and an error
condition will occur.
:p.In the event of an error, the value pointed to by Error_Code will be greater
than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds HIDE_VOLUME16(
        CARDINAL32          Volume_Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_install_boot_manager.Install_Boot_Manager
:p.This function installs Boot Manager.  It can also be used to replace an
existing copy of Boot Manager.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Install_Boot_Manager (

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Drive_Number,   /* (I) Drive number (1 or 2) to install Boot Manager on */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code      /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Drive_Number
:pd.The number of the drive on which Boot Manager is to be installed.
Only a value of 1 or 2 is supported.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.  Depending upon the error (such as for a write error), it is possible that
the Boot Manager partition could be left in an unusuable state.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Boot Manager may be installed on drive 1 or 2.  The MBR for drive 1 may be
altered.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds INSTALL_BOOT_MANAGER16(
        CARDINAL32          Drive_Number,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_new_mbr.New_MBR
:p.This function lays down a new MBR on the specified drive.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System New_MBR(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Drive_Handle,   /* (I) Handle of the drive where the new MBR will be placed */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code      /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Drive_Handle
:pd.The handle of the drive on which the new MBR is to be placed.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, then the existing MBR is not altered, and the value
pointed to by Error_Code will be > 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A new MBR may be placed on the specified drive.  Any existing boot sector
code within the MBR on that drive will be replaced with the standard OS/2
MBR code.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds NEW_MBR16(
        CARDINAL32          Drive_Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_open_lvm_engine.Open_LVM_Engine
:p.This function opens the LVM Engine and readies it for use.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Open_LVM_Engine(

    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Ignore_CHS,   /* (I) Set TRUE to disable validation of CHS values */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.&colon.
:parml break=fit tsize=25.
:pt.Ignore_CHS
:pd.If TRUE, then the LVM engine will not check the CHS values in the MBR/EBR
partition tables for validity.
:p.This is useful if there are drive geometry
problems, as for instance if the drive was partitioned and formatted with one
geometry and then moved to a different machine which uses a different geometry
for the drive.  This would cause the starting and ending CHS values in the
partition tables to be inconsistent with the size and partition offset entries
in the partition tables.
:p.Setting Ignore_CHS to TRUE will disable the LVM
Engine's CHS consistency checks, thereby allowing the drive to be partitioned.

:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.
:p.

:p.:hp7.Returns:ehp7.&colon.
:p.N/A.
:p.

:p.:hp7.Errors:ehp7.&colon.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.
:p.If this function aborts with an error, all memory allocated during the course
of this function will be released.  Disk read errors will only cause this
function to abort if none of the disk drives in the system could be
successfully read.
:p.

:p.:hp7.Side Effects:ehp7.&colon.
:p.The LVM Engine will be initialized.  The partition tables for all
OS2DASD-controlled disk drives will be read into memory.  Memory will be
allocated for the data structures used by the LVM Engine.
:p.

:p.:hp7.Notes:ehp7.&colon.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds OPEN_LVM_ENGINE16(
    BOOLEAN             Ignore_CHS,
    CARDINAL32 * _Seg16 Error_Code
);
:exmp.
:p.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_read_sectors.Read_Sectors
:p.This function reads the data from one or more sectors on the specified drive
into the buffer provided.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Read_Sectors (

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Drive_Number,      /* (I) Number of the drive to read (starting from 1) */
    :link reftype=hd refid=TYPE_lba     .LBA:elink.          Starting_Sector,   /* (I) The first sector to read (starting from 0) */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Sectors_To_Read,   /* (I) The number of sectors to read */
    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Buffer,            /* (O) Buffer to receive the read data */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error              /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Drive_Number
:pd.The number of the hard drive to read from.  The drives in the system are
numbered from 1 to :hp1.n:ehp1., where :hp1.n:ehp1. is the total number of hard
drives in the system.
:pt.Starting_Sector
:pd.The number of the first sector to read from.  The sectors on a drive are
numbered starting from 0.
:pt.Sectors_To_Read
:pd.The number of sectors to read into memory.
:pt.Buffer
:pd.The location to put the data read into.
:pt.Error
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error will be > 0, and the
contents of Buffer will be undefined.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Data may be read into memory starting at Buffer.

:p.
:p.:hp7.Notes:ehp7.
:p.Buffer must be large enough to hold the number of sectors requested.  The
size of one sector is defined as BYTES_PER_SECTOR (512) bytes.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds READ_SECTORS16(
        CARDINAL32          Drive_Number,
        LBA                 Starting_Sector,
        CARDINAL32          Sectors_To_Read,
        ADDRESS      _Seg16 Buffer,
        CARDINAL32 * _Seg16 Error
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_reboot_required.Reboot_Required
:p.This function indicates whether or not any changes were made to the system
which would require a reboot to take effect.

:xmp.

#include &lt.lvm_intr.h&gt.

:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink. _System Reboot_Required( void );
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:p.None.

:p.
:p.:hp7.Returns:ehp7.
:p.The function return value will be TRUE if the system must be rebooted as a
result of changes made through the LVM Engine.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
BOOLEAN _Far16 _Pascal _loadds REBOOT_REQUIRED16( void );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_rediscover_prms.Rediscover_PRMs
:p.This function causes OS2LVM and OS2DASD to check all PRM (partitioned
removable media) devices for new or changed media.
:p.The LVM Engine must be :hp2.closed:ehp2. when this function is called.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Rediscover_PRMs(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be > 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.New volumes may be discovered and assigned drive letters.

:p.
:p.:hp7.Notes:ehp7.
:p.This function is disabled while the LVM Engine is open.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds REDISCOVER_PRMS16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_refresh_lvm_engine.Refresh_LVM_Engine
:p.This function causes the LVM Engine to look for changes in the current
system configuration and update its internal tables accordingly.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System  Refresh_LVM_Engine(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Volumes which represent non-LVM devices may have their handles changed!

:p.
:p.:hp7.Notes:ehp7.
:p.After calling this function,
:link reftype=hd refid=FN_get_volume_control_data.Get_Volume_Control_Data:elink.
should be called to get the updated list of volumes.  This is necessary as the
handles of some volumes may have changed.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds REFRESH_LVM_ENGINE16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_remove_boot_manager.Remove_Boot_Manager
:p.This function removes Boot Manager from the system.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Remove_Boot_Manager(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, the value pointed to by Error_Code will be greater than
0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Boot Manager may be removed from the system.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds REMOVE_BOOT_MANAGER16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_remove_from_boot_manager.Remove_From_Boot_Manager
:p.This function removes the specified partition or volume from the Boot Manager
menu.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Remove_From_Boot_Manager(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,      /* (I) Handle of the partition or volume to be removed */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the partition or volume which is to be removed from the Boot
Manager menu.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Handle is not a valid handle, a trap may result.
:p.If Handle represents a drive, or if Handle represents a volume or partition
which is not on the Boot Manager menu, then this function will abort and the
value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The Boot Manager menu may be altered.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds REMOVE_FROM_BOOT_MANAGER16(
        CARDINAL32          Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_active_flag.Set_Active_Flag
:p.This function sets the value of a partition's Active Flag.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Active_Flag (

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handle,   /* (I) Handle of the target partition */
    :link reftype=hd refid=TYPE_byte    .BYTE:elink.         Active_Flag,        /* (I) New value of the Active Flag */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code          /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Partition_Handle
:pd.The handle of the partition whose Active Flag is to be set.
:pt.Active_Flag
:pd.The new byte value for the Active Flag.
:p.The Active Flag indicates whether the partition is designated as
&osq.active&csq. in the disk partition table.
:p.Refer to the description of the :link reftype=fn refid=PIR_active.Active_Flag:elink.
field under
:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
for the allowable values.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Partition_Handle is not a valid handle, a trap may result.
:p.If Partition_Handle is a volume or drive handle, then an error condition
will result.
:p.In the event of an error, this function will abort without changing any disk
structures, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The Active Flag for a partition may be modified.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_ACTIVE_FLAG16(
        CARDINAL32          Partition_Handle,
        BYTE                Active_Flag,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_boot_manager_options.Set_Boot_Manager_Options
:p.This function sets the Boot Managers options.  The settable options are&colon.
:ul compact.
:li.The partition or volume to boot by default.
:li.Whether or not the timeout timer is active.
:li.The length of the timeout interval.
:li.Whether Boot Manager should display its menu using default or advanced mode.
:eul.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Boot_Manager_Options(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,           /* (I) Handle of the default partition or volume */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Timer_Active,     /* (I) TRUE if the timeout timer is active */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Time_Out_Value,   /* (I) Timeout interval in seconds */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Advanced_Mode,    /* (I) TRUE to display the menu in advanced mode */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code        /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the default partition or volume to boot.  The corresponding
entry on the Boot Manager menu will be highlighted by default.  In addition,
if the time-out timer is active, this partition or volume will be booted
automatically when the time-out value is reached.
:p.Specifying a NULL handle will cause Boot Manager to default to whichever
partition or volume was previously booted.
:pt.Timer_Active
:pd.If TRUE, then the timeout timer is active.
:pt.Time_Out_Value
:pd.If the timeout timer is active, this is the length of the timeout, in
seconds.
:pt.Advanced_Mode
:pd.If TRUE, then Boot Manager will operate in advanced mode.  If FALSE, then
normal mode will be in effect.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, no changes will be made to Boot Manager and the value
pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Boot Manager may be modified.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_BOOT_MANAGER_OPTIONS16(
        CARDINAL32          Handle,
        BOOLEAN             Timer_Active,
        CARDINAL32          Time_Out_Value,
        BOOLEAN             Advanced_Mode,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_free_space_threshold.Set_Free_Space_Threshold
:p.This function tells the LVM Engine not to report blocks of free space which
are less than the size specified.  By default, the LVM engine will not report
blocks of free space which are smaller than 2,048 sectors (1 MB).

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Free_Space_Threshold(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.  Min_Sectors   /* (I) The new free space threshold, in sectors */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Min_Sectors
:pd.The minimum size, in sectors, that a block of free space must be in order
for the LVM engine to report it.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_FREE_SPACE_THRESHOLD16( CARDINAL32 Min_Sectors );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_install_flags.Set_Install_Flags
:p.This function sets the value of the Install Flags.  The Install Flags reside
in a 32-bit field in the LVM dataspace.  These flags are not used by LVM,
thereby leaving the OS/2 install program free to use them for whatever it wants.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Install_Flags(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Install_Flags,   /* (I) The new value for the Install Flags */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Install_Flags
:pd.The new value for the Install Flags.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, then the value of the Install Flags will be unchanged,
and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The value of the Install Flags may be changed.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds Set_Install_Flags16(
        CARDINAL32          Install_Flags,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_installable.Set_Installable
:p.This function sets the Installable flag for the specified volume.
:p.The Installable flag is used by the OS/2 installation program (RSPINST).  It
is set for only one volume in the system, and only at OS install time.  It
designates the volume onto which OS/2 will be installed.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Installable (

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Volume_Handle,   /* (I) Handle of the volume to be set Installable */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code       /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Volume_Handle
:pd.The handle of the volume to which OS/2 will be installed.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Volume_Handle is not a valid handle, a trap may result.
:p.If Volume_Handle is a partition or drive handle, then this function will
abort and the value pointed to by Error_Code will be non-zero.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The specified volume may be marked as installable.

:p.
:p.:hp7.Notes:ehp7.
:p.This function should be called immediately prior to executing the OS/2
installation program (SEINST or RSPINST), by the application responsible
for calling those programs.
:p.This function should not be used under any circumstances other than the
above.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_INSTALLABLE16(
        CARDINAL32          Volume_Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_min_install_size.Set_Min_Install_Size
:p.This function tells the LVM Engine how big a partition/volume must be in
order for it to marked installable.  If this function is not used to set the
minimum size for an installable partition/volume, the LVM Engine will use a
default value of 300 MB.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Min_Install_Size(

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.  Min_Sectors   /* (I) The minimum size, in sectors */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Min_Sectors
:pd.The minimum size, in sectors, that a partition must be in order for it to
be marked as installable.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.N/A.

:p.
:p.:hp7.Side Effects:ehp7.
:p.None.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_MIN_INSTALL_SIZE16( CARDINAL32 Min_Sectors );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_name.Set_Name
:p.This function sets the name of a volume, drive, or partition.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Name (

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,       /* (I) Handle of a partition, volume, or drive */
    char         New_Name[],   /* (I) New name of the object specified by Handle */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code    /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the drive, partition, or volume which is to have its name set.
:pt.New_Name[]
:pd.The new name for the drive, partition, or volume specified by Handle.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Handle is not a valid handle, a trap may result.
:p.If the name can not be set, then the drive, volume, or partition is not
modified.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A drive, volume, or partition may have its name set.

:p.
:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_NAME16(
        CARDINAL32          Handle,
        char       * _Seg16 New_Name,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_os_flag.Set_OS_Flag
:p.This function sets the OS Flag field for a partition.  This field (sometimes
also known as the Filesystem Flag or the Partition Type Flag), is typically
used to indicate the filesystem used on the partition, which generally gives an
indication of which OS is using that partition.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_OS_Flag (

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Partition_Handle,   /* (I) Handle of the target partition */
    :link reftype=hd refid=TYPE_byte    .BYTE:elink.         OS_Flag,            /* (I) New value of the OS Flag */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code          /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Partition_Handle
:pd.The handle of the partition whose OS Flag is to be set.
:pt.OS_Flag
:pd.The new value for the OS Flag.
:p.Refer to the description of the :link reftype=fn refid=PIR_osflag.OS_Flag:elink.
field under
:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
for various possible values of interest.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If Partition_Handle is not a valid handle, a trap may result.
:p.If Partition_Handle is a volume or drive handle, then this function an error
condition will occur.
:p.If an error occurs, this function will abort without changing any disk
structures, and the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The OS Flag for a partition may be modified.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_OS_FLAG16(
        CARDINAL32          Partition_Handle,
        BYTE                OS_Flag,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_reboot_flag.Set_Reboot_Flag
:p.This function sets the Reboot Flag.  The Reboot Flag is a special flag on
the boot disk used by the OS/2 install program to keep track of whether or not
the system was just rebooted.  It is used by the various phases of install.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Reboot_Flag(

    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      Reboot,      /* (I) New value for the Reboot Flag */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Reboot
:pd.The new value for the Reboot Flag.  If TRUE, then the Reboot Flag will be
set.  If FALSE, then the Reboot Flag will be cleared.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, then the Reboot Flag will be unchanged, and the value
pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The value of the Reboot Flag may be changed.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds SET_REBOOT_FLAG16(
        BOOLEAN             Reboot,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_set_startable.Set_Startable
:p.This function sets the specified volume or partition Startable.  A Startable
volume or partition will be booted directly from the Master Boot Record on
system startup.
:p.If a partition is specified, it must be a primary partition on the first
drive in the system.  If a volume is specified, it must be a compatibility
volume consisting of a primary partition on the first drive.
:p.Only one partition or volume may be set Startable.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Set_Startable(

    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Handle,      /* (I) Handle of a volume or partition */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Handle
:pd.The handle of the partition or volume which is to be set Startable.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the volume or partition could not be set Startable, then nothing in the
system is changed.
:p.If Handle is not a valid handle, a trap may result.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Any other partition or volume which is marked Startable will have its
Startable flag cleared.

:p.
:p.:hp7.Notes:ehp7.
:p.None.
:p.

:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void  _Far16 _Pascal _loadds SET_STARTABLE16(
        CARDINAL32          Handle,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_start_logging.Start_Logging
:p.Activates LVM Engine logging.  Once activated, the logging function will log
all LVM Engine activity to the specified log file.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Start_Logging(

    char *       Filename,    /* (I) Log file name */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Filename
:pd.The filename of the log file to be generated.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the log file could not be created, the value pointed to by Error_Code will
be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.A file may be created/opened for the logging of LVM Engine actions.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds START_LOGGING16(
        char *       _Seg16 Filename,
        CARDINAL32 * _Seg16 Error_Code
);
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_stop_logging.Stop_Logging
:p.This function ends LVM Engine logging and closes the log file.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Stop_Logging (

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error_Code   /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If the log file is not currently opened, or if the file close operation
fails, then the value pointed to by Error_Code will be greater than 0.

:p.
:p.:hp7.Side Effects:ehp7.
:p.The log file may be closed.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds STOP_LOGGING16( CARDINAL32 * _Seg16 Error_Code );
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=FN_write_sectors.Write_Sectors
:p.This function writes data from memory to one or more sectors on the
specified drive.

:xmp.

#include &lt.lvm_intr.h&gt.

void _System Write_Sectors (

    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Drive_Number,       /* (I) Number of the drive to write to (starting from 1) */
    :link reftype=hd refid=TYPE_lba     .LBA:elink.          Starting_Sector,    /* (I) The first sector to write to (starting from 0) */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   Sectors_To_Write,   /* (I) The number of sectors to be written */
    :link reftype=hd refid=TYPE_address .ADDRESS:elink.      Buffer,             /* (I) Buffer containing the data to write */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. * Error               /* (O) Address where the error code will be stored */

);
:exmp.

:p.
:p.:hp7.Parameters:ehp7.
:parml break=fit tsize=25.
:pt.Drive_Number
:pd.The number of the hard drive to write to.  The drives in the system are
numbered from 1 to :hp1.n:ehp1., where :hp1.n:ehp1. is the total number of hard
drives in the system.
:pt.Starting_Sector
:pd.The number of the first sector to write to.  The sectors on a drive are
numbered starting from 0.
:pt.Sectors_To_Write
:pd.The number of sectors to be written.
:pt.Buffer
:pd.The address of the data to be written to disk.
:pt.Error_Code
:pd.The address of a :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. in
which to store an error code should an error occur.
:eparml.

:p.
:p.:hp7.Returns:ehp7.
:p.N/A.

:p.
:p.:hp7.Errors:ehp7.
:p.If an error occurs, then the value pointed to by Error will be > 0, and the
contents of the specified sectors on disk will be undefined.

:p.
:p.:hp7.Side Effects:ehp7.
:p.Data may be written to disk.

:p.
:p.:hp7.Notes:ehp7.
:p.None.

:p.
:p.:hp7.16-Bit Equivalent:ehp7.&colon.
:xmp.
void _Far16 _Pascal _loadds WRITE_SECTORS16(
        CARDINAL32          Drive_Number,
        LBA                 Starting_Sector,
        CARDINAL32          Sectors_To_Write,
        ADDRESS      _Seg16 Buffer,
        CARDINAL32 * _Seg16 Error
);
:exmp.


.im lvmref2.ipf

:euserdoc.

