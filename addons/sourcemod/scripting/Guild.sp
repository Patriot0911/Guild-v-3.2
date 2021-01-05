#include <sourcemod>
#include <wcs_core>
#include <cstrike>
#include <clientprefs>
#include <guild>

#pragma tabsize 0

#include "guild/global.sp"
#include "guild/func.sp"
#include "guild/db.sp"
#include "guild/admin.sp"
#include "guild/api.sp"


public Plugin myinfo =
{
	name = "Guilds",
	author = "Patriot",
	version = "3.2"
};

public void OnPluginStart()
{
	Database.Connect(ConnectCallBack, "guildv2"); 
	
	RegGuildCommand();
}
public Action Guild(int iClient, int args)
{	
	if(g_guild[iClient] != 0)
	{
		GuildMenu(iClient);
	}else{
		GuildZeroMenu(iClient);
	}
}
void GuildMenu(int iClient)
{	
	Menu g_mn = new Menu(g_mn_hndl);
	KeyValues 	Mn 	= KvImport("configs/guild/Main.txt", "Main");
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");		
    char buffer[124],
		nums[5],
		str[4][300],
		id[5],
		buffer1[245];
	Mn.Rewind();	
	g_mn.SetTitle("Гильдия\n ");	
	for(int i = 1; i <= Mn.GetNum("Count"); i++)
	{
		IntToString(i, nums, 5);
		Mn.GetString(nums, buffer, 124);
		Mn.GetString(buffer, buffer1, 245); 
		ExplodeString(buffer1, "|", str, 4, 100);
		if(GL_GetGuildId(iClient) == StringToInt(str[3]) || 0 == StringToInt(str[3])){
			GS.Rewind();
			IntToString(GL_GetGuildId(iClient), id, sizeof(id));
			if(GS.JumpToKey(id)){
				if(GS.JumpToKey("Allow"))
				{
					if(GL_GetRankid(iClient) >= GS.GetNum(str[2]) && GS.GetNum(str[2]) != -1)
					{
						AddMenuItem(g_mn, buffer1, buffer, ITEMDRAW_DEFAULT);
					}else{
						AddMenuItem(g_mn, buffer1, buffer, ITEMDRAW_DISABLED);					
					}
				}
			}
		}
	}
	delete GS;
	delete Mn;
	g_mn.Display(iClient, MENU_TIME_FOREVER);		
}
public int g_mn_hndl(Menu g_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete g_mn;
        }
		case MenuAction_Select:
        {
			char buffer[245],
				fun[3][364];
			g_mn.GetItem(iItem, buffer, 245);
			ExplodeString(buffer, "|", fun, 4, 200);
			if(StrEqual(fun[0], "cmd"))
			{
				ClientCommand(iClient, fun[1]);
			}else
			if(StrEqual(fun[0], "func"))
			{
				if(StrEqual(fun[1], "Profile"))
				{
					Profile(iClient);
				}
				if(StrEqual(fun[1], "Leave"))
				{
					Leave(iClient);
				}
				if(StrEqual(fun[1], "Ranks"))
				{
					Ranks(iClient);
				}
				if(StrEqual(fun[1], "Info"))
				{
					Info(iClient);
				}
				if(StrEqual(fun[1], "Invite"))
				{
					Invite(iClient);
				}
				if(StrEqual(fun[1], "AdminC"))
				{
					AdminC(iClient);
				}				
			}
		}		
    }
    return 0;	
}
void Ranks(int iClient)
{
	char buffer[256];	
	Menu rn_mn = new Menu(rn_mn_hndl);
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");		
	GS.Rewind();

	SetMenuTitle(rn_mn, "Ранги\n  ");
	if(GS.GotoFirstSubKey())
	{	
		do
		{
			GS.GetSectionName(buffer, 124);
			if(GL_GetGuildId(iClient) == StringToInt(buffer))
			{
				if(GS.JumpToKey("Ranks"))
				{
					int n = GS.GetNum("count");
					for(int i = 1; i <= n; i++)
					{
						IntToString(i, buffer, 10);
						GS.GetString(buffer, buffer, 256);
						AddMenuItem(rn_mn, "", buffer, ITEMDRAW_DISABLED);
					}
				}
			}
		} while (GS.GotoNextKey());	
	}
	delete GS;
	rn_mn.Display(iClient, MENU_TIME_FOREVER);
}
public int rn_mn_hndl(Menu rn_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			GuildMenu(iClient);
			delete rn_mn;			
        }
    }
    return 0;	
}

