# ProgressBar
Display Windows Progress bar. Optionally with remaining time:
Idea "stolen" from the following two sources:
"Gunnar's Blog": https://dynamics.is/?p=626
"Vjeko.com": http://vjeko.com/estimated-time-left/


## Usage Example:
See ProgressBarTest.Page.al


Var 
  dlg: Codeunit: ProgressBar;

### Before Loop:
dlg.WindowOpen('processing #1####',TRUE);   // TRUE = with remaining time
dlg.WindowSetTotal(2,myFilteredTable.COUNT);

### In Loop:
dlg.WindowUpdateText(1,myFilteredTable.CODE);

### After Loop:
dlg.WindowClose;

## The Percentage (Progress) Bar
To make a long story short, the Percentage Bar doesn't exist anymore in the same way we are accustomed in the older Navision-Versions.
Therefore it is simulated and looks something like this:
 51% would be like:  ********/________
 87% like            *************\___
  
