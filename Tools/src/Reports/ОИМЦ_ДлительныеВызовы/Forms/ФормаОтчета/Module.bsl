
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Отчет.ДатаНачала = НачалоГода(ТекущаяДатаСеанса());
	Отчет.ДатаОкончания = ТекущаяДатаСеанса();
	ОтчетыБольничнаяАптека.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	УстановитьВидимостьЭлементовФормы(Отказ, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если Не ЗначениеЗаполнено(Настройки.Получить("Отчет.ДатаНачала")) Тогда
		Настройки.Удалить("Отчет.ДатаНачала");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Настройки.Получить("Отчет.ДатаОкончания")) Тогда
		Настройки.Удалить("Отчет.ДатаОкончания");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтчетыБольничнаяАптекаКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	ОтчетыБольничнаяАптека.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	ОтчетыБольничнаяАптека.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ОтчетыБольничнаяАптекаКлиент.ОбработатьСобытиеЗаписиМакета(ЭтотОбъект, ИмяСобытия, Параметр, Источник) Тогда
		УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОтчетыБольничнаяАптекаКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// Шапка
#Область Шапка

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
КонецПроцедуры

#КонецОбласти // Шапка

////////////////////////////////////////////////////////////////////////////////
// Оформление
#Область Оформление

//&НаКлиенте
//Процедура УсловноеОформлениеПриИзменении(Элемент)
//	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
//КонецПроцедуры
//
//&НаКлиенте
//Процедура ВыводитьЗаголовокПриИзменении(Элемент)
//	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
//КонецПроцедуры
//
//&НаКлиенте
//Процедура ВыводитьПодвалПриИзменении(Элемент)
//	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
//КонецПроцедуры

#КонецОбласти // Оформление

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	МойСформировать();
	ЗагрузитьДанные();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные()
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(Отчет.ДатаНачала, Отчет.ДатаОкончания);
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	УстановитьСтандартныеНастройкиНаСервере();
	УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		ТекстВопроса = НСтр("ru = 'Отчет не сформирован. Сформировать?'");
		Оповестить = Новый ОписаниеОповещения("ОтправитьПослеФормированияОтчета", ЭтотОбъект);
		ПоказатьВопрос(Оповестить, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Иначе
		ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьМакет(Команда)
	ОтчетыБольничнаяАптекаКлиент.ИзменитьМакет(ЭтотОбъект, МакетыОтчета);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКУправлениюМакетами(Команда)
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.МакетыПечатныхФорм");
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

#Область ОтправкаПоПочте

&НаКлиенте
Процедура ОтправитьПослеФормированияОтчета(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОтправитьПослеФормирования = Истина;
		МойСформировать();
		ЗагрузитьДанные();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	ОтчетыБольничнаяАптекаКлиент.ПоказатьДиалогОтправкиПоЭлектроннойПочте(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти // ОтправкаПоПочте

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы(Отказ, СтандартнаяОбработка)
	// Тесная интеграция с почтой.
	ДоступнаОтправкаПисем = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		ДоступнаОтправкаПисем = МодульРаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем();
	КонецЕсли;
	Если Не ДоступнаОтправкаПисем Тогда
		Элементы.ОтправитьПоЭлектроннойПочте.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Период) Тогда
		Отчет.ДатаНачала = Период.ДатаНачала;
		Отчет.ДатаОкончания = Период.ДатаОкончания;
		УстановитьСостояниеОтображенияНеактуальность(Элементы.Результат, ИдентификаторЗадания);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиНаСервере()
	ОтчетыБольничнаяАптека.УстановитьНастройкиПоУмолчанию(ЭтотОбъект);
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	ПериодОтчета = ОбщегоНазначенияБольничнаяАптекаКлиентСервер.ПолучитьПараметр(Отчет.КомпоновщикНастроек, "Период").Значение;
	ЗаполнитьЗначенияСвойств(Отчет, ПериодОтчета);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеОтображенияНеактуальность(ПолеТабличногоДокумента, ИдентификаторЗадания)
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, "Неактуальность");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции

&НаСервере
Процедура МойСформировать()
	Перем ЗначСклад;
	Результат.Очистить();
	Макет = Отчеты.ОИМЦ_ДлительныеВызовы.ПолучитьМакет("СписокВызовов");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	Результат.Вывести(ОбластьЗаголовок);
	Результат.Вывести(ОбластьШапка);
	ТЗ = ОИМЦ_Данные.ЗапросДанных63("select log.long_duration('" + Отчет.ДатаНачала + "', '" + КонецДня(Отчет.ДатаОкончания) + 
									"' , " + Формат(Отчет.Длительность * 1000, "ЧГ=0") + ") as duration;");
	Если ТЗ <> Неопределено Тогда
		Счетчик = 1;
		Для каждого Элемент Из ТЗ Цикл
			МассивСтрок = РазобратьСтроку(Элемент.duration);
			ОбластьСтрока.Параметры.Ид = Строка(МассивСтрок[0]);
			ОбластьСтрока.Параметры.Длительность = Строка(Окр(МассивСтрок[1] / 1000, 0));				
			ОбластьСтрока.Параметры.Команда = Строка(МассивСтрок[2]);
			ОбластьСтрока.Параметры.ДатаВремя = Строка(МассивСтрок[3]);
			ОбластьСтрока.Параметры.Логин = Строка(МассивСтрок[4]);
			ОбластьСтрока.Параметры.Номер = Строка(Счетчик);
			Счетчик = Счетчик + 1;
			Результат.Вывести(ОбластьСтрока);	
		КонецЦикла; 
		Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Результат.АвтоМасштаб = Истина;   		
	КонецЕсли; 
КонецПроцедуры    

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



