enum TOP_enum {
	TopKasy,
	TopKasyn[24],
	TopRsp,
	TopRspn[24],
	TopKill,
	TopKilln[24],
	TopOnede,
	TopOneden[24],
	TopDeath,
	TopDeathn[24],
	TopDeta,
	TopDetan[24],
	TopPompa,
	TopPompan[24],
	TopMini,
	TopMinin[24],
	TopOnline,
	TopOnlinen[24],
	TopSniper,
	TopSnipern[24]
}
new Top[10][TOP_enum];
stock CreateTop(){
	new Cache:res = mysql_query(DBM, "SELECT `csh`,`nck` FROM` plys` ORDER BY `csh` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopKasy]);
	cache_get_value_index_int(1, 0, Top[1][TopKasy]);
	cache_get_value_index_int(2, 0, Top[2][TopKasy]);
	cache_get_value_index_int(3, 0, Top[3][TopKasy]);
	cache_get_value_index_int(4, 0, Top[4][TopKasy]);
	cache_get_value_index_int(5, 0, Top[5][TopKasy]);
	cache_get_value_index_int(6, 0, Top[6][TopKasy]);
	cache_get_value_index_int(7, 0, Top[7][TopKasy]);
	cache_get_value_index_int(8, 0, Top[8][TopKasy]);
	cache_get_value_index_int(9, 0, Top[9][TopKasy]);
	cache_get_value_index(0, 1, Top[0][TopKasyn],24);
	cache_get_value_index(1, 1, Top[1][TopKasyn],24);
	cache_get_value_index(2, 1, Top[2][TopKasyn],24);
	cache_get_value_index(3, 1, Top[3][TopKasyn],24);
	cache_get_value_index(4, 1, Top[4][TopKasyn],24);
	cache_get_value_index(5, 1, Top[5][TopKasyn],24);
	cache_get_value_index(6, 1, Top[6][TopKasyn],24);
	cache_get_value_index(7, 1, Top[7][TopKasyn],24);
	cache_get_value_index(8, 1, Top[8][TopKasyn],24);
	cache_get_value_index(9, 1, Top[9][TopKasyn],24);
	cache_delete(res);
	res = mysql_query(DBM, "SELECT `rsp`,`nck` FROM `plys` ORDER BY `rsp` DESC LIMIT 10", true);
	cache_get_value_index_int(0, 0, Top[0][TopRsp]);
	cache_get_value_index_int(1, 0, Top[1][TopRsp]);
	cache_get_value_index_int(2, 0, Top[2][TopRsp]);
	cache_get_value_index_int(3, 0, Top[3][TopRsp]);
	cache_get_value_index_int(4, 0, Top[4][TopRsp]);
	cache_get_value_index_int(5, 0, Top[5][TopRsp]);
	cache_get_value_index_int(6, 0, Top[6][TopRsp]);
	cache_get_value_index_int(7, 0, Top[7][TopRsp]);
	cache_get_value_index_int(8, 0, Top[8][TopRsp]);
	cache_get_value_index_int(9, 0, Top[9][TopRsp]);
	cache_get_value_index(0, 1, Top[0][TopRspn],24);
	cache_get_value_index(1, 1, Top[1][TopRspn],24);
	cache_get_value_index(2, 1, Top[2][TopRspn],24);
	cache_get_value_index(3, 1, Top[3][TopRspn],24);
	cache_get_value_index(4, 1, Top[4][TopRspn],24);
	cache_get_value_index(5, 1, Top[5][TopRspn],24);
	cache_get_value_index(6, 1, Top[6][TopRspn],24);
	cache_get_value_index(7, 1, Top[7][TopRspn],24);
	cache_get_value_index(8, 1, Top[8][TopRspn],24);
	cache_get_value_index(9, 1, Top[9][TopRspn],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `kills`,`nck` FROM `plys` ORDER BY `kills` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopKill]);
	cache_get_value_index_int(1, 0, Top[1][TopKill]);
	cache_get_value_index_int(2, 0, Top[2][TopKill]);
	cache_get_value_index_int(3, 0, Top[3][TopKill]);
	cache_get_value_index_int(4, 0, Top[4][TopKill]);
	cache_get_value_index_int(5, 0, Top[5][TopKill]);
	cache_get_value_index_int(6, 0, Top[6][TopKill]);
	cache_get_value_index_int(7, 0, Top[7][TopKill]);
	cache_get_value_index_int(8, 0, Top[8][TopKill]);
	cache_get_value_index_int(9, 0, Top[9][TopKill]);
	cache_get_value_index(0, 1, Top[0][TopKilln],24);
	cache_get_value_index(1, 1, Top[1][TopKilln],24);
	cache_get_value_index(2, 1, Top[2][TopKilln],24);
	cache_get_value_index(3, 1, Top[3][TopKilln],24);
	cache_get_value_index(4, 1, Top[4][TopKilln],24);
	cache_get_value_index(5, 1, Top[5][TopKilln],24);
	cache_get_value_index(6, 1, Top[6][TopKilln],24);
	cache_get_value_index(7, 1, Top[7][TopKilln],24);
	cache_get_value_index(8, 1, Top[8][TopKilln],24);
	cache_get_value_index(9, 1, Top[9][TopKilln],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `deaths`,`nck` FROM `plys` ORDER BY `deaths` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopDeath]);
	cache_get_value_index_int(1, 0, Top[1][TopDeath]);
	cache_get_value_index_int(2, 0, Top[2][TopDeath]);
	cache_get_value_index_int(3, 0, Top[3][TopDeath]);
	cache_get_value_index_int(4, 0, Top[4][TopDeath]);
	cache_get_value_index_int(5, 0, Top[5][TopDeath]);
	cache_get_value_index_int(6, 0, Top[6][TopDeath]);
	cache_get_value_index_int(7, 0, Top[7][TopDeath]);
	cache_get_value_index_int(8, 0, Top[8][TopDeath]);
	cache_get_value_index_int(9, 0, Top[9][TopDeath]);
	cache_get_value_index(0, 1, Top[0][TopDeathn],24);
	cache_get_value_index(1, 1, Top[1][TopDeathn],24);
	cache_get_value_index(2, 1, Top[2][TopDeathn],24);
	cache_get_value_index(3, 1, Top[3][TopDeathn],24);
	cache_get_value_index(4, 1, Top[4][TopDeathn],24);
	cache_get_value_index(5, 1, Top[5][TopDeathn],24);
	cache_get_value_index(6, 1, Top[6][TopDeathn],24);
	cache_get_value_index(7, 1, Top[7][TopDeathn],24);
	cache_get_value_index(8, 1, Top[8][TopDeathn],24);
	cache_get_value_index(9, 1, Top[9][TopDeathn],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `TopDeta`,`nck` FROM `plys` ORDER BY `TopDeta` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopDeta]);
	cache_get_value_index_int(1, 0, Top[1][TopDeta]);
	cache_get_value_index_int(2, 0, Top[2][TopDeta]);
	cache_get_value_index_int(3, 0, Top[3][TopDeta]);
	cache_get_value_index_int(4, 0, Top[4][TopDeta]);
	cache_get_value_index_int(5, 0, Top[5][TopDeta]);
	cache_get_value_index_int(6, 0, Top[6][TopDeta]);
	cache_get_value_index_int(7, 0, Top[7][TopDeta]);
	cache_get_value_index_int(8, 0, Top[8][TopDeta]);
	cache_get_value_index_int(9, 0, Top[9][TopDeta]);
	cache_get_value_index(0, 1, Top[0][TopDetan],24);
	cache_get_value_index(1, 1, Top[1][TopDetan],24);
	cache_get_value_index(2, 1, Top[2][TopDetan],24);
	cache_get_value_index(3, 1, Top[3][TopDetan],24);
	cache_get_value_index(4, 1, Top[4][TopDetan],24);
	cache_get_value_index(5, 1, Top[5][TopDetan],24);
	cache_get_value_index(6, 1, Top[6][TopDetan],24);
	cache_get_value_index(7, 1, Top[7][TopDetan],24);
	cache_get_value_index(8, 1, Top[8][TopDetan],24);
	cache_get_value_index(9, 1, Top[9][TopDetan],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `PKi`,`nck` FROM `plys` ORDER BY `PKi` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopPompa]);
	cache_get_value_index_int(1, 0, Top[1][TopPompa]);
	cache_get_value_index_int(2, 0, Top[2][TopPompa]);
	cache_get_value_index_int(3, 0, Top[3][TopPompa]);
	cache_get_value_index_int(4, 0, Top[4][TopPompa]);
	cache_get_value_index_int(5, 0, Top[5][TopPompa]);
	cache_get_value_index_int(6, 0, Top[6][TopPompa]);
	cache_get_value_index_int(7, 0, Top[7][TopPompa]);
	cache_get_value_index_int(8, 0, Top[8][TopPompa]);
	cache_get_value_index_int(9, 0, Top[9][TopPompa]);
	cache_get_value_index(0, 1, Top[0][TopPompa],24);
	cache_get_value_index(1, 1, Top[1][TopPompa],24);
	cache_get_value_index(2, 1, Top[2][TopPompa],24);
	cache_get_value_index(3, 1, Top[3][TopPompa],24);
	cache_get_value_index(4, 1, Top[4][TopPompa],24);
	cache_get_value_index(5, 1, Top[5][TopPompa],24);
	cache_get_value_index(6, 1, Top[6][TopPompa],24);
	cache_get_value_index(7, 1, Top[7][TopPompa],24);
	cache_get_value_index(8, 1, Top[8][TopPompa],24);
	cache_get_value_index(9, 1, Top[9][TopPompa],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `OKi`,`nck` FROM `plys` ORDER BY `OKi` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopOnede]);
	cache_get_value_index_int(1, 0, Top[1][TopOnede]);
	cache_get_value_index_int(2, 0, Top[2][TopOnede]);
	cache_get_value_index_int(3, 0, Top[3][TopOnede]);
	cache_get_value_index_int(4, 0, Top[4][TopOnede]);
	cache_get_value_index_int(5, 0, Top[5][TopOnede]);
	cache_get_value_index_int(6, 0, Top[6][TopOnede]);
	cache_get_value_index_int(7, 0, Top[7][TopOnede]);
	cache_get_value_index_int(8, 0, Top[8][TopOnede]);
	cache_get_value_index_int(9, 0, Top[9][TopOnede]);
	cache_get_value_index(0, 1, Top[0][TopOneden],24);
	cache_get_value_index(1, 1, Top[1][TopOneden],24);
	cache_get_value_index(2, 1, Top[2][TopOneden],24);
	cache_get_value_index(3, 1, Top[3][TopOneden],24);
	cache_get_value_index(4, 1, Top[4][TopOneden],24);
	cache_get_value_index(5, 1, Top[5][TopOneden],24);
	cache_get_value_index(6, 1, Top[6][TopOneden],24);
	cache_get_value_index(7, 1, Top[7][TopOneden],24);
	cache_get_value_index(8, 1, Top[8][TopOneden],24);
	cache_get_value_index(9, 1, Top[9][TopOneden],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `MKi`,`nck` FROM `plys` ORDER BY `MKi` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopMini]);
	cache_get_value_index_int(1, 0, Top[1][TopMini]);
	cache_get_value_index_int(2, 0, Top[2][TopMini]);
	cache_get_value_index_int(3, 0, Top[3][TopMini]);
	cache_get_value_index_int(4, 0, Top[4][TopMini]);
	cache_get_value_index_int(5, 0, Top[5][TopMini]);
	cache_get_value_index_int(6, 0, Top[6][TopMini]);
	cache_get_value_index_int(7, 0, Top[7][TopMini]);
	cache_get_value_index_int(8, 0, Top[8][TopMini]);
	cache_get_value_index_int(9, 0, Top[9][TopMini]);
	cache_get_value_index(0, 1, Top[0][TopMini],24);
	cache_get_value_index(1, 1, Top[1][TopMini],24);
	cache_get_value_index(2, 1, Top[2][TopMini],24);
	cache_get_value_index(3, 1, Top[3][TopMini],24);
	cache_get_value_index(4, 1, Top[4][TopMini],24);
	cache_get_value_index(5, 1, Top[5][TopMini],24);
	cache_get_value_index(6, 1, Top[6][TopMini],24);
	cache_get_value_index(7, 1, Top[7][TopMini],24);
	cache_get_value_index(8, 1, Top[8][TopMini],24);
	cache_get_value_index(9, 1, Top[9][TopMini],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `TotOnl`,`nck` FROM `plys` ORDER BY `TotOnl` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopOnline] / 3600);
	cache_get_value_index_int(1, 0, Top[1][TopOnline] / 3600);
	cache_get_value_index_int(2, 0, Top[2][TopOnline] / 3600);
	cache_get_value_index_int(3, 0, Top[3][TopOnline] / 3600);
	cache_get_value_index_int(4, 0, Top[4][TopOnline] / 3600);
	cache_get_value_index_int(5, 0, Top[5][TopOnline] / 3600);
	cache_get_value_index_int(6, 0, Top[6][TopOnline] / 3600);
	cache_get_value_index_int(7, 0, Top[7][TopOnline] / 3600);
	cache_get_value_index_int(8, 0, Top[8][TopOnline] / 3600);
	cache_get_value_index_int(9, 0, Top[9][TopOnline] / 3600);
	cache_get_value_index(0, 1, Top[0][TopOnlinen],24);
	cache_get_value_index(1, 1, Top[1][TopOnlinen],24);
	cache_get_value_index(2, 1, Top[2][TopOnlinen],24);
	cache_get_value_index(3, 1, Top[3][TopOnlinen],24);
	cache_get_value_index(4, 1, Top[4][TopOnlinen],24);
	cache_get_value_index(5, 1, Top[5][TopOnlinen],24);
	cache_get_value_index(6, 1, Top[6][TopOnlinen],24);
	cache_get_value_index(7, 1, Top[7][TopOnlinen],24);
	cache_get_value_index(8, 1, Top[8][TopOnlinen],24);
	cache_get_value_index(9, 1, Top[9][TopOnlinen],24);
	cache_delete(res);
	res = mysql_quer(DBM,"SELECT `SKi`,`nck` FROM `plys` ORDER BY `SpKi` DESC LIMIT 10",true);
	cache_get_value_index_int(0, 0, Top[0][TopSniper]);
	cache_get_value_index_int(1, 0, Top[1][TopSniper]);
	cache_get_value_index_int(2, 0, Top[2][TopSniper]);
	cache_get_value_index_int(3, 0, Top[3][TopSniper]);
	cache_get_value_index_int(4, 0, Top[4][TopSniper]);
	cache_get_value_index_int(5, 0, Top[5][TopSniper]);
	cache_get_value_index_int(6, 0, Top[6][TopSniper]);
	cache_get_value_index_int(7, 0, Top[7][TopSniper]);
	cache_get_value_index_int(8, 0, Top[8][TopSniper]);
	cache_get_value_index_int(9, 0, Top[9][TopSniper]);
	cache_get_value_index(0, 1, Top[0][TopSnipern],24);
	cache_get_value_index(1, 1, Top[1][TopSnipern],24);
	cache_get_value_index(2, 1, Top[2][TopSnipern],24);
	cache_get_value_index(3, 1, Top[3][TopSnipern],24);
	cache_get_value_index(4, 1, Top[4][TopSnipern],24);
	cache_get_value_index(5, 1, Top[5][TopSnipern],24);
	cache_get_value_index(6, 1, Top[6][TopSnipern],24);
	cache_get_value_index(7, 1, Top[7][TopSnipern],24);
	cache_get_value_index(8, 1, Top[8][TopSnipern],24);
	cache_get_value_index(9, 1, Top[9][TopSnipern],24);
	cache_delete(res);
	return 1;
}
CMD:top(playerid,params[]){
	Dialog_Show(playerid, TopD, DIALOG_STYLE_LIST, "TOP 10", "Top Kasy\nTop Expa\nTop Killi\nTop Oof\nTop Czaszek\nTop Onede\nTop Mini\nTop Pompa\nTop Snajpy\nTop Online", "OK","Anuluj");
	return 1;
}
Dialog:TopD(playerid,response,listitem,inputtext[]){
	if(!response){}
	else{
		switch(listitem){
			case 0:{
				new str[512];
				format(str,sizeof(str),"Nick\tKasa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopKasyn],Top[0][TopKasy],Top[1][TopKasyn],Top[1][TopKasyn],Top[2][TopKasyn],Top[2][TopKasy],Top[3][TopKasyn],Top[3][TopKasy],
					Top[4][TopKasyn],Top[4][TopKasyn],Top[5][TopKasy],Top[5][TopKasyn],Top[6][TopKasyn],Top[6][TopKasy],Top[7][TopKasyn],Top[7][TopKasy],Top[8][TopKasyn],Top[8][TopKasy],Top[9][TopKasyn],Top[9][TopKasy]);
				Dialog_Show(playerid,TopD0,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 1:{
				new str[512];
				format(str,sizeof(str),"Nick\tExp\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopRspn],Top[0][TopRsp],Top[1][TopRspn],Top[1][TopRsp],Top[2][TopRspn],Top[2][TopRsp],Top[3][TopRspn],Top[3][TopRsp],
					Top[4][TopRspn],Top[4][TopRsp],Top[5][TopRspn],Top[5][TopRsp],Top[6][TopRspn],Top[6][TopRsp],Top[7][TopRspn],Top[7][TopRsp],Top[8][TopRspn],Top[8][TopRsp],Top[9][TopRspn],Top[9][TopRsp]);
				Dialog_Show(playerid,TopD1,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 2:{
				new str[512];
				format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopKilln],Top[0][TopKill],Top[1][TopKilln],Top[1][TopKill],Top[2][TopKilln],Top[2][TopKill],Top[3][TopKilln],Top[3][TopKill],
					Top[4][TopKilln],Top[4][TopKill],Top[5][TopKilln],Top[5][TopKill],Top[6][TopKilln],Top[6][TopKill],Top[7][TopKilln],Top[7][TopKill],Top[8][TopKilln],Top[8][TopKill],Top[9][TopKilln],Top[9][TopKill]);
				Dialog_Show(playerid,TopD2,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 3:{
				new str[512];
				format(str,sizeof(str),"Nick\tOofed\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopDeathn],Top[0][TopDeath],Top[1][TopDeathn],Top[1][TopDeath],Top[2][TopDeathn],Top[2][TopDeath],Top[3][TopDeathn],Top[3][TopDeath],
					Top[4][TopDeathn],Top[4][TopDeath],Top[5][TopDeathn],Top[5][TopDeath],Top[6][TopDeathn],Top[6][TopDeath],Top[7][TopDeathn],Top[7][TopDeath],Top[8][TopDeathn],Top[8][TopDeath],Top[9][TopDeathn],Top[9][TopDeath]);
				Dialog_Show(playerid,TopD3,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 4:{
				new str[512];
				format(str,sizeof(str),"Nick\tSkulls\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopDetan],Top[0][TopDeta],Top[1][TopDetan],Top[1][TopDeta],Top[2][TopDetan],Top[2][TopDeta],Top[3][TopDetan],Top[3][TopDeta],
					Top[4][TopDetan],Top[4][TopDeta],Top[5][TopDetan],Top[5][TopDeta],Top[6][TopDetan],Top[6][TopDeta],Top[7][TopDetan],Top[7][TopDeta],Top[8][TopDetan],Top[8][TopDeta],Top[9][TopDetan],Top[9][TopDeta]);
				Dialog_Show(playerid,TopD4,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 5:{
				new str[512];
				format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopOneden],Top[0][TopOnede],Top[1][TopOneden],Top[1][TopOnede],Top[2][TopOneden],Top[2][TopOnede],Top[3][TopOneden],Top[3][TopOnede],
					Top[4][TopOneden],Top[4][TopOnede],Top[5][TopOneden],Top[5][TopOnede],Top[6][TopOneden],Top[6][TopOnede],Top[7][TopOneden],Top[7][TopOnede],Top[8][TopOneden],Top[8][TopOnede],Top[9][TopOneden],Top[9][TopOnede]);
				Dialog_Show(playerid,TopD5,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 6:{
				new str[512];
				format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopMinin],Top[0][TopMini],Top[1][TopMinin],Top[1][TopMini],Top[2][TopMinin],Top[2][TopMini],Top[3][TopMinin],Top[3][TopMini],
					Top[4][TopMinin],Top[4][TopMini],Top[5][TopMinin],Top[5][TopMini],Top[6][TopMinin],Top[6][TopMini],Top[7][TopMinin],Top[7][TopMini],Top[8][TopMinin],Top[8][TopMini],Top[9][TopMinin],Top[9][TopMini]);
				Dialog_Show(playerid,TopD6,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 7:{
				new str[512];
				format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopPompan],Top[0][TopPompa],Top[1][TopPompan],Top[1][TopPompa],Top[2][TopPompan],Top[2][TopPompa],Top[3][TopPompan],Top[3][TopPompa],
					Top[4][TopPompan],Top[4][TopPompa],Top[5][TopPompan],Top[5][TopPompa],Top[6][TopPompan],Top[6][TopPompa],Top[7][TopPompan],Top[7][TopPompa],Top[8][TopPompan],Top[8][TopPompa],Top[9][TopPompan],Top[9][TopPompa]);
				Dialog_Show(playerid,TopD7,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 8:{
				new str[512];
				format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopSnipern],Top[0][TopSniper],Top[1][TopSnipern],Top[1][TopSniper],Top[2][TopSnipern],Top[2][TopSniper],Top[3][TopSnipern],Top[3][TopSniper],
					Top[4][TopSnipern],Top[4][TopSniper],Top[5][TopSnipern],Top[5][TopSniper],Top[6][TopSnipern],Top[6][TopSniper],Top[7][TopSnipern],Top[7][TopSniper],Top[8][TopSnipern],Top[8][TopSniper],Top[9][TopSnipern],Top[9][TopSniper]);
				Dialog_Show(playerid,TopD8,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
			case 9:{
				new str[512];
				format(str,sizeof(str),"Nick\tGodziny\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopOnlinen],Top[0][TopOnline],Top[1][TopOnlinen],Top[1][TopOnline],Top[2][TopOnlinen],Top[2][TopOnline],Top[3][TopOnlinen],Top[3][TopOnline],
					Top[4][TopOnlinen],Top[4][TopOnline],Top[5][TopOnlinen],Top[5][TopOnline],Top[6][TopOnlinen],Top[6][TopOnline],Top[7][TopOnlinen],Top[7][TopOnline],Top[8][TopOnlinen],Top[8][TopOnline],Top[9][TopOnlinen],Top[9][TopOnline]);
				Dialog_Show(playerid,TopD9,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str);
			}
		}
	}
	return 1;
}