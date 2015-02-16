# ��װ�����ʼ���峣��
!define PRODUCT_NAME "windows-agent"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "HYKJ"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\AppMainExe.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

#�ִ����涨��
!include "MUI.nsh"
!include "nsProcess.nsh"


# MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "dist\windows-agent.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "dist\windows.bmp" #��ӭҳ������ͼƬ
#!define MUI_HEADERIMAGE #��ӭҳ�����һ����ͷ�ϵ�ͼƬ
#!define MUI_HEADERIMAGE_BITMAP "D:\hold-windows\windows.bmp"
!define MUI_WELCOMEPAGE_TITLE "\r\n ��ӭʹ��hold����װ���� \r\n" #welcome_page_title
!define MUI_WELCOMEPAGE_TEXT "  \r\n ��Ŀ���:Hold��һ�������Ϻ���Ƽ����޹�˾����    �Ŀ�Դ��Ŀ,���������������۲��ߺͺ��ػ���!����   ��ʱ�������ƿ��Լ��İ���. \r\n\r\n �������:���Ϻ���Ƽ����޹�˾ \r\n\r\n ��˾��ַ:����ʡ����������������·�����Ƹ�����    CD����Ԣ1603 \r\n\r\n\r\n ��ϵ����:hold@highwe.com \r\n\r\n\r\n $_CLICK "  #welcome_page_text

# ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
# ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
# ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
# ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\windows-start.exe"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
#�ִ����涨�����

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "windows-agent.exe"
InstallDir "$PROGRAMFILES\agent" #��C������ĳ���װĿ¼program files
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "hold����װ����"

Section "MainSection" SEC01
  call check
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer #���ⲽ���Ʋ����Ѿ���ɡ�
  CreateDirectory "$SMPROGRAMS\agent"
  CreateShortCut "$SMPROGRAMS\agent\agent.lnk" "$INSTDIR\AppMainExe.exe"
  File /r "dist\*.*"
  ExecWait '"$INSTDIR\input.exe"'
  setAutoClose true
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\agent\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\AppMainExe.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\AppMainExe.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
  setOutPath "$INSTDIR"
  ExecWait '"$INSTDIR\windows-stop.exe"'
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\AppMainExe.exe"
  #Delete "$INSTDIR\_ctypes.pyd"
  #Delete "$INSTDIR\_psutil_windows.pyd"
  #Delete "$INSTDIR\_socket.pyd"
  #Delete "$INSTDIR\_ssl.pyd"
  #Delete "$INSTDIR\*.pyd"
  Delete "$INSTDIR\*.*"

  Delete "$SMPROGRAMS\agent\Uninstall.lnk"
  Delete "$SMPROGRAMS\agent\agent.lnk"

  RMDir "$SMPROGRAMS\agent"

  RMDir /r "$INSTDIR\tcl"
  RMDir /r "$INSTDIR\Microsoft.VC90.MFC"
  RMDir /r "$INSTDIR\Microsoft.VC90.CRT"

  setOutPath "$PROGRAMFILES"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function check
  appcheck:
    ${nsProcess::FindProcess} "hold-agent.exe" $R0
    ${If} $R0 == 0
        MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "��ǰ����hold-agent.exe�������У���ֹͣ�ó������԰�װ!" /SD IDCANCEL IDRETRY appcheck
        Quit
      ${EndIf}
    ${nsProcess::Unload}
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
