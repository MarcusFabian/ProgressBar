namespace Fabian.Tools;
codeunit 50900 "ProgressBar"
{
    procedure WindowOpen(WindowContent: Text; WithRemainingTime: Boolean);
    var
        Handled: Boolean;
    begin
        OnBeforeWindowOpen(WindowContent, WithRemainingTime, Handled);
        DoWindowOpen(WindowContent, WithRemainingTime, Handled);
        OnAfterWindowOpen(WindowContent, WithRemainingTime);
    end;

    local procedure DoWindowOpen(WindowContent: Text; WithRemainingTime: Boolean; Handled: Boolean);
    begin
        if Handled then
            exit;
        CLEARALL();
        IF NOT GUIALLOWED THEN
            EXIT;
        IF WithRemainingTime THEN
            Window.OPEN(WindowContent + ' #2#' + RemainingLbl)
        ELSE
            Window.OPEN(WindowContent + ' #2#');
        WindowLastUpdated := CURRENTDATETIME;
        DateTimeStart := WindowLastUpdated;
        DateTimeDifference := 0;
        DialogIsOpen := TRUE;
        AddedRemainingTime := WithRemainingTime;
    end;

    procedure WindowUpdateText(WindowIndex: Integer; UpdateText: Text);
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        IF NOT DialogIsOpen THEN
            EXIT;
        Window.UPDATE(WindowIndex, UpdateText);
        WindowProcess(2);
    end;

    procedure WindowClose();
    begin
        if dialogisopen then
            window.close();
        dialogisopen := false;
    end;

    procedure WindowSetTotal(WindowIndex: Integer; WindowTotal: Integer);
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        Total[WindowIndex] := WindowTotal;
        Counter[WindowIndex] := 0;
        IF NOT DialogIsOpen THEN
            EXIT;
        Window.UPDATE(WindowIndex, 0);
    end;

    procedure WindowProcess(WindowIndex: Integer);
    var
        iPercent: Decimal;
        DateTimeEnd: DateTime;
        PercentText: Text;
        perCentLen: Integer;
        LastChar: Text[4];
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        Counter[WindowIndex] := Counter[WindowIndex] + 1;
        IF NOT DialogIsOpen THEN
            EXIT;
        LastChar := '|/-\';

        // >> Added for remaining time
        DateTimeDifference := ROUND((CURRENTDATETIME - DateTimeStart) * (Total[WindowIndex] / Counter[WindowIndex]), 1, '<');
        DateTimeEnd := DateTimeStart + DateTimeDifference;
        DateTimeDifference := ROUNDDATETIME(DateTimeEnd, 1000) - ROUNDDATETIME(CURRENTDATETIME, 1000);  // No Milliseconds
        IF (CURRENTDATETIME - WindowLastUpdated) > 100 THEN BEGIN
            iPercent := Counter[WindowIndex] * 100 / Total[WindowIndex];
            if iPercent > 100.0 then
                iPercent := 100.0;
            perCentLen := Round(StrLen(TimeBar) * iPercent / 100, 1) + 1; // Number of Characters in TimeBar
            PercentText := CopyStr(TimeBar, 1, perCentLen) + CopyStr(EmptyTimeBar, perCentLen);
            PercentText[perCentLen] := LastChar[Counter[WindowIndex] Mod 4 + 1];
            Window.UPDATE(WindowIndex, Percenttext);
            WindowLastUpdated := CURRENTDATETIME;
            IF AddedRemainingTime THEN
                Window.UPDATE(9, DateTimeDifference);
        END;
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeWindowOpen(WindowContent: Text; WithRemainingTime: Boolean; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterWindowOpen(WindowContent: Text; WithRemainingTime: Boolean);
    begin
    end;


    var
        // dlgRemaining: TextConst ENU = '\Remaining Time: #9##########';
        TimeBar: Label '******************************';
        EmptyTimeBar: Label '______________________________';
        RemainingLbl: Label 'Remaining Time: #9##########',
          //          Comment = 'DES="Verbleibende Zeit: #9##########",DEU="Verbleibende Zeit: #9##########"';
          Comment = 'DEU="Verbleibende Zeit: #9##########",FRA="Temps restant",ITA="Tempo rimanente",ESP="Tiempo restante",DAN="Resterende tid",SWE="Återstående tid"';




        Window: Dialog;
        WindowLastUpdated: DateTime;
        Counter: Array[10] of Integer;
        Total: Array[10] of Integer;
        DialogIsOpen: Boolean;
        AddedRemainingTime: Boolean;
        DateTimeStart: DateTime;
        DatetimeDifference: Duration;

}