!include "LogicLib.nsh"
!include "WordFunc.nsh"

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "�������"
!define PRODUCT_Version "1.0.0.0"
!define PRODUCT_PUBLISHER "��˾����"
!define PRODUCT_Install_KEY "Software\��˾����\�������\"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_HKLM_ROOT_KEY "HKLM"
SetCompressor lzma
SetCompressorDictSize 32

;-------------��������-----------------------
!include nsDialogs.nsh
Var UninstallFileName
Var RADIO_REPAIR
Var RADIO_REMOVE
Var Checkbox_State_REPAIR
Var Checkbox_State_REMOVE
Var Checkbox_State

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI2.nsh"

;ҳ��Ԥ���峣��
;Interface Configuration
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\Logo\��װ����.ico";��װͼ��
!define MUI_UNICON "..\..\Logo\��װ����.ico" ;ж��ͼ��
!define MUI_PAGE_HERDER_TEXT "��ӭʹ��xxxxxx���" ;��ʾ��ͷ����Ϣ������ҳ�����ã�
!define MUI_PAGE_HERDER_STEXT "�������ӱ���" ;�ӱ���
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\..\Logo\����ļ�.bmp"
!define MUI_HEADERIMAGE;����ͷ��ͼƬ
!define MUI_HEADERIMAGE_RIGHT;��������ͼƬ���ұ���ʾ
!define MUI_HEADERIMAGE_BITMAP "..\..\Logo\�����ļ�.bmp";ͼƬ·��

;-------------ҳ�涨��---------------------------
; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; �޸�ҳ��
Page custom nsDialogsRepair nsDialogsRepairLeave
; ���Э��ҳ��
; !define MUI_LICENSEPAGE_RADIOBUTTONS
; !define MUI_LICENSEPAGE_TEXT_TOP "������Ȩҳ����"
; !define MUI_LICENSEPAGE_TEXT_BOTTOM "������Ȩҳ�ײ�"
; !insertmacro MUI_PAGE_LICENSE "SoftwareLicence.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION createZhuoMian
!define MUI_FINISHPAGE_SHOWREADME_TEXT "���������ݷ�ʽ"
; !define MUI_FINISHPAGE_SHOWREADME
; !define MUI_FINISHPAGE_SHOWREADME_FUNCTION createKaiShiCaiDan
; !define MUI_FINISHPAGE_SHOWREADME_TEXT "������ʼ�˵�"
; !define MUI_FINISHPAGE_SHOWREADME
; !define MUI_FINISHPAGE_SHOWREADME_FUNCTION readme
; !define MUI_FINISHPAGE_SHOWREADME_TEXT "�鿴ʹ��˵��"
!define MUI_FINISHPAGE_RUN "notepad.exe"
!define MUI_FINISHPAGE_RUN_TEXT "���г���"
!insertmacro MUI_PAGE_FINISH
; ж���򵼻�ӭ����
;!insertmacro MUI_UNPAGE_WELCOME
; ��װж��·��ҳ��
!insertmacro MUI_UNPAGE_CONFIRM
; ж���������Ϣ
;!insertmacro MUI_UNPAGE_COMPONENTS
; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES
; ��װж�����ҳ��
!insertmacro MUI_UNPAGE_FINISH
; ��װԤ�ͷ��ļ�
;!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"
; ------ MUI �ִ����涨����� ------

;����
Name "${PRODUCT_NAME}${PRODUCT_Version}"
;���ɵ��ļ�����
OutFile "${PRODUCT_NAME}${PRODUCT_Version}.exe"
;����Ĭ�ϰ�װ·��
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
;�����ǰ�İ�װ·��
InstallDirRegKey ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}" "InstallPath"
;��ʾ��װ��ϸ��Ϣ
ShowInstDetails show
;��ʾж����ϸ��Ϣ
ShowUninstDetails show
;����Э��ҳ���½ǻ�ɫ��Ϣ��
BrandingText ${PRODUCT_PUBLISHER}

Section "�ж�ϵͳ�汾"
	System::Call "Kernel32::GetVersion(v) i .s"
	Pop $0
	IntOp $1 $0 & 0xFF
	DetailPrint "Windows ���汾: $1"
	IntOp $1 $0 & 0xFFFF
	IntOp $1 $1 >> 8
	DetailPrint "Windows �ΰ汾: $1"
	IntCmpU $0 0x80000000 0 nt
	DetailPrint "Windows 95/98/Me"
	nt:
	DetailPrint "Windows NT/2000/XP"
SectionEnd

Section "�ж�NET Framework 3.5"
ReadRegDWORD $0 HKLM 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5' Install
${If} $0 == ''
NSISdl::download /TRANSLATE2 '�������� %s' '��������...' '(ʣ�� 1 ��)' '(ʣ�� 1 ����)' '(ʣ�� 1 Сʱ)' '(ʣ�� %u ��)' '(ʣ�� %u ����)' '(ʣ�� %u Сʱ)' '����ɣ�%skB(%d%%) ��С��%skB �ٶȣ�%u.%01ukB/s' /TIMEOUT=7500 /NOIEPROXY 'http://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe' '$EXEDIR\dotnetfx35.exe'
Pop $R0
StrCmp $R0 "success" 0 +3
MessageBox MB_YESNO|MB_ICONQUESTION ".net framework 3.5 �ѳɹ���������$\r$\n$\t$EXEDIR\dotnetfx35.exe$\r$\n�Ƿ�����ִ�а�װ����" IDNO +2
ExecWait '$EXEDIR\dotnetfx35.exe'
${Else}
DetailPrint "..NET Framework 3.5 already installed !!"
${EndIf}
SectionEnd

