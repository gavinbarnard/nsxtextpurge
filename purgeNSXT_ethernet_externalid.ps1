# gavinbarnard@vmware.com Feb 28 2019
#
# This is provided as a sample on how to blank the externalid for NSXT connected VMs
#
# Please validate it works to your needs in a test environment before using in any production situation
#
#
#This is free and unencumbered software released into the public domain.
#
#Anyone is free to copy, modify, publish, use, compile, sell, or
#distribute this software, either in source code form or as a compiled
#binary, for any purpose, commercial or non-commercial, and by any
#means.
#
#In jurisdictions that recognize copyright laws, the author or authors
#of this software dedicate any and all copyright interest in the
#software to the public domain. We make this dedication for the benefit
#of the public at large and to the detriment of our heirs and
#successors. We intend this dedication to be an overt act of
#relinquishment in perpetuity of all present and future rights to this
#software under copyright law.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
#OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.
#
#For more information, please refer to <http://unlicense.org>

Param(
$vmname
)

$vm = Get-VM $vmname

if ($vm.PowerState -eq "PoweredOff") 
{

	$vdevConfigSpec = New-Object VMware.Vim.VirtualDeviceConfigSpec
	$vdevConfigSpec.Operation = [VMware.Vim.VirtualDeviceConfigSpecOperation]::edit

	$net = $vm | Get-NetworkAdapter

	$extData = $net.ExtensionData
	$extData.ExternalId = ""

	$vdevConfigSpec.Device = $extData

	$cspec = New-Object VMware.Vim.VirtualMachineConfigSpec

	$cspec.DeviceChange = @($vdevConfigSpec)

	$vm.ExtensionData.ReconfigVM($cspec)

	Write-Output "If there are no errors above this text $vm's network adapter has had the externalid blanked"
	Write-Output "You will need to Edit the VM, and change it to a different Logical Switch save settings"
	Write-Output "and then reconnect it to the original logical switch"
}
else
{
	Write-Output "$vm VM is not powered off"
}
