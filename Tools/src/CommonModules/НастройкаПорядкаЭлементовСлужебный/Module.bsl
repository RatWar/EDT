///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает значение реквизита доп. упорядочивания для нового объекта.
//
// Параметры:
//  Информация - Структура - информация о метаданных объекта;
//  Родитель   - Ссылка    - ссылка на родителя объекта;
//  Владелец   - Ссылка    - ссылка на владельца объекта.
//
// Возвращаемое значение:
//  Число - значение реквизита доп. упорядочивания.
Функция ПолучитьНовоеЗначениеРеквизитаДопУпорядочивания(Информация, Родитель, Владелец) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	
	УсловияЗапроса = Новый Массив;
	
	Если Информация.ЕстьРодитель Тогда
		УсловияЗапроса.Добавить("Таблица.Родитель = &Родитель");
		Запрос.УстановитьПараметр("Родитель", Родитель);
	КонецЕсли;
	
	Если Информация.ЕстьВладелец Тогда
		УсловияЗапроса.Добавить("Таблица.Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", Владелец);
	КонецЕсли;
	
	ДополнительныеУсловия = "ИСТИНА";
	Для Каждого Условие Из УсловияЗапроса Цикл
		ДополнительныеУсловия = ДополнительныеУсловия + " И " + Условие;
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	&ДополнительныеУсловия
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Информация.ПолноеИмя);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДополнительныеУсловия", ДополнительныеУсловия);
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(Не ЗначениеЗаполнено(Выборка.РеквизитДопУпорядочивания), 1, Выборка.РеквизитДопУпорядочивания + 1);
	
КонецФункции

