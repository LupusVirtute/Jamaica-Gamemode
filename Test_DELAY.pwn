#include <a_samp>
main(){

}
public OnGameModeInit(){
	for(new i=0;i<101;i++){
		new str[128];
		format(str,sizeof(str),"Joey");
		ConnectNPC(str, "npc");
	}
	new ex[101];
	for(new i=0;i<101;i++){
		if(true){
			SetPlayerPos(i, 0.0,0.0,0.0);
			SetPlayerFacingAngle(i, 0.0);
			SetPlayerVirtualWorld(i,56);
			SetPlayerInterior(i, 10);
			new c = CreateVehicle(401,0.0,0.0,0.0,0.0, -1,-1,-1,0);
			PutPlayerInVehicle(i, c, 0);
			SetVehicleParamsEx(c,0,0,0, 1, 0,0,0);
			TogglePlayerControllable(i, 0);
			ex[i] = GetTickCount();
		}
	}
	for(new i=0;i<101;i++){
		ex[i] -= GetTickCount();
		printf("Time nr %i : %i",i,ex[i]);
	}
	return 1;
}