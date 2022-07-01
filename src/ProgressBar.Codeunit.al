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
            Window.OPEN(WindowContent + RemainingLbl)
        ELSE
            Window.OPEN(WindowContent);
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
        iPercent: Integer;
        DateTimeEnd: DateTime;
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        Counter[WindowIndex] := Counter[WindowIndex] + 1;
        IF NOT DialogIsOpen THEN
            EXIT;

        // >> Added for remaining time
        iPercent := ROUND(Counter[WindowIndex] / Total[WindowIndex] * 10000, 1, '<');
        DateTimeDifference := ROUND((CURRENTDATETIME - DateTimeStart) * (Total[WindowIndex] / Counter[WindowIndex]), 1, '<');
        DateTimeEnd := DateTimeStart + DateTimeDifference;
        DateTimeDifference := ROUNDDATETIME(DateTimeEnd, 1000) - ROUNDDATETIME(CURRENTDATETIME, 1000);  // No Milliseconds
        IF (CURRENTDATETIME - WindowLastUpdated) > 100 THEN BEGIN
            Window.UPDATE(WindowIndex, iPercent);
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
        RemainingLbl: Label '\Remaining Time: #9##########', Comment = '#1 = Remaining Time in hours minutes seconds';


        Window: Dialog;
        WindowLastUpdated: DateTime;
        Counter: Array[10] of Integer;
        Total: Array[10] of Integer;
        DialogIsOpen: Boolean;
        AddedRemainingTime: Boolean;
        DateTimeStart: DateTime;
        DatetimeDifference: Duration;

}