Функция ПроверитьУпорядочиваниеЭлементов(МетаданныеТаблицы)
	Если Не ПравоДоступа("Изменение", МетаданныеТаблицы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Владелец КАК Владелец,
	|	&Родитель КАК Родитель,
	|	Таблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	1 КАК Количество,
	|	Таблица.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВсеЭлементы
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЭлементы.Владелец,
	|	ВсеЭлементы.Родитель,
	|	ВсеЭлементы.РеквизитДопУпорядочивания,
	|	СУММА(ВсеЭлементы.Количество) КАК Количество
	|ПОМЕСТИТЬ СтатистикаИндексов
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеЭлементы.РеквизитДопУпорядочивания,
	|	ВсеЭлементы.Родитель,
	|	ВсеЭлементы.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатистикаИндексов.Владелец,
	|	СтатистикаИндексов.Родитель,
	|	СтатистикаИндексов.РеквизитДопУпорядочивания
	|ПОМЕСТИТЬ Дубли
	|ИЗ
	|	СтатистикаИндексов КАК СтатистикаИндексов
	|ГДЕ
	|	СтатистикаИндексов.Количество > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеЭлементы.Ссылка КАК Ссылка
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Дубли КАК Дубли
	|		ПО ВсеЭлементы.РеквизитДопУпорядочивания = Дубли.РеквизитДопУпорядочивания
	|			И ВсеЭлементы.Родитель = Дубли.Родитель
	|			И ВсеЭлементы.Владелец = Дубли.Владелец
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВсеЭлементы.Ссылка
	|ИЗ
	|	ВсеЭлементы КАК ВсеЭлементы
	|ГДЕ
	|	ВсеЭлементы.РеквизитДопУпорядочивания = 0";
	
	Информация = НастройкаПорядкаЭлементов.ПолучитьИнформациюДляПеремещения(МетаданныеТаблицы);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Информация.ПолноеИмя);
	
	ПолеРодителя = "Родитель";
	Если Не Информация.ЕстьРодитель Тогда
		ПолеРодителя = "1";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Родитель", ПолеРодителя);
	
	ПолеВладельца = "Владелец";
	Если Не Информация.ЕстьВладелец Тогда
		ПолеВладельца = "1";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Владелец", ПолеВладельца);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.РеквизитДопУпорядочивания = 0;
		Попытка
			Объект.Записать();
		Исключение
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПереместитьЭлемент(ЭлементСписок, ТекущийЭлементСсылка, Направление) Экспорт
	
	ПараметрыДоступа = ПараметрыДоступа("Изменение", ТекущийЭлементСсылка.Метаданные(), "Ссылка");
	Если Не ПараметрыДоступа.Доступность Тогда
		Возврат НСтр("ru = 'Недостаточно прав для изменения порядка элементов.'");
	КонецЕсли;
	
	Информация = НастройкаПорядкаЭлементов.ПолучитьИнформациюДляПеремещения(ТекущийЭлементСсылка.Метаданные());
	НастройкиКомпоновкиДанных = ЭлементСписок.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	// Для иерархических справочников может быть установлен отбор по родителю, если нет,
	// то способ отображения должен быть иерархический или в виде дерева.
	ОтображениеСписком = ЭлементСписок.Отображение = ОтображениеТаблицы.Список;
	Если Информация.ЕстьРодитель И ОтображениеСписком И Не СписокСодержитОтборПоРодителю(НастройкиКомпоновкиДанных) Тогда
		Возврат НСтр("ru = 'Для изменения порядка элементов необходимо установить режим просмотра ""Дерево"" или ""Иерархический список"".'");
	КонецЕсли;
	
	// Для подчиненных справочников должен быть установлен отбор по владельцу.
	Если Информация.ЕстьВладелец И Не СписокСодержитОтборПоВладельцу(НастройкиКомпоновкиДанных) Тогда
		Возврат НСтр("ru = 'Для изменения порядка элементов необходимо установить отбор по полю ""Владелец"".'");
	КонецЕсли;
	
	// Проверка признака "Использование" у реквизита РеквизитДопУпорядочивания по отношению к перемещаемому элементу.
	Если Информация.ЕстьГруппы Тогда
		ЭтоГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийЭлементСсылка, "ЭтоГруппа");
		Если ЭтоГруппа И Не Информация.ДляГрупп Или Не ЭтоГруппа И Не Информация.ДляЭлементов Тогда
			Возврат НСтр("ru = 'Выбранный элемент нельзя перемещать.'");
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьУпорядочиваниеЭлементов(ТекущийЭлементСсылка.Метаданные());
	
	НастройкиКомпоновкиДанных = ЭлементСписок.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	ТекстОшибки = ПроверитьСортировкуВСписке(НастройкиКомпоновкиДанных);
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Возврат ТекстОшибки;
	КонецЕсли;
	
	ГруппировкаКомпоновкиДанных = НастройкиКомпоновкиДанных.Структура[0];
	
	ПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.ДоступныеПоляВыбора.Элементы.Найти("Ссылка").Поле;
	ЕстьПолеСсылка = Ложь;
	Для Каждого ВыбранноеПолеКомпоновкиДанных Из ГруппировкаКомпоновкиДанных.Выбор.Элементы Цикл
		Если ТипЗнч(ВыбранноеПолеКомпоновкиДанных) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если ВыбранноеПолеКомпоновкиДанных.Поле = ПолеКомпоновкиДанных Тогда
			ЕстьПолеСсылка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Не ЕстьПолеСсылка Тогда
		ВыбранноеПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		ВыбранноеПолеКомпоновкиДанных.Поле = ПолеКомпоновкиДанных;
	КонецЕсли;
	
	СхемаКомпоновкиДанных = ЭлементСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	ДеревоЗначений = ВыполнитьЗапрос(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	Если ДеревоЗначений = Неопределено Тогда
		Возврат НСтр("ru = 'Для изменения порядка элементов необходимо сбросить настройки списка
			|(Меню Еще - Установить стандартные настройки).'");
	КонецЕсли;
	
	СтрокаДереваЗначений = ДеревоЗначений.Строки.Найти(ТекущийЭлементСсылка, "Ссылка", Истина);
	Родитель = СтрокаДереваЗначений.Родитель;
	Если Родитель = Неопределено Тогда
		Родитель = ДеревоЗначений;
	КонецЕсли;
	
	ИндексТекущего = Родитель.Строки.Индекс(СтрокаДереваЗначений);
	ИндексСоседнего = ИндексТекущего;
	Если Направление = "Вверх" Тогда
		Если ИндексТекущего > 0 Тогда
			ИндексСоседнего = ИндексТекущего - 1;
		КонецЕсли;
	Иначе // Вниз
		Если ИндексТекущего < Родитель.Строки.Количество() - 1 Тогда
			ИндексСоседнего = ИндексТекущего + 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ИндексТекущего <> ИндексСоседнего Тогда
		СоседняяСтрока = Родитель.Строки.Получить(ИндексСоседнего);
		СоседнийЭлементСсылка = СоседняяСтрока.Ссылка;
		
		Элементы = Новый Массив;
		Элементы.Добавить(ТекущийЭлементСсылка);
		Элементы.Добавить(СоседнийЭлементСсылка);
		
		ПоменятьЭлементыМестами(ТекущийЭлементСсылка, СоседнийЭлементСсылка);
	КонецЕсли;
	
	Возврат "";
КонецФункции

Функция ВыполнитьЗапрос(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных)
	
	Результат = Новый ДеревоЗначений;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Попытка
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
			НастройкиКомпоновкиДанных, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат Результат;
	
КонецФункции

Процедура ПоменятьЭлементыМестами(ПервыйЭлементСсылка, ВторойЭлементСсылка)
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ПервыйЭлементСсылка);
		ЗаблокироватьДанныеДляРедактирования(ВторойЭлементСсылка);
		
		ПервыйЭлементОбъект = ПервыйЭлементСсылка.ПолучитьОбъект();
		ВторойЭлементОбъект = ВторойЭлементСсылка.ПолучитьОбъект();
		
		ИндексПервого = ПервыйЭлементОбъект.РеквизитДопУпорядочивания;
		ИндексВторого = ВторойЭлементОбъект.РеквизитДопУпорядочивания;
		
		ПервыйЭлементОбъект.РеквизитДопУпорядочивания = ИндексВторого;
		ВторойЭлементОбъект.РеквизитДопУпорядочивания = ИндексПервого;
	
		ПервыйЭлементОбъект.Записать();
		ВторойЭлементОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ПроверитьСортировкуВСписке(НастройкиКомпоновкиДанных)
	
	ЭлементыПорядка = НастройкиКомпоновкиДанных.Порядок.Элементы;
	
	ДополнительныеПоляПорядка = Новый Массив;
	ДополнительныеПоляПорядка.Добавить(Новый ПолеКомпоновкиДанных("ДополнительноеПолеПорядка1"));
	ДополнительныеПоляПорядка.Добавить(Новый ПолеКомпоновкиДанных("ДополнительноеПолеПорядка2"));
	ДополнительныеПоляПорядка.Добавить(Новый ПолеКомпоновкиДанных("ДополнительноеПолеПорядка3"));
	
	Элемент = Неопределено;
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование Тогда
			Элемент = ЭлементПорядка;
			Если ДополнительныеПоляПорядка.Найти(Элемент.Поле) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	СортировкаПравильная = Ложь;
	Если Элемент <> Неопределено И ТипЗнч(Элемент) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Если Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ПолеРеквизита = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
			Если Элемент.Поле = ПолеРеквизита Тогда
				СортировкаПравильная = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РеквизитДопУпорядочивания = НастройкиКомпоновкиДанных.Порядок.ДоступныеПоляПорядка.НайтиПоле(Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания"));
	Если Не СортировкаПравильная Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для перемещения элементов необходимо настроить сортировку
			|в списке по полю ""%1"" (по возрастанию)'"), РеквизитДопУпорядочивания.Заголовок);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция СписокСодержитОтборПоВладельцу(НастройкиКомпоновкиДанных)
	
	ТребуемыеОтборы = Новый Массив;
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Владелец"));
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Owner"));
	
	Возврат ЕстьТребуемыйОтбор(НастройкиКомпоновкиДанных.Отбор, ТребуемыеОтборы);
	
КонецФункции

Функция СписокСодержитОтборПоРодителю(НастройкиКомпоновкиДанных)
	
	ТребуемыеОтборы = Новый Массив;
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Родитель"));
	ТребуемыеОтборы.Добавить(Новый ПолеКомпоновкиДанных("Parent"));
	
	Возврат ЕстьТребуемыйОтбор(НастройкиКомпоновкиДанных.Отбор, ТребуемыеОтборы);
	
КонецФункции

Функция ЕстьТребуемыйОтбор(КоллекцияОтборов, ТребуемыеОтборы)
	
	Для Каждого Отбор Из КоллекцияОтборов.Элементы Цикл
		Если ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ОтборНайден = ЕстьТребуемыйОтбор(Отбор, ТребуемыеОтборы);
		Иначе
			ОтборНайден = ТребуемыеОтборы.Найти(Отбор.ЛевоеЗначение) <> Неопределено;
		КонецЕсли;
		
		Если ОтборНайден Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции


#КонецОбласти
