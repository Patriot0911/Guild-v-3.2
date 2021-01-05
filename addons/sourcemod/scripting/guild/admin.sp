public Action Commands_SetGl(int client, int args)
{
	char arg1[96], arg2[32], buffer[96];	
	if (args < 2)
	{
		GetCmdArg(0, buffer, sizeof(buffer));
		ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <count>", buffer);
		return Plugin_Handled;
	}	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	int[] targets = new int[MaxClients];
	bool ml;
	
	int icount = StringToInt(arg2);
	
	int count = ProcessTargetString(arg1, client, targets, MaxClients, COMMAND_FILTER_NO_BOTS, buffer, sizeof(buffer), ml);	

	if (count < 1)
	{
		if (client)
		{
			PrintToChat(client, "TargetNotFound");
		}
		else
		{
			ReplyToCommand(client, "TargetNotFound");
		}
	}
	else
	{
		for (int i = 0; i < count; i++)
		{
			if (!CanUserTarget(client, targets[i])) continue;
			GL_SetGuildId(targets[i], icount);
		}
		if (client)
		{
			PrintToChat(client, "success [%i]", icount);
		}
		else
		{
			ReplyToCommand(client, "success [%i]", icount);
		}
	}
	
	return Plugin_Handled;

}

public Action Commands_GiveMaster(int client, int args)
{
	char arg1[96], arg2[32], buffer[96];	
	if (args < 2)
	{
		GetCmdArg(0, buffer, sizeof(buffer));
		ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <guildid>", buffer);
		return Plugin_Handled;
	}	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	int[] targets = new int[MaxClients];
	bool ml;
	
	int inum = StringToInt(arg2);
	
	int count = ProcessTargetString(arg1, client, targets, MaxClients, COMMAND_FILTER_NO_BOTS, buffer, sizeof(buffer), ml);	

	if (count < 1)
	{
		if (client)
		{
			PrintToChat(client, "TargetNotFound");
		}
		else
		{
			ReplyToCommand(client, "TargetNotFound");
		}
	}
	else
	{
		for (int i = 0; i < count; i++)
		{
			if (!CanUserTarget(client, targets[i])) continue;
			GL_SetGuildId(targets[i], inum);
			GL_SetImmune(targets[i], 100); 	
			GL_SetRankid(targets[i], 6);		
		}
	}
	return Plugin_Handled;

}


public Action Commands_SetRk(int client, int args)
{
	char arg1[96], arg2[32], buffer[96];	
	if (args < 2)
	{
		GetCmdArg(0, buffer, sizeof(buffer));
		ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <count>", buffer);
		return Plugin_Handled;
	}	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	int[] targets = new int[MaxClients];
	bool ml;
	
	int icount = StringToInt(arg2);
	
	int count = ProcessTargetString(arg1, client, targets, MaxClients, COMMAND_FILTER_NO_BOTS, buffer, sizeof(buffer), ml);	

	if (count < 1)
	{
		if (client)
		{
			PrintToChat(client, "TargetNotFound");
		}
		else
		{
			ReplyToCommand(client, "TargetNotFound");
		}
	}
	else
	{
		for (int i = 0; i < count; i++)
		{
			if (!CanUserTarget(client, targets[i])) continue;
			KeyValues GS 	= KvImport("configs/guild/guilds.txt", "Guilds");	
			GS.Rewind();
			int n;
			if(GS.GotoFirstSubKey())
			{	
				do
				{
					GS.GetSectionName(buffer, 124);
					if(GL_GetGuildId(targets[i]) == StringToInt(buffer))
					{
						if(GS.JumpToKey("Ranks"))
						{
							n = GS.GetNum("count");
						}
						break;
					}
				}while (GS.GotoNextKey())
			}
			delete GS;
			if(icount <= n){
				GL_SetRankid(targets[i], icount);
				db_Update(targets[i]);
			}else{
				GetCmdArg(0, buffer, sizeof(buffer));
				ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <count <= %i >", buffer, n);	
			}
		}
		if (client)
		{
			PrintToChat(client, "success [%i]", icount);
		}
		else
		{
			ReplyToCommand(client, "success [%i]", icount);
		}
	}
	return Plugin_Handled;
}

public Action Commands_SetIm(int client, int args)
{
	char arg1[96], arg2[32], buffer[96];	
	if (args < 2)
	{
		GetCmdArg(0, buffer, sizeof(buffer));
		ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <count>", buffer);
		return Plugin_Handled;
	}	
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	int[] targets = new int[MaxClients];
	bool ml;
	
	int icount = StringToInt(arg2);
	
	int count = ProcessTargetString(arg1, client, targets, MaxClients, COMMAND_FILTER_NO_BOTS, buffer, sizeof(buffer), ml);	

	if (count < 1)
	{
		if (client)
		{
			PrintToChat(client, "TargetNotFound");
		}
		else
		{
			ReplyToCommand(client, "TargetNotFound");
		}
	}
	else
	{
		if(icount <= 100){
			for (int i = 0; i < count; i++)
			{
				if (!CanUserTarget(client, targets[i])) continue;
				GL_SetImmune(targets[i], icount);
			}
			if (client)
			{
				PrintToChat(client, "success [%i]", icount);
			}
			else
			{
				ReplyToCommand(client, "success [%i]", icount);
			}
		}else{
			GetCmdArg(0, buffer, sizeof(buffer));
			ReplyToCommand(client, "Usage: %s <userid|name|uniqueid> <count <= 100 >", buffer);	
		}
	}
	
	return Plugin_Handled;

}










