#include <Pawn.RakNet>

#define BulletCrasher -5.5
#define eight 8
#define two 2
#define NULL 0
#define PASSENGER_SYNC  211
#define VEHICLE_SYNC  200
#define PLAYER_SYNC 207
#undef MAX_PLAYERS
#define MAX_PLAYERS 50

new AFK[MAX_PLAYERS];
public OnIncomingPacket(playerid, packetid, BitStream:bs){
	if(INVALID_PLAYER_ID == playerid){return true;}
	AFK[playerid] = GetTickCount();
	switch(packetid) {
	case VEHICLE_SYNC:{
			new inCarData[PR_InCarSync];
			BS_IgnoreBits(bs, eight);
			BS_ReadInCarSync(bs, inCarData);
			if(inCarData[PR_position][two] == BulletCrasher){
				Kick(playerid);
				return false;
			}
		}
	case PLAYER_SYNC:{
			new onFootData[PR_OnFootSync];
			BS_IgnoreBits(bs,eight);
			BS_ReadOnFootSync(bs, onFootData);
			if(onFootData[PR_position][two] == BulletCrasher) {
				Kick(playerid);
				return false;
			}
		}
	case PASSENGER_SYNC:{
			new passengerData[PR_PassengerSync];
			BS_IgnoreBits(bs, eight);
			BS_ReadPassengerSync(bs, passengerData);
			if(GetPlayerVehicleSeat(playerid) == NULL) {
				Kick(playerid);
				return false;
			}
			if(passengerData[PR_position][two] == BulletCrasher) {
				Kick(playerid);
				return false;
			}
		}

	}
	return true;
}
new legalmods[48][22] = {
        {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
        {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
        {491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
        {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
        {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
        {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
        {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
        {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
        {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
        {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
        {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
        {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
        {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
        {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
        {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
        {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
        {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
        {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
        {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
        {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
        {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
        {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
        {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
        {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
        {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
    };

stock iswheelmodel(modelid) {
    
    new wheelmodels[17] = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098};
    
    for(new I=0,x=sizeof(wheelmodels);I<x;I++) {
        
        if (modelid == wheelmodels[I])
            return true;
        
    }
    
    return false;
}

stock IllegalCarNitroIde(carmodel) {
    
    new illegalvehs[29] = { 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449 };
    
    for(new I=0,x=sizeof(illegalvehs);I<x;I++) {
        
        if (carmodel == illegalvehs[I])
            return true;
        
    }
    
    return false;
}


stock islegalcarmod(vehicleide, componentid) {
    
    new modok = false;
    
    // stereo, hydraulics & nos (1x 2x 3x) are special.
    if ( (iswheelmodel(componentid)) || (componentid == 1086) || (componentid == 1087) || ((componentid >= 1008) && (componentid <= 1010))) {
        
        new nosblocker = IllegalCarNitroIde(vehicleide);
        
        if (!nosblocker)
            modok = true;
        
    } else {
        
        // check if the specified model CAN use this particular mod.
        for(new I=0,x=sizeof(legalmods);I<x;I++) {
            
            if (legalmods[I][0] == vehicleide) { // first is car IDE
                
                for(new J = 1; J < 22; J++) { // start with 1
                    if (legalmods[I][J] == componentid)
                        modok = true;
                }
                
            }
            
        }
        
    }
    
    return modok;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
    
    new vehicleide = GetVehicleModel(vehicleid);
    new modok = islegalcarmod(vehicleide, componentid);
    
    if (!modok) {
        Kick(playerid);
        return 0;
    }
    
    return 1;
}
#define PROPERTY_OFFSET(%0)	((((%0) * ((%0) << 1)) << 2) + 65536) 
#if defined _ALS_ChangeVehicleColor
	#undef _ALS_ChangeVehicleColor
#else
	#define _ALS_ChangeVehicleColor
#endif
#if defined _ALS_CreateVehicle
	#undef _ALS_CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif
#if defined _ALS_DestroyVehicle
	#undef _ALS_DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif
#if defined _ALS_AddStaticVehicleEx
	#undef _ALS_AddStaticVehicleEx
#else
	#define _ALS_AddStaticVehicleEx
#endif
#if defined _ALS_AddStaticVehicle
	#undef _ALS_AddStaticVehicle
#else
	#define _ALS_AddStaticVehicle
#endif
#if defined _ALS_ChangeVehiclePaintjob
	#undef _ALS_ChangeVehiclePaintjob
#else
	#define _ALS_ChangeVehiclePaintjob
#endif
#if defined _ALS_OnVehicleRespray
	#undef _ALS_OnVehicleRespray
#else
	#define _ALS_OnVehicleRespray
#endif
#if defined _ALS_OnVehiclePaintjob
	#undef _ALS_OnVehiclePaintjob
#else
	#define _ALS_OnVehiclePaintjob
#endif
stock ADSV(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2){
	if(color1 < 0 || color2 < 0){
		color1 = random(256);
		color2 = random(256);
	}
	modelid = AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2);
	new str[24];
	format(str, sizeof(str), "%d,%d", color1, color2); 
	setproperty(_, "",PROPERTY_OFFSET(modelid),str);
	return modelid;
}
stock ADSVEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay){
	if(color1 < 0 || color2 < 0){
		color1 = random(256);
		color2 = random(256);
	}
	modelid = AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay);
	new str[24];
	format(str, sizeof(str), "%d,%d", color1, color2); 
	setproperty(_, "",PROPERTY_OFFSET(modelid),str);
	return modelid;
}
stock DeV(vehicleid){
	deleteproperty(_, "", PROPERTY_OFFSET(vehicleid));
	return DestroyVehicle(vehicleid);
}
stock CrV(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay){
	if(color1 < 0 || color2 < 0){
		color1 = random(256);
		color2 = random(256);
	}
	vehicletype = CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay);
	new str[24];
	format(str, sizeof(str), "%d,%d", color1, color2); 
	setproperty(_, "",PROPERTY_OFFSET(vehicletype),str);
	return vehicletype;
}
stock CVC(vehicleid, color1, color2){
	new str[24];
	format(str, sizeof(str), "%d,%d", color1, color2); 
	setproperty(_, "",PROPERTY_OFFSET(vehicleid),str);
	return ChangeVehicleColor(vehicleid, color1, color2);
}
stock CVPj(vehicleid,pjb){
	new str[24];
	format(str,sizeof(str),"%d",pjb);
	setproperty(2, "",PROPERTY_OFFSET(vehicleid),str);
	return ChangeVehiclePaintjob(vehicleid, pjb);
}
forward OVR(playerid, vehicleid, color1, color2);
public OVR(playerid, vehicleid, color1, color2){
	new str[24];
	format(str, sizeof(str), "%d,%d", color1, color2); 
	setproperty(_, "",PROPERTY_OFFSET(vehicleid),str);
	return 1;
}
forward OVPj(playerid, vehicleid, paintjobid);
public OVPj(playerid, vehicleid, paintjobid){
	new str[24];
	format(str, sizeof(str), "%d", paintjobid); 
	setproperty(2, "",PROPERTY_OFFSET(vehicleid),str);
	return 1;
}
stock GPj(vehid){
	vehid = PROPERTY_OFFSET(vehid);
	if(existproperty(2, "",vehid)){
		new str[24];
		getproperty(2, "",vehid, str);
		return strval(str);
	}
	return -1;
}
stock GVC(vehid,&c1,&c2){
	vehid = PROPERTY_OFFSET(vehid);
	if(existproperty(_, "", vehid)){
		new str[24];
		getproperty(_, "", vehid, str);
		strunpack(str,str);
		new a=strfind(str, ",",true);
		if(a != -1){
			c1 = strval(str);
			c2 = strval(str[a+1]);
		}
	}
	return 0;
}
stock IsAFK(pid){
	if(AFK[pid]+300000 <= GetTickCount()) return 1;
	else return 0;
}
#define AddStaticVehicle ADSV
#define AddStaticVehicleEx ADSVEx
#define DestroyVehicle DeV
#define CreateVehicle CrV
#define ChangeVehicleColor CVC
#define ChangeVehiclePaintjob CVPj
#define OnVehicleRespray OVR
#define OnVehiclePaintjob OVPj