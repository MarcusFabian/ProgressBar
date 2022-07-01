# ProgressBar
Display Windows Progress bar. Optionally with remaining time:
Idea "stolen" from the following two sources:
"Gunnar's Blog": https://dynamics.is/?p=626
"Vjeko.com": http://vjeko.com/estimated-time-left/


## Usage Example:
Var dlg: Codeunit: Progressbar;

### Before Loop:
dlg.WindowOpen('processing #1####\@2@@@@@@@@',TRUE);   // TRUE = with remaining time
dlg.WindowSetTotal(2,myFilteredTable.COUNT);

### In Loop:
dlg.WindowProcess(2);
dlg.WindowUpdateText(1,myFilteredTable.CODE);

### After Loop:
dlg.WindowClose;
