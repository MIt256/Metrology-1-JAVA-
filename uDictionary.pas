unit uDictionary;
//словарь
interface

type
  TLexem = String;
  TLexems = array of TLexem;

  TLexInf = record
    name: TLexem;
    count: Integer;
  end;
  TLexemsInf = array of TLexInf;


const
//dictionaries of key words
  java_identifier = ['A'..'Z', 'a'..'z', '_', '0'..'9'];
   //это операторы которые будем искать
  java_keywords: array[1..35] of string = ( 'abstract', 'continue', 'for', 'new',
   'switch', 'assert', 'default', 'goto',
'synchronized', 'do', 'if', 'private', 'this', 'break', 'implements',
'protected', 'throw', 'else' , 'throws', 'case', 'enum', 'instanceof', 'return',
'transient', 'catch', 'extends', 'try', 'final', 'interface',
'finally', 'strictfp', 'volatile', 'native', 'super', 'while');
  //тоже
  java_statements: array[1..40] of string = ( '=', '>', '<', '!', '~', '?', ':','==', '<=', '>=', '!=', '&&', '||', '++', '--', '+',
'-', '*', '/', '&', '|', '^', '%', '->', '::', '+=','-=', '*=', '/=', '&=', '|=', '^=', '%=', '<<=', '>>=',
'>>>=','@',',',';','{');
     // а вот это уже исключения, можно переместить  в верхний словарь и выводить как оператор
     // я к тому что понятие оператора размыто и можно искать а можно игнорировать
     //в данном случае, то что находится здесь будет игнорироваться
    not_in: array[1..33] of string = ('void','#','integer','String','string','Integer','java','System','io','IOException','com',
    'company','Main','NumberFormatException','in','public','import', 'static','package','class','float','short','byte','double',
    'const','long','word','out','boolean','BufferedReader','InputStreamReader','int','char');

function lexem_in_java_keywords(const lexem: TLexem): Boolean;
function lexem_in_java_statements(const lexem: TLexem): Boolean;
function lexem_in_list(const lexems: TLexemsInf; const lexem: TLexem): Integer;
function lexem_in_java_not_in(const lexem: TLexem): Boolean;

implementation

//checking for availability in dictionaries
function lexem_in_list(const lexems: TLexemsInf; const lexem: TLexem): Integer;
{
Лексема уже в списке лексем: Да - индекс/ нет - (-1)
}
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while (i <= length(lexems) - 1) and (Result = - 1) do
  begin
    if lexem = lexems[i].name then
      Result := i;
    i := i + 1;
  end;
end;

function lexem_in_java_statements(const lexem: TLexem): Boolean;
{Лехема в списке операторов: да - True; нет - False}
var
  i: Integer;
begin
  Result := False;
  i := 1;
  while (i <= length(java_statements)) and (not Result) do
  begin
    if lexem = java_statements[i] then
    begin
      Result := True;
    end;
    Inc(i);
  end;
end;

function lexem_in_java_keywords(const lexem: TLexem): Boolean;
{Лехема в списке ключевых слов: да - True; нет - False}
var
  i: Integer;
begin
  Result := False;
  i := 1;
  while (i <= length(java_keywords)) and (not Result) do
  begin
    if lexem = java_keywords[i] then
    begin
      Result := True;
    end;
    Inc(i);
  end;
end;


function lexem_in_java_not_in(const lexem: TLexem): Boolean;
{Лехема в списке исключений: да - True; нет - False}
var
  i: Integer;
begin
  Result := False;
  i := 1;
  while (i <= length(not_in)) and (not Result) do
  begin
    if lexem = not_in[i] then
    begin
      Result := True;
    end;
    Inc(i);
  end;
end;

end.
