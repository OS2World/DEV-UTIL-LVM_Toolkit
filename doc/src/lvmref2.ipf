
.* ----------------------------------------------------------------------------
.* Data types
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100% id=types.Data Types
:p.The follow sections define the data types defined by the LVM Engine.

:p.Some types are defined even though they are directly equivalent to existing
types from the OS/2 Toolkit.  This was done in order to provide a
platform-neutral code framework for the LVM Engine.

:p.Primitive types&colon.
:sl compact.
:li.:link reftype=hd refid=TYPE_address.ADDRESS:elink.
:li.:link reftype=hd refid=TYPE_boolean.BOOLEAN:elink.
:li.:link reftype=hd refid=TYPE_byte.BYTE:elink.
:li.:link reftype=hd refid=TYPE__byte.Byte:elink.
:li.:link reftype=hd refid=TYPE_cardinal.CARDINAL types:elink.
:li.:link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.
:li.:link reftype=hd refid=TYPE_integer.INTEGER types:elink.
:li.:link reftype=hd refid=TYPE_lba.LBA:elink.
:li.:link reftype=hd refid=TYPE_lsn.LSN:elink.
:li.:link reftype=hd refid=TYPE_psn.PSN:elink.
:li.:link reftype=hd refid=TYPE_pstring.pSTRING:elink.
:li.:link reftype=hd refid=TYPE_quadword.QuadWord:elink.
:li.:link reftype=hd refid=TYPE_real.REAL types:elink.
:li.:link reftype=hd refid=TYPE_word.Word:elink.
:esl.

:p.Data structures&colon.
:sl compact.
:li.:link reftype=hd refid=TYPE_aliastableentry.AliasTableEntry:elink.
:li.:link reftype=hd refid=TYPE_allocation_algorithm.Allocation_Algorithm:elink.
:li.:link reftype=hd refid=TYPE_boot_manager_menu_item.Boot_Manager_Menu_Item:elink.
:li.:link reftype=hd refid=TYPE_boot_manager_menu.Boot_Manager_Menu:elink.
:li.:link reftype=hd refid=TYPE_dla_entry.DLA_Entry:elink.
:li.:link reftype=hd refid=TYPE_dla_table_sector.DLA_Table_Sector:elink.
:li.:link reftype=hd refid=TYPE_drive_control_array.Drive_Control_Array:elink.
:li.:link reftype=hd refid=TYPE_drive_control_record.Drive_Control_Record:elink.
:li.:link reftype=hd refid=TYPE_drive_information_record.Drive_Information_Record:elink.
:li.:link reftype=hd refid=TYPE_extended_boot_record.Extended_Boot_Record:elink.
:li.:link reftype=hd refid=TYPE_lvm_feature_data.LVM_Feature_Data:elink.
:li.:link reftype=hd refid=TYPE_lvm_signature_sector.LVM_Signature_Sector:elink.
:li.:link reftype=hd refid=TYPE_master_boot_record.Master_Boot_Record:elink.
:li.:link reftype=hd refid=TYPE_partition_information_array.Partition_Information_Array:elink.
:li.:link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
:li.:link reftype=hd refid=TYPE_partition_record.Partition_Record:elink.
:li.:link reftype=hd refid=TYPE_volume_control_array.Volume_Control_Array:elink.
:li.:link reftype=hd refid=TYPE_volume_control_record.Volume_Control_Record:elink.
:li.:link reftype=hd refid=TYPE_volume_information_record.Volume_Information_Record:elink.
:esl.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_address.ADDRESS
:p.An ADDRESS variable is one which holds an address.  The address can contain
anything, or even be invalid.  It is just an address which is presumed to
hold some kind of data.
:p.In the LVM Engine, the ADDRESS type is most often used as a handle to an
object such as a drive, volume, or partition.

:xmp.

#include &lt.lvm_intr.h&gt.

typedef void * ADDRESS;
:exmp.


.* ----------------------------------------------------------------------------
.* AliasTableEntry
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_aliastableentry.AliasTableEntry
:p.The following definition covers the Boot Manager Alias Table in the EBR.
:p.A Boot Manager Alias is used for items that were placed on the Boot Manager
Menu by FDISK and which have since been migrated to the new LVM format.  The
alias text is put into the Name field of an AliasTableEntry so that, if FDISK
(or another program which understands the old Boot Manager Menu format) is run,
it will display something for those partitions/volumes which are on the Boot
Manager Menu.
:p.For primary partitions, the Alias Table is located within the Boot Manager
partition; for logical partitions, it is located within the EBR at byte offset
0x18A.
:p.The Alias Table has 2 entries in it, although only the first one is actually
used.
:p.This type is used internally by LVM.

:xmp.

#include &lt.lvm_data.h&gt.

/*
 * Defines the length of the alias text field.  This is a fixed-length string&colon.
 * the alias text must be exactly this many characters in length.  The string
 * is not null-terminated.
 */
#define ALIAS_NAME_SIZE  8


typedef struct _AliasTableEntry {
    :link reftype=hd refid=TYPE_boolean.BOOLEAN:elink.     :link reftype=fn refid=ATE_on_boot_manager_menu.On_Boot_Manager_Menu:elink.;
    char        :link reftype=fn refid=ATE_name.Name[ ALIAS_NAME_SIZE ]:elink.;
} AliasTableEntry;
:exmp.

:fn id=ATE_on_boot_manager_menu.
:p.TRUE if the partition is on the Boot Manager menu.
:efn.
:fn id=ATE_name.
:p.This text must be exactly ALIAS_NAME_SIZE characters in length!
:p.The default value for this text is one of the following&colon.
:xmp.
 ALIAS_TABLE_ENTRY_MIGRATION_TEXT       "--> LVM "
 ALIAS_TABLE_ENTRY_MIGRATION_TEXT2      "--> LVM*"
:exmp.
:efn.


.* ----------------------------------------------------------------------------
.* Allocation_Algorithm
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_allocation_algorithm.Allocation_Algorithm
:p.This enumeration defines the allocation strategies available for use with
the :link reftype=hd refid=FN_create_partition.Create_Partition:elink.
function.  The allocation strategy is used to determine which block of free
space, out of those available, should be used when creating a partition if
one is not explicitly specified.

:xmp.

#include &lt.lvm_intr.h&gt.

typedef enum _Allocation_Algorithm {
    :link reftype=fn refid=AA_automatic    .Automatic:elink.,        /* Let LVM decide which block to use                      */
    :link reftype=fn refid=AA_best_fit     .Best_Fit:elink.,         /* Use the block which is closest in size                 */
    :link reftype=fn refid=AA_first_fit    .First_Fit:elink.,        /* Use the first block which is large enough              */
    :link reftype=fn refid=AA_last_fit     .Last_Fit:elink.,         /* Use the last block which is large enough               */
    :link reftype=fn refid=AA_from_largest .From_Largest:elink.,     /* Use the largest block out of those available           */
    :link reftype=fn refid=AA_from_smallest.From_Smallest:elink.,    /* Use the smallest possible block out of those available */
    :link reftype=fn refid=AA_all          .All:elink.               /* Turn the drive or block into a single partition        */
} Allocation_Algorithm;
:exmp.


:fn id=AA_automatic.
:p.Let LVM decide which block of free space to use to create the partition.
:efn.
:fn id=AA_best_fit.
:p.Use the block of free space which is closest in size to the partition being created.
:efn.
:fn id=AA_first_fit.
:p.Use the first block of free space on the disk which is large enough to hold a partition of the specified size.
:efn.
:fn id=AA_last_fit.
:p.Use the last block of free space on the disk which is large enough to hold a partition of the specified size.
:efn.
:fn id=AA_from_largest.
:p.Find the largest block of free space and allocate the partition from that block of free space.
:efn.
:fn id=AA_from_smallest.
:p.Find the smallest block of free space that can accommodate a partition of the size specified.
:efn.
:fn id=AA_all.
:p.Turn the specified drive or block of free space into a single partition.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_boolean.BOOLEAN
:p.A BOOLEAN variable is one which is either TRUE or FALSE.

:xmp.

#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned char  BOOLEAN;

#define TRUE  1
#define FALSE 0
:exmp.


.* ----------------------------------------------------------------------------
.* Boot_Manager_Menu_Item
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_boot_manager_menu_item.Boot_Manager_Menu_Item
:p.This structure defines an item on the Boot Manager menu.

:xmp.

#include &lt.lvm_intr.h&gt.

typedef struct _Boot_Manager_Menu_Item {
    :link reftype=hd refid=TYPE_address.ADDRESS:elink.     :link reftype=fn refid=BMMI_handle.Handle:elink.;    /* A volume or partition handle                      */
    :link reftype=hd refid=TYPE_boolean.BOOLEAN:elink.     :link reftype=fn refid=BMMI_volume.Volume:elink.;    /* Indicates whether Handle is a volume or partition */
} Boot_Manager_Menu_Item;
:exmp.


:fn id=BMMI_handle.
:p.A volume or partition handle.
:efn.
:fn id=BMMI_volume.
:p.If TRUE, then Handle is the handle of a volume.  Otherwise, Handle is the handle of a partition.
:efn.


.* ----------------------------------------------------------------------------
.* Boot_Manager_Menu
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_boot_manager_menu.Boot_Manager_Menu
:p.The following structure is used to get a list of the items on the partition manager menu.

:xmp.

#include &lt.lvm_intr.h&gt.

