
#Область ПрограммныйИнтерфейс

// Возвращает параметры расшифровки отчета.
//
// Параметры:
//  ИдентификаторОбъекта - Строка - Имя отчета, как оно задано в конфигураторе.
//  Адрес - Строка - адрес временного хранилища, где находятся данные расшифровки и ПараметрыОтчета.
//  Расшифровка - Произвольный - расшифровка ячеек области отчета.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - компоновщик отчета, для которого получаются параметры расшифровки.
//
// Возвращаемое значение:
//  Структура - параметры обработки расшифровки.
//
Функция ПолучитьПараметрыРасшифровкиОтчета(Знач ИдентификаторОбъекта, Знач Адрес, Знач Расшифровка, Знач КомпоновщикНастроек) Экспорт
	
	ПараметрыРасшифровки = Новый Структура;
	
	ПараметрыИсполненияОтчета = Отчеты[ИдентификаторОбъекта].ПолучитьПараметрыИсполненияОтчета();
	Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьРасширенныеПараметрыРасшифровки")
	   И ПараметрыИсполненияОтчета.ИспользоватьРасширенныеПараметрыРасшифровки Тогда
		Отчеты[ИдентификаторОбъекта].ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки);
		Возврат ПараметрыРасшифровки;
	КонецЕсли;
	
	ТипРасшифровки = ТипЗнч(Расшифровка);
	Если ТипРасшифровки = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		
		ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
		ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
		ПоляРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьПоля();
		
		ДоступныеПоляВыбора = КомпоновщикНастроек.ПолучитьНастройки().ДоступныеПоляВыбора;
		
		Значения = Новый СписокЗначений;
		Для Каждого ПолеРасшифровки Из ПоляРасшифровки Цикл
			
			Значение = ПолеРасшифровки.Значение;
			Если ЗначениеЗаполнено(Значение) И ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Значение)) Тогда
				
				ПредставлениеПоля = "";
				Поле = ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ПолеРасшифровки.Поле));
				Если Поле <> Неопределено Тогда
					ПредставлениеПоля = Поле.Заголовок;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ПредставлениеПоля) Тогда
					ПредставлениеПоля = Значение.Метаданные().ПредставлениеОбъекта;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ПредставлениеПоля) Тогда
					ПредставлениеПоля = Значение.Метаданные().Представление();
				КонецЕсли;
				
				Значения.Добавить(Значение, ПредставлениеПоля + " = " + Значение);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Значения.Количество() = 1 Тогда
			ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			ПараметрыРасшифровки.Вставить("Значение"     , Значения[0].Значение);
		ИначеЕсли Значения.Количество() > 1 Тогда
			ПараметрыРасшифровки.Вставить("СписокПунктовМеню", Значения);
		КонецЕсли;
		
	Иначе
		Если ОбщегоНазначения.ЭтоСсылка(ТипРасшифровки) Тогда
			ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			ПараметрыРасшифровки.Вставить("Значение", Расшифровка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыРасшифровки;
	
КонецФункции

// Продолжает запись измененного макета отчета.
//
// Параметры:
//  ИмяОбъектаМетаданныхМакета      - Строка -  полный путь к макету в формате:
//                                             "Отчет.<ИмяОтчета>.<ИмяМакета>"
//  АдресМакетаВоВременномХранилище - Строка - адрес измененного макета во временном хранилище.
//
Процедура ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище) Экспорт
	
	УправлениеПечатью.ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
	
КонецПроцедуры

// Возвращает признак актуальности расчета себестоимости товаров по указанным отборам.
// (см. функцию "ОтчетыБольничнаяАптека.СебестоимостьТоваровАктуализирована")
//
// Параметры:
//  ПараметрыРасчета - Структура со свойствами:
//   * ОкончаниеПериодаРасчета - Дата - проверяемая дата актуальности расчета себестоимости.
//   * СписокОрганизаций       - Ссылка, Массив - проверяемые организации, по которым была рассчитана себестоимость.
//   * НомерЗадания            - Число - номер задания расчета себестоимости.
//
// Возвращаемое значение:
//  Истина, если по переданному отбору выполнен расчет себестоимости.
//
Функция СебестоимостьТоваровАктуализирована(Знач ПараметрыРасчета) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	МИНИМУМ(Очередь.Месяц) КАК НачалоПериодаРасчета
	|ИЗ
	|	РегистрСведений.ГраницыРасчетаСебестоимостиТоваров КАК Очередь
	|ГДЕ
	|	Очередь.НомерЗадания <= &НомерЗадания
	|	И Очередь.Организация В (&СписокОрганизаций)
	|ИМЕЮЩИЕ
	|	НЕ МИНИМУМ(Очередь.Месяц) ЕСТЬ NULL
	|	И МИНИМУМ(Очередь.Месяц) <= &ОкончаниеПериодаРасчета
	|");
	
	Запрос.УстановитьПараметр("ОкончаниеПериодаРасчета", ПараметрыРасчета.ОкончаниеПериодаРасчета);
	Запрос.УстановитьПараметр("СписокОрганизаций"      , ПараметрыРасчета.СписокОрганизаций);
	Запрос.УстановитьПараметр("НомерЗадания"           , ПараметрыРасчета.НомерЗадания);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

// Выводит информационную надпись в результат формирования отчета
// о статусе актуализации себестоимости товаров.
//
// Параметры:
//  РезультатЗапускаРасчета - Структура - описание результата запуска актуализации себестоимости товаров.
//  ДокументРезультат       - ТабличныйДокумент - результат формирования отчета,
//                            куда помещается описание актуализации себестоимости товаров.
//
Процедура ВывестиОписаниеАктуальностиРасчета(РезультатЗапускаРасчета, ДокументРезультат) Экспорт
	
	Макет = Новый ТабличныйДокумент;
	
	Область = ДокументРезультат.Область(1,,1);
	ДокументРезультат.ВставитьОбласть(Макет.Область(1,,1), Область, ТипСмещенияТабличногоДокумента.ПоВертикали);
	Область.СоздатьФорматСтрок();
	
	Область = ДокументРезультат.Область(1,1,1,1);
	Область.ШиринаКолонки = 60;
	
	Если РезультатЗапускаРасчета.ДлительнаяОперация <> Неопределено
	   И РезультатЗапускаРасчета.ДлительнаяОперация.Статус = "Выполняется" Тогда
		Текст = НСтр("ru = 'Запущено фоновое задание расчета себестоимости до %1.
			|После окончания расчета Вам будет предложено переформировать отчет.'");
		Дата = Формат(РезультатЗапускаРасчета.ОкончаниеПериодаРасчета, "ДЛФ=D");
	Иначе
		Текст = НСтр("ru = 'Расчет себестоимости выполнен до %1.'");
		Дата = Формат(КонецМесяца(РезультатЗапускаРасчета.НачалоПериодаРасчета - 1), "ДЛФ=D");
	КонецЕсли;
	
	Область.Текст      = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, Дата);
	Область.ЦветТекста = ЦветаСтиля.ПросроченныеДанныеЦвет;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс
