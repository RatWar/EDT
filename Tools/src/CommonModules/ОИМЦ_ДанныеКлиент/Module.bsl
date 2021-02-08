
&НаКлиенте
Функция ЗапросДанныхЛог(ТекстЗапроса) Экспорт 
	Connection = Новый COMОбъект("ADODB.CONNECTION");
	Connection.ConnectionString = "Driver=SQLite3 ODBC Driver;Database=C:\Users\control\Documents\Work\Work\Log.db";	
	Попытка            
		Connection.Open();            
	Исключение            
		Возврат Неопределено;
	КонецПопытки;	
	Command = Новый COMObject("ADODB.Command"); 
	Command.ActiveConnection = Connection; 
	Command.CommandType = 1;	
	Command.CommandText = ТекстЗапроса;
	Recordset = Новый COMОбъект("ADODB.Recordset");
	Попытка
		RecordSet = Command.Execute(); 	
	Исключение
		Recordset.Close();
		Connection.Close();
		Возврат Неопределено; 
	КонецПопытки;
	Recordset.MoveFirst();
	ИндексЗаписи = 1;
	Данные = Новый Массив;
	Пока Recordset.EOF = 0 Цикл	
		НС = Новый Структура;
		Для НомерСтолбца = 0 По Recordset.Fields.Count - 1 Цикл
			ИмяСтолбца = Recordset.Fields.Item(НомерСтолбца).Name;
			НС.Вставить(ИмяСтолбца, Recordset.Fields(ИмяСтолбца).Value);
		КонецЦикла;
		Данные.Добавить(НС);
		Recordset.MoveNext();
		ИндексЗаписи = ИндексЗаписи + 1;
	КонецЦикла;
	Recordset.Close();
	Connection.Close();	
КонецФункции   

&НаКлиенте
Функция ЗаписьДанныхЛог(ТекстКоманды) Экспорт
	Connection = Новый COMОбъект("ADODB.CONNECTION");
	Connection.ConnectionString = "Driver=SQLite3 ODBC Driver;Database=C:\Users\control\Documents\Work\Work\Log.db";	
	Попытка            
		Connection.Open();            
	Исключение         
		Возврат Неопределено;
	КонецПопытки;	
	Command = Новый COMObject("ADODB.Command"); 
	Command.ActiveConnection = Connection; 
	Command.CommandType = 1;	
	Command.CommandText = ТекстКоманды;
	Попытка
		Command.Execute(); 	
	Исключение
		Connection.Close();
		Возврат Ложь; 
	КонецПопытки;
	Connection.Close();
	Возврат Истина;
КонецФункции