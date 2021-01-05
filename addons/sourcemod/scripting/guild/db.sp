#include <sourcemod>


public void ConnectCallBack(Database hDatabase, const char[] sError, any data) 
{
	if (hDatabase == null)	
	{
		SetFailState("Database failure: %s", sError); 
		return;
	}
	g_hDatabase = hDatabase;
	
	SQL_LockDatabase(g_hDatabase); 

	g_hDatabase.Query(SQL_Callback_CheckError,	"CREATE TABLE IF NOT EXISTS `guildv2_table` (\
															`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
															`auth` VARCHAR(32) NOT NULL,\
															`name` VARCHAR(32) NOT NULL default 'unknown',\															
															`guild` INTEGER NOT NULL default '0',\
															`imune` INTEGER NOT NULL default '0',\															
															`rank` INTEGER NOT NULL default '0');");												
	SQL_UnlockDatabase(g_hDatabase);
	g_hDatabase.SetCharset("utf8");
}


public void SQL_Callback_CheckError(Database hDatabase, DBResultSet results, const char[] szError, any data)
{
	if(szError[0])
	{
		LogError("SQL_Callback_CheckError: %s", szError);
	}
}


// Игрок подключился     
public void OnClientPostAdminCheck(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		char szQuery[256], szAuth[32];
		GetClientAuthId(iClient, AuthId_Engine, szAuth, sizeof(szAuth), true); 
		FormatEx(szQuery, sizeof(szQuery), "SELECT `id`, `guild`, `rank`, `imune` FROM `guildv2_table` WHERE `auth` = '%s'; ", szAuth);	// Формируем запрос
		g_hDatabase.Query(SQL_Callback_SelectClient, szQuery, GetClientUserId(iClient)); 
	}
}
public void SQL_Callback_SelectClient(Database hDatabase, DBResultSet hResults, const char[] sError, any iUserID)
{
	if(sError[0]) 
	{
		LogError("SQL_Callback_SelectClient: %s", sError); 
		return; 
	}

	int iClient = GetClientOfUserId(iUserID);


	if(iClient)
	{
		char szQuery[256], szName[MAX_NAME_LENGTH*2+1];
		GetClientName(iClient, szQuery, MAX_NAME_LENGTH);
		g_hDatabase.Escape(szQuery, szName, sizeof(szName)); 
	
	
		if(hResults.FetchRow())	 
		{

			g_iClientID[iClient]		= hResults.FetchInt(0);				
			g_guild[iClient]		= hResults.FetchInt(1);
			g_rank[iClient]		= hResults.FetchInt(2);
			g_immune[iClient]		= hResults.FetchInt(3);

			FormatEx(szQuery, sizeof(szQuery), "UPDATE `guildv2_table` SET `name` = '%s' WHERE `id` = %i;", szName, g_iClientID[iClient]);
			g_hDatabase.Query(SQL_Callback_CheckError, szQuery);
			
		}else{ 
		
			g_iClientID[iClient]		= 0;				
			g_guild[iClient]		= 0;
			g_rank[iClient]		= 0;
			g_immune[iClient]		= 0;
			
			char szAuth[32];		
			GetClientAuthId(iClient, AuthId_Engine, szAuth, sizeof(szAuth));
			FormatEx(szQuery, sizeof(szQuery), "INSERT INTO `guildv2_table` (`auth`, `name`) VALUES ('%s', '%s');", szAuth, szName);
			g_hDatabase.Query(SQL_Callback_CreateClient, szQuery, GetClientUserId(iClient));		
		}
	}
}


public void SQL_Callback_CreateClient(Database hDatabase, DBResultSet results, const char[] szError, any iUserID)
{
	if(szError[0])
	{
		LogError("SQL_Callback_CreateClient: %s", szError);
		return; 
	}
	
	int iClient = GetClientOfUserId(iUserID);
	if(iClient)
	{
		g_iClientID[iClient] = results.InsertId;
	}
}
public void OnClientDisconnect(int iClient)
{
	db_Update(iClient);
}