void Profile(int iClient)
{
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");		
	GS.Rewind();
		
	if(GS.GotoFirstSubKey())
	{	
		do
		{
			char Buffer[256],
				buffer1[125];
			GS.GetSectionName(Buffer, sizeof(Buffer));
			if(GL_GetGuildId(iClient) == StringToInt(Buffer))
			{
				Panel pf_pnl = new Panel();
				pf_pnl.SetTitle("Мой профиль \n \n");
				GS.GetString("Name", buffer1, 125);
				Format(Buffer, 256, "Ваша гильдия:\n %s", buffer1);
				pf_pnl.DrawText(Buffer);	

					if (GS.JumpToKey("Ranks"))
					{
						IntToString(GL_GetRankid(iClient), Buffer, 24);
						GS.GetString(Buffer, buffer1, 125);
						Format(Buffer, 256, "Ваш ранг:\n %s", buffer1);					
						pf_pnl.DrawText(Buffer);							
					}
					Format(Buffer, 256, "Ваш иммунитет: %i%\n ", g_immune[iClient]);					
					pf_pnl.DrawText(Buffer);						
				
					SetPanelCurrentKey(pf_pnl, 8);
					pf_pnl.DrawItem("Назад");							
					SetPanelCurrentKey(pf_pnl, 8);
					pf_pnl.DrawItem("Выход");							
					
					pf_pnl.Send(iClient, pf_pnl_hndl, 0);
				delete pf_pnl;	
			}
		} while (GS.GotoNextKey());	
	}
	delete GS;
}
public int pf_pnl_hndl(Menu pf_pnl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete pf_pnl;			
        }
		case MenuAction_Select:
        {
			if(iItem == 8){
				GuildMenu(iClient);
			}
			if(iItem == 9){
				delete pf_pnl;
			}
		}
    }
    return 0;	
}
void Leave(int iClient)
{
	Panel gllv_pnl = new Panel();
	gllv_pnl.SetTitle("Выход \n \n");
	gllv_pnl.DrawText("Вы точно хотите покинуть ");	
	gllv_pnl.DrawText("свою гильдию? \n \n");
	gllv_pnl.DrawItem("Да");	 
	gllv_pnl.DrawItem("Нет");	
	SendPanelToClient(gllv_pnl, iClient, gllv_pnl_hndl, MENU_TIME_FOREVER)
}
public int gllv_pnl_hndl(Menu gllv_pnl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete gllv_pnl;			
        }
		case MenuAction_Select:
        {
			if(iItem == 1){
				g_guild[iClient] = 0;
				g_rank[iClient] = 0;
				g_immune[iClient] = 0;	
			}
			if(iItem == 2){
				GuildMenu(iClient);
				delete gllv_pnl;				
			}
		}
    }
    return 0;	
}

void Info(int iClient)
{
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");			
	GS.Rewind();
	if(GS.GotoFirstSubKey())
	{	
		do
		{
			char Buffer[568],
				buffer1[256];
			GS.GetSectionName(Buffer, sizeof(Buffer));
			int id = StringToInt(Buffer);
			if(g_guild[iClient] == id)
			{
				if (GS.JumpToKey("Info")){
					Panel info_pnl = new Panel();
					SetPanelTitle(info_pnl, "Информация\n ");
						
					GS.GetString("Text1", Buffer, sizeof(Buffer));					
					info_pnl.DrawText(Buffer);
						
					GS.GetString("Text2", Buffer, sizeof(Buffer));					
					info_pnl.DrawText(Buffer);
						
					GS.GetString("Text3", buffer1, sizeof(buffer1));
					Format(Buffer, sizeof(Buffer), "%s \n ", buffer1);						
					info_pnl.DrawText(Buffer);
						
					SetPanelCurrentKey(info_pnl, 8);
					info_pnl.DrawItem("Назад");
					SetPanelCurrentKey(info_pnl, 9);
					info_pnl.DrawItem("Выход");					
					info_pnl.Send(iClient, info_pnl_hndl, 0);
					delete info_pnl;							
				}
			}
		} while (GS.GotoNextKey());
	}
	delete GS;
}
public int info_pnl_hndl(Menu info_pnl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete info_pnl;
        }
		case MenuAction_Select:
        {
			if(iItem == 8){
				GuildMenu(iClient);				
			}	
			if(iItem == 9){
				delete info_pnl;			
			}			
        }
    }
    return 0;	
}