typedef struct _Boot_Manager_Menu {
    :link reftype=hd refid=TYPE_boot_manager_menu_item.Boot_Manager_Menu_Item:elink. *  Menu_Items;    /* Array of menu items  */
    :link reftype=hd refid=TYPE_cardinal              .CARDINAL32:elink.                Count;         /* Number of menu items */
} Boot_Manager_Menu;
:exmp.


:fn id=BMM_menu_items.
:p.An array of Boot Manager menu items.
:efn.
:fn id=BMM_count.
:p.The number of entries in the array of menu items.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_byte.BYTE
:p.A BYTE is 8 bits of memory with no interpretation attached.  If not already
defined by the development environment, it is declared as&colon.

:xmp.

#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned char BYTE;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE__byte.Byte
:p.Defines a single-byte (8-bit) integer value.
:p.This type is used by various internal LVM data structures related to disk
layout.

:xmp.

#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned char Byte;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_cardinal.CARDINAL types
:p.A CARDINAL number is a positive (that is, unsigned) integer value. The
number appended to the CARDINAL key word indicates the number of bits used
to represent a CARDINAL of that type.

:xmp.

#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned short int CARDINAL16;   /* 16 bits */
typedef unsigned long      CARDINAL32;   /* 32 bits */
typedef unsigned int       CARDINAL;     /* Compiler default */
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_dla_entry.DLA_Entry
:p.This structure defines the drive letter assignment (DLA) entry for a
primary or extended partition.  It corresponds to one of the (maximum of)
four entries in a disk drive's partition table.
:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.

#include &lt.lvm_data.h&gt.

typedef struct _DLA_Entry {
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.  :link reftype=fn refid=DLAE_volume_serial_number   .Volume_Serial_Number:elink.;                     /* Serial number of the current volume                */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.  :link reftype=fn refid=DLAE_partition_serial_number.Partition_Serial_Number:elink.;                  /* Serial number of this partition                    */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.  :link reftype=fn refid=DLAE_partition_size         .Partition_Size:elink.;                           /* Partition size, in sectors                         */
    :link reftype=hd refid=TYPE_lba       .LBA:elink.         :link reftype=fn refid=DLAE_partition_start        .Partition_Start:elink.;                          /* The starting sector of the partition               */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.     :link reftype=fn refid=DLAE_on_boot_manager_menu   .On_Boot_Manager_Menu:elink.;                     /* Indicates if partition is on the Boot Manager menu */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.     :link reftype=fn refid=DLAE_installable            .Installable:elink.;                              /* Indicates if partition is set Installable          */
    char        :link reftype=fn refid=DLAE_drive_letter                                                         .Drive_Letter:elink.;                             /* Drive letter assigned to the partition             */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.        :link reftype=fn refid=DLAE_reserved               .Reserved:elink.;
    char        :link reftype=fn refid=DLAE_volume_name                                                          .Volume_Name[ VOLUME_NAME_SIZE ]:elink.;          /* Name of the current volume                         */
    char        :link reftype=fn refid=DLAE_partition_name                                                       .Partition_Name[ PARTITION_NAME_SIZE ]:elink.;    /* Name of the partition                              */
} DLA_Entry;
:exmp.


:fn id=DLAE_volume_serial_number.
:p.The serial number of the volume that this partition belongs to.
:efn.
:fn id=DLAE_partition_serial_number.
:p.The serial number of this partition.
:efn.
:fn id=DLAE_partition_size.
:p.The size of the partition, in sectors.
:efn.
:fn id=DLAE_partition_start.
:p.The starting sector of the partition.
:efn.
:fn id=DLAE_on_boot_manager_menu.
:p.Set to TRUE if this volume/partition is on the Boot Manager Menu.
:efn.
:fn id=DLAE_installable.
:p.Set to TRUE if this volume is the one to install the operating system on.
:efn.
:fn id=DLAE_drive_letter.
:p.The drive letter assigned to the partition.
:efn.
:fn id=DLAE_reserved.
:p.Reserved field (used for structure alignment).
:efn.
:fn id=DLAE_volume_name.
:p.The name assigned to the volume by the user.
:efn.
:fn id=DLAE_partition_name.
:p.The name assigned to the partition.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_dla_table_sector.DLA_Table_Sector
:p.This structure defines the drive letter assignment (DLA) table used by
LVM.  For each partition table on the disk, there will be a DLA table in the
last sector of the track containing that partition table.
:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.

#include &lt.lvm_data.h&gt.

typedef struct _DLA_Table_Sector {
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=DLATS_dla_signature1         .DLA_Signature1:elink.;                 /* The DLAT signature (part 1)             */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=DLATS_dla_signature2         .DLA_Signature2:elink.;                 /* The DLAT signature (part 2)             */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=DLATS_dla_crc                .DLA_CRC:elink.;                        /* The 32-bit CRC for this sector          */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=DLATS_disk_serial_number     .Disk_Serial_Number:elink.;             /* The serial number assigned to this disk */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=DLATS_boot_disk_serial_number.Boot_Disk_Serial_Number:elink.;        /* The serial number of the boot disk      */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.     :link reftype=fn refid=DLATS_install_flags          .Install_Flags:elink.;                  /* For use by the Install program          */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.     Cylinders;
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.     Heads_Per_Cylinder;
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.     Sectors_Per_Track;
    char           :link reftype=fn refid=DLATS_disk_name                                                            .Disk_Name[ DISK_NAME_SIZE ]:elink.;    /* The name of the current disk            */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.        :link reftype=fn refid=DLATS_reboot                 .Reboot:elink.;                         /* For use by the Install program          */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.           :link reftype=fn refid=DLATS_reserved               .Reserved[ 3 ]:elink.;
    :link reftype=hd refid=TYPE_dla_entry .DLA_Entry:elink.      :link reftype=fn refid=DLATS_dla_array              .DLA_Array[ 4 ]:elink.;                 /* DLA entries for each partition          */
} DLA_Table_Sector;
:exmp.

:fn id=DLATS_dla_signature1.
:p.The magic signature (part 1) of a Drive Letter Assignment Table.
:p.This value is defined as&colon.
:xmp.
 DLA_TABLE_SIGNATURE1    0x424D5202L
:exmp.
:efn.
:fn id=DLATS_dla_signature2.
:p.The magic signature (part 2) of a Drive Letter Assignment Table.
:p.This value is defined as&colon.
:xmp.
 DLA_TABLE_SIGNATURE2    0x44464D50L
:exmp.
:efn.
:fn id=DLATS_dla_crc.
:p.The 32-bit CRC for this sector.  Calculated assuming that this field and
all unused space in the sector is 0.
:efn.
:fn id=DLATS_disk_serial_number.
:p.The serial number assigned to this disk.
:efn.
:fn id=DLATS_boot_disk_serial_number.
:p.The serial number of the disk used to boot the system.
:p.This is used for conflict resolution when multiple volumes want the same
drive letter.  Since LVM.EXE will not let this situation happen, the only way
to get this situation is for the disk to have been altered by something other
than LVM.EXE, or if a disk drive has been moved from one machine to another.  If
the drive has been moved, then it should have a different
Boot_Disk_Serial_Number.  Thus, the LVM Engine can tell which disk drive is the
&osq.foreign&csq. drive and therefore reject its claim for the drive letter in
question.
:p.If all of the claimants have the same Boot_Disk_Serial_Number, then the LVM
Engine will assign drive letters on a first-come-first-served basis.
:efn.
:fn id=DLATS_install_flags.
:p.Used by the Install program.
:efn.
:fn id=DLATS_cylinders.
:p.
:efn.
:fn id=DLATS_heads_per_cylinder.
:p.
:efn.
:fn id=DLATS_sectors_per_track.
:p.
:efn.
:fn id=DLATS_disk_name.
:p.The name assigned to the disk containing this sector.
:efn.
:fn id=DLATS_reboot.
:p.For use by Install.  Used to keep track of reboots initiated by install.
:efn.
:fn id=DLATS_reserved.
:p.Reserved field (used for structure alignment).
:efn.
:fn id=DLATS_dla_array.
:p.These are the four entries which correspond to the entries in the partition
table.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_doubleword.DoubleWord
:p.Defines a four-byte (32-bit) integer value.
:p.This type is used in the declaration of disk structures.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned long DoubleWord;
:exmp.


.* ----------------------------------------------------------------------------
.* Drive_Control_Array
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_drive_control_array.Drive_Control_Array
:p.This structure represents an array of invariant drive data. It is returned
by :link reftype=hd refid=FN_get_drive_control_data.Get_Drive_Control_Data:elink..

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Drive_Control_Array {
    :link reftype=hd refid=TYPE_drive_control_record.Drive_Control_Record:elink. *   :link reftype=fn refid=DCA_data .Drive_Control_Data:elink.;    /* An array of drive control records  */
    :link reftype=hd refid=TYPE_cardinal            .CARDINAL32:elink.               :link reftype=fn refid=DCA_count.Count:elink.;                 /* The number of records in the array */
} Drive_Control_Array;
:exmp.


:fn id=DCA_data.
:p.An array of drive control records.
:efn.

:fn id=DCA_count.
:p.The number of drive control records in the array.
:efn.


.* ----------------------------------------------------------------------------
.* Drive_Control_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_drive_control_record.Drive_Control_Record
:p.This structure contains invariant data associated with a disk drive.

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Drive_Control_Record {
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=DCR_drive_number       .Drive_Number:elink.;           /* The OS/2 drive number for this drive           */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=DCR_drive_size         .Drive_Size:elink.;             /* The total number of sectors on the drive       */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.   :link reftype=fn refid=DCR_drive_serial_number.Drive_Serial_Number:elink.;    /* The serial number assigned to this drive       */
    :link reftype=hd refid=TYPE_address   .ADDRESS:elink.      :link reftype=fn refid=DCR_drive_handle       .Drive_Handle:elink.;           /* The handle of this disk drive                  */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=DCR_drive_cylinders    .Cylinder_Count:elink.;         /* The number of cylinders on this drive          */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=DCR_drive_heads        .Heads_Per_Cylinder:elink.;     /* The number of heads per cylinder on this drive */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=DCR_drive_sectors      .Sectors_Per_Track:elink.;      /* The number of sectors per track on this drive  */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.      :link reftype=fn refid=DCR_drive_isprm        .Drive_Is_PRM:elink.;           /* Set to TRUE for partitioned removable media    */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=DCR_reserved           .Reserved[ 3 ]:elink.;
} Drive_Control_Record;
:exmp.


:fn id=DCR_drive_number.
:p.The OS/2 drive number for this drive, where 1 is the first drive seen by the
system.
:efn.
:fn id=DCR_drive_size.
:p.The total number of sectors on the drive.
:efn.
:fn id=DCR_drive_serial_number.
:p.The serial number assigned to this drive. The LVM Engine does not make use
of this data; it is provided for informational purposes only.
:efn.
:fn id=DCR_drive_handle.
:p.The handle of the disk drive to which this record refers.  The drive handle
may be used to perform various operations on the disk.
:efn.
:fn id=DCR_drive_cylinders.
:p.The number of cylinders on the drive.
:efn.
:fn id=DCR_drive_heads.
:p.The number of heads per cylinder for this drive.
:efn.
:fn id=DCR_drive_sectors.
:p.The number of sectors per track for this drive.
:efn.
:fn id=DCR_drive_isprm.
:p.Set to TRUE if this drive is a PRM (Partitioned Removable Media) device.
:efn.
:fn id=DCR_reserved.
:p.Reserved field (used for structure alignment).
:efn.


.* ----------------------------------------------------------------------------
.* Drive_Information_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_drive_information_record.Drive_Information_Record
:p.This structure defines the information that can be changed for a specific
disk drive.  It is returned by :link reftype=hd refid=FN_get_drive_status.Get_Drive_Status:elink..

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Drive_Information_Record {
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   :link reftype=fn refid=DIR_available.Total_Available_Sectors:elink.;          /* The total amount of free space, in sectors              */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink.   :link reftype=fn refid=DIR_largest  .Largest_Free_Block_Of_Sectors:elink.;    /* The size of the largest block of free space, in sectors */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      :link reftype=fn refid=DIR_corrupt  .Corrupt_Partition_Table:elink.;          /* TRUE if the partitioning information is invalid         */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      :link reftype=fn refid=DIR_unusable .Unusable:elink.;                         /* TRUE if the disk's MBR cannot be accessed               */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      :link reftype=fn refid=DIR_ioerror  .IO_Error:elink.;                         /* TRUE if the last I/O operation on the disk failed       */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.      :link reftype=fn refid=DIR_bigfloppy.Is_Big_Floppy:elink.;                    /* TRUE if the disk is a "large floppy" type device        */
    char         :link reftype=fn refid=DIR_drive_name                                           .Drive_Name[ DISK_NAME_SIZE ]:elink.;     /* User-assigned name for this disk drive                  */
} Drive_Information_Record;
:exmp.


:fn id=DIR_available.
:p.The number of sectors on the disk which are not currently assigned to a partition.
:efn.
:fn id=DIR_largest.
:p.The number of sectors in the largest contiguous block of available sectors.
:efn.
:fn id=DIR_corrupt.
:p.If TRUE, then the partitioning information found on the drive is incorrect.
:efn.
:fn id=DIR_unusable.
:p.If TRUE, the drive's MBR is not accessible and the drive can not be partitioned.
:efn.
:fn id=DIR_ioerror.
:p.If TRUE, then the last I/O operation on this drive failed!
:efn.
:fn id=DIR_bigfloppy.
:p.If TRUE, then the drive is a removable media device formatted in "large floppy" (i.e.
partitionless) mode.
:efn.
:fn id=DIR_drive_name.
:p.The user-assigned name for this disk drive.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_extended_boot_record.Extended_Boot_Record
:p.An Extended Boot Record is used to define the contents of an extended
partition.  It has the same basic format as a Master Boot Record, although the
contents will be interpreted somewhat differently.
:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.
#include &lt.lvm_data.h&gt.

/*
 * The following define the values used to indicate that a partition table
 * entry is for an EBR, not a partition.
 */
#define EBR_BOOT_INDICATOR     0x0
#define EBR_FORMAT_INDICATOR   0x05
#define EBR_FORMAT_INDICATORX  0x0F


typedef :link reftype=hd refid=TYPE_master_boot_record.Master_Boot_Record:elink.  Extended_Boot_Record;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_integer.INTEGER types
:p.An INTEGER number is a signed (either positive or negative) whole
number. The number appended to the INTEGER key word indicates the number
of bits used to represent an INTEGER of that type.

:xmp.
#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef short int INTEGER16;             /* 16 bits */
typedef long  int INTEGER32;             /* 32 bits */
typedef int       INTEGER;               /* Compiler default. */
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_LBA.LBA
:p.Defines a Logical Block Address.  A Logical Block Address is relative to
the start of a physical device - a disk drive.  The first sector on a disk
drive is LBA 0.
:p.This type is used internally by LVM.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned long LBA;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_LSN.LSN
:p.Defines a Logical Sector Number.  A Logical Sector Number is relative to
the start of a volume.  The first sector in a volume is LSN 0.
:p.This type is used internally by LVM.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned long LSN;
:exmp.


.* ----------------------------------------------------------------------------
.* LVM_Feature_Data
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_lvm_feature_data.LVM_Feature_Data
:p.This structure is used to hold the location of the feature-specific data for
LVM features.
:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.
#include &lt.lvm_data.h&gt.

#define  NULL_FEATURE   0


typedef struct _LVM_Feature_Data {
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.     :link reftype=fn refid=LFD_feature_id                        .Feature_ID:elink.;                            /* The ID of the feature */
    :link reftype=hd refid=TYPE_psn       .PSN:elink.            :link reftype=fn refid=LFD_location_of_primary_feature_data  .Location_Of_Primary_Feature_Data:elink.;      /* The address of the feature data */
    :link reftype=hd refid=TYPE_psn       .PSN:elink.            :link reftype=fn refid=LFD_location_of_secondary_feature_data.Location_Of_Secondary_Feature_Data:elink.;    /* The address of the backup feature data */
    :link reftype=hd refid=TYPE_quadword  .DoubleWord:elink.     :link reftype=fn refid=LFD_feature_data_size                 .Feature_Data_Size:elink.;                     /* The size, in sectors, of the feature data */
    :link reftype=hd refid=TYPE_word      .Word:elink.           :link reftype=fn refid=LFD_feature_major_version_number      .Feature_Major_Version_Number:elink.;          /* The feature's major version number */
    :link reftype=hd refid=TYPE_word      .Word:elink.           :link reftype=fn refid=LFD_feature_minor_version_number      .Feature_Minor_Version_Number:elink.;          /* The feature's minor version number */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.        :link reftype=fn refid=LFD_feature_active                    .Feature_Active:elink.;                        /* TRUE if this feature is active */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.           :link reftype=fn refid=LFD_reserved                          .Reserved[ 3 ]:elink.;
} LVM_Feature_Data;
:exmp.

:fn id=LFD_feature_id.
:p.The ID of the feature.
:p.All unused feature entries will have the value NULL_FEATURE (0).
:efn.
:fn id=LFD_location_of_primary_feature_data.
:p.The PSN of the starting sector of the private data for this feature.
:efn.
:fn id=LFD_location_of_secondary_feature_data.
:p.The PSN of the starting sector of the backup copy of the private data for this feature.
:efn.
:fn id=LFD_feature_data_size.
:p.The number of sectors used by this feature for its private data.
:efn.
:fn id=LFD_feature_major_version_number.
:p.The integer portion of the version number of this feature.
:efn.
:fn id=LFD_feature_minor_version_number.
:p.The decimal portion of the version number of this feature.
:efn.
:fn id=LFD_feature_active.
:p.TRUE if this feature is active on the current partition or volume, FALSE
otherwise.
:efn.
:fn id=LFD_reserved.
:p.Reserved field (used for structure alignment).
:efn.


.* ----------------------------------------------------------------------------
.* LVM_Signature_Sector
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_lvm_signature_sector.LVM_Signature_Sector
:p.The following structure defines the LVM Signature Sector (LSS).  This is the
last sector of every partition which is part of an LVM volume.  It gives vital
information about the version of LVM used to create the LVM volume that it is a
part of, as well as which LVM features (BBR, drive linking, etc.) are active on
the volume that this partition is a part of.

:nt.The remainder of the sector (following the contents of this structure) is
reserved for future use, and should be all zero to ensure proper calculation
of the CRC field.:ent.

:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.
#include &lt.lvm_data.h&gt.

#define  COMMENT_SIZE                       81
#define  MAX_FEATURES_PER_VOLUME            10

/*
 * These constants define the current LVM version.  The Major_Version_Number and
 * Minor_Version_Number fields should contain these values, respectively, if the
 * partition was created by this version of LVM.
 */
#define  CURRENT_LVM_MAJOR_VERSION_NUMBER   1
#define  CURRENT_LVM_MINOR_VERSION_NUMBER   0


typedef struct _LVM_Signature_Sector {
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_lvm_signature1                   .LVM_Signature1:elink.;                                 /* The first part of the LVM signature     */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_lvm_signature2                   .LVM_Signature2:elink.;                                 /* The second part of the LVM signature    */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_signature_sector_crc             .Signature_Sector_CRC:elink.;                           /* 32 bit CRC for this sector              */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_partition_serial_number          .Partition_Serial_Number:elink.;                        /* The serial number for this partition    */
    :link reftype=hd refid=TYPE_lba             .LBA:elink.               :link reftype=fn refid=LSS_partition_start                         .Partition_Start:elink.;                                /* LBA of the first sector                 */
    :link reftype=hd refid=TYPE_lba             .LBA:elink.               :link reftype=fn refid=LSS_partition_end                           .Partition_End:elink.;                                  /* LBA of the last sector                  */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_partition_sector_count           .Partition_Sector_Count:elink.;                         /* The number of sectors                   */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_lvm_reserved_sector_count        .LVM_Reserved_Sector_Count:elink.;                      /* The number of sectors reserved by LVM   */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_partition_size_to_report_to_user .Partition_Size_To_Report_To_User:elink.;               /* The reported size of the partition      */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_boot_disk_serial_number          .Boot_Disk_Serial_Number:elink.;                        /* The serial number of the boot disk      */
    :link reftype=hd refid=TYPE_doubleword      .DoubleWord:elink.        :link reftype=fn refid=LSS_volume_serial_number             .Volume_Serial_Number:elink.;                           /* The serial number of the current volume */
    :link reftype=hd refid=TYPE_cardinal        .CARDINAL32:elink.        :link reftype=fn refid=LSS_fake_ebr_location                .Fake_EBR_Location:elink.;                              /* The location of a fake EBR, if any      */
    :link reftype=hd refid=TYPE_word            .Word:elink.              :link reftype=fn refid=LSS_lvm_major_version_number         .LVM_Major_Version_Number:elink.;                       /* Major LVM version number                */
    :link reftype=hd refid=TYPE_word            .Word:elink.              :link reftype=fn refid=LSS_lvm_minor_version_number         .LVM_Minor_Version_Number:elink.;                       /* Minor LVM version number                */
    char              :link reftype=fn refid=LSS_partition_name                                                                       .Partition_Name[ PARTITION_NAME_SIZE ]:elink.;          /* User-defined partition name             */
    char              :link reftype=fn refid=LSS_volume_name                                                                          .Volume_Name[ VOLUME_NAME_SIZE ]:elink.;                /* User-defined volume name                */
    :link reftype=hd refid=TYPE_lvm_feature_data.LVM_Feature_Data:elink.  :link reftype=fn refid=LSS_lvm_feature_array.LVM_Feature_Array[ MAX_FEATURES_PER_VOLUME ]:elink.;   /* Array of features active on this volume */
    char              :link reftype=fn refid=LSS_drive_letter                                                                         .Drive_Letter:elink.;                                   /* The assigned drive letter               */
    :link reftype=hd refid=TYPE_boolean         .BOOLEAN:elink.           :link reftype=fn refid=LSS_fake_ebr_allocated               .Fake_EBR_Allocated:elink.;                             /* Indicates existence of a fake EBR       */
    char              :link reftype=fn refid=LSS_comment                                                                              .Comment[ COMMENT_SIZE ]:elink.;                        /* Comment field (unused)                  */
    char              :link reftype=fn refid=LSS_disk_name                                                                            .Disk_Name[ DISK_NAME_SIZE ]:elink.;                    /* Name of disk containing bad sectors     */
} LVM_Signature_Sector;
:exmp.


:fn id=LSS_lvm_signature1.
:p.The first part of the magic LVM signature.  This is defined as follows&colon.
:xmp.
 LVM_PRIMARY_SIGNATURE      0x4A435332L
:exmp.
:efn.
:fn id=LSS_lvm_signature2.
:p.The second part of the magic LVM signature.  This is defined as follows&colon.
:xmp.
 LVM_SECONDARY_SIGNATURE    0x4252444BL
:exmp.
:efn.
:fn id=LSS_signature_sector_crc.
:p.32-bit CRC for this sector.  Calculated using 0 for this field.
:efn.
:fn id=LSS_partition_serial_number.
:p.The LVM assigned serial number for this partition.
:efn.
:fn id=LSS_partition_start.
:p.LBA of the first sector of this partition.
:efn.
:fn id=LSS_partition_end.
:p.LBA of the last sector of this partition.
:efn.
:fn id=LSS_partition_sector_count.
:p.The number of sectors in this partition.
:efn.
:fn id=LSS_lvm_reserved_sector_count.
:p.The number of sectors reserved for use by LVM.
:efn.
:fn id=LSS_partition_size_to_report_to_user.
:p.The size of the partition as the user sees it.  This is equivalent to the
actual size of the partition minus the LVM-reserved sectors, rounded to a
track boundary.
:efn.
:fn id=LSS_boot_disk_serial_number.
:p.The serial number of the boot disk for the system.  If the system contains
Boot Manager, then this is the serial number of the disk containing the active
copy of Boot Manager.
:efn.
:fn id=LSS_volume_serial_number.
:p.The serial number of the volume that this partition belongs to.
:efn.
:fn id=LSS_fake_ebr_location.
:p.The location, on disk, of a Fake EBR, if one has been allocated.
:efn.
:fn id=LSS_lvm_major_version_number.
:p.Major version number of the LVM that created this partition.
:efn.
:fn id=LSS_lvm_minor_version_number.
:p.Minor version number of the LVM that created this partition.
:efn.
:fn id=LSS_partition_name.
:p.User-defined partition name.
:efn.
:fn id=LSS_volume_name.
:p.The name of the volume that this partition belongs to.
:efn.
:fn id=LSS_lvm_feature_array.
:p.The feature array.  This indicates which LVM features, if any, are active on
this volume, and what order they should be applied in.
:efn.
:fn id=LSS_drive_letter.
:p.The drive letter assigned to the volume that this partition is part of.
:efn.
:fn id=LSS_fake_ebr_allocated.
:p.If TRUE, then a fake EBR has been allocated.
:efn.
:fn id=LSS_comment.
:p.The Comment field is reserved but not currently used.  This is for future
expansion and use.
:efn.
:fn id=LSS_disk_name.
:p.Used by the Bad Block Relocation feature to report the name of a disk when
bad sectors are encountered on that disk.
:efn.


.* ----------------------------------------------------------------------------
.* Master_Boot_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_master_boot_record.Master_Boot_Record
:p.The following structure defines the format of the Master Boot Record (MBR).

:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.
#include &lt.lvm_data.h&gt.

#define MBR_EBR_SIGNATURE  0xAA55


typedef struct _Master_Boot_Record {
    :link reftype=hd refid=TYPE__byte           .Byte:elink.                :link reftype=fn refid=MBR_reserved.Reserved[ 446 ]:elink.;         /* Code area               */
    :link reftype=hd refid=TYPE_partition_record.Partition_Record:elink.    :link reftype=fn refid=MBR_partition_table.Partition_Table[ 4 ]:elink.;    /* Partition table         */
    :link reftype=hd refid=TYPE_word            .Word:elink.                :link reftype=fn refid=MBR_signature.Signature:elink.;               /* MBR/EBR signature bytes */
} Master_Boot_Record;
:exmp.

:fn id=MBR_reserved.
:p.This part of the MBR contains the boot code area and disk signature bytes.
:efn.
:fn id=MBR_partition_table.
:p.The partition table defines up to four primary or extended partitions.
:efn.
:fn id=MBR_signature.
:p.A value of MBR_EBR_SIGNATURE (0xAA55) in this field indicates that this is a
valid partition table/MBR.
:efn.


.* ----------------------------------------------------------------------------
.* Partition_Information_Array
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_partition_information_array.Partition_Information_Array
:p.The following structure is returned by various functions in the LVM Engine.

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Partition_Information_Array {
    :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink. * :link reftype=fn refid=PIA_array.Partition_Array:elink.;    /* An array of partition information records */
    :link reftype=hd refid=TYPE_cardinal                    .CARDINAL32:elink.                     :link reftype=fn refid=PIA_count.Count:elink.;              /* The number of entries in the array        */
} Partition_Information_Array;
:exmp.
:p.

:fn id=PIA_array.
:p.An array of partition information records.
:efn.
:fn id=PIA_count.
:p.The number of entries in Partition_Array.
:efn.


