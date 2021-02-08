///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	ТекущийОбъект = ЭтотОбъект();
	ТекущийОбъект.ПрочитатьНастройки();
	ТекущийОбъект.ПрочитатьПризнакиПоддержкиБСП();
	ЭтотОбъект(ТекущийОбъект);
	
	ОбъектРегистрации = Параметры.ОбъектРегистрации;
	Расшифровка       = "";
	
	Если ТипЗнч(ОбъектРегистрации) = Тип("Структура") Тогда
		ТаблицаРегистрации = Параметры.ТаблицаРегистрации;
		ОбъектСтрокой = ТаблицаРегистрации;
		Для Каждого КлючЗначение Из ОбъектРегистрации Цикл
			Расшифровка = Расшифровка + "," + КлючЗначение.Значение;
		КонецЦикла;
		Расшифровка = " (" + Сред(Расшифровка,2) + ")";
	Иначе		
		ТаблицаРегистрации = "";
		ОбъектСтрокой = ОбъектРегистрации;
	КонецЕсли;
	
	ЧастиЗаголовка = Новый Массив;
	ЧастиЗаголовка.Добавить(НСтр("ru = 'Регистрация'"));
	ЧастиЗаголовка.Добавить(" ");
	ЧастиЗаголовка.Добавить(ТекущийОбъект.ПредставлениеСсылки(ОбъектСтрокой));
	ЧастиЗаголовка.Добавить(Расшифровка);
	
	Заголовок = Новый ФорматированнаяСтрока(ЧастиЗаголовка);
	
	ПрочитатьУзлыОбмена();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РазвернутьВсеУзлы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоУзловОбмена
//