void Invite(int iClient)
{
	Menu iv_mn = new Menu(iv_mn_hndl);	
	iv_mn.SetTitle("Выберите игрока \n \n");
    char buffer[128], userId[32];
    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && iClient != i && g_guild[i] == 0)
        {
            GetClientName(i, buffer, 128);
            IntToString(GetClientUserId(i), userId, 32);
            iv_mn.AddItem(userId, buffer, ITEMDRAW_DEFAULT);
        }
    } 
    if(!iv_mn.ItemCount)
    {
        Format(buffer, 128, "Нет доступных игрков");
        iv_mn.AddItem("", buffer, ITEMDRAW_DISABLED);
    }	
	iv_mn.Display(iClient, MENU_TIME_FOREVER);
}

public int iv_mn_hndl(Menu iv_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			GuildMenu(iClient);
        }
		case MenuAction_Select:
        {
			char Buffer[1024],
				buffer1[256];
			
			iv_mn.GetItem(iItem, Buffer, 1024);
			
			Menu target_inv = new Menu(target_inv_hndl);	
			
            int target = GetClientOfUserId(StringToInt(Buffer));	
			
			KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");	

			if(g_guild[target] != g_guild[iClient]){
				if(g_immune[target] < g_immune[iClient])
				{
					target_inv.SetTitle("Приглашение \n \n");
					GS.Rewind();	
					if(GS.GotoFirstSubKey())
					{	
						do
						{
							GS.GetSectionName(Buffer, sizeof(Buffer));
							int id = StringToInt(Buffer);		
							if(g_guild[iClient] == id)
							{
								GS.GetString("Name", buffer1, sizeof(buffer1));
								Format(Buffer, sizeof(Buffer), "Вас пригласили в %s.", buffer1);			
								target_inv.AddItem("", Buffer, ITEMDRAW_DISABLED);					
							}
						} while (GS.GotoNextKey());
					}
					num[0][iClient] = g_guild[iClient];
					IntToString(num[0][iClient], Buffer, 568);
					
					target_inv.AddItem("", "Вы принимаете приглашение? \n \n", ITEMDRAW_DISABLED);
					target_inv.AddItem(Buffer, "Да", ITEMDRAW_DEFAULT);	 
					target_inv.AddItem("", "Нет", ITEMDRAW_DEFAULT);	 
					target_inv.Display(target, MENU_TIME_FOREVER);
				}else{
					PrintToChat(iClient, "[ERRORS] Ваш статус не соответствует критериям.");
				}
			}
			delete GS;
		}	
    }
    return 0;	
}
public int target_inv_hndl(Menu target_inv, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete target_inv;
        }
		case MenuAction_Select:
        {
            char buffer[1024];
			
			target_inv.GetItem(iItem, buffer, 1024);
			
			num[0][iClient] = StringToInt(buffer);
			
			if(iItem == 2){
				g_guild[iClient] = num[0][iClient];
				g_rank[iClient] = 1;
				g_immune[iClient] = 0;		
				GuildMenu(iClient);
			}
			if(iItem == 3){
				delete target_inv;
			}
		}		
    }
    return 0;	
}

void AdminC(int iClient)
{
	KeyValues Adc		= KvImport("configs/guild/Admin.txt", "Guild_Adm"); 	
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");	
	Adc.Rewind();
	char Snum[15],
		box[4][200],
		Overbuffer[240];
	Menu admc_mn = new Menu(admc_mn_hndl);	
	admc_mn.SetTitle("Админ-центр\n ");
	int perm;
	for(int k = 1; k <= Adc.GetNum("count"); k++)
	{
		IntToString(k, Snum, 15);
		Adc.GetString(Snum, Overbuffer, 240);
		ExplodeString(Overbuffer, "|", box, 3, 200);
		if(GS.JumpToKey("Admin"))
		{
			perm = GS.GetNum(box[2]);
		}
		if(GL_GetRankid(iClient) >= perm && perm != -1){
			AddMenuItem(admc_mn, box[1], box[0], ITEMDRAW_DEFAULT);
		}else{
			AddMenuItem(admc_mn, "", box[0], ITEMDRAW_DISABLED);			
		}
	}
	delete Adc;
	delete GS;	
	admc_mn.Display(iClient, MENU_TIME_FOREVER);
}

