page 50900 ProgressBar_Test
{
    Caption = 'ProgressBar_Test';
    PageType = Card;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(MaxLoops; MaxLoops)
                {
                    ApplicationArea = All;
                    Caption = 'Max Loops';
                    ToolTip = '100 ist a good number to have a loop lasting 50 Seconds! (There is a delay of 500ms per loop)';

                    trigger OnValidate()
                    var
                        dlg: Codeunit ProgressBar;
                        i: Integer;
                    begin
                        Rec.SetRange(Number, 1, MaxLoops);
                        dlg.WindowOpen('processing #1####', TRUE);   // TRUE = with remaining time
                        dlg.WindowSetTotal(2, MaxLoops);

                        for i := 1 to MaxLoops do begin
                            dlg.WindowUpdateText(1, format(i));
                            sleep(500);
                        end;

                        dlg.WindowClose();

                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        MaxLoops := 1;
    end;

    var
        MaxLoops: Integer;
}