Section "�ļ�����" SecA
	SetOutPath "$INSTDIR\";����������Ŀ¼
	SetOverwrite on ;��������ļ������ǵ�
	File /r "..\�ļ���\"; ������Ŀ¼���Ʋ�ѹ���ļ�
	File "�ļ�.exe"
SectionEnd

Section "-Post";"-"��ͷ����������
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}" "InstallPath" "$INSTDIR"
	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Version" "${PRODUCT_Version}"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_DIR_REGKEY}" "Path" "$INSTDIR\${PRODUCT_NAME}.exe"
SectionEnd

Section "Uninstall"
	;ɾ����װĿ¼�е������ļ�
	RMDir /r $INSTDIR
	
	;ɾ����ݷ�ʽ
	Delete "$DESKTOP\�����ݷ�ʽ.lnk"
	Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\��ʼ�˵���ݷ�ʽ.lnk"
	Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\"

	
	;ж�ذ�װĿ¼��ע���
	DeleteRegKey ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}"
	DeleteRegKey ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_DIR_REGKEY}"

	;ˢ��ҳ��
	System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v (0x08000000, 0, 0, 0)'
	SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
 
;��װ�������ǰ���г�ʼ��
Function .onInit
	;��װ����ʼʱ��ı���ͼƬ����,���Ŀ¼�ڰ�װ�����Ƴ����Զ�ɾ��
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "..\..\Logo\����ͼƬ.bmp"
	splash::show 2000 $PLUGINSDIR\splash
	
	;��ȡж�س���·��
	ReadRegStr $UninstallFileName ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
	
	;��ȡ��ǰ�İ�װ·���������ǰû��װ��������Ĭ��ֵ
	;ReadRegStr $INSTDIR ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}" "InstallPath"
	;${if} $INSTDIR == ""
	;StrCpy $INSTDIR "$PROGRAMFILES\${PRODUCT_NAME}\"
	;${EndIf}
	
	;�ж�ϵͳ�汾
	; ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
	; strcmp $0 "" 98 nt
	; 98:
	; messagebox  MB_ICONINFORMATION|MB_OK "��ʹ�õĲ���ϵͳ�汾���ͣ��޷���װ�������˳���"
	; quit
	; nt:
FunctionEnd

Function .onInstSuccess
	; HideWindow
	; MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ���װ�����ļ������"
	; ;�Զ�ɾ����װ����
	; System::Call 'kernel32::GetModuleFileNameA(i 0, t .s, i ${NSIS_MAX_STRLEN}) i'
	; Pop $0
	; Delete /REBOOTOK $0
FunctionEnd

Function un.onInit
	; MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
	; Abort
FunctionEnd

Function un.onUninstScess
HideWindow
MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd

Function readme
ExecShell "open" "http://www.baidu.com"
Functionend

Function createKaiShiCaiDan
	CreateDirectory "$SMPROGRAMS\${PRODUCT_PUBLISHER}";��ʼ�˵�
	CreateShortCut "$SMPROGRAMS\${PRODUCT_PUBLISHER}\��ʼ�˵���ݷ�ʽ.lnk" "notepad.exe";��ʼ�˵���ݷ�ʽ
FunctionEnd

Function createZhuoMian
	CreateShortCut "$DESKTOP\�����ݷ�ʽ.lnk" "notepad.exe";�����ݷ�ʽ
FunctionEnd

Function nsDialogsRepairLeave
  ${NSD_GetState} $RADIO_REPAIR $Checkbox_State_REPAIR
  ${NSD_GetState} $RADIO_REMOVE $Checkbox_State_REMOVE
  ${If} $Checkbox_State_REMOVE == ${BST_CHECKED}
    Exec $UninstallFileName
    Quit
  ${EndIf}
FunctionEnd

Function nsDialogsRepair
	${if} $UninstallFileName == ""
	Abort
	${EndIf}
	
	!insertmacro MUI_HEADER_TEXT "�Ѿ���װ" "ѡ����Ҫִ�еĲ���"
	nsDialogs::Create /NOUNLOAD 1018
	${NSD_CreateLabel} 10u 0u 300u 30u "����Ѿ���װ����ѡ����Ҫִ�еĲ��������������һ��(N)������"

	${NSD_CreateRadioButton}  40u 30u 100u 30u "�޸������°�װ"
	Pop $RADIO_REPAIR
	${If} $Checkbox_State_REPAIR == ${BST_CHECKED}
	${NSD_Check} $RADIO_REPAIR
	${NSD_GetState} $RADIO_REPAIR $Checkbox_State
	${EndIf}

	${NSD_CreateRadioButton}  40u 60u 100u 30u "ж��"
	Pop $RADIO_REMOVE
	;${NSD_SetState} $RADIO_REMOVE 1;Ĭ��ѡ��
	${If} $Checkbox_State_REMOVE == ${BST_CHECKED}
	${NSD_Check} $RADIO_REMOVE
	${NSD_GetState} $RADIO_REMOVE $Checkbox_State
	${EndIf}

	${If} $Checkbox_State <> ${BST_CHECKED}
	${NSD_Check} $RADIO_REPAIR
	${EndIf}
	nsDialogs::Show
FunctionEnd