&НаКлиенте
Процедура ДеревоУзловОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Поле = Элементы.ДеревоУзловОбменаНаименование Или Поле = Элементы.ДеревоУзловОбменаКод Тогда
		ОткрытьФормуРедактированияДругихОбъектов();
		Возврат;
	ИначеЕсли Поле <> Элементы.ДеревоУзловОбменаНомерСообщения Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("ДеревоУзловОбменаВыборЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("Узел", ТекущиеДанные.Ссылка);
	
	Подсказка = НСтр("ru = 'Номер отправленного'"); 
	ПоказатьВводЧисла(Оповещение, ТекущиеДанные.НомерСообщения, Подсказка);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУзловОбменаПометкаПриИзменении(Элемент)
	ИзменениеПометки(Элементы.ДеревоУзловОбмена.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура ПеречитатьДеревоУзлов(Команда)
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена();
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияОтУзла(Команда)
	ОткрытьФормуРедактированияДругихОбъектов();
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсеУзлы(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Истина;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Ложь;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			СтрокаУзла.Пометка = Не СтрокаУзла.Пометка;
			ИзменениеПометки(СтрокаУзла.ПолучитьИдентификатор())
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрацию(Команда)
	
	ЗаголовокВопроса = НСтр("ru = 'Подтверждение'");
	Текст = НСтр("ru = 'Изменить регистрацию ""%1""
	             |на узлах?'");
	
	Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьРегистрациюЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , ,ЗаголовокВопроса);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрациюЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Количество = ИзменениеРегистрацииПоУзлам(ДеревоУзловОбмена);
	Если Количество > 0 Тогда
		Текст = НСтр("ru = 'Регистрация %1 была изменена на %2 узлах'");
		ЗаголовокОповещения = НСтр("ru = 'Изменение регистрации:'");
		
		Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
		Текст = СтрЗаменить(Текст, "%2", Количество);
		
		ПоказатьОповещениеПользователя(ЗаголовокОповещения,
			ПолучитьНавигационнуюСсылку(ОбъектРегистрации),
			Текст,
			Элементы.СкрытаяКартинкаИнформация32.Картинка);
		
		Если Параметры.ОповещатьОбИзменениях Тогда
			Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
				Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
				ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена(Истина);
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек(Команда)
	ОткрытьФормуНастроекОбработки();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаНомерСообщения.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Пометка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ДеревоУзловОбменаНомерСообщения'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не выгружалось'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаКод.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаАвторегистрация.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаНомерСообщения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры
//

&НаКлиенте
Процедура ДеревоУзловОбменаВыборЗавершение(Знач Число, Знач ДополнительныеПараметры) Экспорт
	Если Число = Неопределено Тогда 
		// Отказ от ввода
		Возврат;
	КонецЕсли;
	
	ИзменитьНомерСообщенияНаСервере(ДополнительныеПараметры.Узел, Число, ОбъектРегистрации, ТаблицаРегистрации);
	
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена(Истина);
	РазвернутьВсеУзлы(ТекущийУзел);
	
	Если Параметры.ОповещатьОбИзменениях Тогда
		Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
			Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
			ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ТекущийВыбранныйУзел()
	ТекущиеДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Новый Структура("Наименование, Ссылка", ТекущиеДанные.Наименование, ТекущиеДанные.Ссылка);
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастроекОбработки()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Настройки";
	ОткрытьФорму(ТекИмяФормы, , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияДругихОбъектов()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Форма";
	Данные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если Данные <> Неопределено И Данные.Ссылка <> Неопределено Тогда
		ТекПараметры = Новый Структура("УзелОбмена, ИдентификаторКоманды, ОбъектыНазначения", Данные.Ссылка);
		ОткрытьФорму(ТекИмяФормы, ТекПараметры, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсеУзлы(УзелФокуса = Неопределено)
	НайденныйУзел = Неопределено;
	
	Для Каждого Строка Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Идентификатор = Строка.ПолучитьИдентификатор();
		Элементы.ДеревоУзловОбмена.Развернуть(Идентификатор, Истина);
		
		Если УзелФокуса <> Неопределено И НайденныйУзел = Неопределено Тогда
			Если Строка.Наименование = УзелФокуса.Наименование И Строка.Ссылка = УзелФокуса.Ссылка Тогда
				НайденныйУзел = Идентификатор;
			Иначе
				Для Каждого Подстрока Из Строка.ПолучитьЭлементы() Цикл
					Если Подстрока.Наименование = УзелФокуса.Наименование И Подстрока.Ссылка = УзелФокуса.Ссылка Тогда
						НайденныйУзел = Подстрока.ПолучитьИдентификатор();
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если УзелФокуса <> Неопределено И НайденныйУзел <> Неопределено Тогда
		Элементы.ДеревоУзловОбмена.ТекущаяСтрока = НайденныйУзел;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменениеРегистрацииПоУзлам(Знач Данные)
	ТекущийОбъект = ЭтотОбъект();
	КоличествоУзлов = 0;
	Для Каждого Строка Из Данные.ПолучитьЭлементы() Цикл
		Если Строка.Ссылка <> Неопределено Тогда
			УжеЗарегистрировано = ТекущийОбъект.ОбъектЗарегистрированНаУзле(Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
			Если Строка.Пометка = 0 И УжеЗарегистрировано Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Ложь, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КоличествоУзлов = КоличествоУзлов + Результат.Успешно;
			ИначеЕсли Строка.Пометка = 1 И (Не УжеЗарегистрировано) Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Истина, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КоличествоУзлов = КоличествоУзлов + Результат.Успешно;
			КонецЕсли;
		КонецЕсли;
		КоличествоУзлов = КоличествоУзлов + ИзменениеРегистрацииПоУзлам(Строка);
	КонецЦикла;
	Возврат КоличествоУзлов;
КонецФункции

&НаСервере
Функция ИзменитьНомерСообщенияНаСервере(Узел, НомерСообщения, Данные, ИмяТаблицы = Неопределено)
	Возврат ЭтотОбъект().ИзменитьРегистрациюНаСервере(НомерСообщения, Истина, Узел, Данные, ИмяТаблицы);
КонецФункции

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПолучитьИмяФормы(ТекущийОбъект = Неопределено)
	Возврат ЭтотОбъект().ПолучитьИмяФормы(ТекущийОбъект);
КонецФункции

&НаСервере
Процедура ИзменениеПометки(Строка)
	ЭлементДанных = ДеревоУзловОбмена.НайтиПоИдентификатору(Строка);
	ЭтотОбъект().ИзменениеПометки(ЭлементДанных);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУзлыОбмена(ТолькоОбновить = Ложь)
	ТекущийОбъект = ЭтотОбъект();
	Дерево = ТекущийОбъект.СформироватьДеревоУзлов(ОбъектРегистрации, ТаблицаРегистрации);
	
	Если ТолькоОбновить Тогда
		// Обновляем некоторые поля текущим данным.
		Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
				СтрокаДерева = Дерево.Строки.Найти(СтрокаУзла.Ссылка, "Ссылка", Истина);
				Если СтрокаДерева <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(СтрокаУзла, СтрокаДерева, "Пометка, ИсходнаяПометка, НомерСообщения, НеВыгружалось");
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		// Переформируем полностью
		ЗначениеВРеквизитФормы(Дерево, "ДеревоУзловОбмена");
	КонецЕсли;
	
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			ТекущийОбъект.ИзменениеПометки(СтрокаУзла);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
