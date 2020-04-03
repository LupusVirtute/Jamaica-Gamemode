/*
	ENUM PDV
	Worker,
	Prace
		-Kosiarz 		- 1
		-Ten Od Truckow - 2
		-Taxówiarz		- 3
		-PIZZAMAN!		- 4




*/
#define X 0.0000
//WORK LAYOUTS NEEDS TO BE DONE ~No shit sherlock ~przyszłościowy Korwin
stock CreateWorkLayouts(){

	return 1;
}
CMD:praca(playerid,params[]){
	Dialog_Show(playerid, WorkD, DIALOG_STYLE_LIST, "Wybierz Prace", "Kosiarz\nSpeedycja\nTaxiMan\nPizzaMan","OK","Nje");
	return 1;
}
Dialog:WorkD(playerid,response,listitem,inputtext[]){
	if(response){
		switch(listitem){
			case 0:{
				SetPlayerPos(playerid, X,X,X);
				SetPlayerFacingAngle(playerid, X);
			}
			case 1:{
				SetPlayerPos(playerid, X,X,X);
				SetPlayerFacingAngle(playerid, X);
			}
			case 2:{
				SetPlayerPos(playerid, X,X,X);
				SetPlayerFacingAngle(playerid, X);
			}
			case 3:{
				SetPlayerPos(playerid, X,X,X);
				SetPlayerFacingAngle(playerid, X);
			}
		}
	}
	return 1;
}