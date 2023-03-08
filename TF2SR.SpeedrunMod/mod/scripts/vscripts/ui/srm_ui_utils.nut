global function SRM_ConfirmDialog

void function SRM_ConfirmDialog( string header, string message, string confirmMessage )
{
	DialogData dialog
	dialog.header = header
	dialog.message = message
    AddDialogButton( dialog, confirmMessage )
    OpenDialog( dialog )
}