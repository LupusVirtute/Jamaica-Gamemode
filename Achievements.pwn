#define MAX_ACHIEVS 200
new Achievs[][][] = {
	{"Zabójca I stopnia "," zabij na onede 150 graczy"},
	{"Zabójca II stopnia "," zabij na onede 1,500 graczy"},
	{"Zabójca III stopnia "," zabij na onede 10,000 graczy"},
	{"Mistrz Broni "," Gracz wygrał 200 solówek"},
	{"Pierwsza Krew "," zabij swojego pierwszego gracza"},
	{"Zabójca I stopnia ","  Zabij 1,000 graczy"},
	{"Zabójca II stopnia "," Zabij 5,000 graczy"},
	{"Zabójca III stopnia "," Zabij 15,000 graczy"},
	{"Pierwsza Śmierć "," popełnij samobójstwo"},
	{"Samouk "," gracz przeczytał regulamin serwera"}
/*	{"Minigun I stopnia "," zabij na Minigunie 150 graczy"},
	{"Uczciwy Znalazca "," Gracz znalazł 50 walizek"},
	{"Minigun II stopnia "," zabij na Minigunie 1,500 graczy"},
	{"Minigun III stopnia "," zabij na Minigunie 10,000 graczy"},
	{"Pompa I stopnia "," zabij na Shotgun 150 graczy"},
	{"Pompa II stopnia "," zabij na Shotgun 1,500 graczy"},
	{"Pompa III stopnia "," zabij na Shotgun 10,000 graczy"},
	{"Snajper I stopnia "," zabij na Sniper 150 graczy"},
	{"Snajper II stopnia "," zabij na Sniper 1,500 graczy"},
	{"Snajper III stopnia "," zabij na Sniper 10,000 graczy"},
	{"Plan na Życie "," zostań ukarany w formie więzienia"},
	{"Wędrownik "," odwiedź wszystkie teleporty serwera"},
	{"Prywatna Gablota "," kup privcara"},
	{"Gablota w Ruchu I "," Gracz przejechal privcarem 1,000 km"},
	{"Gablota w Ruchu II "," Gracz przejechal privcarem 3,000 km"},
	{"Gablota w Ruchu III "," Gracz przejechal privcarem 5,000 km"},
	{"Stały Fan "," gracz był cały czas online przez ponad 3 godziny"},
	{"Młody Biznesmen "," gracz zyskał ileś tam z posiadłości jednocześnie"},
	{"Stały gracz "," gracz spędził w sumie 40 godzin na serwerze"},
	{"Zabytek Serwera! "," Gracz spędził w sumie 500 godzin na serwerze"},
	{"Legenda Jamaici "," Gracz odwiedził serwer 1000 razy"},
	{"Psychol "," Gracz nabił killstreak większy niż 10"},
	{"Urodziny Jamaica Server! "," gracz zalogował się w tygodniu świętowania urodzin!"},
	{"Konfident "," gracz zgłosił innych 20 razy"},
	{"Snajper "," gracz zabił ogółem 50 przeciwników ze sniperki"},
	{"Milioner "," gracz uzbierał w swoim sejfie 300.000.000 dolarów"},
	{"Gangster "," Gracz załozył własny gang lub do niego dołączył!"},
	{"Pierwsza Inwestycja "," Gracz zakupił dom"},
	{"Pasja Zabijania "," Gracz zabił kogos z /admins (ogolnie admina)"},
	{"Ideał Serwera "," Gracz zdobył wszystkie poprzednie osiągnięcia"},
	{"Zawodowy Rajdowiec I stopnia "," Gracz nabił 10,000 pkt driftu z mnoznikiem"},
	{"Zawodowy Rajdowiec II stopnia "," Gracz nabił 10,000 pkt driftu bez mnoznika"},
	{"Zawodowy Rajdowiec III stopnia "," Gracz nabił 15,000 pkt driftu bez mnoznika"},
	{"Gangowicz "," zdobadz dla gangu 5000 respektu"},
	{"Królicza łapka "," gracz wygrał w lotto ponad 400,000 dolarów"},
	{"Zabijam Bronią Dnia "," Gracz zabił 200 graczy bronią dnia"},
	{"Miłośnik Broni "," Gracz zabił 500 graczy bronią dnia"},
	{"Ślub z Bronią "," Gracz zabił 1000 graczy bronią dnia"},
	{"Pracuś "," gracz przepracował 50 prac 'czegoś tam'"},
	{"Złodziej Idealny "," Gracz okradł 40 domów "},
	{"Łowca Krów "," Gracz zabił 5 krówek"},
	{"Mistrz Zadań I stopnia"," Gracz wykonał 50 questów"},
	{"Mistrz Zadań II stopnia"," Gracz wykonał 100 questów"},
	{"Mistrz Zadań III stopnia"," Gracz wykonał 150 questów"},
	{"Mistrz Sumo "," Gracz wygrał 30 gier Sumo"},
	{"Mistrz Wyścigów "," Gracz wygrał 40 wyścigów"},
	{"Mistrz Wojen "," Gracz wygrał 40 Wojen Gangów"},
	{"Mistrz Labiryntu "," Gracz wygrał 30 labiryntów"},
	{"Mistrz GunGame "," Gracz wygrał 40 gier GunGame"},
	{"Mistrz Kolorów "," Gracz wygrał 30 gier ColorMatch"},
	{"Mistrz CTF "," Graczz wygrał 40 gier Capture The Flag"},
	{"Mistrz Chowanego "," Gracz wygrał 40 gier Chowanego"},
	{"Mistrz Derbów "," Gracz wygrał 30 razy Derby"},
	{"Łowca głów "," gracz wygrał 40 razy wyspe przetrwania"},
	{"Mistrz H&C "," Gracz wygrał 40 gier Walk Hydr przeciwko Czołgom"},
	{"Mistrz Siana "," Gracz wygrał 40 razy Sianko"},
	{"Mistrz Fallout "," Gracz wygrał 40 gier Fallout"}*/
};
stock AchievSee(pid){
	new str[1150];
	for(new i=0,x=sizeof(Achievs);i<x;i++){
		strcat(str,Achievs[i][0],1150);
	}
	Dialog_Show(playerid, AchievD, DIALOG_STYLE_LIST, "Twoje Osiągniecia", str, "Ok","Ok");
	return 1;
}
new AchTD[7];
new pAchTD[MAX_PLAYERS][2];
stock TxtD(){

	AchTD[6] = TextDrawCreate(270.888854, 40.168880, "box");
	TextDrawLetterSize(AchTD[6], 0.000000, 5.555554);
	TextDrawTextSize(AchTD[6], 446.000000, 0.000000);
	TextDrawAlignment(AchTD[6], 1);
	TextDrawColor(AchTD[6], -1);
	TextDrawUseBox(AchTD[6], 1);
	TextDrawBoxColor(AchTD[6], 80);
	TextDrawSetShadow(AchTD[6], 0);
	TextDrawBackgroundColor(AchTD[6], 255);
	TextDrawFont(AchTD[6], 1);
	TextDrawSetProportional(AchTD[6], 1);

	AchTD[0] = TextDrawCreate(418.777740, 74.360000, "LD_CHAT:badchat");
	TextDrawTextSize(AchTD[0], 18.000000, 13.000000);
	TextDrawAlignment(AchTD[0], 1);
	TextDrawColor(AchTD[0], -1);
	TextDrawSetShadow(AchTD[0], 0);
	TextDrawBackgroundColor(AchTD[0], 255);
	TextDrawFont(AchTD[0], 4);
	TextDrawSetProportional(AchTD[0], 0);

	AchTD[1] = TextDrawCreate(448.111450, 92.280075, "LD_DRV:tvcorn");
	TextDrawTextSize(AchTD[1], -91.000000, -29.000000);
	TextDrawAlignment(AchTD[1], 1);
	TextDrawColor(AchTD[1], -1);
	TextDrawSetShadow(AchTD[1], 0);
	TextDrawBackgroundColor(AchTD[1], 255);
	TextDrawFont(AchTD[1], 4);
	TextDrawSetProportional(AchTD[1], 0);

	AchTD[2] = TextDrawCreate(268.555694, 38.022235, "LD_DRV:tvcorn");
	TextDrawTextSize(AchTD[2], 90.000000, 28.000000);
	TextDrawAlignment(AchTD[2], 1);
	TextDrawColor(AchTD[2], -1);
	TextDrawSetShadow(AchTD[2], 0);
	TextDrawBackgroundColor(AchTD[2], 255);
	TextDrawFont(AchTD[2], 4);
	TextDrawSetProportional(AchTD[2], 0);

	AchTD[3] = TextDrawCreate(448.111541, 38.022235, "LD_DRV:tvcorn");
	TextDrawTextSize(AchTD[3], -91.000000, 26.000000);
	TextDrawAlignment(AchTD[3], 1);
	TextDrawColor(AchTD[3], -1);
	TextDrawSetShadow(AchTD[3], 0);
	TextDrawBackgroundColor(AchTD[3], 255);
	TextDrawFont(AchTD[3], 4);
	TextDrawSetProportional(AchTD[3], 0);

	AchTD[4] = TextDrawCreate(268.555419, 92.280044, "LD_DRV:tvcorn");
	TextDrawTextSize(AchTD[4], 89.000000, -29.000000);
	TextDrawAlignment(AchTD[4], 1);
	TextDrawColor(AchTD[4], -1);
	TextDrawSetShadow(AchTD[4], 0);
	TextDrawBackgroundColor(AchTD[4], 255);
	TextDrawFont(AchTD[4], 4);
	TextDrawSetProportional(AchTD[4], 0);

	AchTD[5] = TextDrawCreate(280.999847, 78.839965, "ld_shtr:hi_b");
	TextDrawTextSize(AchTD[5], 53.000000, 12.000000);
	TextDrawAlignment(AchTD[5], 1);
	TextDrawColor(AchTD[5], -1);
	TextDrawSetShadow(AchTD[5], 0);
	TextDrawBackgroundColor(AchTD[5], 255);
	TextDrawFont(AchTD[5], 4);
	TextDrawSetProportional(AchTD[5], 0);

	pAchTD[pid][0] = CreatePlayerTextDraw(pid,300.666503, 59.582218, "~b~1000 ~r~EXP ~b~10000 ~g~$");
	PlayerTextDrawLetterSize(pid,pAchTD[pid][0], 0.400000, 1.600000);
	PlayerTextDrawTextSize(pid,pAchTD[pid][0], 468.000000, 0.000000);
	PlayerTextDrawAlignment(pid,pAchTD[pid][0], 1);
	PlayerTextDrawColor(pid,pAchTD[pid][0], 512557055);
	PlayerTextDrawSetShadow(pid,pAchTD[pid][0], -133);
	PlayerTextDrawSetOutline(pid,pAchTD[pid][0], -1);
	PlayerTextDrawBackgroundColor(pid,pAchTD[pid][0], 255);
	PlayerTextDrawFont(pid,pAchTD[pid][0], 3);
	PlayerTextDrawSetProportional(pid,pAchTD[pid][0], 1);

	pAchTD[pid][1] = CreatePlayerTextDraw(pid,282.000030, 46.142242, "Zawodowy Rajdowiec III stopnia");
	PlayerTextDrawLetterSize(pid,pAchTD[pid][1], 0.261777, 0.818488);
	PlayerTextDrawTextSize(pid,pAchTD[pid][1], 506.000000, 0.000000);
	PlayerTextDrawAlignment(pid,pAchTD[pid][1], 1);
	PlayerTextDrawColor(pid,pAchTD[pid][1], 512557055);
	PlayerTextDrawSetShadow(pid,pAchTD[pid][1], 0);
	PlayerTextDrawSetOutline(pid,pAchTD[pid][1], 1);
	PlayerTextDrawBackgroundColor(pid,pAchTD[pid][1], 255);
	PlayerTextDrawFont(pid,pAchTD[pid][1], 3);
	PlayerTextDrawSetProportional(pid,pAchTD[pid][1], 1);
	return 1;}