.* ----------------------------------------------------------------------------
.* Partition_Information_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_partition_information_record.Partition_Information_Record
:p.This structure defines the data associated with a specific partition.  It is
returned by :link reftype=hd refid=FN_get_partition_information.Get_Partition_Information:elink..

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Partition_Information_Record {
    :link reftype=hd refid=TYPE_address   .ADDRESS:elink.      :link reftype=fn refid=PIR_partition_handle.Partition_Handle:elink.;                            /* The partition handle                                             */
    :link reftype=hd refid=TYPE_address   .ADDRESS:elink.      :link reftype=fn refid=PIR_volume_handle   .Volume_Handle:elink.;                               /* The handle of the partition's volume, if any                     */
    :link reftype=hd refid=TYPE_address   .ADDRESS:elink.      :link reftype=fn refid=PIR_drive_handle    .Drive_Handle:elink.;                                /* The handle of the current disk drive                             */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink.   :link reftype=fn refid=PIR_partition_serial.Partition_Serial_Number:elink.;                     /* The serial number assigned to this partition                     */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=PIR_partition_start .Partition_Start:elink.;                             /* The LBA of the first sector of the partition                     */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=PIR_true_size       .True_Partition_Size:elink.;                         /* The total size of the partition, in sectors                      */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=PIR_usable_size     .Usable_Partition_Size:elink.;                       /* The size of the partition as reported to the IFS manager         */
    :link reftype=hd refid=TYPE_cardinal  .CARDINAL32:elink.   :link reftype=fn refid=PIR_boot_limit      .Boot_Limit:elink.;                                  /* The maximum size of a bootable partition created in this block   */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.      :link reftype=fn refid=PIR_spanned_volume  .Spanned_Volume:elink.;                              /* TRUE if this partition is part of a multi-partition volume       */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.      :link reftype=fn refid=PIR_primary         .Primary_Partition:elink.;                           /* TRUE if this partition is a primary partition                    */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=PIR_active          .Active_Flag:elink.;                                 /* Indicates whether this is an active partition                    */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=PIR_osflag          .OS_Flag:elink.;                                     /* Indicates the OS (type) flag for this partition                  */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=PIR_partition_type  .Partition_Type:elink.;                              /* Indicates the partition's LVM type                               */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=PIR_status          .Partition_Status:elink.;                            /* Indicates the partition's LVM status                             */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.      :link reftype=fn refid=PIR_onbm            .On_Boot_Manager_Menu:elink.;                        /* TRUE if partition is not part of a volume but is marked Bootable */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.         :link reftype=fn refid=PIR_reserved        .Reserved:elink.;
    char         :link reftype=fn refid=PIR_volume_letter                                                 .Volume_Drive_Letter:elink.;                         /* The preferred drive letter of the partition's volume, if any     */
    char         :link reftype=fn refid=PIR_drive_name                                                    .Drive_Name[ DISK_NAME_SIZE ]:elink.;                /* The user-assigned name of the current disk drive                 */
    char         :link reftype=fn refid=PIR_fs_name                                                       .File_System_Name[ FILESYSTEM_NAME_SIZE ]:elink.;    /* The name of the filesystem in use on this partition              */
    char         :link reftype=fn refid=PIR_partition_name                                                .Partition_Name[ PARTITION_NAME_SIZE ]:elink.;       /* The user-assigned name of this partition                         */
    char         :link reftype=fn refid=PIR_volume_name                                                   .Volume_Name[ VOLUME_NAME_SIZE ]:elink.;             /* The user-assigned name of the partition's volume                 */
} Partition_Information_Record;
:exmp.


:fn id=PIR_partition_handle.
:p.The handle used to perform operations on this partition.
:efn.
:fn id=PIR_volume_handle.
:p.If this partition is part of a volume, this will be the handle of
the volume.  If this partition is NOT part of a volume, then this
handle will be 0.
:efn.
:fn id=PIR_drive_handle.
:p.The handle of the disk drive on which this partition resides.
:efn.
:fn id=PIR_partition_serial.
:p.The serial number assigned to this partition.
:efn.
:fn id=PIR_partition_start.
:p.The LBA of the first sector of the partition.
:efn.
:fn id=PIR_true_size.
:p.The total number of sectors comprising the partition.
:efn.
:fn id=PIR_usable_size.
:p.The size of the partition as reported to the file system manager, in
sectors.  This is the size of the partition less any LVM overhead.
:efn.
:fn id=PIR_boot_limit.
:p.If this partition is a block of free space, this field indicates the maximum
number of sectors that could be used to create a bootable partition from it
(assuming that the partition would be allocated from the beginning of the block).
:efn.
:fn id=PIR_spanned_volume.
:p.TRUE if this partition is part of a multi-partition volume.
:efn.
:fn id=PIR_primary.
:p.True or False.  Any non-zero value here indicates that
this partition is a primary partition.  Zero here indicates
that this partition is a "logical drive" - i.e. it resides
inside of an extended partition.
:efn.
:fn id=PIR_active.
:p.Indicates whether the partition is designated as &osq.active&csq. in the
partition table.  Possible values are&colon.
:xmp.
 ACTIVE_PARTITION   0x80   Partition is active.
                    0      Partition is not active.
:exmp.
:efn.
:fn id=PIR_osflag.
:p.This field is from the partition table.  It is known as the OS Flag, the
Partition Type, Filesystem Type, and various other names.
:p.There are many possible values defined by various vendors.  Some particular
values of interest include&colon.
:xmp.
 0x00   Unformatted partition.
 0x01   FAT12-formatted partition.
 0x04   FAT16-formatted partition &lt. than 32 MB.
 0x06   FAT16-formatted partition &gt.= 32 MB.
 0x07   Partition formatted for use with an installable filesystem (IFS) such
        as HPFS or JFS under OS/2, or NTFS under Windows NT.
 0x0A   OS/2 Boot Manager partition.
 0x11   FAT12-formatted partition &lt. 32 MB which has been &osq.hidden&csq.
        by Boot Manager.
 0x14   FAT16-formatted partition &lt. 32 MB which has been &osq.hidden&csq.
        by Boot Manager.
 0x16   FAT16-formatted partition &gt.= 32 MB which has been &osq.hidden&csq.
        by Boot Manager.
 0x17   IFS-formatted partition which has been &osq.hidden&csq. by Boot
        Manager.
 0x35   Partition assigned to an LVM volume.
 0x82   Linux swap partition
 0x83   Linux partition
 0x87   HPFS386 Fault Tolerance mirror partition, or NT stripe/volume set.
 0xC7   Disabled HPFS386 Fault Tolerance mirror partition.
:exmp.
:efn.
:fn id=PIR_partition_type.
:p.Indicates the partition's type classification according to LVM&colon.
:xmp.
 FREE_SPACE_PARTITION      0    Free space block
 LVM_PARTITION             1    Partition is part of an LVM Volume.
 COMPATIBILITY_PARTITION   2    Partition is assigned as a compatibility volume.
:exmp.
:p.All other values are reserved for future use.
:efn.
:fn id=PIR_status.
:p.Indicates the partition's current status according to LVM&colon.
:xmp.
 PARTITION_IS_FREE_SPACE   0    Partition is a free space block.
 PARTITION_IS_IN_USE       1    Partition is already assigned to a volume.
 PARTITION_IS_AVAILABLE    2    Partition is not currently assigned to a volume.
:exmp.
:efn.
:fn id=PIR_onbm.
:p.Set to TRUE if this partition is not part of a volume, yet is on the Boot
Manager Menu.
:efn.
:fn id=PIR_reserved.
:p.Reserved field (used for structure alignment).
:efn.
:fn id=PIR_volume_letter.
:p.The drive letter assigned to the volume that this partition is a part of.
:p.This field reflects the user-assigned (i.e. preferred) drive letter, which is
not necessarily the same as the current drive letter assigned to the volume by
LVM.
:efn.
:fn id=PIR_drive_name.
:p.The user-assigned name of the disk drive on which this partition resides.
:efn.
:fn id=PIR_fs_name.
:p.The name of the filesystem in use on this partition, if it is known.
:p.Possible values of interest include "HPFS", "JFS", "FAT12", "FAT16", "FAT32",
"NTFS", "UDF", "CDFS", "Linux" and "????".
:p.In addition, certain filesystem names may have the string "-H" appended to
them, which indicates that they reside on partitions which have been
&osq.hidden&csq. by Boot Manager.  (&osq.Hidden&csq. in this context simply
means that a primary partition has been temporarily marked by Boot Manager as
inactive, or not currently booted, in the partition table.  It should not be
confused with the separate concept of hiding a volume.)
:p.Note that there is an error in the current OS/2 implementation which
causes partition type 0x83 (Linux native) to be reported as "????" while
type 0x82 (Linux swap) is reported as "Linux".
:efn.
:fn id=PIR_partition_name.
:p.The user-assigned name for this partition.
:efn.
:fn id=PIR_volume_name.
:p.If this partition is part of a volume, then this will be the name of the
volume that this partition is a part of.  If this record represents free space,
then the Volume_Name will be "FREE SPACE xx", where xx is a unique numeric ID
generated by LVM.DLL.  Otherwise, it will be an empty string.
:efn.


.* ----------------------------------------------------------------------------
.* Partition_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_partition_record.Partition_Record
:p.The following structure defines the format of a partition table entry.

:p.This type is used internally by LVM, and is not directly available through
the public LVM API.  However, it is possible to access this data by means of
the :link reftype=hd refid=FN_read_sectors.Read_Sectors:elink. and
:link reftype=hd refid=FN_write_sectors.Write_Sectors:elink. functions.

:xmp.
#include &lt.lvm_data.h&gt.

#define ACTIVE_PARTITION       0x80
#define EBR_BOOT_INDICATOR     0x0


typedef struct _Partition_Record {
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_boot_indicator   .Boot_Indicator:elink.;    /* Active partition indicator                                           */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_starting_head    .Starting_Head:elink.;     /* Starting head of this partition                                      */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_starting_sector  .Starting_Sector:elink.;   /* Starting sector (bits 0-5) and cylinder (bits 6-7) of this partition */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_starting_cylinder.Starting_Cylinder:elink.; /* Starting cylinder (combined with bits 6-7 of the previous field)     */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_format_indicator .Format_Indicator:elink.;  /* Indicates the filesystem/OS type of this partition                   */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_ending_head      .Ending_Head:elink.;       /* Ending head of this partition                                        */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_ending_sector    .Ending_Sector:elink.;     /* Ending sector (bits 0-5) and cylinder (bits 6-7) of this partition   */
    :link reftype=hd refid=TYPE__byte     .Byte:elink.       :link reftype=fn refid=PR_ending_cylinder  .Ending_Cylinder:elink.;   /* Ending cylinder (combined with bits 6-7 of the previous field)       */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink. :link reftype=fn refid=PR_sector_offset    .Sector_Offset:elink.;     /* The number of sectors on the disk prior to this partition            */
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink. :link reftype=fn refid=PR_sector_count     .Sector_Count:elink.;      /* The number of sectors in this partition                              */
} Partition_Record;
:exmp.

:fn id=PR_boot_indicator.
:p.A value of ACTIVE_PARTITION (0x80) indicates the active partition.
:efn.
:fn id=PR_starting_head.
:p.The starting head of this partition.
:efn.
:fn id=PR_starting_sector.
:p.Bits 0-5 contain the starting sector of this partition.
:p.Bits 6 and 7 are the high order bits of the starting cylinder, to be used in
combination with the
:link reftype=fn refid=PR_starting_cylinder.Starting_Cylinder:elink. field.
:efn.
:fn id=PR_starting_cylinder.
:p.The cylinder number is a 10-bit value.  The high order bits of the 10-bit value
come from bits 6 and 7 of the
:link reftype=fn refid=PR_starting_sector.Starting_Sector:elink. field.
:efn.
:fn id=PR_format_indicator.
:p.An indicator of the format/operating system on this partition.
:p.Some common values of interest include (symbolic names are defined in
:hp2.lvm_data.h:ehp2.)&colon.
:xmp.
0x00    UNUSED_INDICATOR
0x01    FAT12_INDICATOR
0x04    FAT16_SMALL_PARTITION_INDICATOR
0x05    EBR_INDICATOR  or  EBR_FORMAT_INDICATOR
0x06    FAT16_LARGE_PARTITION_INDICATOR
0x07    IFS_INDICATOR
0x0A    BOOT_MANAGER_INDICATOR
0x0E    FAT16X_LARGE_PARTITION_INDICATOR
0x0F    WINDOZE_EBR_INDICATOR  or  EBR_FORMAT_INDICATORX
0x10    BOOT_MANAGER_HIDDEN_PARTITION_FLAG
0x35    LVM_PARTITION_INDICATOR
:exmp.
:p.See the description of the :link reftype=fn refid=PIR_osflag.OS_Flag:elink.
field under :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
for various other possible values.
:nt.When creating a new partition, the LVM Engine will set the value of
Format_Indicator to either 0x16 (for inactive or &osq.hidden&csq. primary
partitions), or 0x06 (for all other primary or logical partitions).:ent.
:efn.
:fn id=PR_ending_head.
:p.The ending head of this partition.
:efn.
:fn id=PR_ending_sector.
:p.Bits 0-5 contain the ending sector of this partition.
:p.Bits 6 and 7 are the high order bits of the ending cylinder, to be used in
combination with the
:link reftype=fn refid=PR_ending_cylinder.Ending_Cylinder:elink. field.
:efn.
:fn id=PR_ending_cylinder.
:p.The cylinder number is a 10-bit value.  The high order bits of the 10-bit value
come from bits 6 and 7 of the
:link reftype=fn refid=PR_ending_sector.Ending_Sector:elink. field.
:efn.
:fn id=PR_sector_offset.
:p.The number of sectors on the disk prior to the start of this partition.
:efn.
:fn id=PR_sector_count.
:p.The number of sectors in this partition.
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_PSN.PSN
:p.Defines a Partition Sector Number.  A Partition Sector Number is relative to
the start of a partition.  The first sector in a partition is PSN 0.
:p.This type is used internally by LVM.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef unsigned long PSN;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_pstring.pSTRING
:p.A basic string type.

:xmp.
#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef char * pSTRING;
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_quadword.QuadWord
:p.Defines an eight-byte (64-bit) integer value.
:p.This type is used in the declaration of disk structures.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

#ifdef LONG_LONG_SUPPORTED

typedef long long QuadWord;

#else

typedef struct _QuadWord {
    unsigned long  High32Bits;
    unsigned long  Low32Bits;
} QuadWord;

#endif
:exmp.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_real.REAL types
:p.A REAL number is a floating point number.

:xmp.
#include &lt.lvm_gbls.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef float   REAL32;
typedef double  REAL64;
:exmp.


.* ----------------------------------------------------------------------------
.* Volume_Control_Array
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_volume_control_array.Volume_Control_Array
:p.This structure represents an array of invariant volume data. It is returned
by :link reftype=hd refid=FN_get_volume_control_data.Get_Volume_Control_Data:elink..

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Volume_Control_Array {
    :link reftype=hd refid=TYPE_volume_control_record.Volume_Control_Record:elink. *  :link reftype=fn refid=VCA_data .Volume_Control_Data:elink.;    /* An array of volume control records */
    :link reftype=hd refid=TYPE_cardinal             .CARDINAL32:elink.               :link reftype=fn refid=VCA_count.Count:elink.;                  /* The number of entries in the array */
} Volume_Control_Array;
:exmp.


:fn id=VCA_data.
:p.An array of volume control records.
:efn.
:fn id=VCA_count.
:p.The number of entries in the array of volume control records.
:efn.


.* ----------------------------------------------------------------------------
.* Volume_Control_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_volume_control_record.Volume_Control_Record
:p.This structure contains invariant data associated with a logical volume.

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Volume_Control_Record {
    :link reftype=hd refid=TYPE_doubleword.DoubleWord:elink. :link reftype=fn refid=VCR_serial       .Volume_Serial_Number:elink.;    /* The serial number assigned to this volume                */
    :link reftype=hd refid=TYPE_address   .ADDRESS:elink.    :link reftype=fn refid=VCR_handle       .Volume_Handle:elink.;           /* The handle used to perform operations on this volume     */
    :link reftype=hd refid=TYPE_boolean   .BOOLEAN:elink.    :link reftype=fn refid=VCR_compatibility.Compatibility_Volume:elink.;    /* TRUE if this volume is a compatibility volume            */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.       :link reftype=fn refid=VCR_devtype      .Device_Type:elink.;             /* Indicates the type of device on which the volume resides */
    :link reftype=hd refid=TYPE_byte      .BYTE:elink.       :link reftype=fn refid=VCR_reserved     .Reserved[ 2 ]:elink.;
} Volume_Control_Record;
:exmp.


:fn id=VCR_serial.
:p.The serial number assigned to this volume.
:efn.
:fn id=VCR_handle.
:p.The handle used to perform operations on this volume.
:efn.
:fn id=VCR_compatibility.
:p.TRUE indicates that this volume is compatible with older versions of OS/2.
:p.FALSE indicates that this is an LVM specific volume and can not be used without OS2LVM.DMD.
:efn.
:fn id=VCR_devtype.
:p.Indicates what type of device the volume resides on&colon.
:xmp.
LVM_HARD_DRIVE   0    Hard disk drive under LVM control
LVM_PRM          1    Partitioned removable media device under LVM control
NON_LVM_CDROM    2    CD-ROM drive :hp2.not:ehp2. under LVM control
NETWORK_DRIVE    3    Network drive :hp2.not:ehp2. under LVM control
NON_LVM_DEVICE   4    Unknown device :hp2.not:ehp2. under LVM control
:exmp.
:efn.
:fn id=VCR_reserved.
:p.Reserved field (used for structure alignment).
:efn.


.* ----------------------------------------------------------------------------
.* Volume_Information_Record
.*
:h2 x=left y=bottom width=100% height=100% id=TYPE_volume_information_record.Volume_Information_Record
:p.This structure defines information about a particular volume which can (and
often does) vary.  It is returned by
:link reftype=hd refid=FN_get_volume_information.Get_Volume_Information:elink..

:xmp.
#include &lt.lvm_intr.h&gt.

typedef struct _Volume_Information_Record {
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. :link reftype=fn refid=VIR_size           .Volume_Size:elink.;                                 /* The size of this volume, in sectors                 */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. :link reftype=fn refid=VIR_pcount         .Partition_Count:elink.;                             /* The number of partitions which comprise this volume */
    :link reftype=hd refid=TYPE_cardinal.CARDINAL32:elink. :link reftype=fn refid=VIR_letter_conflict.Drive_Letter_Conflict:elink.;                       /* Indicates whether a drive letter conflict occurred  */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    :link reftype=fn refid=VIR_compatibility  .Compatibility_Volume:elink.;                        /* TRUE if this volume is a compatibility volume       */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    :link reftype=fn refid=VIR_bootable       .Bootable:elink.;                                    /* TRUE if this volume is bootable                     */
    char       :link reftype=fn refid=VIR_letter_preference                                          .Drive_Letter_Preference:elink.;                     /* The drive letter that this volume desires to have   */
    char       :link reftype=fn refid=VIR_current_letter                                             .Current_Drive_Letter:elink.;                        /* The drive letter currently assigned to this volume  */
    char       :link reftype=fn refid=VIR_initial_letter                                             .Initial_Drive_Letter:elink.;                        /* The drive letter initially assigned to this volume  */
    :link reftype=hd refid=TYPE_boolean .BOOLEAN:elink.    :link reftype=fn refid=VIR_new_volume     .New_Volume:elink.;                                  /* TRUE if the volume was created during this session  */
    :link reftype=hd refid=TYPE_byte    .BYTE:elink.       :link reftype=fn refid=VIR_status         .Status:elink.;                                      /* Indicates the bootability status of this volume     */
    :link reftype=hd refid=TYPE_byte    .BYTE:elink.       :link reftype=fn refid=VIR_reserved       .Reserved_1:elink.;
    char       :link reftype=fn refid=VIR_volume_name                                                .Volume_Name[ VOLUME_NAME_SIZE ]:elink.;             /* The user-assigned name for this volume              */
    char       :link reftype=fn refid=VIR_fs_name                                                    .File_System_Name[ FILESYSTEM_NAME_SIZE ]:elink.;    /* The name of the filesystem in use on this volume    */
} Volume_Information_Record;
:exmp.


:fn id=VIR_size.
:p.The number of sectors comprising the volume.
:efn.
:fn id=VIR_pcount.
:p.The number of partitions which comprise this volume.
:efn.
:fn id=VIR_letter_conflict.
:dl compact tsize=3.
:dt.0
:dd.Indicates that the drive letter preference for this volume is unique.
:dt.1
:dd.Indicates that the drive letter preference for this volume
is not unique, but this volume got its preferred drive letter anyway.
:dt.2
:dd.Indicates that the drive letter preference for this volume
is not unique, and this volume did :hp2.not:ehp2. get its preferred drive letter.
:dt.4
:dd.Indicates that this volume is currently &osq.hidden&csq. - i.e. it has
no drive letter preference at the current time.
:edl.
:efn.
:fn id=VIR_compatibility.
:p.TRUE if this is a compatibility volume, FALSE otherwise.
:efn.
:fn id=VIR_bootable.
:p.Set to TRUE if this volume appears on the Boot Manager menu, or if it is
a compatibility volume and its corresponding partition is the first active
primary partition on the first drive.
:efn.
:fn id=VIR_letter_preference.
:p.The drive letter that this volume desires to have.  This generally
corresponds to a drive letter selected by the user or system administrator
within the LVM application.
:efn.
:fn id=VIR_current_letter.
:p.The drive letter currently used to access this volume.  May be different from
:link reftype=fn refid=VIR_letter_preference.Drive_Letter_Preference:elink. if
there was a conflict (i.e. Drive_Letter_Preference is already in use by another
volume).
:nt.When the volume drive letter is changed using the
:link reftype=hd refid=FN_assign_drive_letter.Assign_Drive_Letter:elink.
function, the
:link reftype=fn refid=VIR_letter_preference.Drive_Letter_Preference:elink.
field reflects the requested change immediately; however, the
Current_Drive_Letter field will contain a null character (0) until all changes
are committed and the LVM engine is refreshed.
:p.This is because a drive letter conflict could potentially occur up to the
point hen the changes are committed.  The null character serves as a flag for
the application to indicate that the drive letter assignment is not yet fixed.
:ent.
:efn.
:fn id=VIR_initial_letter.
:p.The drive letter that was assigned to this volume when LVM was started. This
may be different from the
:link reftype=fn refid=VIR_letter_preference.Drive_Letter_Preference:elink. if
there were conflicts, and may be different from the
:link reftype=fn refid=VIR_current_letter.Current_Drive_Letter:elink..  This
will be null (0) if the volume did not exist when the LVM Engine was opened
(i.e. if it was created during the current LVM session).
:efn.
:fn id=VIR_new_volume.
:p.Set to FALSE if this volume existed before the LVM Engine was opened.  Set to
TRUE if this volume was created after the LVM Engine was opened (i.e. during the
current LVM session).
:efn.
:fn id=VIR_status.
:p.Indicates which of the following states is true for this volume&colon.
:xmp.
0   None
1   Bootable
2   Startable
3   Installable
:exmp.
:efn.
:fn id=VIR_volume_name.
:p.The user-assigned name for this volume.
:efn.
:fn id=VIR_fs_name.
:p.The name of the filesystem in use on this volume, if it is known.
:p.Known values include "HPFS", "JFS", "FAT16", "FAT32", "NTFS", "UDF", "CDFS",
"Linux" and "????".
:p.Note that there is an apparent error in the current OS/2 implementation
which causes partition type 0x83 (Linux native) to be reported as "????"
while type 0x82 (Linux swap) is reported as "Linux".
:efn.
:fn id=VIR_reserved.
:p.Reserved field (used for structure alignment).
:efn.


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=TYPE_word.Word
:p.Defines a two-byte (16-bit) integer value.
:p.This type is used in the declaration of disk structures.

:xmp.
#include &lt.lvm_type.h&gt.      /* or &lt.lvm_intr.h&gt. */

typedef short unsigned int Word;
:exmp.
:p.


.* ----------------------------------------------------------------------------
.* Constants
.* ----------------------------------------------------------------------------
.* :h1 x=left y=bottom width=100% height=100% id=constants.Constants
.* :p.The following sections describe various constants defined for use with LVM.


.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.Active partition indicator
.* :p.The following value indicates an active partition.
.* :xmp.
.* #define ACTIVE_PARTITION   0x80
.* :exmp.
.* :p.This value is used in the Boot_Indicator field of a
.* :link reftype=hd refid=TYPE_partition_record.Partition_Record:elink., as well as
.* in the Active_Flag field of a
.* :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink..


.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.AliasTableEntry values
.* :p.The following are used for the Name field of the
.* :link reftype=hd refid=TYPE_aliastableentry.AliasTableEntry:elink.
.* structure.  This is provided for FDISK (or another program which
.* understands the old Boot Manager Menu format) to display for
.* partitions/volumes on the Boot Manager Menu.
.* :xmp.
.* #define ALIAS_TABLE_ENTRY_MIGRATION_TEXT       "--> LVM "
.* #define ALIAS_TABLE_ENTRY_MIGRATION_TEXT2      "--> LVM*"
.* :exmp.



.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.Device_Type values
.* :p.The following define the device types used in the Device_Type field of the
.* :link reftype=hd refid=TYPE_volume_control_record.Volume_Control_Record:elink.
.* structure.
.* :xmp.
.* #define LVM_HARD_DRIVE  0
.* #define LVM_PRM         1
.* #define NON_LVM_CDROM   2
.* #define NETWORK_DRIVE   3
.* #define NON_LVM_DEVICE  4
.* :exmp.


.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.Boot Manager Definitions
.* :p.LVM includes various functions and data types for working with the IBM Boot
.* Manager.  Some additional definitions are shown below.
.*
.* :table cols='28 15 42' rules='none' frame='none'.
.* :row.
.* :row.
.* :c.BOOT_MANAGER_SIGNATURE
.* :c."APJ&amp.WN"
.* :c.The signature used in the Boot Sector for Boot Manager.
.* :etable.


.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.Partition_Status values
.* :p.The following defines are for use with the Partition_Status field in the
.* :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
.* structure.
.* :xmp.
.* #define PARTITION_IS_IN_USE      1
.* #define PARTITION_IS_AVAILABLE   2
.* #define PARTITION_IS_FREE_SPACE  0
.* :exmp.

.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100%.Partition_Type values
.* :p.The following defines are for use with the Partition_Type field in the
.* :link reftype=hd refid=TYPE_partition_information_record.Partition_Information_Record:elink.
.* structure.
.*
.* :xmp.
.* #define FREE_SPACE_PARTITION     0
.* #define LVM_PARTITION            1
.* #define COMPATIBILITY_PARTITION  2
.* :exmp.


.* ----------------------------------------------------------------------------
.* :h2 x=left y=bottom width=100% height=100% id=CONS_signatures.Signatures
.* :p.The following define the DLA Table signatures used in the DLA_Signature1 and
.* DLA_Signature2 fields of the
.* :link reftype=hd refid=TYPE_dla_table_sector.DLA_Table_Sector:elink. structure.
.* :xmp.
.* #define DLA_TABLE_SIGNATURE1  0x424D5202L
.* #define DLA_TABLE_SIGNATURE2  0x44464D50L
.* :exmp.:p.
.*
.* :p.The following are used in the LVM_Signature1 and LVM_Signature2 fields of the
.* :link reftype=hd refid=TYPE_lvm_signature_sector.LVM_Signature_Sector:elink.
.* structure.
.* :xmp.
.* #define  LVM_PRIMARY_SIGNATURE   0x4A435332L
.* #define  LVM_SECONDARY_SIGNATURE 0x4252444BL
.* :exmp.:p.
.*
.* :p.The following is the signature used for a Master Boot Record, an Extended
.* Boot Record, and a Boot Sector.  It is used in the Signature field of the
.* :link reftype=hd refid=TYPE_master_boot_record.Master_Boot_Record:elink.
.* structure.
.* :xmp.
.* #define MBR_EBR_SIGNATURE  0xAA55
.* :exmp.:p.
.*
.* :p.The following is the signature used in the Boot Sector for Boot Manager.
.* :xmp.
.* #define BOOT_MANAGER_SIGNATURE       "APJ&amp.WN"
.* :exmp.
.*

