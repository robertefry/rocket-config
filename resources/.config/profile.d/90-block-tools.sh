
# List information about block devices
lsblk()
{
    if echo "$*" | grep -Eq "(\s|^)-"; # only change the default columns
    then
        "$(which lsblk)" "$@"
    else
        "$(which lsblk)" "$@" -o NAME,RM,RO,LABEL,UUID,FSTYPE,FSSIZE,FSUSE%
    fi
}

# List information about mounted block devices
lsmnt()
{
    lsblk "$@" -o NAME,LABEL,FSSIZE,FSUSE%,FSUSED,FSAVAIL,FSROOTS,MOUNTPOINTS
}
