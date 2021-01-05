#include <sourcemod>
#include <wcs_core>
#include <guild>

#pragma tabsize 0
#pragma newdecls required

int num[MAXPLAYERS+1];

public void OnPluginStart()
{
	RegConsoleCmd("gl_cat", CatCall);	
	RegConsoleCmd("gl_wcs_adm", GlRaceCall);				
}

public Action GlRaceCall(int iClient, int args)
{
	if(iClient != 0 && GL_GetGuildId(iClient) != 0)
	{	
		KeyValues kv = new KeyValues("Guilds");
		char path[PLATFORM_MAX_PATH],
			buffer[10],
			_buffer[250],
			str[2][250];	
		BuildPath(Path_SM, path, PLATFORM_MAX_PATH, "configs/guild/guilds.txt")
		kv.Rewind();
		
		if(kv.ImportFromFile(path))
		{
			IntToString(GL_GetGuildId(iClient), buffer, 10);

			if(kv.JumpToKey(buffer))
			{
				int perm;
				if(kv.JumpToKey("Admin"))
				{
					perm = kv.GetNum("perm_races");
					kv.GoBack();					
				}
				if(perm <= GL_GetRankid(iClient)){
					Menu admrc = new Menu(hndl_admrc);
					admrc.SetTitle("Выдача рас\n ");	

					if(kv.JumpToKey("Races"))
					{
						for(int i = 1; i <= kv.GetNum("count"); i++)
						{
							IntToString(i, buffer, 10);
							kv.GetString(buffer, _buffer, 250);
							ExplodeString(_buffer, "|", str, 2, 200);
							AddMenuItem(admrc, str[0], str[1]);
						}
					}
					DisplayMenu(admrc, iClient, MENU_TIME_FOREVER);
				}else{
					ReplyToCommand(iClient, "No access");
				}
			}
		}
		delete kv;
	}else{
		ReplyToCommand(iClient, "No access");
	}
	return Plugin_Handled;
}

public int hndl_admrc(Menu admrc, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete admrc;
        }
		case MenuAction_Select:
        {
			char buffer[250];
			admrc.GetItem(iItem, buffer, 20);
			num[iClient] = StringToInt(buffer);
			Menu view = new Menu(pl_v);
			view.SetTitle("Выберите игрока \n \n");
			
			char userId[32];
			
			for(int i = 1; i <= MaxClients; i++)
			{
				if(GL_GetGuildId(iClient) == GL_GetGuildId(i))
				{
					GetClientName(i, buffer, 128);
					IntToString(GetClientUserId(i), userId, 32);
					
					view.AddItem(userId, buffer, ITEMDRAW_DEFAULT);
				}
			} 
			if(!view.ItemCount)
			{
				Format(buffer, 128, "Нет доступных игрков");
				view.AddItem("", buffer, ITEMDRAW_DISABLED);
			}
			view.Display(iClient, MENU_TIME_FOREVER);
		}
	}
    return 0;
}

public int pl_v(Menu view, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete view;
        }
		case MenuAction_Select:
        {
			char Buffer[568];
			view.GetItem(iItem, Buffer, 568);	
            int target = GetClientOfUserId(StringToInt(Buffer));	
			GetClientAuthId(target, AuthId_Steam2, Buffer, 568, true); 
			ServerCommand("give_race \"%s\" %d", Buffer, num[iClient]);
			Gl_Menu(iClient); 
		}
	}
    return 0;		
}

public Action CatCall(int iClient, int args)
{
	if(iClient != 0 && GL_GetGuildId(iClient) != 0){
		KeyValues kv = new KeyValues("Guilds");
		char path[PLATFORM_MAX_PATH],
			buffer[10];
		BuildPath(Path_SM, path, PLATFORM_MAX_PATH, "configs/guild/guilds.txt")
		if(kv.ImportFromFile(path))
		{
			IntToString(GL_GetGuildId(iClient), buffer, 10);
			kv.Rewind();
			if(kv.JumpToKey(buffer))
			{
				int perm;
				if(kv.JumpToKey("Allow"))
				{
					perm = kv.GetNum("perm_cat");
					kv.GoBack();
				}
				if(GL_GetRankid(iClient) >= perm){
					if(kv.GetNum("Perm") == 1){
						WCS_BuildRacesMenu(iClient, kv.GetNum("Choose"), BRM_NO_REQLEVEL);
					}else if(kv.GetNum("Perm") == -1){
						WCS_BuildRacesMenu(iClient, kv.GetNum("Choose"), BRM_EXISTS_ONLY);
					}else if(kv.GetNum("Perm") == 2){
						WCS_BuildRacesMenu(iClient, kv.GetNum("Choose"), BRM_DEFAULT);
					}
				}
			}	
		}
		delete kv;
	}
	return Plugin_Handled;
}