.* ----------------------------------------------------------------------------
.* Error codes
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100%.Error Codes
:p.The following error codes may be returned by the LVM Engine&colon.
:xmp.
LVM_ENGINE_NO_ERROR                            0
LVM_ENGINE_OUT_OF_MEMORY                       1
LVM_ENGINE_IO_ERROR                            2
LVM_ENGINE_BAD_HANDLE                          3
LVM_ENGINE_INTERNAL_ERROR                      4
LVM_ENGINE_ALREADY_OPEN                        5
LVM_ENGINE_NOT_OPEN                            6
LVM_ENGINE_NAME_TOO_BIG                        7
LVM_ENGINE_OPERATION_NOT_ALLOWED               8
LVM_ENGINE_DRIVE_OPEN_FAILURE                  9
LVM_ENGINE_BAD_PARTITION                      10
LVM_ENGINE_CAN_NOT_MAKE_PRIMARY_PARTITION     11
LVM_ENGINE_TOO_MANY_PRIMARY_PARTITIONS        12
LVM_ENGINE_CAN_NOT_MAKE_LOGICAL_DRIVE         13
LVM_ENGINE_REQUESTED_SIZE_TOO_BIG             14
LVM_ENGINE_1024_CYLINDER_LIMIT                15
LVM_ENGINE_PARTITION_ALIGNMENT_ERROR          16
LVM_ENGINE_REQUESTED_SIZE_TOO_SMALL           17
LVM_ENGINE_NOT_ENOUGH_FREE_SPACE              18
LVM_ENGINE_BAD_ALLOCATION_ALGORITHM           19
LVM_ENGINE_DUPLICATE_NAME                     20
LVM_ENGINE_BAD_NAME                           21
LVM_ENGINE_BAD_DRIVE_LETTER_PREFERENCE        22
LVM_ENGINE_NO_DRIVES_FOUND                    23
LVM_ENGINE_WRONG_VOLUME_TYPE                  24
LVM_ENGINE_VOLUME_TOO_SMALL                   25
LVM_ENGINE_BOOT_MANAGER_ALREADY_INSTALLED     26
LVM_ENGINE_BOOT_MANAGER_NOT_FOUND             27
LVM_ENGINE_INVALID_PARAMETER                  28
LVM_ENGINE_BAD_FEATURE_SET                    29
LVM_ENGINE_TOO_MANY_PARTITIONS_SPECIFIED      30
LVM_ENGINE_LVM_PARTITIONS_NOT_BOOTABLE        31
LVM_ENGINE_PARTITION_ALREADY_IN_USE           32
LVM_ENGINE_SELECTED_PARTITION_NOT_BOOTABLE    33
LVM_ENGINE_VOLUME_NOT_FOUND                   34
LVM_ENGINE_DRIVE_NOT_FOUND                    35
LVM_ENGINE_PARTITION_NOT_FOUND                36
LVM_ENGINE_TOO_MANY_FEATURES_ACTIVE           37
LVM_ENGINE_PARTITION_TOO_SMALL                38
LVM_ENGINE_MAX_PARTITIONS_ALREADY_IN_USE      39
LVM_ENGINE_IO_REQUEST_OUT_OF_RANGE            40
LVM_ENGINE_SPECIFIED_PARTITION_NOT_STARTABLE  41
LVM_ENGINE_SELECTED_VOLUME_NOT_STARTABLE      42
LVM_ENGINE_EXTENDFS_FAILED                    43
LVM_ENGINE_REBOOT_REQUIRED                    44
LVM_ENGINE_CAN_NOT_OPEN_LOG_FILE              45
LVM_ENGINE_CAN_NOT_WRITE_TO_LOG_FILE          46
LVM_ENGINE_REDISCOVER_FAILED                  47
:exmp.



.* ----------------------------------------------------------------------------
.* Legal Schmegal
.* ----------------------------------------------------------------------------
:h1 x=left y=bottom width=100% height=100% id=notices.Notices
:p.:hp2.Logical Volume Manager Programming Reference:ehp2.

:p.Copyright (C) 2011 Alexander Taylor
.br
Copyright (C) 2000 International Business Machines Corporation

:p.This documentation is based on the Enterprise Volume Management System
source code, initial GPL release, with additional information derived from the
IBM Device Driver Kit for OS/2.

:p.This material is licensed under the GNU General Public License, the terms of
which are summarized under :link reftype=hd refid=gpl.COPYING:elink..

:nt.&osq.Program&csq., as used in the following terms and conditions, should be
taken to refer to the entirety of the data (including both text and formatting
information, and in both compiled and source forms) comprising this
documentation.:ent.

:p.This program is free software;  you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

:p.This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY;  without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
the GNU General Public License for more details.

:p.You should have received a copy of the GNU General Public License
along with this program;  if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


.* ----------------------------------------------------------------------------
:h2 x=left y=bottom width=100% height=100% id=gpl.COPYING
.ce GNU GENERAL PUBLIC LICENSE
.ce Version 2, June 1991

:p.Copyright (C) 1989, 1991 Free Software Foundation, Inc.
.br
59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
:p.Everyone is permitted to copy and distribute verbatim copies of this license
document, but changing it is not allowed.
:p.
.ce Preamble

:p.The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Library General Public License instead.)  You can apply it to
your programs, too.

:p.When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.

:p.To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.

:p.For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.

:p.We protect your rights with two steps&colon. (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

:p.Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

:p.Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.

:p.The precise terms and conditions for copying, distribution and
modification follow.

:p.
.ce GNU GENERAL PUBLIC LICENSE
.ce TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

:dl tsize=6 break=none.
:dt.0.
:dd.This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law&colon.
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term "modification".)  Each licensee is addressed as "you".

:p.Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.

:dt.1.
:dd.You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.

:p.You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

:dt.2.
:dd.You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions&colon.
:dl tsize=3 break=none.
:dt.a)
:dd.You must cause the modified files to carry prominent notices
stating that you changed the files and the date of any change.

:dt.b)
:dd.You must cause any work that you distribute or publish, that in
whole or in part contains or is derived from the Program or any
part thereof, to be licensed as a whole at no charge to all third
parties under the terms of this License.

:dt.c)
:dd.If the modified program normally reads commands interactively
when run, you must cause it, when started running for such
interactive use in the most ordinary way, to print or display an
announcement including an appropriate copyright notice and a
notice that there is no warranty (or else, saying that you provide
a warranty) and that users may redistribute the program under
these conditions, and telling the user how to view a copy of this
License.  (Exception&colon. if the Program itself is interactive but
does not normally print such an announcement, your work based on
the Program is not required to print an announcement.)
:edl.

:p.These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

:p.Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.

:p.In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

:dt.3.
:dd.You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following&colon.
:dl tsize=3 break=none.
:dt.a)
:dd.Accompany it with the complete corresponding machine-readable
source code, which must be distributed under the terms of Sections
1 and 2 above on a medium customarily used for software interchange; or,

:dt.b)
:dd.Accompany it with a written offer, valid for at least three
years, to give any third party, for a charge no more than your
cost of physically performing source distribution, a complete
machine-readable copy of the corresponding source code, to be
distributed under the terms of Sections 1 and 2 above on a medium
customarily used for software interchange; or,

:dt.c)
:dd.Accompany it with the information you received as to the offer
to distribute corresponding source code.  (This alternative is
allowed only for noncommercial distribution and only if you
received the program in object code or executable form with such
an offer, in accord with Subsection b above.)
:edl.

:p.The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.

:p.If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

:dt.4.
:dd.You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

:dt.5.
:dd.You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

:dt.6.
:dd.Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

:dt.7.
:dd.If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.

:p.If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

:p.It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

:p.This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

:dt.8.
:dd.If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.

:dt.9.
:dd.The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

:p.Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

:dt.10.
:dd.If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.
.br
.ce NO WARRANTY

:dt.11.
:dd.BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.

:dt.12.
:dd.IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.
:edl.
:p.
.ce END OF TERMS AND CONDITIONS

:p.
.ce How to Apply These Terms to Your New Programs

:p.If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

:p.To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

:xmp.
   &lt.one line to give the program's name and a brief idea of what it does.&gt.
   Copyright (C) 19yy  &lt.name of author&gt.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
:exmp.

:p.Also add information on how to contact you by electronic and paper mail.

:p.If the program is interactive, make it output a short notice like this
when it starts in an interactive mode&colon.

:xmp.
   Gnomovision version 69, Copyright (C) 19yy name of author
   Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
   This is free software, and you are welcome to redistribute it
   under certain conditions; type 'show c' for details.
:exmp.

:p.The hypothetical commands 'show w' and 'show c' should show the appropriate
parts of the General Public License.  Of course, the commands you use may
be called something other than 'show w' and 'show c'; they could even be
mouse-clicks or menu items--whatever suits your program.

:p.You should also get your employer (if you work as a programmer) or your
school, if any, to sign a "copyright disclaimer" for the program, if
necessary.  Here is a sample; alter the names&colon.

:xmp.
   Yoyodyne, Inc., hereby disclaims all copyright interest in the program
   'Gnomovision' (which makes passes at compilers) written by James Hacker.

   &lt.signature of Ty Coon&gt., 1 April 1989
   Ty Coon, President of Vice
:exmp.

:p.This General Public License does not permit incorporating your program into
proprietary programs.  If your program is a subroutine library, you may
consider it more useful to permit linking proprietary applications with the
library.  If this is what you want to do, use the GNU Library General
Public License instead of this License.
:p.


