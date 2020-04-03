#define MAX_GANGS 130
#define MAX_ZONES 200
/*
	DODA∆ Wartoúci PDV
		-IGid
		-GPid
		-Spar
*/
enum G_enum{
	idG,
	gName[24],
	gTag[6],
	gRspkt,
	gExpire,
	Float:gSpawnX,
	Float:gSpawnY,
	Float:gSpawnZ,
	GOid,
	gcolo,
	gTrtCoun,
	gPick,
	bool:gWar,
	Text3D:g3DTxt,
	gMem,
	bool:Gspar,
	sprGzon,
	sprzone,
	SprKillC,
	sprT,
	sprSt,
	SparT,
	SprW,
	SprZap
}
new GDV[MAX_GANGS][G_enum];
new iterator:GTHC<MAX_GANGS>;
enum GZ_enum{
	GZid,
	Float:GZPos[4],
	GZoid,
	GZname[24],
	GZGang,
	GZZone,
	GZWar,
	GZWWG,
	Text:GZTxd[13],
	GZWar2,
	GZCas[2],
	GZTis
}
new GZDV[MAX_ZONES][GZ_enum];
new iterator:aZones<MAX_ZONES>;
new Float:gSparAr[][] = {
	//spx1 	spy1 spz1  spx2  spy2  spz2  arx1 ary1 	 arx2	ary2
	{0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000},
};
new Text:SparTd1[MAX_GANGS],Text:SparTd2[MAX_GANGS],Text:SparTd3[MAX_GANGS],Text:SparTd4[MAX_GANGS],Text:SparTd5[MAX_GANGS];
public OnPlayerConnect(playerid){
	foreach(new zid : aZones){
		if(GZDV[zid][GZGang] == -1){
			GangZoneShowForPlayer(zid,0xAAAAAAAA);
		}else {
			GangZoneShowForPlayer(zid,GDV[GZDV[zid][GZoid]][gcolo] + 170);
		}
	}
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason){
	if(GDV[PDV[playerid][IGid]][gWar]){
		foreach(new x : aZones){
			if(IsPlayerInDynamicArea(playerid, GZDV[x][GZZone])){
				if(GZDV[x][GZTis] != -1){
					if(GZDV[x][GZoid] == PDV[playerid][IGid]){
						UpdateGZHud(x);
						GZDV[x][GZCas][0]++;
						GZDV[x][GZTis] += 10000;
					}else if(GZDV[x][GZWWG] == PDV[playerid][IGid]){
						GZDV[x][GZCas][1]++;
						GZDV[x][GZTis] += 10000;
						UpdateGZHud(x);
					}
				}
				break;
			}
		}
	}
	if(PDV[playerid][IGid] != -1 && PDV[killerid][IGid] != -1){
		GDV[PDV[killerid][IGid]][gRspkt] += 3;
		GDV[PDV[playerid][IGid]][gRspkt] -= 2;
		if(PDV[playerid][VIP] >= 1){
			GDV[PDV[playerid][IGid]][gRspkt]++;
		}
		if(PDV[killerid][VIP] >= 1){
			GDV[PDV[killerid][IGid]][gRspkt]++;
		}
	}
	return 1;
}
//DO timera
forward Timer();
public Timer(){
	foreach(new x : aZones){
		if(GZDV[x][GZTis] != -1){
			if(GZDV[x][GZTis] <= GetTickCount()){
				AttckEnd(x);
			}
		}
	}
	return 1;
}
public OnPlayerEnterDynamicArea(playerid, areaid){
	if(PDV[playerid][gSpar]){
		new l;
		if(GDV[PDV[playerid][IGid]][sprT] == -1){
			l = GDV[PDV[playerid][IGid]][SprW];
		}
		if(GDV[l][sprzone] == areaid){
			GameTextForPlayer(playerid, "~g~~h~~h~Powrociles do gry", 1500, 3);
			PDV[playerid][SetF] = 0;
			PDV[playerid][nCtD] = 0;
		}
	}	
	foreach(new x : aZones){
		if(GZDV[x][GZZone] == areaid){
			if(PDV[playerid][zSl]){SCM(playerid,-1,"|ID STREFY| : %i",x);}
			if(GZDV[x][GZoid] != -1){
				if(PDV[playerid][IGid] != GZDV[x][GZoid] && PDV[playerid][IGid] != -1){
					if(GZDV[x][GZWar] != -1){
						if(PDV[playerid][IGid] == GZDV[x][GZWWG]){
							GZDV[x][GZWar]++;
							return 1;
						}else if(PDV[playerid][IGid] == GZDV[x][GZoid]){
							GZDV[x][GZWar2]++;
							return 1;
						}
					}
					if(GDV[PDV[playerid][IGid]][gWar]){return 1;}
					new c;
					foreach(Player,i){
						if(IsPlayerConnected(i)){
							if(IsPlayerInDynamicArea(i, areaid) && PDV[playerid][IGid] == PDV[i][IGid]){
								c++;
							}
						}
					}
					if(c >= 3){
						InitateAttack(x,PDV[playerid][IGid],c);
					}
				}
			}else {
				InitateAttack(x,PDV[playerid][IGid],-1);
			}
		}
	}
	return 1;
}
public OnPlayerLeaveDynamicArea(playerid, areaid){
	if(PDV[playerid][gSpar]){
		new l;
		if(GDV[PDV[playerid][IGid]][sprT] == -1){
			l = GDV[PDV[playerid][IGid]][SprW];
		}
		if(GDV[l][sprzone] == areaid){
			GameTextForPlayer(playerid, "~r~~h~~h~Masz 4 sekundy na powrÛt do strefy gry", 2000, 3);
			PDV[playerid][SetF] = 6;
			PDV[playerid][nCtD] = GetTickCount()+4000;
		}
	}
	foreach(new x : aZones){
		if(GZDV[x][GZZone] == areaid){
			if(GZDV[x][GZWar] != -1){
				GZDV[x][GZWar]--;
			}
		}else if(PDV[playerid][IGid] == GZDV[x][GZoid]){
			GZDV[x][GZWar2]--;
		}
	}
	return 1;
}
forward GetZDat(zid);
public GetZDat(zid){
	if(Iter_Contains(aZones, zid)){print("ERROR: zid alerady exists"); return 1;}
	if(mysql_num_rows() == 1){
		Iter_Add(aZones, zid);
		cache_get_value_index_int(0, 0,GZDV[zid][GZid]);
		cache_get_value_index_int(0, 1,GZDV[zid][GZoid]);
		cache_get_value_index(0, 2,GZDV[zid][GZname],24);
		cache_get_value_index_float(0, 3,GZDV[zid][GZPos][0]);
		cache_get_value_index_float(0, 4,GZDV[zid][GZPos][1]);
		cache_get_value_index_float(0, 5,GZDV[zid][GZPos][2]);
		cache_get_value_index_float(0, 6,GZDV[zid][GZPos][3]);
		GZDV[zid][GZWar] = -1;
		GZDV[zid][GZWar2] = -1;
		GZDV[zid][GZCas][0] = 0;
		GZDV[zid][GZCas][1] = 0;
		GZDV[zid][GZWWG] = -1;
		GZDV[zid][GZTis] = -1;
		GZDV[zid][GZGang] = GangZoneCreate(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
		GZDV[zid][GZZone] = CreateDynamicRectangle(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
	}else {
		printf("ERROR: zid of id:%i doesn't exist",zid);
	}
	return 1;
}
forward Spar(gid1,gid2);
public Spar(gid1,gid2){
	if(GDV[gid1][sprST] >= 0){
		if(GDV[gid1][sprST] == 0){
			GDV[gid1][sprST] = -1;
			StartSpar(gid1,gid2);		
		}
		GDV[gid1][sprST]--;
	}
	else{
		GDV[gid1][sprT]--;
		UpdateSparTxD(gid1,gid2);
		if(GDV[gid1][sprT] <= 0) EndSpar(gid1,gid2);
	}
}
stock IniSparTxD(gid1,gid2){
	SparTd1[gid1] = TextDrawCreate(206.301971, -83.549919, "LD_POKE:cd10h");
	TextDrawLetterSize(SparTd1[gid1], 0.000000, 0.000000);
	TextDrawTextSize(SparTd1[gid1], 252.000000, 96.000000);
	TextDrawAlignment(SparTd1[gid1], 1);
	TextDrawColor(SparTd1[gid1], 32);
	TextDrawSetShadow(SparTd1[gid1], 0);
	TextDrawSetOutline(SparTd1[gid1], 0);
	TextDrawBackgroundColor(SparTd1[gid1], 255);
	TextDrawFont(SparTd1[gid1], 4);
	TextDrawSetProportional(SparTd1[gid1], 0);
	TextDrawSetShadow(SparTd1[gid1], 0);

	new str[32],iz=sizeof(str);
	format(str,iz,"%s~n~0",GDV[gid1][gName]);

	SparTd2[gid1] = TextDrawCreate(269.285064, 0.416654, str);
	TextDrawLetterSize(SparTd2[gid1], 0.150278, 0.614166);
	TextDrawAlignment(SparTd2[gid1], 2);
	TextDrawColor(SparTd2[gid1], 16711935);
	TextDrawSetShadow(SparTd2[gid1], 0);
	TextDrawSetOutline(SparTd2[gid1], 1);
	TextDrawBackgroundColor(SparTd2[gid1], 255);
	TextDrawFont(SparTd2[gid1], 2);
	TextDrawSetProportional(SparTd2[gid1], 1);
	TextDrawSetShadow(SparTd2[gid1], 0);

	format(str,iz,"%s~n~0",GDV[gid2][gName]);

	SparTd3[gid1] = TextDrawCreate(385.992187, 0.416654, str);
	TextDrawLetterSize(SparTd3[gid1], 0.150278, 0.614166);
	TextDrawAlignment(SparTd3[gid1], 2);
	TextDrawColor(SparTd3[gid1], 15269887);
	TextDrawSetShadow(SparTd3[gid1], 0);
	TextDrawSetOutline(SparTd3[gid1], 1);
	TextDrawBackgroundColor(SparTd3[gid1], 255);
	TextDrawFont(SparTd3[gid1], 2);
	TextDrawSetProportional(SparTd3[gid1], 1);
	TextDrawSetShadow(SparTd3[gid1], 0);

	SparTd4[gid1] = TextDrawCreate(323.299743, 2.233266, "Versus");
	TextDrawLetterSize(SparTd4[gid1], 0.150278, 0.614166);
	TextDrawAlignment(SparTd4[gid1], 2);
	TextDrawColor(SparTd4[gid1], -16776961);
	TextDrawSetShadow(SparTd4[gid1], 0);
	TextDrawSetOutline(SparTd4[gid1], 1);
	TextDrawBackgroundColor(SparTd4[gid1], 255);
	TextDrawFont(SparTd4[gid1], 2);
	TextDrawSetProportional(SparTd4[gid1], 1);
	TextDrawSetShadow(SparTd4[gid1], 0);

	SparTd5[gid1] = TextDrawCreate(323.799774, 8.833264, "Czas_Pozostaly:240s");
	TextDrawLetterSize(SparTd5[gid1], 0.150278, 0.624166);
	TextDrawAlignment(SparTd5[gid1], 2);
	TextDrawColor(SparTd5[gid1], -16776961);
	TextDrawSetShadow(SparTd5[gid1], 0);
	TextDrawSetOutline(SparTd5[gid1], 1);
	TextDrawBackgroundColor(SparTd5[gid1], 255);
	TextDrawFont(SparTd5[gid1], 2);
	TextDrawSetProportional(SparTd5[gid1], 1);
	TextDrawSetShadow(SparTd5[gid1], 0);
	return 1;
}
stock UpdateSparTxD(gid1,gid2){
	new str[32],iz=sizeof(str);
	format(str,iz,"Czas Pozostaly:%is",GDV[gid1][SprT]);
	TextDrawSetString(SparTd5[gid1], str);
	format(str,iz,"%s~n~%i",GDV[gid2][gName],GDV[gid2][SprKillC]);
	TextDrawSetString(SparTd3[gid2], str);
	format(str,iz,"%s~n~%i",GDV[gid1][gName],GDV[gid1][SprKillC]);
	TextDrawSetString(SparTd2[gid1], str);
	return 1;
}
stock onSparAcc(gid1,gid2){
	GDV[gid1][sprST]	=	60;
	new str[45];
	format(str,sizeof(str),"Za 60 sekund rozpocznie siÍ sparing z %s",GDV[gid1][gName]);
	MSGGang(gid2,INVALID_PLAYER_ID,str);
	format(str,sizeof(str),"Za 60 sekund rozpocznie siÍ sparing z %s",GDV[gid2][gName]);
	MSGGang(gid1,INVALID_PLAYER_ID,str);
	GDV[gid1][SparT] 	=	SetTimer("Spar", 1000, true,gid1,gid2);
	return 1;
}
stock StartSpar(gid1,gid2){
	IniSparTxD(gid1,gid2);
	new r = random(sizeof(gSparAr));
	if(!(GDV[gid1][Gspar] && GDV[gid1][Gspar])){
		KillTimer(GDV[gid1][SparT]);
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sparing nie mÛg≥ siÍ zaczπÊ");
		return 1;
	}
	new c1,c2;
	GDV[gid1][sprGzon] = GangZoneCreate(gSparAr[r][6],gSparAr[r][7],gSparAr[r][8],gSparAr[r][9]);
	foreach(Player,i){
		if((PDV[i][IGid] == gid1 || PDV[i][IGid] == gid2) && !Busy(i)){
			SetPlayerVirtualWorld(i, gid1+10);
			GetPlayerPos(i, PDV[i][LaX],PDV[i][LaY],PDV[i][LaZ]);
			switch(PDV[i][IGid]){
				case gid1:{
					SetPlayerPos(i, gSparAr[r][0],gSparAr[r][1],gSparAr[r][2]);
					c1++;
				}
				case gid2:{
					SetPlayerPos(i, gSparAr[r][3],gSparAr[r][4],gSparAr[r][5]);
					c2++;
				}
			}
			PDV[i][gSpar] = true;
		}
	}
	if(c1 <= 1 || c2 <= 1){
		foreach(Player,i){
			if((PDV[i][IGid] == gid1 || PDV[i][IGid] == gid2) && !Busy(i)){
				ReS(i);
			}
		}
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sparing nie mÛg≥ siÍ zaczπÊ");
		return 1;
	}
	GDV[gid1][SprW] = gid2;
	GDV[gid2][SprW] = gid1;
	GDV[gid1][sprT]		=	240;
	GDV[gid1][sprzone] 	=	CreateDynamicRectangle(gSparAr[r][6],gSparAr[r][7],gSparAr[r][8],gSparAr[r][9],gid1+10);
	return 1;
}
stock EndSpar(gid1,gid2){
	if(GDV[gid1][SprKillC] > GDV[gid2][SprKillC]){
		KillTimer(GDV[gid1][SparT]);
		GDV[gid1][gRspkt] += 10;
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Sparing wygra≥ %s",GDV[gid1][Name]);
		foreach(Player,i){
			switch(PDV[i][IGid]){
				case gid1:{
					PDV[i][gSpar] = false;
					TkPlRe(i,30);
					TkPlMo(i,30000);
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Przegra≥eú sparing tracπc 30 exp i 30k$");
					ReS(i);
				}
				case gid2:{
					PDV[i][gSpar] = false;
					GiRe(i,20);
					GiPlMo(i,20000);
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wygra≥eú sparing zyskujπc 20 exp i 20k$");
					ReS(i);
				}
			}
		}
	}else if(GDV[gid1][SprKillC] < GDV[gid2][SprKillC]){
		KillTimer(GDV[gid1][SparT]);
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Sparing wygra≥ %s",GDV[gid2][Name]);
		GDV[gid2][gRspkt] += 10;
		foreach(Player,i){
			switch(PDV[i][IGid]){
				case gid1:{
					PDV[i][gSpar] = false;
					TkPlRe(i,30);
					TkPlMo(i,30000);
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Przegra≥eú sparing tracπc 30 exp i 30k$");
					ReS(i);
				}
				case gid2:{
					PDV[i][gSpar] = false;
					GiRe(i,20);
					GiPlMo(i,20000);
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wygra≥eú sparing zyskujπc 20 exp i 20k$");
					ReS(i);
				}
			}
		}
	}else{
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Sparing:Remis +10sek czasu");
		GDV[gid1][sprT] += 10;
		return 1;
	}
	TextDrawHideForAll(SparTd1[gid1]);
	TextDrawHideForAll(SparTd2[gid1]);
	TextDrawHideForAll(SparTd3[gid1]);
	TextDrawHideForAll(SparTd4[gid1]);
	TextDrawHideForAll(SparTd5[gid1]);
	TextDrawDestroy(SparTd1[gid1]);
	TextDrawDestroy(SparTd2[gid1]);
	TextDrawDestroy(SparTd3[gid1]);
	TextDrawDestroy(SparTd4[gid1]);
	TextDrawDestroy(SparTd5[gid1]);
	GangZoneDestroy(GDV[gid1][sprGzon]);
	DestroyDynamicArea(GDV[gid1][sprzone]);
	GDV[gid1][sprT] = -1;
	GDV[gid1][gSpar] = false;
	GDV[gid2][gSpar] = false;
	return 1;
}
stock IniGZHud(zid){
	GZDV[zid][GZTxd][0] = TextDrawCreate(-12.833065, 231.416671, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][0], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][0], 121.000000, 78.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][0], 1);
	TextDrawColor(GZDV[zid][GZTxd][0], 97);
	TextDrawSetShadow(GZDV[zid][GZTxd][0], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][0], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][0], 255);
	TextDrawFont(GZDV[zid][GZTxd][0], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][0], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][0], 0);

	GZDV[zid][GZTxd][1] = TextDrawCreate(27.519060, 215.200134, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][1], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][1], 51.000000, 16.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][1], 1);
	TextDrawColor(GZDV[zid][GZTxd][1], 79);
	TextDrawSetShadow(GZDV[zid][GZTxd][1], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][1], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][1], 255);
	TextDrawFont(GZDV[zid][GZTxd][1], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][1], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][1], 0);

	GZDV[zid][GZTxd][2] = TextDrawCreate(35.515312, 218.200027, "WOJNA");
	TextDrawLetterSize(GZDV[zid][GZTxd][2], 0.255694, 0.999162);
	TextDrawAlignment(GZDV[zid][GZTxd][2], 1);
	TextDrawColor(GZDV[zid][GZTxd][2], 10420479);
	TextDrawSetShadow(GZDV[zid][GZTxd][2], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][2], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][2], 255);
	TextDrawFont(GZDV[zid][GZTxd][2], 2);
	TextDrawSetProportional(GZDV[zid][GZTxd][2], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][2], 0);

	GZDV[zid][GZTxd][3] = TextDrawCreate(6.544661, 247.749984, "TAG12345.");
	TextDrawLetterSize(GZDV[zid][GZTxd][3], 0.218213, 1.034165);
	TextDrawAlignment(GZDV[zid][GZTxd][3], 1);
	TextDrawColor(GZDV[zid][GZTxd][3], -1);
	TextDrawSetShadow(GZDV[zid][GZTxd][3], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][3], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][3], 255);
	TextDrawFont(GZDV[zid][GZTxd][3], 2);
	TextDrawSetProportional(GZDV[zid][GZTxd][3], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][3], 0);

	GZDV[zid][GZTxd][4] = TextDrawCreate(6.544661, 260.000000, "TAG12345.");
	TextDrawLetterSize(GZDV[zid][GZTxd][4], 0.218213, 1.034165);
	TextDrawAlignment(GZDV[zid][GZTxd][4], 1);
	TextDrawColor(GZDV[zid][GZTxd][4], -1);
	TextDrawSetShadow(GZDV[zid][GZTxd][4], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][4], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][4], 255);
	TextDrawFont(GZDV[zid][GZTxd][4], 2);
	TextDrawSetProportional(GZDV[zid][GZTxd][4], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][4], 0);

	GZDV[zid][GZTxd][5] = TextDrawCreate(5.139129, 234.916671, "Wojna_o_teren.123456789111315171921234");
	TextDrawLetterSize(GZDV[zid][GZTxd][5], 0.132942, 0.783330);
	TextDrawAlignment(GZDV[zid][GZTxd][5], 1);
	TextDrawColor(GZDV[zid][GZTxd][5], -1);
	TextDrawSetShadow(GZDV[zid][GZTxd][5], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][5], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][5], 255);
	TextDrawFont(GZDV[zid][GZTxd][5], 1);
	TextDrawSetProportional(GZDV[zid][GZTxd][5], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][5], 0);

	GZDV[zid][GZTxd][6] = TextDrawCreate(4.039278, 232.916824, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][6], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][6], 98.000213, 13.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][6], 1);
	TextDrawColor(GZDV[zid][GZTxd][6], 16);
	TextDrawSetShadow(GZDV[zid][GZTxd][6], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][6], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][6], 255);
	TextDrawFont(GZDV[zid][GZTxd][6], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][6], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][6], 0);

	GZDV[zid][GZTxd][7] = TextDrawCreate(3.570755, 246.916839, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][7], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][7], 98.449882, 13.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][7], 1);
	TextDrawColor(GZDV[zid][GZTxd][7], 16);
	TextDrawSetShadow(GZDV[zid][GZTxd][7], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][7], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][7], 255);
	TextDrawFont(GZDV[zid][GZTxd][7], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][7], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][7], 0);

	GZDV[zid][GZTxd][8] = TextDrawCreate(4.507800, 260.333526, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][8], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][8], 97.959777, 13.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][8], 1);
	TextDrawColor(GZDV[zid][GZTxd][8], 16);
	TextDrawSetShadow(GZDV[zid][GZTxd][8], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][8], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][8], 255);
	TextDrawFont(GZDV[zid][GZTxd][8], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][8], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][8], 0);

	GZDV[zid][GZTxd][9] = TextDrawCreate(5.018926, 274.799713, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][9], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][9], 97.509681, 13.020000);
	TextDrawAlignment(GZDV[zid][GZTxd][9], 1);
	TextDrawColor(GZDV[zid][GZTxd][9], 16);
	TextDrawSetShadow(GZDV[zid][GZTxd][9], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][9], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][9], 255);
	TextDrawFont(GZDV[zid][GZTxd][9], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][9], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][9], 0);

	GZDV[zid][GZTxd][10] = TextDrawCreate(7.481678, 276.366394, "Wynik.12456789");
	TextDrawLetterSize(GZDV[zid][GZTxd][10], 0.213059, 1.010831);
	TextDrawAlignment(GZDV[zid][GZTxd][10], 1);
	TextDrawColor(GZDV[zid][GZTxd][10], -1);
	TextDrawSetShadow(GZDV[zid][GZTxd][10], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][10], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][10], 255);
	TextDrawFont(GZDV[zid][GZTxd][10], 2);
	TextDrawSetProportional(GZDV[zid][GZTxd][10], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][10], 0);

	GZDV[zid][GZTxd][11] = TextDrawCreate(4.550405, 294.417602, "LD_POKE:cd10h");
	TextDrawLetterSize(GZDV[zid][GZTxd][11], 0.000000, 0.000000);
	TextDrawTextSize(GZDV[zid][GZTxd][11], 99.000000, 13.000000);
	TextDrawAlignment(GZDV[zid][GZTxd][11], 1);
	TextDrawColor(GZDV[zid][GZTxd][11], 16);
	TextDrawSetShadow(GZDV[zid][GZTxd][11], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][11], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][11], 255);
	TextDrawFont(GZDV[zid][GZTxd][11], 4);
	TextDrawSetProportional(GZDV[zid][GZTxd][11], 0);
	TextDrawSetShadow(GZDV[zid][GZTxd][11], 0);

	GZDV[zid][GZTxd][12] = TextDrawCreate(7.013171, 296.166687, "Czas_pozostaly.60sekund");
	TextDrawLetterSize(GZDV[zid][GZTxd][12], 0.120292, 0.719166);
	TextDrawAlignment(GZDV[zid][GZTxd][12], 1);
	TextDrawColor(GZDV[zid][GZTxd][12], -1);
	TextDrawSetShadow(GZDV[zid][GZTxd][12], 0);
	TextDrawSetOutline(GZDV[zid][GZTxd][12], 0);
	TextDrawBackgroundColor(GZDV[zid][GZTxd][12], 255);
	TextDrawFont(GZDV[zid][GZTxd][12], 2);
	TextDrawSetProportional(GZDV[zid][GZTxd][12], 1);
	TextDrawSetShadow(GZDV[zid][GZTxd][12], 0);
	return 1;
}
stock DesGZHud(zid){
	TextDrawDestroy(GZDV[zid][GZTxd][0]);
	TextDrawDestroy(GZDV[zid][GZTxd][1]);
	TextDrawDestroy(GZDV[zid][GZTxd][2]);
	TextDrawDestroy(GZDV[zid][GZTxd][3]);
	TextDrawDestroy(GZDV[zid][GZTxd][4]);
	TextDrawDestroy(GZDV[zid][GZTxd][5]);
	TextDrawDestroy(GZDV[zid][GZTxd][6]);
	TextDrawDestroy(GZDV[zid][GZTxd][7]);
	TextDrawDestroy(GZDV[zid][GZTxd][8]);
	TextDrawDestroy(GZDV[zid][GZTxd][9]);
	TextDrawDestroy(GZDV[zid][GZTxd][10]);
	TextDrawDestroy(GZDV[zid][GZTxd][11]);
	TextDrawDestroy(GZDV[zid][GZTxd][12]);
	return 1;
}
stock UpdateGZHud(zid){
	new str[128];
	format(str,sizeof(str),"%s:%i",GDV[GZDV[zid][GZoid]][gTag],GZCas[1]);
	TextDrawSetString(GZDV[zid][GZTxd][3], str);
	format(str,sizeof(str),"%s:%i",GDV[GZDV[zid][GZWWG]][gTag],GZCas[0]);
	TextDrawSetString(GZDV[zid][GZTxd][4], str);
	format(str,sizeof(str),"Wynik:%i",GZCas[1] - GZCas[0]);
	TextDrawSetString(GZDV[zid][GZTxd][10], str);
	format(str,sizeof(str),"Czas pozostaly:%i",GZCas[1] - GZCas[0]);
	TextDrawSetString(GZDV[zid][GZTxd][12], str);
	return 1;
}
stock MSGGang(gid,pid,txt[]){
	foreach(Player,i){
		if(PDV[i][IGid] == gid){
			if(pid == INVALID_PLAYER_ID){
				SCM(-1,"{9b9da0}[ {56ff56}Gang-MSG {9b9da0}] {7700cc} BOT{aaaacc} : %s",txt);
			}else{SCM(-1,"{9b9da0}[ {56ff56}Gang-MSG {9b9da0}] {7700cc} %s{aaaacc} : %s",PDV[pid][Nck],txt);}
		}
	}
	return 1;
}
stock AttckEnd(zid){
	GDV[GZDV[zid][GZoid]] = false;
	GDV[GZDV[zid][GZWWG]] = false;
	if(GZDV[zid][GWar] <= 0){
		SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} Pokona≥ Wroga {cc0000}%s",GDV[agid][gTag],GDV[GZDV[zid][GZWWG]][gTag]);
		GDV[GZDV[zid][GZWWG]][gRspkt] -= 150;
		GDV[GZDV[zid][GZoid]][gRspkt] += 100;
		MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Wygraliúcie 100 respektu w tej bitwie o teren");
		MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Przegraliúcie i straciliúcie 150 respektu");
	}
	else if(GZDV[zid][GWar2] <= 0){
		SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przejπ≥ teren {cc0000}%s",GDV[agid][gTag],GZDV[zid][GZname]);
		GDV[GZDV[zid][GZWWG]][gRspkt] += 100;
		GDV[GZDV[zid][GZoid]][gRspkt] -= 150;	
		MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Wygraliúcie 100 respektu w tej bitwie o teren");
		MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Przegraliúcie i straciliúcie 150 respektu");
		ChangeGZOw(zid,GZDV[zid][GZWWG]);
	}
	else{
		if(GZDV[zid][GZCas][0] > GZDV[zid][GZCas][1]){
			SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przejπ≥ teren {cc0000}%s",GDV[agid][gTag],GZDV[zid][GZname]);
			GDV[GZDV[zid][GZWWG]][gRspkt] += 100;
			GDV[GZDV[zid][GZoid]][gRspkt] -= 150;
			MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Wygraliúcie 100 respektu w tej bitwie o teren");
			MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Przegraliúcie i straciliúcie 150 respektu");
			ChangeGZOw(zid,GZDV[zid][GZWWG]);
		}else{
			GDV[GZDV[zid][GZWWG]][gRspkt] -= 150;
			GDV[GZDV[zid][GZoid]][gRspkt] += 100;
			MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Wygraliúcie 100 respektu w tej bitwie o teren");
			MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Przegraliúcie i straciliúcie 150 respektu");
			SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} Pokona≥ Wroga {cc0000}%s",GDV[agid][gTag],GDV[GZDV[zid][GZWWG]][gTag]);
		}
	}
	GZDV[zid][GZWar] = -1;
	GZDV[zid][GZWar2] = -1;
	GZDV[zid][GZCas][0] = 0;
	GZDV[zid][GZCas][1] = 0;
	GZDV[zid][GZWWG] = -1;
	GZDV[zid][GZTis] = -1;
	TextDrawHideForAll(GZDV[zid][GZTxd][0]);
	TextDrawHideForAll(GZDV[zid][GZTxd][1]);
	TextDrawHideForAll(GZDV[zid][GZTxd][2]);
	TextDrawHideForAll(GZDV[zid][GZTxd][3]);
	TextDrawHideForAll(GZDV[zid][GZTxd][4]);
	TextDrawHideForAll(GZDV[zid][GZTxd][5]);
	TextDrawHideForAll(GZDV[zid][GZTxd][6]);
	TextDrawHideForAll(GZDV[zid][GZTxd][7]);
	TextDrawHideForAll(GZDV[zid][GZTxd][8]);
	TextDrawHideForAll(GZDV[zid][GZTxd][9]);
	TextDrawHideForAll(GZDV[zid][GZTxd][10]);
	TextDrawHideForAll(GZDV[zid][GZTxd][11]);
	TextDrawHideForAll(GZDV[zid][GZTxd][12]);
	DesGZHud(zid);
	return 1;
}
stock InitateAttack(zid,agid,prs){
	if(prs == -1){
		SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przejπ≥ teren {cc0000}%s",GDV[agid][gTag],GZDV[zid][GZname]);
		GDV[agid][gRspkt] += 80;
		MSGGang(agid,INVALID_PLAYER_ID,"Wygraliúcie 80 respektu w tej bitwie o teren");
		ChangeGZOw(zid,agid);
		return 1;
	}
	GDV[GZDV[zid][GZoid]] = true;
	GDV[GZDV[zid][GZWWG]] = true;
	SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}GangÛw {9b9da0}| {ff5656}%s {56ff56}vs {ff5656}%s {56ff56}o teren {cc0000}%s",GDV[agid][gTag],GDV[GZDV[zid][GZoid]][gTag],GZDV[zid][GZname]);
	GZDV[zid][GZWWG] = agid;
	GZDV[zid][GZWar] = prs;
	IniGZHud(zid);
	new c;
	foreach(Player,i){
		if(PDV[i][IGid] == agid || PDV[i][IGid] == GZDV[zid][GZoid]){
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][0]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][0]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][1]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][2]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][3]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][4]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][5]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][6]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][7]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][8]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][9]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][10]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][11]);
			TextDrawShowForPlayer(i, GZDV[zid][GZTxd][12]);
		}
		if(PDV[i][IGid] == GZDV[zid][GZoid]){
			c++;
		}
	}
	GZDV[zid][GZWar2] = c;
	GZDV[zid][GZTis] = GetTickCount()+60000;
	return 1;
}
stock ChangeGZOw(zid,hoid){
	GangZoneHideForAll(GZDV[zid][GZGang]);
	GZDV[zid][GZoid] = hoid;
	if(hoid == -1){
		GangZoneShowForAll(GZDV[zid][GZGang], 0xAAAAAAAA);
	}else{
		GangZoneShowForAll(GZDV[zid][GZGang], GDV[hoid][gcolo] + 170);
	}
	return 1;
}
stock DestroyZone(zid){
	if(!Iter_Contains(aZones, zid)){print("ERROR: zid doesn't exist"); return 0;}
	new quer[64];
	mysql_format(DBM,quer,sizeof(quer), "DELETE FROM `GZones` WHERE `id`='%i'",zid);
	mq(quer);
	Iter_Remove(aZones, zid);
	GZDV[zid][GZid] = -1;
	GZDV[zid][GZoid] = -1;
	GZDV[zid][GZname][23] = EOS;
	GZDV[zid][GZPos][0] = 0;
	GZDV[zid][GZPos][1] = 0;
	GZDV[zid][GZPos][2] = 0;
	GZDV[zid][GZPos][3] = 0;
	GangZoneDestroy(GZDV[zid][GZGang]);
	DestroyDynamicArea(GZDV[zid][GZZone]);
	return 1;
}
stock CreateZone(gzname[24],Float:pos1,Float:pos2,Float:pos3,Float:pos4){
	new zid = Iter_Free(aZones);
	if(zid == ITER_NONE){print("ERROR: Iterator.aZones is full"); return 0;}
	if(pos1 > pos3){
		new x = pos3;
		pos3 = pos1;
		pos1 = x;
	}
	if(pos2 > pos4){
		new x = pos4;
		pos4 = pos2;
		pos2 = x;
	}
	GZDV[zid][GZid] = -1;
	GZDV[zid][GZoid] = -1;
	strcat(GZDV[zid][GZname],gzname,sizeof(GZname));
	GZDV[zid][GZPos][0] = pos1;
	GZDV[zid][GZPos][1] = pos2;
	GZDV[zid][GZPos][2] = pos3;
	GZDV[zid][GZPos][3] = pos4;
	SqlEscStr(gzname,gzname);
	new quer[64];
	mysql_format(DBM,quer,sizeof(quer), "INSERT INTO `GZones` (`id`,`name`,`minX`,`minY`,`maxX`,`maxY`) VALUES ('%i','%s','%f','%f','%f','%f')",zid,gzname,pos1,pos2,pos3,pos4);
	mq(quer);
	Iter_Add(aZones, zid);
	GZDV[zid][GZGang] = GangZoneCreate(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
	GZDV[zid][GZZone] = CreateDynamicRectangle(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
	GangZoneShowForAll(GZDV[zid][GZGang], 0xAAAAAAAA);
	return 1;
}
CMD:stworzteren(playerid,params[])
{
	if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostÍpu do tej cmd"); return 1;}
	if(floatround(GM[GZs][0],floatround_round) == 0){
		if(sscanf(params,'s[24]',GM[GZnm])){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uøycie: /stworzteren [nazwa]"); return 1;}
		new Float:z;
		GetPlayerPos(playerid, GM[GZs][0],GM[GZs][1], z);
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uda≥o ci siÍ stworzyÊ pierwszπ czÍúÊ strefy idü teraz do drugiego rogu");
	}else{
		new Float:z;
		GetPlayerPos(playerid,GM[GZs][2],GM[GZs][3],z);
		GM[crtingz] = false;
		new x = CreateZone(GM[GZnm],GM[GZs][0],GM[GZs][1],GM[GZs][2],GM[GZs][3]);
		GM[GZnm][23] = EOS;
		GM[GZs][0] = 0.000;
		GM[GZs][1] = 0.000;
		GM[GZs][2] = 0.000;
		GM[GZs][3] = 0.000;
		if(x == 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dojebano do limitu stref");}
		else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo Stworzy≥eú strefe");}
	}
	return 1;
}
CMD:sledzt(playerid,params[]){
	if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostÍpu do tej cmd"); return 1;}
	if(!PDV[playerid][zSl]){
		PDV[playerid][zSl] = true;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}W≥πczy≥eú åledzenie id terenu");
	}else{
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wy≥πczy≥eú åledzenie id terenu");
		PDV[playerid][zSl] = false;
	}
	return 1;
}
CMD:usunteren(playerid,params[]){
	if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostÍpu do tej cmd"); return 1;}
	new x;
	if(sscanf(params,"i",x)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uøycie: /ausunteren [id]"); return 1;}
	if(!Iter_Contains(aZones, x)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Takie coú nie istnieje"); return 1;}
	DestroyZone(x);
	SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Poprawnie usuniÍto strefe");
	return 1;
}
forward GetGDat(gid);
public GetGDat(gid){
	if(Iter_Contains(GTHC, gid)){print("ERROR: zid alerady exists"); return 1;}
	if(mysql_num_rows() == 1){
		Iter_Add(GTHC, gid);
		cache_get_value_index_int(0, 0, GDV[gid][idG]);
		cache_get_value_index(0, 1, GDV[gid][gName],24);
		cache_get_value_index(0, 2, GDV[gid][gTag],6);
		cache_get_value_index_int(0, 3, GDV[gid][gRspkt]);
		cache_get_value_index_float(0, 4, GDV[gid][gSpawnX]);
		cache_get_value_index_float(0, 5, GDV[gid][gSpawnY]);
		cache_get_value_index_float(0, 6, GDV[gid][gSpawnZ]);
		cache_get_value_index_int(0, 7, GDV[gid][GOid]);
		cache_get_value_index_int(0, 8, GDV[gid][gcolo]);
		GDV[gid][sprT] = -1;
		if(GDV[gid][gSpawnX] != 0.000){
			GDV[gid][gPick] = CreateDynamicPickup(1279, 2, GDV[gid][gSpawnX],GDV[gid][gSpawnY],GDV[gid][gSpawnZ]);
			new str[90];
			format(str,sizeof(str),"{ff0000}-{aaffaa}Baza Gangu{ff0000}-\n{ffaaaa}Gang{ffffff}:%s",GDV[gid][gName]);
			GDV[gid][g3DTxt] = CreateDynamic3DTextLabel(str, -1, GDV[gid][gSpawnX],GDV[gid][gSpawnY],GDV[gid][gSpawnZ], 15.0);
		}
	}
	else{
		printf("ERROR: None or multiple Gangs id:%i",gid);
	}
	return 1;
}
stock CreateGang(gname[24],goid,gtag[6]){
	new gid = Iter_Free(GTHC);
	if(gid == ITER_NONE){return 0;}
	GDV[gid][idG] = gid;
	strcat(GDV[gid][gName],gname,sizeof(gName));
	strcat(GDV[gid][gtag],gtag,sizeof(gTag));
	GDV[gid][gRspkt] = 0;
	GDV[gid][gSpawnX] = 0.000;
	GDV[gid][gSpawnY] = 0.000;
	GDV[gid][gSpawnZ] = 0.000;
	GDV[gid][GOid] = goid;
	GDV[gid][gMem] = 1;
	GDV[gid][sprT] = -1;
	SqlEscStr(gname,gname);
	SqlEscStr(gtag,gtag);
	new quer[110];
	mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `GaS` (`id`,`name`,`tag`,`GOid`) VALUES ('%i','%s','%s','%i')",gid,gname,gtag,goid);
	mq(quer);
	mysql_format(DBM,quer,sizeof(quer),"UPDATE `plys` SET `iGid`='%i',`GPid`='2' WHERE `id`='%i'",gid,goid);
	mq(quer);
	return 1;
}
stock DestroyGang(gid){
	if(!Iter_Contains(GTHC, gid)){return 0;}
	GDV[gid][idG] = -1;
	strcat(GDV[gid][gName],"\0",sizeof(gName));
	strcat(GDV[gid][gtag],"\0",sizeof(gTag));
	GDV[gid][gRspkt] = 0;
	GDV[gid][gSpawnX] = 0.000;
	GDV[gid][gSpawnY] = 0.000;
	GDV[gid][gSpawnZ] = 0.000;
	GDV[gid][GOid] = -1;
	new quer[52];
	mysql_format(DBM, quer, sizeof(quer),"UPDATE `plys` SET `iGid`='-1' WHERE `iGid`='%i'",gid);
	mq(quer);
	mysql_format(DBM,quer,sizeof(quer),"DELETE FROM `GaS` WHERE `id`='%i'",gid);
	mq(quer);
	Iter_Remove(GTHC, gid);
	return 1;
}
stock LoadGZS(){
	new x = sizeof(quer);
	new resi,Cache:res = mq("SELECT COUNT(*) FROM `GZones`");
	cache_get_value_index_int(0,0,resi);
	cache_delete(res);
	resi++;
	if(resi == 1){return 1;}
	new quer[64];
	for(new i=1;i<resi;i++){
		mysql_format(DBM, quer, x, "SELECT * FROM `GZones` WHERE `id`='%i'",i);
		tmq(quer,"GetGDat","i",i);
	}
	return 1;
}
stock LoadGs(){
	new x = sizeof(quer);
	new resi,Cache:res = mq("SELECT COUNT(*) FROM `GaS`");
	cache_get_value_index_int(0,0,resi);
	cache_delete(res);
	resi++;
	if(resi == 1){return 1;}
	new quer[64];
	for(new i=1;i<resi;i++){
		mysql_format(DBM, quer, x, "SELECT * FROM `GaS` WHERE `id`='%i'",i);
		tmq(quer,"GetGDat","i",i);
	}
	return 1;
}
stock SVGDV(gid){
	if(!Iter_Contains(GTHC, gid)){return 0;}
	new quer[150],str1[24],str[6];
	SqlEscStr(GDV[gid][gName],str1);
	SqlEscStr(GDV[gid][gTag],str);
	mysql_format(DBM, quer,sizeof(quer), "UPDATE `GaS` SET `name`='%s',`tag`='%s',`rspkt`='%i',`GOid`='%i',`color`='%i' WHERE `id`='%i'",str1,str,GDV[gid][gRspkt],GDV[gid][GOid],GDV[gid][gcolo],gid);	
	mysql_query(DBM, quer);
	return 1;
}
stock SVGZDV(zid){
	if(!Iter_Contains(aZones, zid)){return 0;}
	new quer[70];
	mysql_format(DBM, quer,sizeof(quer), "UPDATE `GZones` SET `name`='%s',`owner`='%i' WHERE `id`='%i'",GZDV[zid][GZname],GZDV[zid][GZoid],zid);
	mysql_query(DBM, quer);
	return 1;
}
CMD:gang(playerid,params[]){
	if(PDV[playerid][IGid] == -1){
		Dialog_Show(playerid, GangD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Menu", "StwÛrz Gang\nLista GangÛw\nTop Respektu\nInformacje", "OK","Anuluj");
	}else{
		Dialog_Show(playerid, GangJD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Menu", "TwÛj Gang\nLista GangÛw\nTop Respektu\nInformacje", "OK","Anuluj");
	}
	return 1;
}
CMD:stworzgang(playerid,params[]){
	if(PDV[playerid][IGid] != -1){return 0;}
	Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- StwÛrz Gang", "StwÛrz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}PieniÍdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk≥ad:PK,PartiaKorwin", "Ok","Nie");
	return 1;
}
CMD:listagangow(playerid,params[]){
	new str[530],iz=sizeof(str);
	foreach(new x : GTHC){
		strcat(str, GDV[x][gName],iz);
		strcat(str,"\n",iz);
	}
	if(isnull(str)){
		strcat(str,"{ff0000}Brak gangÛw",iz);
	}
	Dialog_Show(playerid, GangLD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Lista GangÛw", str, "Wybierz","Nie");
	return 1;
}
CMD:topgangow(playerid,params[]){
	new str[170];
	format(str,sizeof(str),"Gang\tRespekt\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopGangT],Top[0][TopGang],Top[1][TopGangT],Top[1][TopGang],Top[2][TopGangT],Top[2][TopGang],Top[3][TopGangT],Top[3][TopGang],Top[4][TopGangT],
		Top[4][TopGang],Top[5][TopGangT],Top[5][TopGang],Top[6][TopGangT],Top[6][TopGang],Top[7][TopGangT],Top[7][TopGang],Top[8][TopGangT],Top[8][TopGang],Top[9][TopGangT],Top[9][TopGang]);
	Dialog_Show(playerid,TopDx,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str,"OK","OK");
	return 1;
}
CMD:ginfo(playerid,params[]){
	Dialog_Show(playerid, infoD, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- Info", "------------------System GangÛw------------------\nKrÛtko o gangach:\nWstπpienie lub za≥oøenie gangu zalicza osiπgniÍcie i daje moøliwoúÊ zaliczenia innych.\nJeúli gang posiada teren wszyscy cz≥onkowie na tym zyskujπ otrzymujπc co godzinÍ exp na w≥asne konto.\nGangi naleøy ulepszaÊ by z czasem wiÍcej z niego zyskiwaÊ.\nZa≥oøenie gangu kosztuje : 50k expa i 300k$\nUtrzymanie gangu kosztuje 2.4kExp i 15k$ na dzien", "OK","");
	return 1;
}
CMD:mojgang(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
	Dialog_Show(playerid, GangMD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- MÛj gang", "Dodaj Gracza\nUsun Cz≥onka\nInfo O Gangu\nUlepsz Gang\nCz≥onkowie\nPrzed≥uø Gang", "OK","Anuluj");
	return 1;
}
CMD:dodajg(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
	if(PDV[playerid][GPid] <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz permisji do tej komendy"); return 1;}
	Dialog_Show(playerid, GangDGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Dodaj Gracza", "{ffffff}Podaj ID gracza ktÛrego chcesz dodaÊ", "OK","Nie");
	return 1;
}
CMD:usung(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
	if(PDV[playerid][GPid] <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz permisji do tej komendy"); return 1;}
	Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");
	return 1;
}
CMD:gaccept(playerid,params[]){
	if(PDV[playerid][IGidI] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak zaproszenia"); return 1;}
	foreach(Player,i){
		if(PDV[i][IGid] == PDV[playerid][IGidI] && PDV[i][GPid] <= 1){
			SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz %s zaakceptowa≥ zaproszenie",PDV[playerid][Nck]);
		}
	}
	PDV[playerid][IGid] = PDV[playerid][IGidI];
	PDV[playerid][IGidI] = -1;
	GDV[PDV[playerid][IGid]][gMem]++;
	SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Do≥πczy≥eú do gangu %s",GDV[PDV[playerid][IGid]][gName]);
	return 1;
}
CMD:gdeny(playerid,params[]){
	if(PDV[playerid][IGidI] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Zaproszenia"); return 1;}
	foreach(Player,i){
		if(PDV[i][IGid] == PDV[playerid][IGidI] && PDV[i][GPid] <= 1){
			SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz %s odrzuci≥ zaproszenie",PDV[playerid][Nck]);
		}
	}
	PDV[playerid][IGidI] = -1;
	SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Odrzuci≥eú zaproszenie");
	return 1;
}
CMD:gopusc(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Gangu"); return 1;}
	if(PDV[playerid][GPid] == 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Jesteú liderem nie moøesz siÍ usunπÊ"); return 1;}
	new str[45];
	format(str,sizeof(str),"Gracz %s opuúci≥ gang",PDV[playerid][Nck]);
	MSGGang(PDV[playerid][IGid],INVALID_PLAYER_ID,str);
	GDV[PDV[playerid][IGid]][gMem]--;
	PDV[playerid][IGid] = -1;
	PDV[playerid][GPid] = 0;
	SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Odszed≥eú z gangu");
	return 1;
}
CMD:gulepsz(playerid,params[]){
	if(PDV[playerid][PGid] != 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteú liderem gangu"); return 1;}
	Dialog_Show(playerid, GangUpGD, DIALOG_STYLE_TABLIST_HEADERS, "{aaffaa}Gang {ffffff}- Ulepsz Gang", "LVL\tKoszt\n{ffffff}LVL 1\t75k Expa i 500k$\nLVL 2\t100k Expa i 750k$\nLVL 3\t150k Expa 1mln $\nLVL 4\t200k expa i 2 mln$", "OK","Nie");
	return 1;
}
CMD:mginfo(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak gangu"); return 1;}
	new st2[390],iz=sizeof(st2);
	foreach(Player,i){
		if(PDV[i][IGid] == PDV[playerid][IGid]){
			strcat(st2,PDV[i][Nck],iz);
			strcat(st2,"\n",iz);
		}
	}
	new str[520];
	format(str,sizeof(str),"Gang:%s\nTag:%s\n\nRespekt:%i\nIloúÊ TerenÛw:%i\nIloúÊ Cz≥onkÛw:%i\nCz≥onkowie Online:{00ff00}%s",GDV[PDV[playerid][IGid]][gName],GDV[PDV[playerid][IGid]][gTag],GDV[PDV[playerid][IGid]][gRpskt],GDV[PDV[playerid][IGid]][gTrtCoun],GDV[PDV[playerid][IGid]][gMem],st2);
	Dialog_Show(playerid, infoD, DIALOG_STYLE_TABLIST_HEADERS, "{aaffaa}Gang {ffffff}- Info o Gangu", str, "Ok","");
	return 1;
}
CMD:mgczlonkowie(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Gangu"); return 1;}
	new st2[600],iz=sizeof(st2);
	foreach(Player,i){
		if(PDV[i][IGid] == PDV[playerid][IGid]){
			strcat(st2,PDV[i][Nck],iz);
			strcat(st2,"\n",iz);
		}
	}
	new str[520];
	format(str,sizeof(str),"{ffffff}Cz≥onkowie Online:{00ff00}%s",st2);
	Dialog_Show(playerid, infoD, DIALOG_STYLE_TABLIST_HEADERS, "{aaffaa}Gang {ffffff}- Info o Gangu", str, "Ok","");	
	return 1;
}
CMD:gprzedluz(playerid,params[]){
	if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Gangu"); return 1;}
	Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed≥uø", "{ffffff}Wpisz iloúÊ dni na ktÛrπ chcesz przed≥uøyÊ {aaffaa}Gang","OK","Anuluj");
	return 1;
}
CMD:spar(playerid,params[]){
	if(PDV[playerid][GPid] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostÍpu do tej komendy"); return 1;}
	new spra;
	if(sscanf(params,"i",spra)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uøycie:/spar [id]")}
	return 1;
}
CMD:sparaccept(playerid,params[]){
	return 1;
}
Dialog:expirG(playerid,response,listitem,inputtext[]){
	if(PDV[playerid][IGid] == -1){return 1;}
	if(response){
		if(isnull(inputtext)){Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed≥uø", "{ffffff}Wpisz iloúÊ dni na ktÛrπ chcesz przed≥uøyÊ {aaffaa}Gang\n{ff0000}Wpisz COå!","OK","Anuluj");}
		if(!IsNumeric(inputtext)){Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed≥uø", "{ffffff}Wpisz iloúÊ dni na ktÛrπ chcesz przed≥uøyÊ {aaffaa}Gang\n{ff0000}ILOå∆ DNI!","OK","Anuluj");}
		new v = strval(inputtext);
		new bool:cos = TkPlRe(playerid,v * 2400);
		if(!cos){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak úrodkÛw potrzebne %i Exp",v * 2400); return 1;}
		cos = TkPlMo(playerid,v * 15000);
		if(!cos){GiRe(playerid,v * 2400);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak úrodkÛw potrzebne %i Hajsu",v * 15000); return 1;}
		GDV[PDV[playerid][IGid]][gExpire] += v;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff80}Przed≥uøy≥eú Gang na {00ffff}%i {00ff80}dni",GDV[PDV[playerid][IGid]][gExpire]);
	}
	return 1;
}
Dialog:GangMD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else{
		switch(listitem){
			case 0:callcmd::dodajg(playerid,'');
			case 1:callcmd::usung(playerid,'');
			case 2:callcmd::mginfo(playerid,'');
			case 3:callcmd::gulepsz(playerid,'');
			case 4:callcmd::mgczlonkowie(playerid,'');
			case 5:callcmd::gprzedluz(playerid,'');
		}
	}
	return 1;
}
Dialog:GangUpGD(playerid,response,listitem,inputtext[]){
	if(PDV[playerid][GPid] != 2){}
	else if(!response){}
	else {
		switch(listitem){
			case 0:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem+1){
					new v = TkPlRe(playerid,75000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					v = TkPlMo(playerid,500000);
					if(!v){GiRe(playerid,75000);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					GDV[PDV[playerid][IGid]][LVL] = 1;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy≥eú Gang");
				}else{
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Juø masz wiÍkszy lvl bπdü taki sam");
				}
			}
			case 1:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem+1){
					new v = TkPlRe(playerid,100000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					v = TkPlMo(playerid,750000);
					if(!v)GiRe(playerid,100000);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					GDV[PDV[playerid][IGid]][LVL] = 2;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy≥eú Gang");
				}else{
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Juø masz wiÍkszy lvl bπdü taki sam");
				}
			}
			case 2:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem+1){
					new v = TkPlRe(playerid,150000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					v = TkPlMo(playerid,1000000);
					if(!v){GiRe(playerid,150000);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					GDV[PDV[playerid][IGid]][LVL] = 3;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy≥eú Gang");
				}else{
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Juø masz wiÍkszy lvl bπdü taki sam");
				}
			}
			case 3:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem+1){
					new v = TkPlRe(playerid,200000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					v = TkPlMo(playerid,2000000);
					if(!v){GiRe(playerid,200000);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
					GDV[PDV[playerid][IGid]][LVL] = 4;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy≥eú Gang");
				}else{
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Juø masz wiÍkszy lvl bπdü taki sam");
				}
			}
		}
	}
	return 1;
}
Dialog:GangDGD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else {
		if(PDV[playerid][GPid] == 0){return 1;}
		if(PDV[playerid][IGid] == -1){return 1;}
		if(isnull(inputtext)){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}BRAK ID GRACZA!\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		new x = strval(inputtext);
		if(!IsPlayerConnected(x)){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz nie istnieje!\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		if(PDV[x][IGid] != -1){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest juø w innym gangu\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		PDV[x][IGidI] = PDV[playerid][IGid];
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zosta≥eú zaproszony do Gangu {aaffaa}%s{00ff00} przez {aaffaa}%s{ffffff} /gaccept",GDV[PDV[playerid][IGid]][gName],PDV[playerid][Nck]);
	}	
	return 1;
}
Dialog:GangUGD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else {
		if(PDV[playerid][GPid] == 0){return 1;}
		if(PDV[playerid][IGid] == -1){return 1;}
		if(isnull(inputtext)){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}BRAK ID GRACZA!\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		new x = strval(inputtext);
		if(!IsPlayerConnected(x)){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz nie istnieje!\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		if(PDV[x][IGid] != PDV[x][IGid]){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest nie w tym gangu\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		if(PDV[x][GPid] == 2){return Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest liderem!\n{ffffff}Podaj ID gracza ktÛrego chcesz UsunπÊ", "OK","Nie");}
		PDV[x][IGid] = -1;
		PDV[x][GPid] = 0;
		GDV[PDV[playerid][IGid]][gMem]--;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta≥eú wyrzucony z gangu przez %s",PDV[playerid][Nck]);
	}
	return 1;
}
Dialog:GangLD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else {
		foreach(new x : GTHC){
			if(x == listitem){
				new str[504],MembersOnline[390],iz=sizeof(MembersOnline);
				foreach(Player,i){
					if(PDV[i][IGid] == x){
						strcat(MembersOnline,PDV[i][Nck],iz);
						strcat(MembersOnline,"\n",iz);
					}
				}
				format(str,sizeof(str),"Gang:%s\nTag:%s\n\nID:%i\nRespekt:%i\nTereny:%i\nCz≥onkowie Online:%s",GDV[x][gName],GDV[x][gTag],x,GDV[x][gRspkt],GDV[x][gTrtCoun],MemberOnline);
				Dialog_Show(playerid, infoD, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- Lista GangÛw", str, "OK","");
				break;
			}
		}
	}
	return 1;
}
Dialog:GangSD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else{
		if(isnull(inputtext)){Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- StwÛrz Gang", "{ff0000}Juø taka nazwa gangu istnieje!\nStwÛrz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}PieniÍdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk≥ad:PK,PartiaKorwin", "Ok","Nie");}
		new TagG[6],NazwaG[24];
		if(sscanf(inputtext, 'p<,>s[6]s[24]', TagG,NazwaG)){Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- StwÛrz Gang", "StwÛrz Gang\n{ff0000}èle wpisa≥eú Tag i nazwe gangu popatrz na dole po przyk≥ad\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}PieniÍdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk≥ad:PK,PartiaKorwin", "Ok","Nie"); return 1;}
		foreach(new x : GTHC){
			if(!strcmp(GDV[x][gTag], TagG, false)){
				Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- StwÛrz Gang", "{ff0000}Juø taka nazwa gangu istnieje!\nStwÛrz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}PieniÍdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk≥ad:PK,PartiaKorwin", "Ok","Nie");
				return 1;
			}
			else if(!strcmp(GDV[x][gName],NazwaG,false)){
				Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- StwÛrz Gang", "{ff0000}Juø taka nazwa gangu istnieje!\nStwÛrz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}PieniÍdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk≥ad:PK,PartiaKorwin", "Ok","Nie");
				return 1;
			}
		}
		new str[170];
		SetPVarString(playerid, TagGp, TagG);
		SetPVarString(playerid, NazwaGp, NazwaG);
		format(str,sizeof(str),"{ffffff}Czy napewno chcesz stworzyÊ Gang?\nNazwa Gangu:{aaffaa}%s\n{ffffff}Tag Gangu:{aaffaa}%s\nBÍdzie cie to kosztowa≥o 30k Expa i 300k$",NazwaG,TagG);
		Dialog_Show(playerid, GangSDc, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- StwÛrz Gang{ff0000}Potwierdz", str, "Tak","Nie");
	}
	return 1;
}
Dialog:GangSDc(playerid,response,listitem,inputtext[]){
	new TagG[6],NazwaG[24];
	GetPVarString(playerid, TagGp, TagG, 6);
	GetPVarString(playerid, NazwaGp, NazwaG, 24);
	if(strlen(TagG) <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {FF0000}Tag musi mieÊ wiÍcej niø 0 znakÛw!!!!"); return 1;}
	if(strlen(NazwaG) <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {FF0000}Nazwa musi mieÊ wiÍcej niø 0 znakÛw!!!!"); return 1;}
	if(!response){}
	else {
		new v = TkPlRe(playerid,30000);
		if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
		v = TkPlMo(playerid,300000);
		if(!v){GiRe(playerid,30000);SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczajπce úrodki"); return 1;}
		CreateGang(NazwaG,PDV[playerid][iDP],TagG);
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Pomyúlnie stworzono Gang:%s",NazwaG);
	}
	return 1;
}
Dialog:GangJD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else{
		switch(listitem){
			case 0:callcmd::stworzgang(playerid,params[]);
			case 1:callcmd::listagangow(playerid,params[]);
			case 2:callcmd::topgangow(playerid,params[]);
			case 3:callcmd::ginfo(playerid,params[]);
		}
	}
	return 1;
}
Dialog:GangD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else {
		switch(listitem){
			case 0:callcmd::mojgang(playerid,params[]);
			case 1:callcmd::listagangow(playerid,params[]);
			case 2:callcmd::topgangow(playerid,params[]);
			case 3:callcmd::ginfo(playerid,params[]);
		}
	}
	return 1;
}