public int admc_mn_hndl(Menu admc_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete admc_mn;
        }
		case MenuAction_Select:
        {	
			char buffer[200],
				_buffer[2][200];
			admc_mn.GetItem(iItem, buffer, 200);
			ExplodeString(buffer, ";", _buffer, 2, 100);
			if(StrEqual(_buffer[0], "func"))
			{
				if(StrEqual(_buffer[1], "Immune"))
				{
					Immune(iClient);
				}
				if(StrEqual(_buffer[1], "Rank"))
				{
					Rank(iClient);
				}
				if(StrEqual(_buffer[1], "Kick"))
				{
					Kick(iClient);
				}
			}else if(StrEqual(_buffer[0], "cmd")){
				ClientCommand(iClient, _buffer[1]);
			}else{
				LogError("[Guild-Admin] No action found")
			}
		}		
    }
    return 0;	
}

void Rank(int iClient)
{
	Menu rnkad_mn = new Menu(rnkad_mn_hndl);
	SetMenuTitle(rnkad_mn, "Изменение Рангов\n ");
	rnkad_mn.AddItem("1", "+1", ITEMDRAW_DEFAULT);
	rnkad_mn.AddItem("-1", "-1", ITEMDRAW_DEFAULT);				
	rnkad_mn.Display(iClient, MENU_TIME_FOREVER);
}
public int rnkad_mn_hndl(Menu rnkad_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete rnkad_mn;
        }
		case MenuAction_Select:
        {
			char Buffer[568];
			
			rnkad_mn.GetItem(iItem, Buffer, 568);	
			
			num[0][iClient] = StringToInt(Buffer);
			
			Menu rnkad_mn_pl = new Menu(rnkad_mn_pl_hndl);	
			rnkad_mn_pl.SetTitle("Выберите игрока \n \n");
			
			char buffer[128], userId[32];
			
			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && iClient != i && g_guild[iClient] == g_guild[i] && g_immune[iClient] >= g_immune[i])
				{
					GetClientName(i, buffer, 128);
					IntToString(GetClientUserId(i), userId, 32);
					
					rnkad_mn_pl.AddItem(userId, buffer, ITEMDRAW_DEFAULT);
				}
			} 
			if(!rnkad_mn_pl.ItemCount)
			{
				Format(buffer, 128, "Нет доступных игрков");
				rnkad_mn_pl.AddItem("", buffer, ITEMDRAW_DISABLED);
			}
			rnkad_mn_pl.Display(iClient, MENU_TIME_FOREVER);
		}
	}
    return 0;		
}
public int rnkad_mn_pl_hndl(Menu rnkad_mn_pl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete rnkad_mn_pl;
        }
		case MenuAction_Select:
        {
			KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");				
			char Buffer[568];
			rnkad_mn_pl.GetItem(iItem, Buffer, 568);	
            int target = GetClientOfUserId(StringToInt(Buffer));
			GS.Rewind();
			int n;
			if(GS.GotoFirstSubKey())
			{	
				do
				{
					GS.GetSectionName(Buffer, 124);
					if(GL_GetGuildId(iClient) == StringToInt(Buffer))
					{
						if(GS.JumpToKey("Ranks"))
						{
							n = GS.GetNum("count");
						}
					}
				}while (GS.GotoNextKey())
			}
			if(num[0][iClient] + g_rank[target] <= n){	
				g_rank[target] = g_rank[target] + num[0][iClient];
			}else{
				WCS_PrintToChat(iClient, ":{green} Что-то пошло не так");
			}
			PrintToChat(iClient, "[Guild] Изменение вступили в силу.");
			GuildMenu(iClient);
			delete GS;
		}
	}
    return 0;		
}


