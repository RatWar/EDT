
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОргИд = Формат(ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ОргИд, "ЧГ=0");
	НомИд = Формат(ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение.НомИд, "ЧГ=0");                                                                       	
	СтрокаЗапроса = ТекстЗапроса(НомИд, ОргИд);
	ТЗ = ОИМЦ_Данные.ЗапросДанных63(СтрокаЗапроса);	
	Для каждого Элемент Из ТЗ Цикл
        Элемент.num_docum = СокрЛП(Элемент.num_docum);	        
	КонецЦикла; 
	ТЗ = ПодготовитьДанные(ТЗ);
	Если ТЗ <> Неопределено Тогда
		Настройки = КомпоновщикНастроек.ПолучитьНастройки(); 
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; 
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;	
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);	
		ВнешнийНаборДанных = Новый Структура("ВнешняяТаблица", ТЗ); //Внешний набор данных записываем в структуру, где ключ = имени внешнего набора данных в СКД 
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных; 
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки); //Устанавливаем в СКД внешний набор данных
		ДокументРезультат.Очистить();
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат); 
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	КонецЕсли;
КонецПроцедуры

Функция ПодготовитьДанные(Данные)
    Результат = Данные.Скопировать();
    Счетчик = Результат.Количество();
    Пока Счетчик > 0 Цикл
        Счетчик = Счетчик - 1;
        Если Результат[Счетчик].amount <> 0 Тогда
            Продолжить;
        Иначе
            Результат.Удалить(Счетчик);     
        КонецЕсли; 
    КонецЦикла; 
    Возврат Результат;  
КонецФункции

Функция ТекстЗапроса(НомИд, ОргИд)
	СтрокаЗапроса = "
	|select m.amount * case m.""operType""
	| when 1 then 1 else -1 end as amount, d2.description as seria, d3.description as budget,
	| d4.description as store, d6.description as place, d5.description as party, d7.""tagName"" as docum, m.dt as date_docum,
	| substring(d7.body, position('<Number>' in d7.body) + length('<Number>'),
	| position('</Number>' in d7.body) - position('<Number>' in d7.body) - length('<Number>')) as num_docum,
	| m.""docID"" as doc_id, m.md5r as md5r
	| from ""movementDrug"".movement m 
	| left join documents.doc d2 on d2.id = m.""seriesID"" left join documents.doc d3 on d3.id = m.""budgetID""
	| left join documents.doc d4 on d4.id = m.""storeID"" left join documents.doc d5 on d5.id = m.""partID""
	| left join documents.doc d7 on d7.id = m.""docID"" left join documents.doc d6 on d6.id = m.""placeID""
	| where m.""nomID"" = %1 and m.""orgID"" = %2 and m.""storeID"" <> 0 order by m.""operDate"";";
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗапроса, НомИд, ОргИд);
КонецФункции

//Функция ТекстЗапроса(НомИд, ОргИд)
//    СтрокаЗапроса = "
//    |select d.description as nomenclature, m.amount * case m.""operType""
//    | when 1 then 1 else -1 end as amount, d2.description as seria, d3.description as budget,
//    | d4.description as place, d5.description as party, d7.""tagName"" as docum, m.dt as date_docum,
//    | substring(d7.body, position('<Number>' in d7.body) + length('<Number>'),
//    | position('</Number>' in d7.body) - position('<Number>' in d7.body) - length('<Number>')) as num_docum,
//    | m.""docID"" as doc_id, m.md5r as md5r
//    | from ""movementDrug"".movement m left join documents.doc d on d.id = m.""nomID""
//    | left join documents.doc d2 on d2.id = m.""seriesID"" left join documents.doc d3 on d3.id = m.""budgetID""
//    | left join documents.doc d4 on d4.id = m.""storeID"" left join documents.doc d5 on d5.id = m.""partID""
//    | left join documents.doc d7 on d7.id = m.""docID""
//    | where m.""nomID"" = %1 and m.""orgID"" = %2 order by m.""operDate"";";
//    Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗапроса, НомИд, ОргИд);
//КонецФункции
