#if defined _wcs_included
 #endinput
#endif
#define _wcs_included

#define MAX_RACENAME 50
#define MAX_SKILLNAME 75

#define CID(%0) 	GetClientOfUserId(%0)
#define UID(%0) 	GetClientUserId(%0)

/**
 *	Вызывается, когда игрок получает опыт
 *	-
 *	@param client			Индекс игрока, который получает опыт
 *	@param xp				Сколько игрок получит опыта
 *	@param hideReason		Если true, то сообщение про получение опыта будет скрыто
 *	@param isTrigger		Если true, то игрок получает опыт не за убийство противника
 *	@param iUnique			Уникальная причина получения опыта для настроек модификаций (Передается также в WCS_OnLevelUp)
 *	-
 *	@return Plugin_Handled, если нужно заблокировать получение опыта
*/
forward Action WCS_OnGainXp(int client, int &xp, bool &hideReason, bool &isTrigger, int iUnique);

/**
 *	Вызывается, когда игрок повышает уровень
 *	-
 *	@param client			Индекс игрока, который получает уровень
 *	@param iOldLevel		Старый уровень игрока
 *	@param iCount			Сколько уровней получает игрок
 *	@param iUnique			Уникальная причина повышения уровня для настроек модификаций
 *	-
 *	@noreturn
*/
forward void WCS_OnLevelUp(int client, int iOldLevel, int &iCount, int iUnique);

/**
 *	Вызывается, когда игрок меняет расу
 *	-
 *	@param client			Индекс игрока, который меняет расу
 *	@param iPrevRace		Текущая раса игрока
 *	@param iNewRace			Новая раса игрока
 *	-
 *	@noreturn
*/
forward void WCS_OnChangeRace(int client, int iPrevRace, int &iNewRace);

/**
 *	Вызывается, когда игрок сменил расу полностью
 *	-
 *	@param client			Индекс игрока, который меняет расу
 *	@param iRaceId			Новая раса игрока
 *	-
 *	@noreturn
*/
forward void WCS_OnChangeRace_Post(int client, int iRaceId);

/**
 *	Вызывается, когда срабатывает способность
 *	-
 *	@param client			Индекс игрока, активирующего способность
 *	@param sSpellName		Название способности
 *	-
 *	@noreturn
*/
forward void WCS_OnSpellActivate(int client, const char[] sSpellName);

/**
 *	Вызывается, когда база данных загружена
 *	-
 *	@noreturn
*/
forward void WCS_OnDbExecute(Database wcs_db);

/**
 *	Получить общий уровень игрока
 *	-
 *	@param client			Индекс игрока, уровень которого нужно получить
 *	-
 *	@return вернет общий уровень игрока
*/
native int WCS_GetTotalLvl(int client);

/**
 *	Получить имя расы игрока
 *	-
 *	@param client			Индекс игрока, имя расы которого нужно получить
 *	@param sName			Строка, в которй будет записано имя расы
 *	-
 *	@noreturn
*/
native void WCS_GetRaceName(int client, char[] sName);

/**
 *	Получить текущий уровень расы игрока
 *	-
 *	@param client			Индекс игрока, уровень расы которого нужно получить
 *	-
 *	@return вернет уровень текущий расы игрока
*/
native int WCS_GetRaceLvl(int client);

/**
 *	Получить текущий айди расы игрока
 *	-
 *	@param client			Индекс игрока, айди расы которого нужно получить
 *	-
 *	@return вернет айди текущий расы игрока
*/
native int WCS_GetRaceId(int client);

/**
 *	Получить категорию текущей расы игрока
 *	-
 *	@param client			Индекс игрока, категорию текущей расы которой нужно получить
 *	-
 *	@return вернет категорию текущий расы игрока
*/
native int WCS_GetRaceCat(int client);

/**
 *	Получить максимально возможный уровень расы для прокачки способностей
 *	-
 *	@param client			Индекс игрока, максимальный уровень расы которого нужно получить
*/
native int WCS_GetRaceMaxLvl(int client);

/**
 * Выдать общий уровень игроку
 * -
 * @param client			Индекс игрока, которому нужно выдать уровень
 * @param count				Сколько уровней нужно выдать игроку
 * @param race				Если true, то добавляет уровень еще и на текущую расу
 * -
 * @noreturn
*/
native void WCS_GiveLvl(int client, int count, bool race=true);