stock ShowAchiev(pid,acid){
	switch(acid){
		case 0:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~120 ~r~EXP ~b~10.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 1:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~250 ~r~EXP ~b~25.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 2:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~520 ~r~EXP ~b~100.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 3:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~140 ~r~EXP ~b~10.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 4:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~1 ~r~EXP ~b~3.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 5:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~340 ~r~EXP ~b~100.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 6:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~1020 ~r~EXP ~b~200.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 7:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~30.020 ~r~EXP ~b~5.000.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 8:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~-20 ~r~EXP ~b~-10.000 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 9:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~80 ~r~EXP ~b~800 ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 10:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 11:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 12:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 13:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 14:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 15:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 16:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 17:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 18:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 19:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 20:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 21:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 22:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 23:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 24:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 25:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 26:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 27:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 28:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 29:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 30:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 31:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 32:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 33:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 34:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 35:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 36:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 37:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 38:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 39:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 40:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 41:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 42:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 43:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 44:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 45:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 46:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 47:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 48:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 49:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 50:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 51:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 52:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 53:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 54:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 55:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 56:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 57:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 58:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 59:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 60:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 61:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 62:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 63:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 64:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 65:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 66:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		case 67:{
			PlayerTextDrawSetString(pid, pAchTD[pid][0],"~b~--- ~r~EXP ~b~--- ~g~$");
			PlayerTextDrawSetString(pid, pAchTD[pid][1],Achievs[acid][0]);
		}
		default:{return 1;}
	}
	TextDrawShowForPlayer(pid, AchTD[0]);
	TextDrawShowForPlayer(pid, AchTD[1]);
	TextDrawShowForPlayer(pid, AchTD[2]);
	TextDrawShowForPlayer(pid, AchTD[3]);
	TextDrawShowForPlayer(pid, AchTD[4]);
	TextDrawShowForPlayer(pid, AchTD[5]);
	PlayerTextDrawShow(pid, AchTD[pid][0]);
	PlayerTextDrawShow(pid, AchTD[pid][1]);
	return 1;
}
stock SetAchiev(pid,acid){
	if(PDV[pid][LogIn]){
		switch(acid){
			case 0:{
				if(PDV[pid][OKi] >= 150 && !PDV[pid][Achiev][0]){
					PDV[pid][Achiev][0] = true;
					GiRe(pid,120);
					GiPlMo(pid,10000);
					ShowAchiev(pid,0);
				}
				else if(PDV[pid][OKi] >= 1500 && !PDV[pid][Achiev][1]){
					PDV[pid][Achiev][1] = true;
					GiRe(pid,250);
					GiPlMo(pid,25000);
					ShowAchiev(pid,1);
				}
				else if(PDV[pid][OKi] >= 10000  && !PDV[pid][Achiev][2]){
					PDV[pid][Achiev][2] = true;
					GiRe(pid,520);
					GiPlMo(pid,100000);
					ShowAchiev(pid,2);
				}
			}
			case 1:{
				if(!PDV[pid][Achiev][9]){
					PDV[pid][Achiev][9] = true;
					GiRe(pid,80);
					GiPlMo(pid,800);
					ShowAchiev(pid,9);
				}
			}
			case 2:{
				if(PDV[pid][SKi] >= 200  && !PDV[pid][Achiev][3]){
					PDV[pid][Achiev][3] = true;
					GiRe(pid,140);
					GiPlMo(pid,10000);
					ShowAchiev(pid,3);
				}
			}
			case 3:{
				if(PDV[pid][Ki] >= 1 && !PDV[pid][Achiev][4]){
					PDV[pid][Achiev][4] = true;
					GiRe(pid,1);
					GiPlMo(pid,3000);
					ShowAchiev(pid,4);
				}
				else if(PDV[pid][Ki] >= 1000 && !PDV[pid][Achiev][5]){
					PDV[pid][Achiev][5] = true;
					GiRe(pid,340);
					GiPlMo(pid,100000);
					ShowAchiev(pid,5);
				}
				else if(PDV[pid][Ki] >= 5000 && !PDV[pid][Achiev][6]){
					PDV[pid][Achiev][6] = true;
					GiRe(pid,1020);
					GiPlMo(pid,200000);
					ShowAchiev(pid,6);	
				}
				else if(PDV[pid][Ki] >= 15000 && !PDV[pid][Achiev][7]){
					PDV[pid][Achiev][7] = true;
					GiRe(pid,30020);
					GiPlMo(pid,5000000);
					ShowAchiev(pid,7);
				}
			}
			case 4:{
				if(PDV[pid][De] >= 1 && !PDV[pid][Achiev][8]){
					PDV[pid][Achiev][8] = true;
					TkPlRe(pid,20);
					TKPlMo(pid,10000);
					ShowAchiev(pid,8);
				}
			}/*
			case 10:{
				if(){
					PDV[pid][Achiev][10] = true;
				}
			}
			case 11:{
				if(){
					PDV[pid][Achiev][11] = true;
				}
			}
			case 12:{
				if(){
					PDV[pid][Achiev][12] = true;
				}
			}
			case 13:{
				if(){
					PDV[pid][Achiev][13] = true;
				}
			}
			case 14:{
				if(){
					PDV[pid][Achiev][14] = true;
				}
			}
			case 15:{
				if(){
					PDV[pid][Achiev][15] = true;
				}
			}
			case 16:{
				if(){
					PDV[pid][Achiev][16] = true;
				}
			}
			case 17:{
				if(){
					PDV[pid][Achiev][17] = true;
				}
			}
			case 18:{
				if(){
					PDV[pid][Achiev][18] = true;
				}
			}
			case 19:{
				if(){
					PDV[pid][Achiev][19] = true;
				}
			}
			case 20:{
				if(){
					PDV[pid][Achiev][20] = true;
				}
			}
			case 21:{
				if(){
					PDV[pid][Achiev][21] = true;
				}
			}
			case 22:{
				if(){
					PDV[pid][Achiev][22] = true;
				}
			}
			case 23:{
				if(){
					PDV[pid][Achiev][23] = true;
				}
			}
			case 24:{
				if(){
					PDV[pid][Achiev][24] = true;
				}
			}
			case 25:{
				if(){
					PDV[pid][Achiev][25] = true;
				}
			}
			case 26:{
				if(){
					PDV[pid][Achiev][26] = true;
				}
			}
			case 27:{
				if(){
					PDV[pid][Achiev][27] = true;
				}
			}
			case 28:{
				if(){
					PDV[pid][Achiev][28] = true;
				}
			}
			case 29:{
				if(){
					PDV[pid][Achiev][29] = true;
				}
			}
			case 30:{
				if(){
					PDV[pid][Achiev][30] = true;
				}
			}
			case 31:{
				if(){
					PDV[pid][Achiev][31] = true;
				}
			}
			case 32:{
				if(){
					PDV[pid][Achiev][32] = true;
				}
			}
			case 33:{
				if(){
					PDV[pid][Achiev][33] = true;
				}
			}
			case 34:{
				if(){
					PDV[pid][Achiev][34] = true;
				}
			}
			case 35:{
				if(){
					PDV[pid][Achiev][35] = true;
				}
			}
			case 36:{
				if(){
					PDV[pid][Achiev][36] = true;
				}
			}
			case 37:{
				if(){
					PDV[pid][Achiev][37] = true;
				}
			}
			case 38:{
				if(){
					PDV[pid][Achiev][38] = true;
				}
			}
			case 39:{
				if(){
					PDV[pid][Achiev][39] = true;
				}
			}
			case 40:{
				if(){
					PDV[pid][Achiev][40] = true;
				}
			}
			case 41:{
				if(){
					PDV[pid][Achiev][41] = true;
				}
			}
			case 42:{
				if(){
					PDV[pid][Achiev][42] = true;
				}
			}
			case 43:{
				if(){
					PDV[pid][Achiev][43] = true;
				}
			}
			case 44:{
				if(){
					PDV[pid][Achiev][44] = true;
				}
			}
			case 45:{
				if(){
					PDV[pid][Achiev][45] = true;
				}
			}
			case 46:{
				if(){
					PDV[pid][Achiev][46] = true;
				}
			}
			case 47:{
				if(){
					PDV[pid][Achiev][47] = true;
				}
			}
			case 48:{
				if(){
					PDV[pid][Achiev][48] = true;
				}
			}
			case 49:{
				if(){
					PDV[pid][Achiev][49] = true;
				}
			}
			case 50:{
				if(){
					PDV[pid][Achiev][50] = true;
				}
			}
			case 51:{
				if(){
					PDV[pid][Achiev][51] = true;
				}
			}
			case 52:{
				if(){
					PDV[pid][Achiev][52] = true;
				}
			}
			case 53:{
				if(){
					PDV[pid][Achiev][53] = true;
				}
			}
			case 54:{
				if(){
					PDV[pid][Achiev][54] = true;
				}
			}
			case 55:{
				if(){
					PDV[pid][Achiev][55] = true;
				}
			}
			case 56:{
				if(){
					PDV[pid][Achiev][56] = true;
				}
			}
			case 57:{
				if(){
					PDV[pid][Achiev][57] = true;
				}
			}
			case 58:{
				if(){
					PDV[pid][Achiev][58] = true;
				}
			}
			case 59:{
				if(){
					PDV[pid][Achiev][59] = true;
				}
			}
			case 60:{
				if(){
					PDV[pid][Achiev][60] = true;
				}
			}
			case 61:{
				if(){
					PDV[pid][Achiev][61] = true;
				}
			}
			case 62:{
				if(){
					PDV[pid][Achiev][62] = true;
				}
			}
			case 63:{
				if(){
					PDV[pid][Achiev][63] = true;
				}
			}
			case 64:{
				if(){
					PDV[pid][Achiev][64] = true;
				}
			}
			case 65:{
				if(){
					PDV[pid][Achiev][65] = true;
				}
			}
			case 66:{
				if(){
					PDV[pid][Achiev][66] = true;
				}
			}*/
		}
	}
	return 1;
}