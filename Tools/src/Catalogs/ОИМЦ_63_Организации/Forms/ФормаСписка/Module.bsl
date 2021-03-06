
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	ТЗ = ОИМЦ_Данные.ЗапросДанных63("select uuid::varchar, ""name"", orgid, extid from documents.check_clinic;");
	Если ТЗ <> Неопределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		Для каждого Элемент Из ТЗ Цикл
			Поиск = Справочники.ОИМЦ_63_Организации.НайтиПоРеквизиту("ОргИд", Элемент.orgid);
			Если Поиск.Пустая() Тогда
				НО = Справочники.ОИМЦ_63_Организации.СоздатьЭлемент();
				НО.Наименование = СокрЛП(Элемент.name);
				НО.ОргИд = Элемент.orgid;
				НО.УИД = Элемент.uuid;
				НО.ОГРН = Элемент.extid;			
				НО.Записать();	
			Иначе
				СО = Поиск.ПолучитьОбъект();
				СО.Наименование = СокрЛП(Элемент.name);
				СО.ОргИд = Элемент.orgid;
				СО.УИД = Элемент.uuid;
				СО.ОГРН = Элемент.extid;			
				СО.Записать();	
			КонецЕсли; 			
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры

