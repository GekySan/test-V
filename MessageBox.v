// https://learn.microsoft.com/fr-fr/windows/win32/api/winuser/nf-winuser-messagebox

fn C.MessageBoxA(hwnd voidptr, text &char, caption &char, utype u32) int
const (
	mb_abortretryignore = 0x00000002 // The message box contains three push buttons: Abort, Retry, and Ignore.
	mb_canceltrycontinue = 0x00000006 // The message box contains three push buttons: Cancel, Try Again, Continue. Use this message box type instead of MB_ABORTRETRYIGNORE.
	mb_help = 0x00004000 // Adds a Help button to the message box. When the user clicks the Help button or presses F1, the system sends a WM_HELP message to the owner.
    mb_ok = 0x00000000 // The message box contains one push button: OK. This is the default.
    mb_okcancel = 0x00000001 // The message box contains two push buttons: OK and Cancel.
    mb_retrycancel = 0x00000005 // The message box contains two push buttons: Retry and Cancel.
    mb_yesno = 0x00000004 // The message box contains two push buttons: Yes and No.
    mb_yesnocancel = 0x00000003 // The message box contains three push buttons: Yes, No, and Cancel.
)
const (
    idabort = 3 // The Abort button was selected.
    idcancel = 2 // The Cancel button was selected.
    idcontinue = 11 // The Continue button was selected.
    idignore = 5 // The Ignore button was selected.
    idno = 7 // The No button was selected.
    idok = 1 // The OK button was selected.
    idretry = 4 // The Retry button was selected.
    idtryagain = 10 // The Try Again button was selected.
    idyes = 6 // The Yes button was selected.
)

fn main() {
    result := C.MessageBoxA(0, c'Hello', c'Message Box', mb_yesno)
    if result == idyes {
        println('✔️')
    } else if result == idno {
        println('❌')
    }
}