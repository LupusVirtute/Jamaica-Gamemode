/*
 0< getting on
 -1 - nothing
 -2 - going on
*/
enum g_En{
	wgs,
	pls[3]
}
new Float:wgsp[][] = {
	{0.000,0.000,0.000,0.000,1.000}
};
//set to 0 in disc and death and check in timer SWG
new GM[g_En];
stock StartWG(){
	if(GM[pls][2] >= 3){
		foreach(Player,i){
			if(PDV[i][Plays] == 3){
				new r = random(sizeof(wgsp))
				SetPlayerPos(i,wgsp[r][0]+i,wgsp[r][1],wgsp[r][2]);
				SetPlayerFacingAngle(i,wgsp[r][3]);
				GivePlayerWeapon(i,24,3000);
				GivePlayerWeapon(i,28,3000);
				CreateDynamicArea//Or Something
				SetPlayerTeam(i,floatround(wgsp[r][4],floatround_toceil));
			}
		}
		GM[wgs] = GetTickCount()+10000;
		//Add message
	}
	return 1;
}
stock OnWGed(Team){
	GM[wgs] = -1;
	GM[pls][2] = 0;
	if(Team == -1){
		//Messages
		return 1;
	}
	foreach(Player,i){
		if(GetPlayerTeam(i) == Team){
			GiRe(i,50);
			GiPlMo(i,35000);
		}
	}
	//another msg
	return 1;
}
//add in exit -
CMD:wg(playerid,params[]){
	if(GM[wgs] == -2){return 1;}//Add message
	if(PDV[playerid][Plays] == 3){return 1;}//Add message
	GM[pls][2] = 0;
	foreach(Player,i){
		if(PDV[i][Plays] == 3){
			GM[pls][2]++;
		}
	}
	//Add SCM
	GM[pls][2]++;
	PDV[playerid][Plays] = 3;
	if(GM[pls][2] >= 3){
		StartWG();
	}
	return 1;
}
CMD:kwg(playerid,params[]){
	if(PDV[playerid][APL] < 6){return 1;}//Add msg
	foreach(Player,i){
		if(PDV[i][Plays] == 3){
			PDV[i][Plays] = 0;
			ReS(i);
		}
	}
	GM[pl][2] = 0;
	GM[wgs] = -1;
	//Msg
	return 1;
}