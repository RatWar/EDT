
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВосстановитьНастройки();
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	Объект.ДатаНачала = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТаблицаВызовов", "ДатаНачала", Объект.ДатаНачала);
	Объект.ДатаОкончания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТаблицаВызовов", "ДатаОкончания", Объект.ДатаОкончания);
	Объект.Длительность = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТаблицаВызовов", "Длительность", Объект.Длительность);
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТаблицаВызовов", "ДатаНачала", Объект.ДатаНачала);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТаблицаВызовов", "ДатаОкончания", Объект.ДатаОкончания);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТаблицаВызовов", "Длительность", Объект.Длительность);
КонецПроцедуры  

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьДанные(Команда)
	ПолучитьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеНаСервере()
	Объект.ТаблицаВызовов.Очистить();
	ТЗ = ОИМЦ_Данные.ЗапросДанных63("select log.long_duration('" + Объект.ДатаНачала + "', '" + КонецДня(Объект.ДатаОкончания) + 
							    	"' , " + Формат(Объект.Длительность * 1000, "ЧГ=0") + ") as duration;");
	Если ТЗ <> Неопределено Тогда
		Для каждого Элемент Из ТЗ Цикл
			МассивСтрок = РазобратьСтроку(Элемент.duration);
			НС = Объект.ТаблицаВызовов.Добавить();
			НС.Ид = Строка(МассивСтрок[0]);
			НС.Длительность = Строка(Окр(МассивСтрок[1] / 1000, 0));				
			НС.Команда = Строка(МассивСтрок[2]);
			НС.ДатаВремя = Строка(МассивСтрок[3]);
			НС.Логин = Строка(МассивСтрок[4]);
			ПозицияН1 = СтрНайти(НС.Команда, "verificationOdDocuments");
			ПозицияН2 = СтрНайти(НС.Команда, "registerExtDocument");
			Если ПозицияН1 > 0 Тогда
				Ст = ОИМЦ_Данные.ЗапросДанных63("select log.find_verification(" + Формат(НС.Ид, "ЧГ=0") + ");");
				НС.Расшифровка = Ст[0].find_verification;				
			ИначеЕсли ПозицияН2 > 0 Тогда
				Уид = Сред(НС.Команда, ПозицияН2 + 20, 36); 
				СК = "with cte_table_1 as (select d.""tagName"" as doc, " 
				"substring(body, position('<Number>' in body) + length('<Number>'), position('</Number>' in body) - " 
					"position('<Number>' in body) - length('<Number>')) as num,"
				"substring(body, position('<Организация>' in body) + length('<Организация>'), position('</Организация>' in body) - "
					"position('<Организация>' in body) - length('<Организация>')) as uuid_org"
				"from documents.doc d where d.uuid = '" + Строка(Уид) + "' order by d.dt desc limit 1)"
				"select doc, num, (select description from documents.doc d "
					"where d.""tagName""='CatalogObject.Организации' and d.uuid = uuid_org::uuid) "
				"from cte_table_1;";
				Ст = ОИМЦ_Данные.ЗапросДанных63(СК);
				НС.Расшифровка = Ст[0].description + " " + Ст[0].doc + " " + Ст[0].num;
			Иначе				
				НС.Расшифровка = "";	
			КонецЕсли; 	
		КонецЦикла; 
	КонецЕсли;
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(Объект.ДатаНачала, Объект.ДатаОкончания);
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Период) Тогда
		Объект.ДатаНачала = Период.ДатаНачала;
		Объект.ДатаОкончания = Период.ДатаОкончания;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// "(51187742,82948,""run registerExtDocument(cf681be6-05c5-11ea-ab8e-0050568f40c3, fileBody) 82948"",""2019-11-22 15:22:33"",ЗолотаревЕВ)"
// возвращает массив из 5 строк, не учитывая запятой внутри кавычек
&НаКлиентеНаСервереБезКонтекста
Функция РазобратьСтроку(ИсходнаяСтрока)
	Результат = Новый Массив;
    ИсходнаяСтрока = Сред(ИсходнаяСтрока, 2, СтрДлина(ИсходнаяСтрока) - 2);
	ОткрытаКавычка = Ложь;   	
	НС = "";
	Для Счетчик = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		СимволСтроки = Сред(ИсходнаяСтрока, Счетчик, 1);
		Если (СимволСтроки = Символ(44)) и (НЕ ОткрытаКавычка) Тогда
			Результат.Добавить(НС);
			НС = "";
		ИначеЕсли СимволСтроки = Символ(34) Тогда
			ОткрытаКавычка = НЕ ОткрытаКавычка;
			НС = НС + СимволСтроки;
		Иначе
			НС = НС + СимволСтроки;
		КонецЕсли;
	КонецЦикла;
	Результат.Добавить(НС);
	Возврат Результат;
КонецФункции

#КонецОбласти





