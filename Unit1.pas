unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Label1: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Label2: TLabel;
    Button3: TButton;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    ComboBox1: TComboBox;
    Button4: TButton;
    Label5: TLabel;
    DBGrid2: TDBGrid;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Edit1: TEdit;
    Button5: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Button6: TButton;
    Button2: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DBLookupComboBox2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  data_name, fio_uch, mark, kod_predm: String; 

implementation

uses Unit2, DB, Unit3;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

       var i: integer;
       Arr_user: Array of string;
       str_add, data_str, check_data: string;


       begin
       check_data:='';
       data_str:=ComboBox1.Text+'-'+'��'+'_'+FormatDateTime('dd.mm.yy',DateTimePicker1.Date);
      // ShowMessage(data_str);
      DataModule2.ADOQWorkAdd.Close;
      DataModule2.ADOQWorkAdd.SQL.Text:= 'SELECT ������_����.[����], ������_����.[���_��������] FROM ������_���� '
      +' WHERE (((������_����.[����])="'+data_str+'") AND ((������_����.[���_��������])='+IntToStr(DBLookupComboBox2.KeyValue)+'))';
      DataModule2.ADOQWorkAdd.Open;

      check_data:=DataModule2.ADOQWorkAdd.Fields[0].AsString;
      //ShowMessage(check_data);

    if check_data = '' then
    begin



     SetLength(Arr_user,DataModule2.ADOQWork.RecordCount);
      i := 0;
        DataModule2.ADOQWork.Close;
        DataModule2.ADOQWork.SQL.Text:='SELECT ������������.���_������������, ������������.���, ������.��������_������  '
        +' FROM ������ INNER JOIN ������������ ON ������.[���_������] = ������������.[���_������] '
        +' WHERE (((������������.���_������)='+IntToStr(DBLookupComboBox1.KeyValue)+')) ORDER BY ������������.���';
        DataModule2.ADOQWork.Open;
        DataModule2.ADOQWork.First;

      //ListBox1.Clear;
         while not DataModule2.ADOQWork.eof
          do begin
          Arr_user[i]:= DataModule2.DataSWork.DataSet.Fields[1].AsString;

         // ListBox1.Items.Insert(i, Arr_user[i]);

          DataModule2.ADOQWorkAdd.Close;
          DataModule2.ADOQWorkAdd.SQL.Text:= ' INSERT INTO ������_���� ( [���_�������], [����], [������], [���_��������] ) '
          +' VALUES ("'+Arr_user[i]+'", "'+data_str+'", "",'+IntToStr(DBLookupComboBox2.KeyValue)+' )';
          DataModule2.ADOQWorkAdd.ExecSQL;

          DataModule2.ADOQWork.next;
          Inc(i);
       end;



          DataModule2.ADOQWorkAdd.Close;
          DataModule2.ADOQWorkAdd.SQL.Text:= ' INSERT INTO ������_���� ( [���_��������], [����], [����_�������] ) '
          +' VALUES ('+IntToStr(DBLookupComboBox2.KeyValue)+', :dt, "" )';
          DataModule2.ADOQWorkAdd.Parameters.ParamByName('dt').Value:=FormatDateTime('dd.mm.yyyy',DateTimePicker1.Date);
          DataModule2.ADOQWorkAdd.ExecSQL;

          Button3Click(Sender);

      end
      else ShowMessage('���� ��� ����� ����� ����������. �������� ������ ���� ��� ����� �����!');



       end;

procedure TForm1.FormShow(Sender: TObject);
begin
DateTimePicker1.Date:=Now;

//DBLookupComboBox1.KeyValue := DBLookupComboBox1.ListSource.DataSet.FieldByName(DBLookupComboBox1.KeyField).Value;


end;

procedure TForm1.Button2Click(Sender: TObject);
begin
        DataModule2.ADOQWork.Close;
        DataModule2.ADOQWork.SQL.Text:='Delete * from ������_����';
        DataModule2.ADOQWork.ExecSQL;

        DataModule2.ADOQWork.Close;
        DataModule2.ADOQWork.SQL.Text:='Delete * from ������_����';
        DataModule2.ADOQWork.ExecSQL;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
 i: Integer;
begin
                 DataModule2.ADOQEljor.Close;
                 DataModule2.ADOQEljor.SQL.Text:='TRANSFORM First(������_����.[������]) AS [First-������] '
                  +' SELECT ������_����.[���_�������]'
                  +' FROM ������_���� '
                  +' WHERE (((������_����.���_��������)='+IntToStr(DBLookupComboBox2.KeyValue)+')) '
                  +' GROUP BY ������_����.[���_�������], ������_����.���_�������� '
                  +' PIVOT ������_����.[����] ';
                 DataModule2.ADOQEljor.Open;

                 for i:=1 to DBGrid1.Columns.count-1 do
                 DBGrid1.Columns[i].Width:=80;

                 DBGrid1.Enabled:=True;
                 Panel1.Enabled:=True;
                 DBGrid2.Enabled:=True;
                 Panel2.Enabled:=True;

                 DBGrid1.SelectedIndex:=1; //����� �� ������

                 Label7.Caption:= '�������: '+DataModule2.DataSubject.DataSet.Fields[1].AsString;
                 Label8.Caption:= '�������������: '+DataModule2.DataSubject.DataSet.Fields[4].AsString;


                 DataModule2.ADOQTema.Close;
                 DataModule2.ADOQTema.SQL.Text:= 'SELECT ������_����.[����], ������_����.[����_�������], ������_����.[���_������] '
                 +' FROM ������_���� WHERE (((������_����.[���_��������])='+IntToStr(DBLookupComboBox2.KeyValue)+'))';
                 DataModule2.ADOQTema.Open;


end;

procedure TForm1.DBLookupComboBox1Click(Sender: TObject);
begin

DataModule2.ADOQSubject.Close;
   DataModule2.ADOQSubject.SQL.Text:='SELECT ��������.���_���������, ��������.��������, ��������.���_������������, ��������.���_������, ������������.��� '
   +' FROM ������������ INNER JOIN �������� ON ������������.[���_������������] = ��������.[���_������������] '
   +' WHERE (((��������.���_������)='+IntToStr(DBLookupComboBox1.KeyValue)+'))';
   DataModule2.ADOQSubject.Open;

   DBLookupComboBox2.ListSource:=DataModule2.DataSubject;
   DBLookupComboBox2.KeyField:= '���_���������';
   DBLookupComboBox2.ListField:= '��������';


   DBGrid1.Enabled:=False;
   Panel1.Enabled:=False;
   DBGrid2.Enabled:=False;
   Panel2.Enabled:=False;
   Button3.Enabled:=False;

   DBLookupComboBox2.Enabled:=True;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
mark:=DBGrid1.Fields[DBgrid1.SelectedIndex].AsString;
data_name:= DBGrid1.Columns[DBgrid1.SelectedIndex].Title.Caption;
fio_uch:=DBGrid1.Fields[0].AsString;
kod_predm:=IntToStr(DBLookupComboBox2.KeyValue);

Form3.Edit1.Text:= mark;

Form3.Show;

end;

procedure TForm1.DBLookupComboBox2Click(Sender: TObject);
begin
Button3.Enabled:=True;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
if (DBGrid2.Fields[2].AsString<>'') then
begin
        DataModule2.ADOQWork.Close;
        DataModule2.ADOQWork.SQL.Text:='UPDATE ������_���� SET ������_����.[����_�������] = "'+Edit1.Text+'" '
        +'  WHERE (((������_����.[���_������])='+DBGrid2.Fields[2].AsString+'))';
        DataModule2.ADOQWork.ExecSQL;

        Button3Click(Sender);
        Edit1.Clear;
     end;
end;

procedure TForm1.DBGrid2CellClick(Column: TColumn);
begin
Edit1.Text:=DBGrid2.Fields[1].AsString;
end;

procedure TForm1.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key =#13) then Button4Click(Sender);
end;

procedure TForm1.Button6Click(Sender: TObject);
var last_rec, data_tema, check_data_del: String;
begin
mark:=DBGrid1.Fields[DBgrid1.SelectedIndex].AsString;
data_name:= DBGrid1.Columns[DBgrid1.SelectedIndex].Title.Caption;
fio_uch:=DBGrid1.Fields[0].AsString;
kod_predm:=IntToStr(DBLookupComboBox2.KeyValue);

data_tema:= '#'+Copy(data_name, 9, 2)+'/'+Copy(data_name, 6, 2)+'/'+Copy(data_name, 12, 2)+'#';
check_data_del:=Copy(data_name, 6, 2);
//ShowMessage(check_data_del);
if (check_data_del<>'��') then

begin

DataModule2.ADOQRegMark.Close;
DataModule2.ADOQRegMark.SQL.Text:= 'SELECT ������_����.[���_������], ������_����.[����], ������_����.���_��������, ������_����.����_������� FROM ������_���� '
+' WHERE (((������_����.[����])='+data_tema+') AND ((������_����.���_��������)='+kod_predm+'))';
DataModule2.ADOQRegMark.Open;
DataModule2.ADOQRegMark.Last;
last_rec:=DataModule2.DataSRegMark.DataSet.Fields[0].AsString;


DataModule2.ADOQRegMark.Close;
DataModule2.ADOQRegMark.SQL.Text:= 'DELETE * FROM ������_���� WHERE (((������_����.[���_������])='+last_rec+'))';
DataModule2.ADOQRegMark.ExecSQL;



DataModule2.ADOQRegMark.Close;
DataModule2.ADOQRegMark.SQL.Text:= 'Delete * from ������_����'
+' WHERE (((������_����.[���_��������])='+kod_predm+')) AND((������_����.[����])like "%'+data_name+'%")';
DataModule2.ADOQRegMark.ExecSQL;


Button3Click(Sender);
end;
end;

end.