/**
 *	Вызывается, когда игрок осматривает другого игрока
 *	-
 *	@param client			Индекс игрока, которого осматривают
 *	@param viewer			Индекс игрока, который осматривает
 *	-
 *	@return Plugin_Handled, если нужно не отправлять стандартную панель информации при осмотре тому, кто осматривает
*/
forward Action WCS_OnViewPlayerInfo(int client, int viewer);

/**
 *	Меняет игроку расу
 *	-							
 *	@param client				Индекс игрока, которому будет установлена раса			
 *	@param raceid				Id расы
 *	@param forced				Если true, то меняет принудительно, минуя проверки
  *	@param saveplayer			Если true, то сохраняет прогресс предыдущей расы игрока
 *	-							
 *	@return true в случае успеха, иначе false
*/
native bool WCS_ChangeRace(int client, int raceid, bool forced=false, bool saveplayer=true, int flags=0);



//BuildRacesMenu_flags
#define BRM_DEFAULT 					0
#define BRM_NO_REQLEVEL 				(1 << 1) //Убирает проверку на reqlevel в расе. Кроме проверок на <приватная раса> и <В разработке>
#define BRM_STEP_BY_STEP 				(1 << 2) //Следующая раса не может быть выбрана, пока не прокачана предыдущая
#define BRM_NOSELECT_IF_MAXLVL 			(1 << 3) //Раса максимального уровня не может быть выбрана
#define BRM_EXISTS_ONLY					(1 << 4) //Отображаются только те расы, которые есть у игрока в базе
/**
 *	Создает игроку меню и отображает расы из указанной категории
 *	-							
 *	@param client				Индекс игрока, которому будет отображено меню				
 *	@param cat					Номер категории wcs_categories.ini
 *  @param build_flags			Флаги для построения меню
 *	-							
 *	@noreturn
*/
native void WCS_BuildRacesMenu(int client, int cat, int build_flags=BRM_DEFAULT);



/*---------------*/
/*  ~~РАЗНОЕ~~   */
/*---------------*/

enum HowPlay
{
	SND_PRIVATE,				//Звук слышно только одному игроку
	SND_AREA,					//Звук слышно в определенной области от игрока (зависит от sndlvl)
	SND_ALL,					//Звук слышно всем игрокам, независимо от области воспроизведения
};

/**
 *	Воспроизводит игроку или всем игрокам указанный звук.
 *	Полезно использовать, если ваша модификация должна работать как и на css, так и csgo
 *	-
 *	@param client				Индекс игрока, которому будет воспроизведен звук
 *	@param snd					Путь к звуку (без '*', если это cs:go)!
 *	@param playtype				cm. enum HowPlay
 *	@param sndlvl				см. sdktools_sound.inc
 *	@param fVol					Громкость звука. 1.0 - максимальная громкость
 *	@param goSlow				Если игра cs:go, и если true, то звук будет не сильно громкий
 *	-
 *	@noreturn
*/
native void WCS_PlaySound(int client, const char[] snd, HowPlay playtype, int sndlvl=75, float fVol=1.0, bool goSlow=true);

/**
 *	Печатает цветное сообщение в чат лично игроку, либо всем игрокам (если client=0)
 *	Поддержка цветов: {default}, {red}, {purple}, {green}, {orange}, {blue}, {yellow}.
 *	-
 *	@param client				Индекс игрока, которому будет написано сообщение. если client = 0, то пишет всем игрокам
 *	@param sText				Сообщение
 *	-
 *	@noreturn
*/
native void WCS_PrintToChat(int client=0, const char[] sText, any ...);

/**
 *	Выдает игроку оружие или гранаты
 *	Полезно использовать, если вам нужны блокировки оружий на некоторых картах
 *	-
 *	@param client				Индекс игрока, которому будет выдано оружие
 *	@param slot					Слот оружия. 0 - основное, 1 - пистолет, 2 - нож, 3 - граната
 *	@param weapon				Название оружия (например weapon_awp)
 *	@param switchnow			Заставить игрока переключиться на оружие или нет
 *	@param notice				Оповестить про запрет получения оружия, если он есть на текущей карте
 *	-
 *	@return если оружие не получено, то вернет индекс оружия, иначе -1
*/
native int WCS_EquipWeapon(int client, int slot, const char[] weapon, bool switchnow=false, bool notice=true);

