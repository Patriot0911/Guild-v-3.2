#include <sourcemod>

KeyValues KvImport(char[] path_a, char[] buffer)
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, PLATFORM_MAX_PATH, path_a);
	KeyValues hKeyValues = new KeyValues(buffer);
	if (hKeyValues.ImportFromFile(path) == false)
	{
		hKeyValues.ExportToFile(path);
	}
	hKeyValues.Rewind();
	return hKeyValues;
}

void db_Update(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		char szQuery[1024];
		FormatEx(szQuery, sizeof(szQuery), "UPDATE `guildv2_table` SET `guild` = %i,  `rank` = %i, `imune` = %i WHERE `id` = %i;", g_guild[iClient], g_rank[iClient], g_immune[iClient], g_iClientID[iClient]);
		g_hDatabase.Query(SQL_Callback_CheckError, szQuery);
	}
}

void RegGuildCommand()
{
	RegAdminCmd("sm_glidset", Commands_SetGl, ADMFLAG_ROOT);
	RegAdminCmd("sm_glmaster", Commands_GiveMaster, ADMFLAG_ROOT);	
	RegAdminCmd("sm_rkidset", Commands_SetRk, ADMFLAG_ROOT);
	RegAdminCmd("sm_imset", Commands_SetIm, ADMFLAG_ROOT);			
	
    RegConsoleCmd ( "gl" , Guild );
    RegConsoleCmd ( "guild" , Guild ); 	 
    RegConsoleCmd ( "sm_gl" , Guild ); 
	RegConsoleCmd ( "sm_guild" , Guild ); 	
	RegConsoleCmd ( "sm_пд" , Guild ); 
    RegConsoleCmd ( "sm_пгшдв" , Guild );
}