# 安装程序初始定义常量
!define PRODUCT_NAME "windows-agent"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "HYKJ"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\AppMainExe.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

#现代界面定义
!include "MUI.nsh"
!include "nsProcess.nsh"


# MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "dist\windows-agent.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "dist\windows.bmp" #欢迎页面左侧的图片
#!define MUI_HEADERIMAGE #欢迎页面的下一步的头上的图片
#!define MUI_HEADERIMAGE_BITMAP "D:\hold-windows\windows.bmp"
!define MUI_WELCOMEPAGE_TITLE "\r\n 欢迎使用hold服务安装程序 \r\n" #welcome_page_title
!define MUI_WELCOMEPAGE_TEXT "  \r\n 项目简介:Hold是一个由云南恒翌科技有限公司开发    的开源项目,超轻量级的主机观察者和和守护者!帮助   您时刻轻松掌控自己的爱机. \r\n\r\n 软件作者:云南恒翌科技有限公司 \r\n\r\n 公司地址:云南省昆明市盘龙区北京路北辰财富中心    CD商务公寓1603 \r\n\r\n\r\n 联系我们:hold@highwe.com \r\n\r\n\r\n $_CLICK "  #welcome_page_text

# 欢迎页面
!insertmacro MUI_PAGE_WELCOME
# 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
# 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
# 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\windows-start.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
#现代界面定义结束

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "windows-agent.exe"
InstallDir "$PROGRAMFILES\agent" #即C盘下面的程序安装目录program files
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "hold服务安装程序"

Section "MainSection" SEC01
  call check
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer #到这步复制操作已经完成。
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
 *  以下是安装程序的卸载部分  *
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

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function check
  appcheck:
    ${nsProcess::FindProcess} "hold-agent.exe" $R0
    ${If} $R0 == 0
        MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "当前进程hold-agent.exe仍在运行，请停止该程序并重试安装!" /SD IDCANCEL IDRETRY appcheck
        Quit
      ${EndIf}
    ${nsProcess::Unload}
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
