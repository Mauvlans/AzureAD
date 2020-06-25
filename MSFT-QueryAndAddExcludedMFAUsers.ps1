# ***************************************************************************
#
# Purpose: Collects all Non MFA Enabled Users and Added them to group specified
# This collects the users Enabled in the Legacy MultiFactor Authentication 
# Page in Azure Active Directory.
#
# ------------- DISCLAIMER -------------------------------------------------
# This script code is provided as is with no guarantee or waranty concerning
# the usability or impact on systems and may be used, distributed, and
# modified in any way provided the parties agree and acknowledge the 
# Microsoft or Microsoft Partners have neither accountabilty or 
# responsibility for results produced by use of this script.
#
# Microsoft will not provide any support through any means.
# ------------- DISCLAIMER -------------------------------------------------
#
# ***************************************************************************

Connect-MsolService 
$groupname = "MVN_MFA_Exclude"
$logpath = "C:\Temp\MFA_Exempt_Log.txt"

#Getting AAD Group Information
$group = Get-MsolGroup -searchstring $groupname

#Collecting users with MFA enabled - Checking for group membership if not member adding.
Get-MsolUser -All | Where-Object {$_.StrongAuthenticationMethods.Count -eq 0 } -pv user | Where-Object {!(Get-MsolGroupMember -GroupObjectId $group.objectid | Where-Object {$_.objectid -eq $user.objectid})} | ForEach-Object{

Add-MsolGroupMember -GroupObjectId $group.objectid -GroupMemberObjectId $user.objectid -GroupMemberType User 

#Writing Actions to Log File
"$(Get-Date) Added User $(($user).userPrincipalName) to $groupname" | Add-Content -path $logpath
}