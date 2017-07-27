{**************************}
{ FastScript v1.0          }
{ Nested procedure demo    }
{**************************}

procedure OK(i: Integer);

  procedure DoShow;
  begin
    ShowMessage(i);
  end;

begin
  DoShow;
  i := 11;
  DoShow;
end;

begin
  OK(1);
end.
    