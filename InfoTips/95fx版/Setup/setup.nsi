!include "LogicLib.nsh"
!include "WordFunc.nsh"

; ��װ�����ʼ���峣��
!define PRODUCT_PATH ""
!define PRODUCT_NAME "�ƽ���㱦"
!define PRODUCT_VERSION "v2.0"
!define PRODUCT_PUBLISHER ""
!define PRODUCT_Install_KEY "Software\�ƽ���㱦\"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_HKLM_ROOT_KEY "HKLM"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION fucRunEXE
SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI2.nsh"

; MUI Ԥ���峣��
;--------------------------------
!define MUI_ABORTWARNING
!define MUI_ICON "logo.ico"
!define MUI_UNICON "logo.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "����ļ�.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "�����ļ�.bmp"

;-------------�޸�ҳ���������-----------------------
!include nsDialogs.nsh
Var UninstallFileName
Var RADIO_REPAIR
Var RADIO_REMOVE
Var Checkbox_State_REPAIR
Var Checkbox_State_REMOVE
Var Checkbox_State

;-------------ҳ�涨��---------------------------
; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; �޸�ҳ��
Page custom nsDialogsRepair nsDialogsRepairLeave
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH
; ��װж��ȷ��ҳ��
!insertmacro MUI_UNPAGE_CONFIRM
; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES
; ��װж�����ҳ��
!insertmacro MUI_UNPAGE_FINISH
; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ------ MUI �ִ����涨����� ------
;����
Name "${PRODUCT_NAME}"
;���ɵ��ļ�����
OutFile "..\${PRODUCT_NAME}${PRODUCT_VERSION}.exe"
;���ɵİ�װ·��
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel user

BrandingText ${PRODUCT_PUBLISHER}��������������Ǹ�רҵ"

Section "NET Framework 2.0.50727"
ReadRegDWORD $0 HKLM 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727' Install
${If} $0 == ''
NSISdl::download /TRANSLATE2 '�������� %s' '��������...' '(ʣ�� 1 ��)' '(ʣ�� 1 ����)' '(ʣ�� 1 Сʱ)' '(ʣ�� %u ��)' '(ʣ�� %u ����)' '(ʣ�� %u Сʱ)' '����ɣ�%skB(%d%%) ��С��%skB �ٶȣ�%u.%01ukB/s' /TIMEOUT=7500 /NOIEPROXY 'http://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe' '$EXEDIR\NetFx20SP2_x86.exe'
Pop $R0
StrCmp $R0 "success" 0 +3
MessageBox MB_YESNO|MB_ICONQUESTION ".net framework 2.0 �ѳɹ���������$\r$\n$\t$EXEDIR\NetFx20SP2_x86.exe$\r$\n�Ƿ�����ִ�а�װ����" IDNO +2
ExecWait '$EXEDIR\NetFx20SP2_x86.exe'
${Else}
DetailPrint "..NET Framework 2.0 already installed !!"
${EndIf}
SectionEnd

Section "���ƽ�" SecA
	; ����������Ŀ¼
	SetOutPath "$INSTDIR\"
	; ��������ļ������ǵ�
	SetOverwrite on
		File /r "..\Output\"
SectionEnd

Section -Post
	CreateShortCut "$DESKTOP\�ƽ���㱦.lnk" "$INSTDIR\InfoTips.exe"	
	CreateShortCut "$SMPROGRAMS\�ƽ���㱦\�ƽ���㱦.lnk" "$INSTDIR\InfoTips.exe"
	CreateShortCut "$SMPROGRAMS\�ƽ���㱦\ж�ػƽ���㱦.lnk" "$INSTDIR\uninst.exe"
	
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}" "InstallPath" "$INSTDIR"

	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
	WriteRegStr ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
SectionEnd

; ҳ�����֮ǰ���г�ʼ��
Function .onInit
	ReadRegStr $UninstallFileName ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
	ReadRegStr $INSTDIR ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_Install_KEY}" "InstallPath"

	${if} $INSTDIR == ""
		StrCpy $INSTDIR "$PROGRAMFILES\�ƽ���㱦\"
	${EndIf}
FunctionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
	; ɾ���ļ�
	RMDir /r $INSTDIR
	;ɾ����ݷ�ʽ
	Delete "$DESKTOP\�ƽ���㱦.lnk"
	Delete "$SMPROGRAMS\�ƽ���㱦\�ƽ���㱦.lnk"
	Delete "$SMPROGRAMS\�ƽ���㱦\ж�ػƽ���㱦.lnk"
	Delete "$SMPROGRAMS\�ƽ���㱦\"
	
	;ж�ذ�װĿ¼��ע���
	DeleteRegKey ${PRODUCT_HKLM_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

	;ˢ��ҳ��
	System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v (0x08000000, 0, 0, 0)'
	SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
/******************************
 *  �����ǰ�װ������޸�����  *
 ******************************/

Function nsDialogsRepairLeave
	${NSD_GetState} $RADIO_REPAIR $Checkbox_State_REPAIR
	${NSD_GetState} $RADIO_REMOVE $Checkbox_State_REMOVE
	${If} $Checkbox_State_REMOVE == ${BST_CHECKED}
		Exec $UninstallFileName
		Quit
	${EndIf}
FunctionEnd

Function fucRunEXE
	Exec "$INSTDIR\InfoTips.exe"
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
	;${NSD_SetState} $RADIO_REMOVE 1
	${If} $Checkbox_State_REMOVE == ${BST_CHECKED}
		${NSD_Check} $RADIO_REMOVE
		${NSD_GetState} $RADIO_REMOVE $Checkbox_State
	${EndIf}

	${If} $Checkbox_State <> ${BST_CHECKED}
		${NSD_Check} $RADIO_REPAIR
	${EndIf}
	nsDialogs::Show
FunctionEnd