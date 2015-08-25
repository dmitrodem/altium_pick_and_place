!define APPNAME "pnptool"
!define COMPANYNAME "MIPT"
!define DESCRIPTION "Pick and Place file generator for Altium Designer"
!define VERSIONMAJOR 0
!define VERSIONMINOR 1
!define VERSIONBUILD 0
!define HELPURL "http://..."
!define UPDATEURL "http://..."
!define ABOUTURL "http://..."
!define INSTALLSIZE 10452

RequestExecutionLevel admin

InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"
Name "${COMPANYNAME} - ${APPNAME}"
OutFile Installer.exe

!include "LogicLib.nsh"

Page directory
Page instfiles

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin"
    messageBox mb_iconstop "Administrator rights required!"
    setErrorLevel 740
    quit
${EndIf}
!macroend

function .onInit
    setShellVarContext all
    !insertmacro VerifyUserIsAdmin
functionEnd


Section "install"
    SetOutPath $INSTDIR
    File dist\API-MS-Win-Core-ErrorHandling-L1-1-0.dll
    File dist\API-MS-Win-Core-LibraryLoader-L1-1-0.dll
    File dist\API-MS-Win-Core-LocalRegistry-L1-1-0.dll
    File dist\API-MS-Win-Core-Misc-L1-1-0.dll
    File dist\API-MS-Win-Core-ProcessThreads-L1-1-0.dll
    File dist\API-MS-Win-Core-Profile-L1-1-0.dll
    File dist\API-MS-Win-Core-String-L1-1-0.dll
    File dist\API-MS-Win-Core-SysInfo-L1-1-0.dll
    File dist\API-MS-Win-Security-Base-L1-1-0.dll
    File dist\bz2.pyd
    File dist\CRYPT32.dll
    File dist\KERNELBASE.dll
    File dist\library.zip
    File dist\MSASN1.dll
    File dist\pnptool.exe
    File dist\python27.dll
    File dist\select.pyd
    File dist\unicodedata.pyd
    File dist\_hashlib.pyd
    File dist\_socket.pyd
    File dist\_ssl.pyd
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${COMPANYNAME} - ${APPNAME} - ${DESCRIPTION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

function un.onInit
    SetShellVarContext all
    MessageBox MB_OKCANCEL "Permanetely remove ${APPNAME}?" IDOK next
        Abort
    next:
    !insertmacro VerifyUserIsAdmin
functionEnd

Section Uninstall
    Delete "$INSTDIR\Uninstall.exe"
    Delete "$INSTDIR\API-MS-Win-Core-ErrorHandling-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-LibraryLoader-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-LocalRegistry-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-Misc-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-ProcessThreads-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-Profile-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-String-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Core-SysInfo-L1-1-0.dll"
    Delete "$INSTDIR\API-MS-Win-Security-Base-L1-1-0.dll"
    Delete "$INSTDIR\bz2.pyd"
    Delete "$INSTDIR\CRYPT32.dll"
    Delete "$INSTDIR\KERNELBASE.dll"
    Delete "$INSTDIR\library.zip"
    Delete "$INSTDIR\MSASN1.dll"
    Delete "$INSTDIR\pnptool.exe"
    Delete "$INSTDIR\python27.dll"
    Delete "$INSTDIR\select.pyd"
    Delete "$INSTDIR\unicodedata.pyd"
    Delete "$INSTDIR\_hashlib.pyd"
    Delete "$INSTDIR\_socket.pyd"
    Delete "$INSTDIR\_ssl.pyd"
    RMDir "$INSTDIR"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" 
SectionEnd
