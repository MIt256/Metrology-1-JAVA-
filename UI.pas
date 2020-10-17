unit UI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, uLexer, uDictionary, Math, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    mainmenu: TMainMenu;
    N1: TMenuItem;
    Open: TMenuItem;
    SG1: TStringGrid;
    dlgOpen1: TOpenDialog;
    L1: TLabel;
    l2: TLabel;
    img1: TImage;
    LP: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure ShowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lexems: TLexems;
  operands, operators: TLexems;
  operands_info: TLexemsInf;
  operators_info: TLexemsInf;
  programDictionary, programLength, programVolume: Integer;
 // programVolume: real;

implementation

{$R *.dfm}
//the initial labels (colomns)
procedure TForm1.FormCreate(Sender: TObject);
begin
  SG1.Visible := False;
SG1.Cells[0,0]:= '                         J';
SG1.Cells[1,0]:= '                  Оператор';
SG1.Cells[2,0]:= '                     F(1j)';
SG1.Cells[3,0]:= '                         I';
SG1.Cells[4,0]:= '                   Операнд';
SG1.Cells[5,0]:= '                     F(2j)';


end;
//metrics show (by click)
//Она не нужна, была идея выводить так, но зачем?

procedure TForm1.ShowClick(Sender: TObject);
begin
    ShowMessage('Объем программы: '+inttostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary));
end;
//adding in main menu button with advanced metrics
procedure AddMainItem(s: string);
var
  newitem: Tmenuitem;
begin
  newitem := tmenuitem.create(Form1.mainmenu);
  newitem.caption := s;
  newitem.onclick:= Form1.ShowClick;
  Form1.mainmenu.items.insert(Form1.mainmenu.items.count, newitem);
end;
//generation 1 line in table
procedure generateTable(filename : string);
var  filekek : TextFile;
    tempOperandsCount, tempOperatorsCount,i,mem,kek,k: Integer;

begin
  Form1.SG1.Visible := true;

  lexems := lexems_from_file(filename);
  lex_alloc(operands, operators, lexems);
  operands_info := get_lexem_info(operands);
  operators_info := get_lexem_info(operators);

    programDictionary := length(operands_info)  + Length(operators_info);
  tempOperandsCount := 0;
  tempOperatorsCount := 0;
  for i:= 0 to Length(operands_info)-1 do
      inc(tempOperandsCount, operands_info[i].count);
  for i:= 0 to Length(operators_info)-1 do
      inc(tempOperatorsCount, operators_info[i].count);
  programLength := tempOperandsCount + tempOperatorsCount;
  if programDictionary <> 0 then
  programVolume := Round(programLength * log2(programDictionary));

  if programLength <> 0 then
  begin
  //здесь начинаются костыли (Нужны для вывода составных операторов)
   for i:=0 to Length(operators_info)-1 do  //else to if else
     if (operators_info[i].name = 'else') then
      begin
        operators_info[i].name:= 'if else';
        for k:=0 to Length(operators_info)-1 do
        begin
          if (operators_info[k].name = 'if') then
          operators_info[k].count:= operators_info[k].count - operators_info[i].count;
        end;
      end;
       for i:=0 to Length(operators_info)-1 do  //do to do while
     if (operators_info[i].name = 'do') then
      begin
        operators_info[i].name:= 'do while';
        for k:=0 to Length(operators_info)-1 do
        begin
          if (operators_info[k].name = 'while') then
          operators_info[k].count:= operators_info[k].count - operators_info[i].count;
        end;
      end;
      for i:=0 to Length(operators_info)-1 do  //? to ?  :
     if (operators_info[i].name = '?') then
      begin
        operators_info[i].name:= '?  :';
        for k:=0 to Length(operators_info)-1 do
        begin
          if (operators_info[k].name = ':') then
          operators_info[k].count:= operators_info[k].count - operators_info[i].count;
        end;
      end;
       for i:=0 to Length(operators_info)-1 do  //for to (for()  : )
     if (operators_info[i].name = 'for') then
      begin
        operators_info[i].name:= 'for()';
        for k:=0 to Length(operators_info)-1 do
        begin
          if (operators_info[k].name = '( )') then
          operators_info[k].count:= operators_info[k].count - operators_info[i].count;
        end;
      end;
    for i:=0 to Length(operators_info)-1 do
    begin
     if (operators_info[i].name = 'println( )') then
       operators_info[i].name:= 'System.out.println()'; //изменяем вывод
     if (operators_info[i].name = 'print( )') then
       operators_info[i].name:= 'System.out.print()';   //изменяем вывод
     if (operators_info[i].name = '{') then          //изменяем вывод для отображения второй скобки
       operators_info[i].name:= '{  }';
       //конец костылей
      Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
      Form1.SG1.Cells[0,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[1,i+1] := operators_info[i].name;
      Form1.SG1.Cells[2,i+1] := IntToStr(operators_info[i].count);
    end;

    mem := i;
    for i:=0 to Length(operands_info)-1 do
    begin
      if i >= mem+1 then
      begin
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' ';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' ';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' ';
        Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' ';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' ';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' ';
      end;
      Form1.SG1.Cells[3,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[4,i+1] := operands_info[i].name;
      Form1.SG1.Cells[5,i+1] := IntToStr(operands_info[i].count);
    end;

    kek := i;  //Вывод результатов
    Form1.img1.Visible:=true;
    Form1.L1.Caption:= 'ОСНОВНЫЕ:'#10+#13+'Уникальных операторов: '+IntToStr(mem)+#10+#13+'Вхождения операторов (N1): '+IntToStr(tempOperatorsCount)+
    #10+#13+'Уникальных операндов: '+IntToStr(kek)+#10+#13+'Вхождения операндов (N2): '+IntToStr(tempOperandsCount);
    Form1.L2.Caption:='ДОПОЛНИТЕЛЬНЫЕ:'#10+#13+ 'Объем программы: '+inttostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary);
    Form1.LP.Caption:=' Developed by Zanko Maxim and Kizeev Ilya';

   end
   else ShowMessage('К сожалению, файл пуст :(');
end;

procedure TForm1.OpenClick(Sender: TObject);
var
  i,j:Integer;
begin
//Создание таблицы
    with Form1.SG1 do
      for i:= + fixedcols to colcount do
        for j:= 1 + fixedrows to rowcount do
          Cells[i,j] := '';
    if dlgOpen1.Execute then
      generateTable(dlgOpen1.filename);
   SG1.RowCount := SG1.RowCount + 1;
   Repaint;
end;

end.
