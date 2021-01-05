
public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max) 
{
	MarkNativeAsOptional("GuessSDKVersion"); 
	MarkNativeAsOptional("GetEngineVersion");

    CreateNative("GL_GetDatabase", Native_GetDatabase);

    CreateNative("GL_GetClientID", Native_GetClientID);
    CreateNative("GL_GetGuildId", Native_GetGuildId);
    CreateNative("GL_GetRankid", Native_GetRankid);	
    CreateNative("GL_GetImmune", Native_GetImmune);	

    CreateNative("GL_SetGuildId", Native_SetGuildId);	
    CreateNative("GL_SetImmune", Native_SetImmune);	   
    CreateNative("GL_SetRankid", Native_SetRankid);	   
    CreateNative("Gl_Engine", Native_Engine);
    CreateNative("Gl_Menu", Native_MainMenu);

    RegPluginLibrary("guild");
   
    return APLRes_Success;
}

public int Native_Engine(Handle hPlugin, int iNumParams)
{
	if (GetFeatureStatus(FeatureType_Native, "GetEngineVersion") == FeatureStatus_Available) 
	{
		switch (GetEngineVersion()) 
		{ 
			case Engine_SourceSDK2006: return false; 
			case Engine_CSS: return true; 
			case Engine_CSGO: return true; 
		} 
	} 
	else if (GetFeatureStatus(FeatureType_Native, "GuessSDKVersion") == FeatureStatus_Available) 
	{ 
		switch (GuessSDKVersion())
		{ 
			case SOURCE_SDK_EPISODE1: return false;
			case SOURCE_SDK_CSS: return true;
			case SOURCE_SDK_CSGO: return true;
		}
	}	
	return false; 
}

public int Native_MainMenu(Handle hPlugin, int iNumParams)
{
    int iClient = GetNativeCell(1);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
    {
        GuildMenu(iClient);
    }

    return 0;
}

public int Native_SetRankid(Handle hPlugin, int iNumParams)
{
    int iClient = GetNativeCell(1);
    int num2 = GetNativeCell(2);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && num2 > 0)
    {
        g_rank[iClient] = num2;
    }

    return 0;
}

public int Native_SetImmune(Handle hPlugin, int iNumParams)
{
    int iClient = GetNativeCell(1);
    int num2 = GetNativeCell(2);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && num2 >= 0 && num2 <= 100)
    {
        g_immune[iClient] = num2;
    }

    return 0;
}

public int Native_SetGuildId(Handle hPlugin, int iNumParams)
{
    int iClient = GetNativeCell(1);
    int IGuild = GetNativeCell(2);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && IGuild >= 0)
    {
        g_guild[iClient] = IGuild;
    }

    return 0;
}


public int Native_GetDatabase(Handle hPlugin, int iNumParams)
{

    return view_as<int>(CloneHandle(g_hDatabase, hPlugin));
}

public int Native_GetClientID(Handle hPlugin, int iNumParams)
{
    /*
        hPlugin - Указатель на плагин, который вызвал натив.
        iNumParams - Количество переданных аргументов.
       
        Исходя из прототипа:
        native int BS_GetClientID(int iClient);
        В натив передается 1 аргумент.
        Нумерация аргументов начинается с 1
       
        Для получения разных значений разных типов используются разные функции:
            int GetNativeArray(int param, any[] local, int size)    - Получение массива
            any GetNativeCell(int param)                            - Получение ячейки (обычно int, bool, float)
            any GetNativeCellRef(int param)                            - Получение ячейки при передаче по адресу (обычно int, bool, float)
            function GetNativeFunction(int param)                    - Получение адреса функции (каллбека)
            int GetNativeString(int param, char[] buffer, int maxlength, int &bytes)    - Получение строки
            int GetNativeStringLength(int param, int &length)        - Получение длины передаваемой строки
       
        Во всех ф-ях: int param это номер аргумента
       
        У нас тип int, поэтому используем GetNativeCell
    */
    int iClient = GetNativeCell(1);
    /*
    Тут мы имеем индекс игрока.
    Дальше опять 2 варианта:
        1) Проверить валиден ли он (в адекватных ли пределах, есть ли он на сервере, не бот ли)
        2) Переложить эти проверки на плагин, использующий натив и надеятся что всё будет хорошо.
    Для надежности пойдем по 1-му пути.
    */
    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
    {
        return g_iClientID[iClient];
    }

    return 0;
}


public int Native_GetGuildId(Handle hPlugin, int iNumParams)
{

    int iClient = GetNativeCell(1);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
    {

        return g_guild[iClient]; 
    }

    return 0;
}

public int Native_GetRankid(Handle hPlugin, int iNumParams)
{

    int iClient = GetNativeCell(1);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
    {
        return g_rank[iClient]; 
    }

    return 0;
}

public int Native_GetImmune(Handle hPlugin, int iNumParams)
{

    int iClient = GetNativeCell(1);

    if(iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
    {
        return g_immune[iClient]; 
    }

    return 0;
}