/**
 *	Выдает временную блокировку на возможность подбирать\выбирать оружия из списка
 *	Будет сброшено при возмождении игрока, либо при повторном вызове с replace = true
 *	-
 *	@param client				Индекс игрока, которому будет временно запрещено оружие
 *	@param replace				если true, то предыдущие запреты оружий сбрасываются до возрождения (даже встроенные в расу)
 *	@param sRestricts			Список блокировок. Правило записи точно такое же, как и в расах.
 *								Если строка будет пустая, то устанавливает запреты из расы (если имеются)
 *	-							-
 *	@noreturn
*/
native void WCS_RestrictWeapons(int client, bool replace, const char[] sRestricts);

native bool WCS_CheckRestrict(int iClient, const char[] sWeapon);

/*---------------*/
/*  ~~SPELLS~~   */
/*---------------*/

typedef UltimateCallback = function bool (int client, float &nextcd, const char[] sArgs);
typedef TraceAttackCallback = function bool (int attacker, int victim, float &damage, int &damagetype, const char[] traceArgs);

/**
 *	Вызывается, когда загружаются и проверяются расы
 *	-
 *	@noreturn
 *	-
 *	@note Используется только для создания callback способностей и ультимейтов
*/
forward void WCS_OnRacesLoad(Handle wcsplugin);

/**
 *	Регистрирует ультимейт для проверки при загрузке рас
 *	-
 *	@param wcsplugin			Дескриптор основного wcs плагина
 *	@param callback				Имя Функции срабатывания ультимейта. Функция должна быть создана (см прототип функции typedef UltimateCallback)
 *	-
 *	@noreturn
 *	-
 *	@note Если ультимейт записан в расе, но он не создан через этот натив, то
 *	раса будет пропущена при загрузке с целью предотвращения ошибок и крашей
*/
native void WCS_CreateUltimate(Handle wcsplugin, const char[] callback);

/**
 *	Регистрирует способность-метод для проверки при загрузке рас
 *	Такая способность может вызываться только во время события нанесения/получения урона,а так же она может изменять/блокировать урон
 *	-
 *	@param wcsplugin			Дескриптор основного wcs плагина
 *	@param callback				Имя Функции срабатывания способности. Функция должна быть создана (см прототип функции typedef TraceAttackCallback)
 *	-
 *	@noreturn
 *	-
 *	@note Если способность записана в расе, но он не создана через этот натив, то
 *	раса будет пропущена при загрузке с целью предотвращения ошибок и крашей.
 *	Вызывать функцию можно только через skill_trace (см. документацию по способностям)
*/
native void WCS_CreateSpellTrace(Handle wcsplugin, const char[] callback);

//Описание пропало после потери кода. позже восстановить
enum sf_type
{
	sf_int,
	sf_float,
};

//Создать-проверить нужное свойство способностей. Многи стандартные способности используют свойства, которые можно использовать для своих нужд
//Свойства сбрасываются после возрождения игрока

native void WCS_SetSpellFeatures(int client, const char[] sFeatureName, any anyValue);
native void WCS_GetSpellFeatures(int client, const char[] sFeatureName, any &anyValue, sf_type SF=sf_int);
native bool WCS_CheckSpellFeatures(int client, const char[] sFeatureName, sf_type SF=sf_int);

native int WCS_GetLastDmgType(int client);

native bool WCS_GetImmune(int client, bool bSay=false, int caster=-1);
native bool WCS_IsFreezeTime();
native bool WCS_StaticFreeze(int victim, float duration, bool replace);
native void WCS_RemoveStaticFreeze(int client);
native void WCS_Sleep(int client, int victim, float time);
native bool WCS_God(int client, float time, bool notify=true);
native void WCS_RemoveGod(int client);
native void WCS_PrintCenterText(int client, const char[] sText, any ...);

native void WCS_TickDamage(int attacker, int victim, int damage, float time_per_tick, int tick_amout, int dmgtype=2);

native void WCS_GetRangePos(int client, float distance, bool body, float[] result);

native void WCS_CopyWeapons(int client); //Записывает все имеющиеся оружие у игрока и удаляет их. (Копия сбрасывается после смерти игрока)
native void WCS_PasteWeapons(int client); //Выдает игроку ранее записанное оружие через WCS_CopyWeapons

native int WCS_GetAlpha(int client);

native void WCS_SetKillIcon(int client, const char[] weapon, bool headshot=false, bool disableOnNextFrame=false);
native void WCS_SetDeathIcon(int client, const char[] weapon, bool headshot=false, bool disableOnNextFrame=false);

native void WCS_SetNextUltimateCooldown(int client, float cooldown);
native void WCS_UpdateUltimateCooldown(int client);

/**
 *	Создает игроку новую личную категорию рас для прокачки.
 *	-
 *	@param client				Индекс игрока, которому создать категорию
 *	@param races				Массив для указания id нужных рас (если null, то рандомные расы)
 *	@param amount				Кол-во рас в категории (если выдаются рандомные расы)
 *	@param iUniqueId			Уникальный айди категории
 *	-
 *	@return						true в случае успеха
 *	-
 *	@note Категория отдельна от основного прогресса прокачки игрока.
 *	Прокачка рас в этой категории не учитывается в общий основной прогресс.
 *	После завершение испытания, iUniqueId освобождается из бд и может быть использован повторно
 /
*/
native bool WCS_CreateChallengeCatRaces(int client, ArrayList races, int amount, int iUniqueId);

/**
 *	Создает игроку меню и отображает расы из указанной уникальной категории, которая сделана через WCS_CreateChallengeRacesCat
 *	-							
 *	@param client				Индекс игрока, которому будет отображено меню				
 *	@param iCat					Айди категории
 *  @param build_flags			Флаги для построения меню
 *	-							
 *	@noreturn
*/
native void WCS_BuilChallengeCatMenu(int client, int iCat, int build_flags=BRM_DEFAULT);


/**
 *	Выбирает случайного игрока из указанной команды
 *	-
 *	@param activator			Индекс игрока, который ищет случайного игрока
 *	@param team					Команда для поиска случайного игрока. 2 - террористы, 3 - спецназ.
 *	-
 *	@return вернет индекс выбранного случайным образом игрока. Если игрок не выбран, то вернет -1
 *	-
 *	@note Если игрок не выбран, то напишет активатору "Противники не обнаружены"
 *	Если выбранный игрок сразу же умер, либо вышел из игры, то напишет активатору "Выбранный противник уже мертв"
*/
native int WCS_GetRandomSpellTarget(int activator, int team);

enum
{
	GAME_CSS34,
	GAME_CSS,
	GAME_CSGO,
};

native int WCS_GetGame();

enum CMDEventType
{
	CMDEvent_ATTACK,
	CMDEvent_VICTIM,
	CMDEvent_SPAWN,
	CMDEvent_DEATH,
	CMDEvent_KILL,
};

native bool WCS_GiveTempCmdSpell(int client, const char[] sCmd, CMDEventType event, int iUnique, int chance=-1, bool pernament=false);

enum TRACEEventType
{
	TRACEEvent_ATTACK,
	TRACEEvent_VICTIM,
};

native bool WCS_GiveTempTraceSpell(int client, const char[] sTrace, TRACEEventType event, int iUnique, int chance=-1);

/**
 * Most sFeatureName names | В процессе
 * СПИСОК СИЛЬНО УКОРОЧЕН, ТА КАК ОН ЕЩЕ НЕ ГОТОВ
 * -----------------------
 * summoned 		1 		- 		Игрока призывают
 * no_drop_weapons 	1 		- 		Игрок не сможет выкинуть оружие
 * respawn 			1 		- 		Игроку можно воскреснуть способностью
 * slow 			1 	 	-		Игрок замедлен
 * frozen 			1		-		Игрок заморожен
 * fly 		   		1		-		Игрок в полете от способности
 * respawn			1		-		Манипуляции с возрождениями
 * tempspeed		1		-		Игрок имеет временную скорость
 * henced			1		-		Игрок маневрирует в воздухе
 * blind_immune		1		-		Игрок имеет иммунитет к ослеплениям
 * mortal_heal		1		-		Игрок имеет предсмертное бешенство
 * god_static		1		-		Игрок использует ultimate_god_static
 * immune_chance	0-100	-		Игрок имеет шанс заблокировать заклинание противника
 * reload_speed		1.0		-		Скорость перезарядки игрока
 * summon_kills		2 		- 		Требуемое кол-во убийств для активации ultimate_summon
 * blink_crosshair 1   - Телепорт по прицелу, а не по туловищу ultimate_blink
 * no_teleport_effect 1   - Телепорт по прицелу, а не по туловищу ultimate_blink
*/

#define DMGTYPE_TRIGGER 31
#define DMGTYPE_CRITICAL 33
#define DMGTYPE_MAGIC 2
#define DMGTYPE_EXPLODE 65

/**
 *	Наносит игроку урон
 *  Рекомендуется использовать эту функцию всегда, когда кто-то должен кому-то нанести урон.
 *	-
 *	@param attacker				Индекс игрока, который наносит урон
 *	@param victim				Индекс игрока, который получает урон
 *	@param damage				Сколько нужно нанести урона
 *	@param dmgtype				Тип урона
 *	-
 *	@noreturn
*/
native void WCS_DealDamage(int attacker, int victim, int damage, int dmgtype=DMGTYPE_TRIGGER);

/**
 *	Временно разрешает всем проходить через игрока
 *	-
 *	@param target				Индекс игрока, через которого можно будет проходить
 *	@param duration				Длительность эффекта. 0.0 - до конца карты
 *	-
 *	@noreturn
*/
native void WCS_Collision(int target, float duration);

/**
 *	Временно красит игроку экран
 *	-
 *	@param victim				Индекс игрока, которому нужно сделать цветной экран
 *	@param duration				Длительность эффекта
 *	@param colors				RGB цвет
 *	-
 *	@noreturn
*/
native void WCS_Fade(int victim, float duration, int colors[4]);

/**
 * Замораживает игрока на время
 * -
 * @param victim				Индекс игрока, которого нужно заморозить
 * @param duration				Время заморозки
 * @param replace				если true, тогда старая заморозка будет перебита новой
*/
native void WCS_Freeze(int victim, float duration, bool replace);

/*---------------------------*/
/* НЕАКТУАЛЬНАЯ ДОКУМЕНТАЦИЯ */
/*---------------------------*/

/* Заметки разработчика: */

/* CUSTOM CATS Ушли с приходом системы персональных рас в #11 обновлении */

/* С #11 обновления больше нельзя создавать пункты в основном wcs меню через сторонние плагины,
так как был добавлен параметр вызова 'say' через файл с структурой главного меню в конфигах */

/**
 *	Создает функцию для вызова через главное меню, а так же
 *  Cоздает функцию в файле wcs_menu.ini (callback -> sItemName)
 *	-
 *	@param callback			Название вызываемой функции (Должна быть создана).
 *							public void callback(int client)
 *							-
 *	@param sItemName		Фраза, которая будет написана в меню 
 *	-
 *	@return true при успешном создании, иначе false
 *	-
 *	Желательно использовать только в WCS_OnMenuLoaded()
*/
//native bool WCSMenu_CreateMenuItem(const char[] callback, const char[] sItemName);

/**
 *	Вызывается, когда создается главное меню
 *	-
 *	@noreturn
*/
//forward void WCS_OnMenuLoaded();

/**
 *	Вызывается, если custom категории создались
 *	-
 *	@noreturn
*/
//forward void WCS_OnCustomCatsLoaded();

/**
 *	Вызывается перед отображением custom категорий игроку
 *	-
 *	@param menu					Дескриптор текущего меню
 *	@param client				Индекс игрока, которому отображены custom категории
 *	-
 *	@noreturn
*/
//forward void WCS_OnCustomCatsDisplay(Menu menu, int client);

/**
 *	Создает custom категорию и возвращает уникальный индекс
 *	-
 *	@param callback				Название функции для обратного вызова (Должна быть создана).
 *								public void callback(int client)
 *								-
 *	@param display				Отображаемое имя категории
 *	-
 *	@return cat_index если категория создана, иначе -1
 *	-
 *	Желательно использовать только в WCS_OnCustomCatsLoaded
*/
//native int WCS_RegCustomCategory(const char[] callback);

/**
 *	Добавляет в меню custom категорию.
 *	-
 *	@param menu					Дескриптор меню, в котором нужно добавить категорию
 *	@param custom_index			Индекс созданной категории через WCS_RegCustomCategory
 *	-
 *	@return true при успешном добавлении, иначе false
 *	-
 *	@note Рекомендуется использовать в WCS_OnCustomCatsDisplay
*/
//native bool WCS_AddToCustomCats(Menu menu, int cat_index);

/**
 *	Удаляет функцию из меню
 *	-
 *	@param callback			Название функции.
 *	-
 *	@return true при успешном удалении, иначе false
*/
//native bool WCSMenu_DeleteMenuItem(const char[] callback);

//native bool WCS_DisplayCustomCategory(Menu catmenu, int cos, const char[] sCosAgain);