void Immune(int iClient)
{
	Menu imm_mn = new Menu(imm_mn_hndl);

	SetMenuTitle(imm_mn, "Изменение Иммунитета\n ");

	imm_mn.AddItem("10", "+10", ITEMDRAW_DEFAULT);
	imm_mn.AddItem("50", "+50", ITEMDRAW_DEFAULT);
	imm_mn.AddItem("-10", "-10", ITEMDRAW_DEFAULT);
	imm_mn.AddItem("-50", "-50", ITEMDRAW_DEFAULT);	
	
	imm_mn.Display(iClient, MENU_TIME_FOREVER);
}
public int imm_mn_hndl(Menu imm_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete imm_mn;
        }
		case MenuAction_Select:
        {
			char Buffer[568];
			
			imm_mn.GetItem(iItem, Buffer, 568);	
			
			num[0][iClient] = StringToInt(Buffer);
			
			Menu imm_mn_pl = new Menu(imm_mn_pl_hndl);	
			imm_mn_pl.SetTitle("Выберите игрока \n \n");
			
			char buffer[128], userId[32];
			
			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && iClient != i && g_guild[iClient] == g_guild[i] && g_immune[iClient] >= g_immune[i])
				{
					GetClientName(i, buffer, 128);
					IntToString(GetClientUserId(i), userId, 32);
					
					imm_mn_pl.AddItem(userId, buffer, ITEMDRAW_DEFAULT);
				}
			} 
			if(!imm_mn_pl.ItemCount)
			{
				Format(buffer, 128, "Нет доступных игрков");
				imm_mn_pl.AddItem("", buffer, ITEMDRAW_DISABLED);
			}
			imm_mn_pl.Display(iClient, MENU_TIME_FOREVER);
		}
	}
    return 0;		
}
public int imm_mn_pl_hndl(Menu imm_mn_pl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete imm_mn_pl;
        }
		case MenuAction_Select:
        {
			char Buffer[568];
			imm_mn_pl.GetItem(iItem, Buffer, 568);	
            int target = GetClientOfUserId(StringToInt(Buffer));	
			if(g_immune[target] + num[0][iClient] <= 100){
				g_immune[target] = g_immune[target] + num[0][iClient];
				PrintToChat(iClient, "[Guild] Изменение вступили в силу.");
			}else{
				PrintToChat(iClient, "[Guild] Вы допустили ошибку.");
			}
			GuildMenu(iClient);
		}
	}
    return 0;		
}





void Kick(int iClient)
{

	Menu kick_mn = new Menu(kick_mn_hndl);	
	kick_mn.SetTitle("Выберите игрока \n \n");
	
	char buffer[128], userId[32];
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && g_guild[iClient] == g_guild[i] && g_rank[i] <= g_rank[iClient] && g_guild[i] > 0 && i != iClient)
		{
			GetClientName(i, buffer, 128);
			IntToString(GetClientUserId(i), userId, 32);
			
			kick_mn.AddItem(userId, buffer, ITEMDRAW_DEFAULT);
		}
	} 
	
	if(!kick_mn.ItemCount)
	{
		Format(buffer, 128, "Нет доступных игрков");
		kick_mn.AddItem("", buffer, ITEMDRAW_DISABLED);
	}	
			
	kick_mn.Display(iClient, MENU_TIME_FOREVER);
}
public int kick_mn_hndl(Menu kick_mn, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete kick_mn;
        }
		case MenuAction_Select:
        {
			char Buffer[568];
			
			kick_mn.GetItem(iItem, Buffer, 568);	
			
            int target = GetClientOfUserId(StringToInt(Buffer));	

			g_guild[target] = 0; 
			g_rank[target] = 0;
			g_immune[target] = 0;

			PrintToChat(iClient, "[Guild] Игрок был исключён из гильдии.")
		}
	}
    return 0;		
}

void GuildZeroMenu(int iClient){
	Panel GuildZero_pnl = new Panel();
	SetPanelTitle(GuildZero_pnl, "Гильдии\n \n ");
	GuildZero_pnl.DrawText("Приветствуем вас в гильдиях!"); 
	GuildZero_pnl.DrawText("Похоже что сейчас вы не состоите в гильдии,");	
	GuildZero_pnl.DrawText("но мы уверенны вы найдёте гильдию, ");
	GuildZero_pnl.DrawText("которая будет вам по душе. \n \n ");
	SetPanelCurrentKey(GuildZero_pnl, 8);
	GuildZero_pnl.DrawItem("Осмотреть гильдии");
	SetPanelCurrentKey(GuildZero_pnl, 9);
	GuildZero_pnl.DrawItem("Выход");	
	SendPanelToClient(GuildZero_pnl, iClient, hndl_zero, MENU_TIME_FOREVER);
}
public int hndl_zero(Menu GuildZero_pnl, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete GuildZero_pnl;
        }
		case MenuAction_Select:
        {
			if(iItem == 8){
				GuildsView(iClient);
			}
			if(iItem == 9){
				delete GuildZero_pnl;
			}
		}
	}
    return 0;		
}

