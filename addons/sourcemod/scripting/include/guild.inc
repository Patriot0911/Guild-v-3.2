#if defined _guild_included
 #endinput
#endif
#define _guild_included

/*
 *  Возращает указатель базы данных, 
 *  для работы с ней.
 *
 *  @return     db
**/
native Database GL_GetDatabase();

/*
 *  Возращает уникальный айди игрока из бд
 *
 *  @iClient    player index
 *
 *  @return     ClientID 
**/
native int GL_GetClientID(int iClient);

/*
 *  Возращает айди гильдии 
 *
 *  @iClient    player index
 *
 *  @return     Guildid 
**/
native int GL_GetGuildId(int iClient);

/*
 *  Возращает айди ранга игрока
 *
 *  @iClient    player index
 *
 *  @return     rankid 
**/
native int GL_GetRankid(int iClient);

/*
 *  Возращает иммунитет игрока
 *
 *  @iClient    player index
 *
 *  @return     Immune 
**/
native int GL_GetImmune(int iClient);

/*
 *  Выставляет айди гильдии игроку
 *
 *  @iClient    player index
 *  @IGuild    new player guild id 
 *
 *  @return     0 
**/
native void GL_SetGuildId(int iClient, int IGuild); 

/*
 *  Выставляет иммунитет игроку
 *
 *  @iClient    player index
 *  @Immune       new player immune 
 *
 *  @return     0 
**/
native void GL_SetImmune(int iClient, int Immune);

/*
 *  Выставляет ранг игроку
 *
 *  @iClient    player index
 *  @Rank       new player rank
 *
 *  @return     0 
**/
native void GL_SetRankid(int iClient, int Rank);

/*
 * Проверяет, игра == css 34 или нет
 *
 * @return bool{
 *                  true:{CSGO..}
 *                  false:{CSS v34}
 *              }
**/
native bool Gl_Engine();

/*
 * @iClient player index
 *
 *
 *  @return Display Main menu to client
**/
native void Gl_Menu(int iClient);