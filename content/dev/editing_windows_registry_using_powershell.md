---
title: "Editing windows registry using PowerShell"
date: 2019-03-18T23:38:22+01:00
draft: false
tags:
  - "cfengine"
  - "configuration"
  - "powershell"
  - "windows"
---

CFEngine Enterprise supports Windows and [Windows Registry](https://docs.microsoft.com/en-us/windows/desktop/sysinfo/structure-of-the-registry) manipulation.
In CFEngine policy you can both [read from](https://docs.cfengine.com/docs/3.12/reference-functions-registryvalue.html) and [write to](https://docs.cfengine.com/docs/3.12/reference-promise-types-databases.html) the registry.
I needed a way to test these features, and I prefer ssh access over GUI, so I made this short reference.

## View

See keys (folders) at a path:

```
Get-ChildItem -Path "HKLM:\SOFTWARE\"
```

See all properties (values) in key:

```
Get-Item -Path "HKLM:\SOFTWARE\CFEngine\"
```

See specific property in key:

```
Get-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION"
```

## Create

Create a new key (folder) at a path:
```
New-Item -Path "HKLM:\SOFTWARE\" -Name "CFEngine"
```

Create new values (strings) inside key:

```
New-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION" -Value "3.12.1" -PropertyType "String"
New-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "EDITION" -Value "Enterprise" -PropertyType "String"
```

## Edit

Edit an existing a value (string):

```
Set-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION" -Value "3.12.2"
```

See the result:

```
PS C:\Users\Administrator> Get-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION"
```

## Delete

Delete a property (value):

```
Remove-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine" -Name "EDITION"
```

Delete a key and any subkeys:

```
Remove-Item -Path "HKLM:\SOFTWARE\CFEngine" -Recurse
```

## Example

Full example with output:

```
PS C:\Users\Administrator> Get-ChildItem -Path "HKLM:\SOFTWARE\"


    Hive: HKEY_LOCAL_MACHINE\SOFTWARE


Name                           Property
----                           --------
Intel
Microsoft
Notepad++                      (default) : C:\Program Files (x86)\Notepad++
ODBC
OpenSSH
SNIA
WOW6432Node
Classes
Clients
Policies
RegisteredApplications         File Explorer             :
                               SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Capabilities
                               Internet Explorer         : SOFTWARE\Microsoft\Internet Explorer\Capabilities
                               Paint                     :
                               SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Capabilities
                               Windows Address Book      : Software\Clients\Contacts\Address Book\Capabilities
                               Windows Disc Image Burner : Software\Microsoft\IsoBurn\Capabilities
                               Windows Media Player      : Software\Clients\Media\Windows Media
                               Player\Capabilities
                               Windows Photo Viewer      : Software\Microsoft\Windows Photo Viewer\Capabilities
                               Windows Search            : Software\Microsoft\Windows Search\Capabilities
                               Wordpad                   :
                               Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Capabilities



PS C:\Users\Administrator> New-Item -Path "HKLM:\SOFTWARE\" -Name "CFEngine"


    Hive: HKEY_LOCAL_MACHINE\SOFTWARE


Name                           Property
----                           --------
CFEngine


PS C:\Users\Administrator> Get-ChildItem -Path "HKLM:\SOFTWARE\"


    Hive: HKEY_LOCAL_MACHINE\SOFTWARE


Name                           Property
----                           --------
CFEngine
Intel
Microsoft
Notepad++                      (default) : C:\Program Files (x86)\Notepad++
ODBC
OpenSSH
SNIA
WOW6432Node
Classes
Clients
Policies
RegisteredApplications         File Explorer             :
                               SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Capabilities
                               Internet Explorer         : SOFTWARE\Microsoft\Internet Explorer\Capabilities
                               Paint                     :
                               SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Capabilities
                               Windows Address Book      : Software\Clients\Contacts\Address Book\Capabilities
                               Windows Disc Image Burner : Software\Microsoft\IsoBurn\Capabilities
                               Windows Media Player      : Software\Clients\Media\Windows Media
                               Player\Capabilities
                               Windows Photo Viewer      : Software\Microsoft\Windows Photo Viewer\Capabilities
                               Windows Search            : Software\Microsoft\Windows Search\Capabilities
                               Wordpad                   :
                               Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Capabilities



PS C:\Users\Administrator> New-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION" -Value "3.12.1" -PropertyType "String"



VERSION      : 3.12.1
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\CFEngine\
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE
PSChildName  : CFEngine
PSDrive      : HKLM
PSProvider   : Microsoft.PowerShell.Core\Registry



PS C:\Users\Administrator> New-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "EDITION" -Value "Enterprise" -PropertyType "String"



EDITION      : Enterprise
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\CFEngine\
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE
PSChildName  : CFEngine
PSDrive      : HKLM
PSProvider   : Microsoft.PowerShell.Core\Registry



PS C:\Users\Administrator> Get-Item -Path "HKLM:\SOFTWARE\CFEngine\"


    Hive: HKEY_LOCAL_MACHINE\SOFTWARE


Name                           Property
----                           --------
CFEngine                       VERSION : 3.12.1
                               EDITION : Enterprise


PS C:\Users\Administrator> Get-ItemProperty -Path "HKLM:\SOFTWARE\CFEngine\" -Name "VERSION"


                               VERSION      : 3.12.1
                               PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\CFEngine\
                               PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE
                               PSChildName  : CFEngine
                               PSDrive      : HKLM
                               PSProvider   : Microsoft.PowerShell.Core\Registry



PS C:\Users\Administrator>
```