void GuildsView(int iClient)
{	
	KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");		
	Menu guilds_viewer = new Menu(MenuHandler_guilds_viewer);		
	GS.Rewind();		
	if(GS.GotoFirstSubKey())
	{	
		do
		{	
			char buffer[256];
			GS.GetString("Pecontact", buffer, 256);
			int perm_cont = StringToInt(buffer);
			SetMenuTitle(guilds_viewer, "Осмотр Гильдий \n \n");
				char id[128], Name[128];
			if(perm_cont >= 0 && perm_cont <= WCS_GetTotalLvl(iClient)){
				GS.GetSectionName(id, 128);
				GS.GetString("Name", Name, 128);
				AddMenuItem(guilds_viewer, id, Name, ITEMDRAW_DEFAULT);
			}else if(perm_cont == -1){
				GS.GetSectionName(id, 128);
				GS.GetString("Name", Name, 128);
				Format(buffer, 256, "%s [Нету доступа]", Name);
				AddMenuItem(guilds_viewer, id, buffer, ITEMDRAW_DISABLED);
			}else if(perm_cont > WCS_GetTotalLvl(iClient)){
				GS.GetSectionName(id, 128);
				GS.GetString("Name", Name, 128);
				Format(buffer, 256, "%s [Нету доступа]", Name);
				AddMenuItem(guilds_viewer, id, buffer, ITEMDRAW_DISABLED);
			}
		}while (GS.GotoNextKey())
	}
	delete GS;
	guilds_viewer.Display(iClient, MENU_TIME_FOREVER);	
}

public int MenuHandler_guilds_viewer(Menu guilds_viewer, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete guilds_viewer;
        }
		case MenuAction_Select:
        {
			KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");					
			char buffer[256];
			guilds_viewer.GetItem(iItem, buffer, 256);
			num[0][iClient] = StringToInt(buffer);
			GS.Rewind();		
			if(GS.GotoFirstSubKey())
			{	
				do
				{
					GS.GetSectionName(buffer, 256);
					int curid = StringToInt(buffer);
					if(num[0][iClient] == curid) 
					{
						char buffer1[158],
							Name[158];
						Panel Guildview = new Panel();
						SetPanelTitle(Guildview, "Осмотр Гильдии \n \n ");
						GS.GetString("Name", Name, 158);
						Format(buffer, 256, "%s \n ", Name);
						DrawPanelText(Guildview, buffer);
						if (GS.JumpToKey("Info"))
						{	
							GS.GetString("Text1", buffer, sizeof(buffer));					
							Guildview.DrawText(buffer);
							GS.GetString("Text2", buffer, sizeof(buffer));					
							Guildview.DrawText(buffer);
							GS.GetString("Text3", buffer1, sizeof(buffer1));
							Format(buffer, sizeof(buffer), "%s \n \n ", buffer1);						
							Guildview.DrawText(buffer);					
						}
						SetPanelCurrentKey(Guildview, 8);
						Guildview.DrawItem("Получить контакт");	
						SetPanelCurrentKey(Guildview, 9);
						Guildview.DrawItem("Выход");	
						SendPanelToClient(Guildview, iClient, hndl_pnl_view, MENU_TIME_FOREVER)
						delete Guildview;
					}
				}while (GS.GotoNextKey())
			}
			delete GS;
		}
	}
    return 0;		
}

public int hndl_pnl_view(Menu Guildview, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
        case MenuAction_End:
        {
			delete Guildview;
        }
		case MenuAction_Select:
        {
			if(iItem == 8)
			{
				KeyValues 	GS 	= KvImport("configs/guild/guilds.txt", "Guilds");					
				char buffer[256];
	
				GS.Rewind();		
				if(GS.GotoFirstSubKey())
				{	
					do
					{
						GS.GetSectionName(buffer, 256);
						int curid = StringToInt(buffer);
						if(num[0][iClient] == curid)
						{
							if(GS.JumpToKey("contact"))	
							{
								GS.GetString("Text1", buffer, sizeof(buffer));		
								PrintToChat(iClient, "[Guild] %s", buffer);
								GS.GetString("Url", buffer, sizeof(buffer));
								PrintToChat(iClient, "%s", buffer);
							}
						}
					}while (GS.GotoNextKey())			
				}
				delete GS;
			}
			if(iItem == 9){
				GuildsView(iClient);
				num[0][iClient] = 0;
			}
		}
	}
    return 0;		
}