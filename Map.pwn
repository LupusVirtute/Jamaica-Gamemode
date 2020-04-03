/*
	Jamaica 2 GAMEMODE Owned by KorwinPresident & EMTI_
	
	Gamemode ten zosta³/byl/jest tworzony przez KorwinPresident & EMTI_ nie usuwac tego podpisu

	macie napisane co i skad wziaÅ‚em:
		-sscanf2 wziÄ™te z forum sampa stworzone przez Y_Less Updated by:Emmet_
		-a_mysql - wziÄ™te z forum sampa stworzone przez BlueG Updated by:maddinator (nwm czy dobrze to pisze)
		-edialog - wziÄ™te z forum sampa created by Emmet_
		-Pawn.CMD i Pawn.Raknet - wziete z forum sampa created by YourShadow
		-KorwinIncludes - moj include nikt oprocz mnie nikt go nie ma
		getBots() - Ibiza.pwn - Tworca Lagowy nie znam oryginalnego tworcy (bylem leniwy by stworzyc od nowa ta funkcje)
	RETURN CODES FOR:
	PPCHECK
		0 - BAD PASS
		1 - GOOD PASS
		-1 - TOO LONG PASS
		2 - PLAYER NOT CONNECTED TO HOST

	Pare slow o wartosciach
		PDV - Player Data Value
		PCDV -Private Car Data Values
		HDV - House Data Values
		ZjebUmysl - Zjebanie Umyslowe adminow co beda wyrzucac wyzszych ranga i banowac kogo chca offnij to jesli chcesz
	Pare Slow o VW
		50-OD
		51-Pompa
		52-Mini
		53-Snajpa
		54-SuuuuuuuuuuMOOOO!
		PID - JAIL/solo

	ARENY:
		0-NULL
		1-Onede
		2-Solo
		3-Pompa
		4-Mini
	Zabawy:
		0-Nie zapisany
		1-BattleRoyale
		2-Derby
		3-WG
		4-Sumo
		5-Chowany Chowaj¹cy
		6-Chowany Szukaj¹cy
		7-Race
	Achievements Condition Numbers:
		0-Onede Kills
		1-Przeczytal Regulamin Serwera
		2-Solówy
		3-Zabójstwa
		4-Œmierci
*/
#include <a_samp>
native IsValidVehicle(vehicleid);
native gpci(playerid, serial[], len);
#include <sscanf2>
#include <crashdetect>
#include <streamer>
#include <edialog>
#include <foreach>
#include <a_mysql>
#include <Pawn.CMD>
#include <KorInc>
#define SqlEscStr(%0,%1); mysql_escape_string(%0, %1, sizeof(%1));
#define mq(%0); mysql_tquery(DBM,%0);
#define tmq(%0,%1,%2); mysql_tquery(DBM, %0, %1, %2);

#define MAX_SKULLS		30
#define VER 			"0.5.1\n"
#undef MAX_PLAYERS
#define MAX_PLAYERS 	20

#define MAX_HOSE 		250
#define MAX_GANGS 130
#define MAX_ZONES 200
new Iterator:IHo<MAX_HOSE>;

#define SITE_A 			"discord.me/jamaicaserver"

#define MAX_Report 		15

#define SCM(%0,%1,%2); 	{new _msg[200]; format(_msg, sizeof(_msg), %2); SendClientMessage(%0,%1, _msg);}
#define SCMA(%0,%1); 	{new _msg[200]; format(_msg, sizeof(_msg), %1); SendClientMessageToAll(%0, _msg);}
#define SCMAS(%0,%1);	{new _msg[300]; format(_msg, sizeof(_msg), %1); if(strlen(_msg) >= 144){new _msg2[144],_msg3[144];strmid(_msg2, _msg, 144, 288, sizeof(_msg2));strmid(_msg3, _msg, 0, 144, sizeof(_msg3));SendClientMessageToAll(-1,_msg3);SendClientMessageToAll(-1, _msg2);}else{SendClientMessageToAll(-1, _msg);}}
#define isnull(%1) 		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
//Jail Position X,Y,Z Set These if u have map
#define JP_X			4343.1821
#define JP_Y			-5616.5605
#define JP_Z			18.3763


//Œmieci
	//A LOT OF ARRAYS
		new Float:gSparAr[][] = {
			//spx1 	spy1 spz1  spx2  spy2  spz2  arx1 ary1 	 arx2	ary2
			{0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000}
		};
		new Float:ChS[][] = {
			{0.000,0.000,0.000,0.000,0.000}
		};
		new ExceptionalObj[591];
		new Float:WyspS[][] = {
			{2932.2395,-3275.9026,2.2980},
			{3062.0012,-3577.7742,2.2980},
			{3111.2542,-3440.6724,2.3173},
			{3122.7888,-3506.2710,2.2980},
			{3131.8101,-3571.6375,2.2980},
			{3075.5146,-3430.4084,2.2986},
			{2999.8579,-3246.7637,2.2980},
			{3135.3792,-3379.4734,2.3085},
			{2897.5471,-3343.6768,2.2980},
			{3032.3755,-3283.1194,2.2980},
			{2941.7007,-3256.1177,2.2980},
			{2995.6384,-3455.7642,2.3522},
			{2818.6616,-3327.1960,2.2980},
			{2845.6379,-3369.2903,2.2980},
			{2840.9956,-3363.2515,2.2980}
		};
		new Float:SnipS[][] = {
			{-1126.4791,1068.1139,1345.7300,181.6819},
			{-1131.5262,1057.9768,1346.4169,271.6819},
			{-1129.0011,1047.3423,1345.7284,300.8333},
			{-1114.3083,1082.7620,1341.9294,229.2464},
			{-1063.0776,1094.4845,1343.1783,148.5309},
			{-1053.5422,1059.1880,1341.3516,205.7044},
			{-1038.2643,1055.9639,1343.6680,146.4655},
			{-1044.7863,1023.3044,1343.0660,337.8279},
			{-1013.7883,1022.9892,1343.0404,29.7164},
			{-1019.8502,1053.8546,1343.8839,193.0691},
			{-1036.9679,1094.2743,1343.1768,214.8329},
			{-1001.6717,1095.7578,1342.4847,168.2293},
			{-1009.1685,1075.2782,1341.1957,187.4473},
			{-986.5511,1037.1849,1342.1829,24.4315},
			{-973.8013,1060.6516,1345.6766,97.9401},
			{-979.8081,1052.6844,1344.9783,358.9676},
			{-973.0035,1077.2910,1344.9973,152.2309}
		};
		new PlCol[500] =
		{
		    0xFF8C13FF,	0xC715FFFF,	0x20B2AAFF,	0xDC143CFF,	0x6495EDFF,	0xF0E68CFF,	0x778899FF,	0xFF1493FF,	0xF09F5BFF,	0x3D0A4FFF,	0x22F767FF,	0xD63034FF,	0xDC143CFF,
			0xF4A460FF,	0xEE82EEFF,	0xFFD720FF,	0x8B4513FF,	0x4949A0FF,	0x148B8BFF,	0x14FF7FFF,	0x556B2FFF,	0x0FD9FAFF,	0x10DC29FF,	0x534081FF,	0x0495CDFF,	0xEF6CE8FF,
			0xBD34DAFF,	0x247C1BFF,	0x0C8E5DFF,	0x635B03FF,	0xCB7ED3FF,	0x65ADEBFF,	0x5C1ACCFF,	0xF2F853FF,	0x11F891FF,	0x7B39AAFF,	0x53EB10FF,	0x54137DFF,	0x275222FF,
			0x9A6980FF,	0xDFB935FF,	0x3793FAFF,	0x90239DFF,	0xE9AB2FFF,	0xAF2FF3FF,	0x057F94FF,	0xB98519FF,	0x388EEAFF,	0x028151FF,	0xA55043FF,	0x0DE018FF,	0x93AB1CFF,
			0x829DC7FF,	0x95BAF0FF,	0x369976FF,	0x18F71FFF,	0x4B8987FF,	0x491B9EFF,	0x42ACF5FF,	0x2FD9DEFF,	0xFAFB71FF,	0x05D1CDFF,	0xC471BDFF,	0x9F945CFF,	0x20B2AAFF,
			0xBCE635FF,	0xCEA6DFFF,	0x20D4ADFF,	0x2D74FDFF,	0x3C1C0DFF,	0x12D6D4FF,	0x48C000FF,	0x2A51E2FF,	0xE3AC12FF,	0xFC42A8FF,	0x2FC827FF,	0x1A30BFFF,	0xB740C2FF,
			0x94436EFF,	0xC1F7ECFF,	0xCE79EEFF,	0xBD1EF2FF,	0x93B7E4FF,	0x3214AAFF,	0x184D3BFF,	0xAE4B99FF,	0x7E49D7FF,	0x4C436EFF,	0xFA24CCFF,	0xCE76BEFF,	0xA04E0AFF,
			0xDCDE3DFF,	0x10C9C5FF,	0x70524DFF,	0x0BE472FF,	0x8A2CD7FF,	0x6152C2FF,	0xCF72A9FF,	0xE59338FF,	0xEEDC2DFF,	0xD8C762FF,	0x3FE65CFF,	0xFF8C13FF,	0xC715FFFF,
			0x6495EDFF,	0xF0E68CFF,	0x778899FF,	0xFF1493FF,	0xF4A460FF,	0xEE82EEFF,	0xFFD720FF,	0x8B4513FF,	0x4949A0FF,	0x148B8BFF,	0x14FF7FFF,	0x556B2FFF,	0x0FD9FAFF,
			0x10DC29FF,	0x534081FF,	0x0495CDFF,	0xEF6CE8FF,	0xBD34DAFF,	0x247C1BFF,	0x0C8E5DFF,	0x635B03FF,	0xCB7ED3FF,	0xDFB935FF,	0x3793FAFF,	0x90239DFF,	0xE9AB2FFF,
			0x65ADEBFF,	0x5C1ACCFF,	0xF2F853FF,	0x11F891FF,	0x7B39AAFF,	0x53EB10FF,	0x54137DFF,	0x275222FF,	0xF09F5BFF,	0x3D0A4FFF,	0x22F767FF,	0xD63034FF,	0x9A6980FF,
			0xAF2FF3FF,	0x057F94FF,	0xB98519FF,	0x388EEAFF,	0x028151FF,	0xA55043FF,	0x0DE018FF,	0x93AB1CFF,	0x95BAF0FF,	0x369976FF,	0x18F71FFF,	0x4B8987FF,	0x491B9EFF,
			0x829DC7FF,	0xBCE635FF,	0xCEA6DFFF,	0x20D4ADFF,	0x2D74FDFF,	0x3C1C0DFF,	0x12D6D4FF,	0x48C000FF,	0x2A51E2FF,	0xE3AC12FF,	0xFC42A8FF,	0x2FC827FF,	0x1A30BFFF,
			0xB740C2FF,	0x42ACF5FF,	0x2FD9DEFF,	0xFAFB71FF,	0x05D1CDFF,	0xC471BDFF,	0x94436EFF,	0xC1F7ECFF,	0xCE79EEFF,	0xBD1EF2FF,	0x93B7E4FF,	0x3214AAFF,	0x184D3BFF,
			0xAE4B99FF,	0x7E49D7FF,	0x4C436EFF,	0xFA24CCFF,	0xCE76BEFF,	0xA04E0AFF,	0x9F945CFF,	0xDCDE3DFF,	0x10C9C5FF,	0x70524DFF,	0x0BE472FF,	0x8A2CD7FF,	0x6152C2FF,
			0xCF72A9FF,	0xE59338FF,	0xEEDC2DFF,	0xD8C762FF,	0x3FE65CFF,	0xFF8C13FF,	0xC715FFFF,	0x20B2AAFF,	0xDC143CFF,	0x6495EDFF,	0xF0E68CFF,	0x778899FF,	0xFF1493FF,
			0xF4A460FF,	0xEE82EEFF,	0xFFD720FF,	0x8B4513FF,	0x4949A0FF,	0x148B8BFF,	0x14FF7FFF,	0x556B2FFF,	0x0FD9FAFF,	0x10DC29FF,	0x534081FF,	0x0495CDFF,	0xEF6CE8FF,
			0xBD34DAFF,	0x247C1BFF,	0x0C8E5DFF,	0x635B03FF,	0xCB7ED3FF,	0x65ADEBFF,	0x5C1ACCFF,	0xF2F853FF,	0x11F891FF,	0x7B39AAFF,	0x53EB10FF,	0x54137DFF,	0x275222FF,
			0xF09F5BFF,	0x3D0A4FFF,	0x22F767FF,	0xD63034FF,	0x9A6980FF,	0xDFB935FF,	0x3793FAFF,	0x90239DFF,	0xE9AB2FFF,	0xAF2FF3FF,	0x057F94FF,	0xB98519FF,	0x388EEAFF,
			0x028151FF,	0xA55043FF,	0x0DE018FF,	0x93AB1CFF,	0x95BAF0FF,	0x369976FF,	0x18F71FFF,	0x4B8987FF,	0x491B9EFF,	0x829DC7FF,	0xBCE635FF,	0xCEA6DFFF,	0x20D4ADFF,
			0x2D74FDFF,	0x3C1C0DFF,	0x12D6D4FF,	0x48C000FF,	0x2A51E2FF,	0xE3AC12FF,	0xFC42A8FF,	0x2FC827FF,	0x1A30BFFF,	0xB740C2FF,	0x42ACF5FF,	0x2FD9DEFF,	0xFAFB71FF,
			0x05D1CDFF,	0xC471BDFF,	0x94436EFF,	0xC1F7ECFF,	0xCE79EEFF,	0xBD1EF2FF,	0x93B7E4FF,	0x3214AAFF,	0x184D3BFF,	0xAE4B99FF,	0x7E49D7FF,	0x4C436EFF,	0xFA24CCFF,
			0xCE76BEFF,	0xA04E0AFF,	0x9F945CFF,	0xDCDE3DFF,	0x10C9C5FF,	0x70524DFF,	0x0BE472FF,	0x8A2CD7FF,	0x6152C2FF,	0xCF72A9FF,	0xE59338FF,	0xEEDC2DFF,	0xD8C762FF,
			0x3FE65CFF,	0xFF8C13FF,	0xC715FFFF,	0x20B2AAFF,	0xDC143CFF,	0x6495EDFF,	0xF0E68CFF,	0x778899FF,	0xFF1493FF,	0xF4A460FF,	0xEE82EEFF,	0xFFD720FF,	0x8B4513FF,
			0x4949A0FF,	0x148B8BFF,	0x14FF7FFF,	0x556B2FFF,	0x0FD9FAFF,	0x10DC29FF,	0x534081FF,	0x0495CDFF,	0xEF6CE8FF,	0xBD34DAFF,	0x247C1BFF,	0x0C8E5DFF,	0x635B03FF,
			0xCB7ED3FF,	0x65ADEBFF,	0x5C1ACCFF,	0xF2F853FF,	0x11F891FF,	0x7B39AAFF,	0x53EB10FF,	0x54137DFF,	0x275222FF,	0xF09F5BFF,	0x3D0A4FFF,	0x22F767FF,	0xD63034FF,
			0x9A6980FF,	0xDFB935FF,	0x3793FAFF,	0x90239DFF,	0xE9AB2FFF,	0xAF2FF3FF,	0x057F94FF,	0xB98519FF,	0x388EEAFF,	0x028151FF,	0xA55043FF,	0x0DE018FF,	0x93AB1CFF,
			0x95BAF0FF,	0x369976FF,	0x18F71FFF,	0x4B8987FF,	0x491B9EFF,	0x829DC7FF,	0xBCE635FF,	0xCEA6DFFF,	0x20D4ADFF,	0x2D74FDFF,	0x3C1C0DFF,	0x12D6D4FF,	0x48C000FF,
			0x2A51E2FF,	0xE3AC12FF,	0xFC42A8FF,	0x2FC827FF,	0x1A30BFFF,	0xB740C2FF,	0x42ACF5FF,	0x2FD9DEFF,	0xFAFB71FF,	0x05D1CDFF,	0xC471BDFF,	0x94436EFF,	0xC1F7ECFF,
			0xCE79EEFF,	0xBD1EF2FF,	0x93B7E4FF,	0x3214AAFF,	0x184D3BFF,	0xAE4B99FF,	0x7E49D7FF,	0x4C436EFF,	0xFA24CCFF,	0xCE76BEFF,	0xA04E0AFF,	0x9F945CFF,	0xDCDE3DFF,
			0x10C9C5FF,	0x70524DFF,	0x0BE472FF,	0x8A2CD7FF,	0x6152C2FF,	0xCF72A9FF,	0xE59338FF,	0xEEDC2DFF,	0xD8C762FF,	0x3FE65CFF,	0xFF8C13FF,	0xC715FFFF,	0x20B2AAFF,
			0xDC143CFF,	0x6495EDFF,	0xF0E68CFF,	0x778899FF,	0xFF1493FF,	0xF4A460FF,	0xEE82EEFF,	0xFFD720FF,	0x8B4513FF,	0x4949A0FF,	0x148B8BFF,	0x14FF7FFF,	0x556B2FFF,
			0x0FD9FAFF,	0x10DC29FF,	0x534081FF,	0x0495CDFF,	0xEF6CE8FF,	0xBD34DAFF,	0x247C1BFF,	0x0C8E5DFF,	0x635B03FF,	0xCB7ED3FF,	0x65ADEBFF,	0x5C1ACCFF,	0xF2F853FF,
			0x11F891FF,	0x7B39AAFF,	0x53EB10FF,	0x54137DFF,	0x275222FF,	0xF09F5BFF,	0x3D0A4FFF,	0x22F767FF,	0xD63034FF,	0x9A6980FF,	0xDFB935FF,	0x3793FAFF,	0x90239DFF,
			0xE9AB2FFF,	0xAF2FF3FF,	0x057F94FF,	0xB98519FF,	0x388EEAFF,	0x028151FF,	0xA55043FF,	0x0DE018FF,	0x93AB1CFF,	0x95BAF0FF,	0x369976FF,	0x18F71FFF,	0x4B8987FF,
			0x491B9EFF,	0x829DC7FF,	0xBCE635FF,	0xCEA6DFFF,	0x20D4ADFF,	0x2D74FDFF,	0x3C1C0DFF,	0x12D6D4FF,	0x48C000FF,	0x2A51E2FF,	0xE3AC12FF,	0xFC42A8FF,	0x2FC827FF,
			0x1A30BFFF,	0xB740C2FF,	0x42ACF5FF,	0x2FD9DEFF,	0xFAFB71FF,	0x05D1CDFF,	0xC471BDFF,	0x94436EFF,	0xC1F7ECFF,	0xCE79EEFF,	0xBD1EF2FF,	0x93B7E4FF,	0x3214AAFF,
			0x184D3BFF,	0xAE4B99FF,	0x7E49D7FF,	0x4C436EFF,	0xFA24CCFF,	0xCE76BEFF,	0xA04E0AFF,	0x9F945CFF,	0xDCDE3DFF,	0x10C9C5FF,	0x70524DFF,	0x0BE472FF,	0x8A2CD7FF,
			0x6152C2FF,	0xCF72A9FF,	0xE59338FF,	0xEEDC2DFF,	0xD8C762FF,	0x3FE65CFF
		};
	//Uselless vars
		new bool:ZjebUmysl;

		new MySQL:DBM;

		new Iterator:ReporI<MAX_Report>;
		new Repor[15][40];
	//Hos
		enum e_HoS {
			hID,
			Float:XP,
			Float:YP,
			Float:ZP,
			Iid,
			Oid,
			bool:Bin,
			hpass[24],
			hidP,
			Text3D:hid3D,
			hidMI,
			ExP,
			MoP,
			expi,
			moni,
			bool:Lck,
			estanam[24],
			ONck[24],
			Security
		}
		new HDV[MAX_HOSE][e_HoS];
	//PDV
		enum Player_Data {
			iDP,
			//Fucking must need
			Nck[25],
			pass[65],
			slt[11],
			PFai,
			//Player Stats
			Csh,
			Rsp,
			Ki,
			De,
			KS,
			DeTa,
			OKi,
			ODe,
			PKi,
			PDe,
			MKi,
			MDe,
			SpKi,
			SpDe,
			TotOnl,
			OwOfP,
			//Admin Shit
			ipP[16],
			ngpci[41],
			last_gpci[41],
			last_ip[16],
			//Car S
			cID,
			PSk,
			psved,
			PrivR,
			pvidp,
			//CoolDown's / Punishment's
			ChSp,
			CMT,
			JaT,
			JaTR[48],
			BaT,
			Ba,
			BaR[48],
			BaG,
			CmU,
			wrn,
			SCl,
			LVL,
			Fps,
			drunklevellast,
			ColDr,
			//Achievementy
			bool:Achiev[67],
			AchievC,
			//Tp
			Ptp,
			//areny
			Arena,
			MinIn,
			WGIn,
			//solówy
			SoBr,
			SoP,
			SoA,
			SKi,
			SDe,
			SWat[5],
			Wat,
			//Kondomy
			AntiFD,
			//?
			Bounty[2],
			RobCld,
			SetF,
			CtD,
			nCtD,
			Float:LaX,
			Float:LaY,
			Float:LaZ,
			Float:PlpX[3],
			Float:PlpY[3],
			Float:PlpZ[3],
			ColD,
			Btle, //Walka
			//T3D
			Text3D:Rank,
			Text3D:DMS,
			//Admin Part
			APL,
			nAPL,
			AdP[45],
			bool:SPM,
			Spect,
			//Prem
			VIP,
			pcolo,
			//Gangi
			bool:gSpar,
			GPid,
			IGid,
			bool:zSl,
			IGidI,
			//House
			OwOf,
			//Zabawy OwO
			Plays,
			//Bool's
			bool:SGod,
			bool:TpOf,
			bool:FrP,
			bool:RpCl,
			bool:TpSp,
			bool:SolOff,
			bool:zw,
			bool:hudon,
			bool:objon,
			CorP, //Pseudo bool 
			bool:LogIn,
			bool:God,
			bool:ToKick,
			bool:NoAcc,
			bool:BlCMD,
			bool:TkD,
			bool:Wypociny,
			bool:BlDM,
			bool:nos,
			bool:Jailed,
			bool:VehGod,
			bool:kmrnik,
			bool:Dying
		}
		new PDV[MAX_PLAYERS][Player_Data];
		new Iterator:SWaI[MAX_PLAYERS]<5>;
		new PSku[MAX_SKULLS][4],Iterator:SkI<MAX_SKULLS>; //Skull Of Death!
	//Spawny
		new Float:SmoS[][] = {
			{-1115.9756,443.4225,450.8922,43.9046},
			{-1162.3446,444.8711,450.3585,0.1065},
			{-1240.4475,445.3518,450.4412,313.9611},
			{-1241.1844,478.6322,450.3757,272.0374},
			{-1241.2089,513.1595,450.3815,270.5313},
			{-1240.2958,568.0393,450.4060,224.5784},
			{-1189.6019,568.4489,450.3060,181.4580},
			{-1118.7784,567.2760,450.2402,134.7027},
			{-1117.5165,535.8314,450.3057,90.1123},
			{-1117.1768,499.9922,450.3838,92.4641}
		};
		new Float:RandomSpawns[][] = {
			{823.2581,841.0947,10.8191,104.2116},
			{2144.7893,1044.8384,10.8203,183.4184},
			{2004.9877,1544.3977,13.5908,94.7475},
			{1413.8094,2809.4346,10.8203,96.1124},
			{227.9380,1909.1342,17.6406,183.1396},
			{-316.5204,1753.3965,42.7453,271.3937},
			{-296.3636,1538.0322,75.5625,148.0860},
			{290.5002,-167.1405,1.3052,359.7469},
			{1338.6030,243.3184,19.1318,156.8002},
			{2063.8918,311.4436,34.4242,95.7849},
			{2852.8328,1719.1028,10.5483,81.9350},
			{4343.1821,-5616.5605,18.3763,269.8333},
			{2126.4009,896.1259,13.9150,1.5434},
			{-2261.2510,541.6370,35.0545,179.4089},
			{2387.4436,1142.4902,10.5580,171.3670},
			{-1974.9700,261.7300,34.9102,358.7900},
			{2496.2949,-1662.8248,13.1702,88.8314},
			{358.5291,2540.2690,16.4435,267.1711},
			{-1113.0200,-1650.2000,76.0970,89.1800},
			{-393.5200,2280.4700,40.5303,0.1000},
			{2148.0425,-86.5715,2.7591,218.5538},
			{78.4072,-228.6485,1.5781,183.0458},
			{-912.7800,1997.2800,60.9141,310.2600},
			{-2346.6619,-1622.7806,483.6635,249.2264},
			{-838.7160,-1915.8672,12.8604,267.9819},
			{-1424.5951,-1522.3618,101.7440,97.4473},
			{-1426.4939,-954.3513,201.0082,90.5565},
			{-1834.0403,-2189.4741,80.5092,63.2553},
			{2294.3386,533.4185,1.7944,181.8075},
			{1348.4362,2149.4700,11.0349,271.6310},
			{835.0217,-2055.9451,12.8672,183.5605},
			{881.8466,-1222.7854,16.7036,270.3884},
			{862.3972,-1102.4753,24.0240,269.0097},
			{1006.5395,-933.5594,41.9068,96.3775},
			{1191.6613,-922.5549,42.8357,98.7423},
			{921.8981,-788.6381,114.1112,270.2955},
			{134.3161,-1489.8055,18.4373,59.6070},
			{755.9744,-1259.6392,13.2666,93.1345},
			{312.5515,-1799.5709,4.2466,272.0325},
			{737.1974,-1435.9344,13.2462,88.3569},
			{2473.5803,912.4630,10.5474,2.0801},
			{2392.6707,1014.8083,10.5474,356.6461},
			{2023.5978,1007.5933,10.5474,271.6972}
		};
		new Float:OdeS[][] = {
			{288.745971,169.350997,1007.171875,0.000},
			{238.7350,195.6458,1008.1719,177.7231},
			{246.2891,187.1755,1008.1719,356.6382},
			{268.4549,187.3168,1008.1719,3.5315},
			{298.9436,191.2083,1007.1794,91.2422},
			{298.0060,173.5531,1007.1719,0.6881},
			{264.0612,170.3343,1003.0234,1.9414},
			{241.9809,172.0385,1003.0234,181.1696},
			{241.9857,151.1212,1003.0234,359.1213},
			{209.5502,142.4530,1003.0234,268.5671},
			{217.4764,148.2149,1003.0234,179.2662},
			{216.6742,161.2179,1003.0234,189.3162},
			{215.6365,182.7528,1003.0313,264.8303},
			{230.2880,183.2777,1003.0313,132.2893},
			{191.5317,178.9985,1003.0234,270.7839},
			{197.5853,168.1372,1003.0234,267.0239},
			{191.2685,158.0452,1003.0234,272.0373}
		};
		new Float:SAr2S[][] = {
			{-423.3143,-1816.6967,1755.3978,96.2684}, // spawn podgldacz walki
			{-427.0164,-1806.0505,1755.3978,109.7419}, // spawn podgldacz walki
			{-419.7264,-1828.3247,1755.3978,88.4116}, // spawn podgldacz walki
			{-426.8150,-1837.1151,1755.3978,71.1781}, // spawn podgldacz walki
			{-459.1526,-1834.5204,1755.3978,278.9203}, // spawn podgldacz walki
			{-460.2189,-1816.7917,1755.3978,273.2801}, // spawn podgldacz walki
			{-455.5891,-1804.8942,1755.3978,248.8398} // spawn podgldacz walki
		};
		new Float:IntId[][] = {
			{2003.1178, 1015.1948, 33.008, 351.5789},
			{770.8033, -0.7033, 1000.7267, 22.8599},
			{974.0177, -9.5937, 1001.1484, 22.6045},
			{961.9308, -51.9071, 1001.1172, 95.5381},
			{830.6016, 5.9404, 1004.1797, 125.8149},
			{1037.8276, 0.397, 1001.2845, 353.9335},
			{1212.1489, -28.5388, 1000.9531, 170.5692},
			{1290.4106, 1.9512, 1001.0201, 179.9419},
			{1412.1472, -2.2836, 1000.9241, 114.661},
			{1527.0468, -12.0236, 1002.0971, 350.0013},
			{1523.5098, -47.8211, 1002.2699, 262.7038},
			{612.2191, -123.9028, 997.9922, 266.5704},
			{512.9291, -11.6929, 1001.5653, 198.7669},
			{418.4666, -80.4595, 1001.8047, 343.2358},
			{386.5259, 173.6381, 1008.3828, 63.7399},
			{288.4723, 170.0647, 1007.1794, 22.0477},
			{206.4627, -137.7076, 1003.0938, 10.9347},
			{-100.2674, -22.9376, 1000.7188, 17.285},
			{-201.2236, -43.2465, 1002.2734, 45.8613},
			{-202.9381, -6.7006, 1002.2734, 204.2693},
			{-25.7220, -187.8216, 1003.5469, 5.0760},
			{454.9853, -107.2548, 999.4376, 309.0195},
			{372.5565, -131.3607, 1001.4922, 354.2285},
			{378.026, -190.5155, 1000.6328, 141.0245},
			{315.244, -140.8858, 999.6016, 7.4226},
			{225.0306, -9.1838, 1002.218, 85.5322},
			{611.3536, -77.5574, 997.9995, 320.9263},
			{246.0688, 108.9703, 1003.2188, 0.2922},
			{6.0856, -28.8966, 1003.5494, 5.0365},
			{773.7318, -74.6957, 1000.6542, 5.2304},
			{621.4528, -23.7289, 1000.9219, 15.6789},
			{445.6003, -6.9823, 1000.7344, 172.2105},
			{285.8361, -39.0166, 1001.5156, 0.7529},
			{204.1174, -46.8047, 1001.8047, 357.5777},
			{245.2307, 304.7632, 999.1484, 273.4364},
			{290.623, 309.0622, 999.1484, 89.9164},
			{322.5014, 303.6906, 999.1484, 8.1747},
			{-2041.2334, 178.3969, 28.8465, 156.2153},
			{-1402.6613, 106.3897, 1032.2734, 105.1356},
			{-1403.0116, -250.4526, 1043.5341, 355.8576},
			{1204.6689, -13.5429, 1000.9219, 350.0204},
			{2016.1156, 1017.1541, 996.875, 88.0055},
			{-741.8495, 493.0036, 1371.9766, 71.7782},
			{2447.8704, -1704.4509, 1013.5078, 314.5253},
			{2527.0176, -1679.2076, 1015.4986, 260.9709},
			{-1129.8909, 1057.5424, 1346.4141, 274.5268},
			{2496.0549, -1695.1749, 1014.7422, 179.2174},
			{366.0248, -73.3478, 1001.5078, 292.0084},
			{2233.9363, 1711.8038, 1011.6312, 184.3891},
			{269.6405, 305.9512, 999.1484, 215.6625},
			{414.2987, -18.8044, 1001.8047, 41.4265},
			{1.1853, -3.2387, 999.4284, 87.5718},
			{-30.9875, -89.6806, 1003.5469, 359.8401},
			{161.4048, -94.2416, 1001.8047, 0.7938},
			{-2638.8232, 1407.3395, 906.4609, 94.6794},
			{1267.8407, -776.9587, 1091.9063, 231.3418},
			{2536.5322, -1294.8425, 1044.125, 254.9548},
			{2350.1597, -1181.0658, 1027.9766, 99.1864},
			{-2158.6731, 642.09, 1052.375, 86.5402},
			{419.8936, 2537.1155, 10.0, 67.6537},
			{256.9047, -41.6537, 1002.0234, 85.8774},
			{204.1658, -165.7678, 1000.5234, 181.7583},
			{1133.35, -7.8462, 1000.6797, 165.8482},
			{-1420.4277, 1616.9221, 1052.5313, 159.1255},
			{493.1443, -24.2607, 1000.6797, 356.9864},
			{1727.2853, -1642.9451, 20.2254, 172.4193},
			{-202.842, -24.0325, 1002.2734, 252.8154},
			{2233.6919, -1112.8107, 1050.8828, 8.6483},
			{1211.2484, 1049.0234, 359.941, 170.9341},
			{2319.1272, -1023.9562, 1050.2109, 167.3959},
			{2261.0977, -1137.8833, 1050.6328, 266.88},
			{-944.2402, 1886.1536, 5.0051, 179.8548},
			{-26.1856, -140.9164, 1003.5469, 2.9087},
			{2217.281, -1150.5349, 1025.7969, 273.7328},
			{1.5491, 23.3183, 1199.5938, 359.9054},
			{681.6216, -451.8933, -25.6172, 166.166},
			{234.6087, 1187.8195, 1080.2578, 349.4844},
			{225.5707, 1240.0643, 1082.1406, 96.2852},
			{224.288, 1289.1907, 1082.1406, 359.868},
			{239.2819, 1114.1991, 1080.9922, 270.2654},
			{207.5219, -109.7448, 1005.1328, 358.62},
			{295.1391, 1473.3719, 1080.2578, 352.9526},
			{-1417.8927, 932.4482, 1041.5313, 0.7013},
			{446.3247, 509.9662, 1001.4195, 330.5671},
			{2306.3826, -15.2365, 26.7496, 274.49},
			{2331.8984, 6.7816, 26.5032, 100.2357},
			{663.0588, -573.6274, 16.3359, 264.9829},
			{-227.5703, 1401.5544, 27.7656, 269.2978},
			{-688.1496, 942.0826, 13.6328, 177.6574},
			{-1916.1268, 714.8617, 46.5625, 152.2839},
			{818.7714, -1102.8689, 25.794, 91.1439},
			{255.2083, -59.6753, 1.5703, 1.4645},
			{446.626, 1397.738, 1084.3047, 343.9647},
			{227.3922, 1114.6572, 1080.9985, 267.459},
			{227.7559, 1114.3844, 1080.9922, 266.2624},
			{261.1165, 1287.2197, 1080.2578, 178.9149},
			{291.7626, -80.1306, 1001.5156, 290.2195},
			{449.0172, -88.9894, 999.5547, 89.6608},
			{-27.844, -26.6737, 1003.5573, 184.3118},
			{2135.2004, -2276.2815, 20.6719, 318.59},
			{306.1966, 307.819, 1003.3047, 203.1354},
			{24.3769, 1341.1829, 1084.375, 8.3305},
			{963.0586, 2159.7563, 1011.0303, 175.313},
			{2548.4807, 2823.7429, 10.8203, 270.6003},
			{215.1515, 1874.0579, 13.1406, 177.5538},
			{221.6766, 1142.4962, 1082.6094, 184.9618},
			{2323.7063, -1147.6509, 1050.7101, 206.5352},
			{344.9984, 307.1824, 999.1557, 193.643},
			{411.9707, -51.9217, 1001.8984, 173.3449},
			{-1421.5618, -663.8262, 1059.5569, 170.9341},
			{773.8887, -47.7698, 1000.5859, 10.7161},
			{246.6695, 65.8039, 1003.6406, 7.9562},
			{-1864.9434, 55.7325, 1055.5276, 85.8541},
			{-262.1759, 1456.6158, 1084.3672, 82.459},
			{22.861, 1404.9165, 1084.4297, 349.6158},
			{140.3679, 1367.8837, 1083.8621, 349.2372},
			{1494.8589, 1306.48, 1093.2953, 196.065},
			{-1813.213, -58.012, 1058.9641, 335.3199},
			{-1401.067, 1265.3706, 1039.8672, 178.6483},
			{234.2826, 1065.229, 1084.2101, 4.3864},
			{-68.5145, 1353.8485, 1080.2109, 3.5742},
			{-2240.1028, 136.973, 1035.4141, 269.0954},
			{297.144, -109.8702, 1001.5156, 20.2254},
			{316.5025, -167.6272, 999.5938, 10.3031},
			{-285.2511, 1471.197, 1084.375, 85.6547},
			{-26.8339, -55.5846, 1003.5469, 3.9528},
			{442.1295, -52.4782, 999.7167, 177.9394},
			{2182.2017, 1628.5848, 1043.8723, 224.8601},
			{748.4623, 1438.2378, 1102.9531, 0.6069},
			{2807.3604, -1171.7048, 1025.5703, 193.7117},
			{366.0002, -9.4338, 1001.8516, 160.528},
			{2216.1282, -1076.3052, 1050.4844, 86.428},
			{2268.5156, 1647.7682, 1084.2344, 99.7331},
			{2236.6997, -1078.9478, 1049.0234, 2.5706},
			{-2031.1196, -115.8287, 1035.1719, 190.1877},
			{2365.1089, -1133.0795, 1050.875, 177.3947},
			{1168.512, 1360.1145, 10.9293, 196.5933},
			{315.4544, 976.5972, 1960.8511, 359.6368},
			{1893.0731, 1017.8958, 31.8828, 86.1044},
			{501.9578, -70.5648, 998.7578, 171.5706},
			{-42.5267, 1408.23, 1084.4297, 172.068},
			{2283.3118, 1139.307, 1050.8984, 19.7032},
			{84.9244, 1324.2983, 1083.8594, 159.5582},
			{260.7421, 1238.2261, 1084.2578, 84.3084},
			{-1658.1656, 1215.0002, 7.25, 103.9074},
			{0.0, -1961.6281, 295.2378, 35.4688, 264.4891}
		};
		new IntIdK[] = {
			11,5,3,3,3,3,3,18,1,3,2,3,3,3,3,3,3,3,3,17,17,5,5,17,7,5,2,10,10,7,1,1,1,1,1,3,5,1,1,7,2,10,1,2,1,10,3,10,1,2,2,2,18,18,3,5,2,5,1,10,14,14,12,14,17,18,16,5,6,9,10,
			17,16,15,1,1,3,2,1,5,15,15,15,12,0,0,0,18,0,0,0,0,2,5,5,4,4,4,4,0,4,10,1,0,0,4,12,6,12,4,6,6,14,4,5,5,3,14,16,6,6,6,6,6,15,6,6,2,6,8,9,1,1,2,3,8,0,9,10,11,8,11,9,9,0
		};
		new VehNam[212][] = {
		    "Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
		    "Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
		    "Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
		    "Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
		    "Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
		    "Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
		    "Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
		    "Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
		    "Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
		    "Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR","NRG","HPV","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
		    "Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
		    "Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
		    "Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
		    "Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
		    "Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
		    "Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
		    "Stair Trailer","Boxville","Farm Plow","Utility Trailer"
		};
		new RandomMsg[13][136] = {
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Widzisz cheatera lub gracza ³ami¹cego regulamin? Zg³oœ go komenda /raport !",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Jesteœ nowy na serwerze? Nie znasz komend? SprawdŸ /cmd",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Obecnych administratorów znajdziesz na /admins",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Administracja jest dla graczy, ale sa ludŸmi jak ty, badz wyrozumia³y(a)!",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Za godzinê gry dostaniesz 100 exp'a !",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Oferujemy wam blisko 100 teleportów na serwerze, sprawdŸ /teles !",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Chcesz siê woziæ w³asn¹ bryk¹? SprawdŸ /privcar",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Pamietajcie, ¿e administracja te¿ posiada regulamin, pilnujcie ich ;D !",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Nasz gamemod jest w 99,99% autorski! :)",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Raz na dzieñ mo¿esz u¿yæ /dotacja ;D Znajcie ³aske Pana :*",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Mo¿esz wymieniæ 7,000 czaszek na V.I.P!",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Zapraszamy was na Discorda Serwera! discord.me/jamaicaserver",
			"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{26bf63} Zaliczanie /osiagniecia daje wiêcej mo¿liwoœci!"
		};
		new Float:DBSp[][] = {
			{471.4289,5259.6694,9.5279,0.7413}, // spawn derby 1
			{468.7542,5409.9287,9.5409,90.4302}, // spawn derby 2
			{367.0519,5414.9292,9.5558,177.4323}, // spawn derby 3
			{319.7149,5408.1230,9.5420,180.7661}, // spawn derby 4
			{322.0984,5258.7349,9.5434,270.5255}, // spawn derby 5
			{369.6972,5317.8218,9.5573,271.1687}, // spawn derby 6
			{419.0187,5347.1235,9.5558,90.0049}, // spawn derby 7
			{317.3044,5279.1094,25.2133,0.2492}, // spawn derby 8
			{324.0245,5408.0244,25.3270,271.2513}, // spawn derby 9
			{466.4237,5406.9346,25.3275,86.3778}, // spawn derby 10
			{467.0403,5275.2354,25.3288,87.8884}, // spawn derby 11
			{434.2003,5275.3169,25.3282,359.5510}, // spawn derby 12
			{456.6314,5353.5762,25.3245,89.6453}, // spawn derby 13
			{319.0156,5353.9424,9.5541,270.7976}, // spawn derby 14
			{385.5341,5353.8687,25.3282,269.9856}, // spawn derby 15
			{3607.1868,-2090.3499,450.6060,314.2944}, // derbyv2 spawn 1
			{3634.4089,-2114.5076,450.6026,0.9347}, // derbyv2 spawn 2
			{3669.6055,-2114.9231,450.6025,0.9527}, // derbyv2 spawn 3
			{3697.2905,-2090.8748,450.6064,44.0092}, // derbyv2 spawn 4
			{3721.9124,-2063.0256,450.6008,91.1568}, // derbyv2 spawn 5
			{3723.8728,-2027.7219,450.6024,92.0436}, // derbyv2 spawn 6
			{3696.4749,-2000.8262,450.6055,134.4575}, // derbyv2 spawn 7
			{3670.0476,-1974.7159,450.6020,178.9992}, // derbyv2 spawn 8
			{3634.7129,-1974.6062,450.6030,181.5304}, // derbyv2 spawn 9
			{3606.2292,-1999.5479,450.6049,226.1740}, // derbyv2 spawn 10
			{3581.8574,-2027.4585,450.6011,271.9594}, // derbyv2 spawn 11
			{3580.1597,-2062.7112,450.6008,270.1725}, // derbyv2 spawn 12
			{3648.4204,-2062.7959,450.5986,270.9288}, // derbyv2 spawn 13
			{3670.0288,-2046.6410,450.6016,359.3225}, // derbyv2 spawn 14
			{3652.8779,-2027.4203,450.5974,90.9588} // derbyv2 spawn 15
		};
		new Float:wgsp[][] = {
			{229.9883,144.1923,1003.0234,269.5252}, // onede druzyna 1 spawn 1
			{230.0268,145.1810,1003.0234,268.0146}, // onede druzyna 1 spawn 2
			{229.8172,146.3137,1003.0234,268.6976}, // onede druzyna 1 spawn 3
			{229.9061,147.3572,1003.0234,267.2435}, // onede druzyna 1 spawn 4
			{229.8527,148.3204,1003.0234,267.9262}, // onede druzyna 1 spawn 5
			{235.4312,148.2564,1003.0300,269.8063}, // onede druzyna 1 spawn 6
			{235.4910,147.2735,1003.0300,266.4158}, // onede druzyna 1 spawn 7
			{235.5942,146.0681,1003.0300,268.6654}, // onede druzyna 1 spawn 8
			{235.5836,144.5826,1003.0300,267.4684}, // onede druzyna 1 spawn 9
			{235.5640,142.7731,1003.0300,269.0915}, // onede druzyna 1 spawn 10
			{241.9576,141.8047,1003.0234,0.8989}, // onede druzyna 1 spawn 11
			{241.9112,143.9963,1003.0234,1.2123}, // onede druzyna 1 spawn 12
			{241.8552,146.6453,1003.0234,1.2123}, // onede druzyna 1 spawn 13
			{241.8050,149.0193,1003.0234,1.2123}, // onede druzyna 1 spawn 14
			{241.9188,151.4576,1003.0234,1.2123}, // onede druzyna 1 spawn 15	
			{298.9259,191.2430,1007.1794,85.5556}, // onede druzyna 2 spawn 1
			{296.8216,191.1995,1007.1719,91.1957}, // onede druzyna 2 spawn 2
			{294.6560,191.1543,1007.1719,91.1957}, // onede druzyna 2 spawn 3
			{292.2874,191.1049,1007.1719,91.1957}, // onede druzyna 2 spawn 4
			{290.0272,191.0578,1007.1719,91.1957}, // onede druzyna 2 spawn 5
			{287.2592,191.0000,1007.1719,91.1957}, // onede druzyna 2 spawn 6
			{284.7721,190.9481,1007.1719,91.1957}, // onede druzyna 2 spawn 7
			{282.2141,190.8947,1007.1719,91.1957}, // onede druzyna 2 spawn 8
			{279.9641,190.8478,1007.1719,91.1957}, // onede druzyna 2 spawn 9
			{277.4775,190.7959,1007.1794,91.1957}, // onede druzyna 2 spawn 10
			{274.5996,190.7358,1007.1719,91.1957}, // onede druzyna 2 spawn 11
			{272.0463,190.6826,1007.7330,91.1957}, // onede druzyna 2 spawn 12
			{269.6505,190.6325,1008.1719,91.1957}, // onede druzyna 2 spawn 13
			{269.1213,186.0482,1008.1719,1.2681}, // onede druzyna 2 spawn 14
			{266.9725,186.3339,1008.1719,1.8948}, // onede druzyna 2 spawn 15
			{2584.0742,1582.6615,10.8203,179.8081}, // kosciollv druzyna 1 spawn 1
			{2584.0503,1580.3351,10.8203,179.4948}, // kosciollv druzyna 1 spawn 2
			{2584.0220,1577.4888,10.8203,179.4948}, // kosciollv druzyna 1 spawn 3
			{2583.9954,1574.7681,10.8203,179.4948}, // kosciollv druzyna 1 spawn 4
			{2584.0513,1572.5760,10.8203,181.0615}, // kosciollv druzyna 1 spawn 5
			{2584.1921,1564.8224,10.8203,181.0615}, // kosciollv druzyna 1 spawn 6
			{2584.2339,1562.4514,10.8203,181.0615}, // kosciollv druzyna 1 spawn 7
			{2584.2722,1560.2859,10.8203,181.0615}, // kosciollv druzyna 1 spawn 8
			{2584.3142,1557.9528,10.8203,181.0615}, // kosciollv druzyna 1 spawn 9
			{2584.3630,1555.2344,10.8203,181.0615}, // kosciollv druzyna 1 spawn 10
			{2584.2637,1548.9847,10.8203,179.4948}, // kosciollv druzyna 1 spawn 11
			{2584.1567,1546.4387,10.8203,177.6148}, // kosciollv druzyna 1 spawn 12
			{2584.0554,1544.0109,10.8203,177.6148}, // kosciollv druzyna 1 spawn 13
			{2583.9470,1541.4136,10.8203,177.6148}, // kosciollv druzyna 1 spawn 14
			{2583.8696,1539.5854,10.8203,177.6148}, // kosciollv druzyna 1 spawn 15
			{2446.0498,1509.8777,10.8203,358.7304}, // kosciollv druzyna 2 spawn 1
			{2446.0950,1511.9402,10.8203,358.7304}, // kosciollv druzyna 2 spawn 2
			{2446.1455,1514.1936,10.8203,358.7304}, // kosciollv druzyna 2 spawn 3
			{2446.2075,1516.9716,10.8203,358.7304}, // kosciollv druzyna 2 spawn 4
			{2446.2751,1519.9740,10.8203,358.7304}, // kosciollv druzyna 2 spawn 5
			{2446.3389,1522.8044,10.8203,358.7304}, // kosciollv druzyna 2 spawn 6
			{2446.3889,1525.0509,10.8203,358.7304}, // kosciollv druzyna 2 spawn 7
			{2446.4446,1527.5282,10.8203,358.7304}, // kosciollv druzyna 2 spawn 8
			{2446.4966,1529.8910,10.8203,358.7304}, // kosciollv druzyna 2 spawn 9
			{2446.5635,1532.8927,10.8203,358.7304}, // kosciollv druzyna 2 spawn 10
			{2446.6213,1535.4982,10.8203,358.7304}, // kosciollv druzyna 2 spawn 11
			{2446.6748,1537.9039,10.8203,358.7304}, // kosciollv druzyna 2 spawn 12
			{2446.7263,1540.2235,10.8203,358.7304}, // kosciollv druzyna 2 spawn 13
			{2446.7761,1542.4923,10.8203,358.7304}, // kosciollv druzyna 2 spawn 14
			{2446.8245,1544.6945,10.8203,358.7304} // kosciollv druzyna 2 spawn 15
		};
		new Float:PompS[][] = {
			{963.8838,2160.7766,1011.0303,179.1478},
			{-10.9705,496.5265,1043.2858,237.8491},
			{-17.4470,478.6063,1043.2858,231.2690},
			{-3.9929,470.6980,1043.2858,359.4234},
			{-11.1633,450.5118,1043.2858,285.1627},
			{-8.0585,424.8453,1043.2858,334.3566},
			{16.3664,426.6277,1043.7773,359.7367},
			{27.2782,448.7307,1048.8766,307.0962},
			{43.9820,410.0937,1043.2858,252.2626},
			{41.7832,415.0363,1043.2858,96.8713},
			{54.1831,410.4342,1043.2858,186.1488},
			{73.0227,418.7364,1044.3335,357.5437},
			{92.3444,438.7169,1044.3335,290.4896},
			{114.3154,420.8503,1044.3400,92.7978},
			{115.7084,450.5472,1044.3400,95.3044},
			{94.6360,447.2028,1044.3335,77.1309},
			{72.7140,458.0810,1044.3335,0.6770},
			{92.9796,481.2717,1043.5798,358.7970},
			{112.7339,496.1530,1043.2858,179.8819},
			{124.3554,483.3712,1043.3440,183.6656},
			{53.1511,468.7046,1043.2858,84.3380},
			{33.1920,464.1386,1043.2858,93.1114},
			{19.0717,494.8882,1043.2858,176.7488}
		};
		new Float:MiniS[][] = {
			{204.6040,1864.5995,13.1406,281.4944},
			{232.2959,1932.2518,33.8984,139.4252},
			{164.1274,1933.1805,33.8984,204.1361},
			{124.7873,1902.1914,18.5876,167.9588},
			{104.9977,1899.1080,33.8984,250.8834},
			{105.4664,1900.4084,25.4985,281.9689},
			{202.7709,1856.6484,20.4890,292.8806},
			{209.2247,1829.9565,17.6406,174.8758},
			{210.4987,1811.5519,21.8594,80.2274},
			{230.1189,1834.9995,23.7154,16.0094},
			{190.6595,1833.1914,23.2422,88.8755},
			{150.5943,1835.5320,21.6334,78.3056},
			{113.4188,1814.2532,25.4985,278.7965},
			{115.7354,1815.8531,33.8984,305.8453},
			{262.3586,1806.8195,25.4985,93.9673},
			{260.8235,1809.7693,33.8984,93.9673}
		};
	//Priv
		enum e_Priv {
			pcidp,
			PJB,
			PCcolor[2],
			PCN,
			pOid,
			pcmodel,
			pccomp[75],
			pveh,
			Text3D:pc3d,
			pcexpc,
			pcmoc,
			pcONi[24],
			Float:przebieg,
			bool:Komornik
		}
		new PCDV[MAX_PLAYERS][e_Priv];
		new Iterator:Privs<MAX_PLAYERS>;
	//Top
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
			TopSnipern[24],
			TopGang,
			TopGangT[6]
		}
		new Top[10][TOP_enum];
	//Gangi
		enum G_enum{
			idG,
			gName[24],
			gTag[6],
			gRspkt,
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
			sprST,
			SprT,
			SparT,
			SprW,
			gExpire,
			LVL
		}
		new GDV[MAX_GANGS][G_enum];
		new Iterator:GTHC<MAX_GANGS>;
		enum GZ_enum{
			GZid,
			Float:GZPos[4],
			GZoid,
			GZname[24],
			GZGang,
			GZZone,
			GZWar,
			GZWWG,
			Text:GZTxd0,
			Text:GZTxd1,
			Text:GZTxd2,
			Text:GZTxd3,
			Text:GZTxd4,
			Text:GZTxd5,
			Text:GZTxd6,
			Text:GZTxd7,
			Text:GZTxd8,
			Text:GZTxd9,
			Text:GZTxd10,
			Text:GZTxd11,
			Text:GZTxd12,
			GZWar2,
			GZCas0,
			GZCas1,
			GZTis
		}
		new GZDV[MAX_ZONES][GZ_enum];
		new Iterator:aZones<MAX_ZONES>;
		new Text:SparTd1[MAX_GANGS],Text:SparTd2[MAX_GANGS],Text:SparTd3[MAX_GANGS],Text:SparTd4[MAX_GANGS],Text:SparTd5[MAX_GANGS];
	//Race
		#define MAX_RCcp 100

		enum E_Rc{
			Rid,
			RCc,
			RCi,
			RCn[24]

		}
		enum EC_Rc{
			rP,
			Float:RCcx,
			Float:RCcy,
			Float:RCcz,
			rType,
			RCcid
		}
		enum ES_Rc{
			Float:Srcx,
			Float:Srcy,
			Float:Srcz,
			Float:Srca,
		}
		new RCl[E_Rc];
		new RCC[MAX_RCcp][EC_Rc];
		new RCS[10][ES_Rc];
		new numRC;
		new rcw[5];
		enum E_Temp{
			ChkP
		}
		new PDT[MAX_PLAYERS][E_Temp];
		new Iterator:RCcp<MAX_RCcp>;
		new RcSp;
		new bool:CreatingF,rcpos;

main(){}
//TD id's
	new Text:red[25];
	new Text:Zegar;
	new Text:Save;
	new Text:LogOnS[14];
	new Text:waltxd;
	new PlayerText:PTD[MAX_PLAYERS][11];
	new PlayerText:PTDHA[MAX_PLAYERS][2];
	new PlayerText:StatTXD[MAX_PLAYERS][2];
	new PlayerText:LogonSP[MAX_PLAYERS];
new SVehs[18];
new wyKam[3],wyHP[2],wyWeap[47];
enum g_En{
	svTx,
	Rest,
	wyp,
	drby,
	wal,
	pl[6],
	wgs,
	Admins,
	Vips,
	players,
	arP[5],
	Smo,
	gCh,
	aCh,
	gRC,
	Float:GZs0,
	Float:GZs1,
	Float:GZs2,
	Float:GZs3,
	Float:GZs4,
	bool:crtingz,
	bool:Yas
}
new GZnm[24];
new GM[g_En];
new MiniZ[2];
new WGZ[2];
//Timer Seconds
	new TSecG0,TSecG1,TSecG2,TSecG3,TSecG4;
	forward public Glob();
	public Glob()
	{
		TSecG0++;
		TSecG1++;
		TSecG2++;
		TSecG3++;
		TSecG4++;
		if(TSecG4 >= 3600){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {22AAFF}ZAPISYWANIE SERWERA, MO¯E WYST¥PIÆ LAG");
			RspCars();
			foreach(new i : IHo){
				if(i == 0){}
				else{
					if((HDV[i][expi] - HDV[i][ExP]) < 0){
						DeOwnH(i);
					}
					else if((HDV[i][moni] - HDV[i][MoP]) < 0){
						DeOwnH(i);
					}else{
						HDV[i][expi] -= HDV[i][ExP];
						HDV[i][moni] -= HDV[i][MoP];
					}
				}
			}
		}
		new time0,time1,time2;
		gettime(time0,time1,time2);
		new str[128];
		format(str,sizeof(str),"%s%i:%s%i", (time0 < 10) ? ("0") : (""),time0, (time1 < 10) ? ("0") : (""),time1);
		TextDrawSetString(Zegar, str);
		GM[players] = 0;
		foreach(Player,i)
		{
			if(IsPlayerConnected(i))
			{
				if(IsAFK(i) && PDV[i][LogIn]){callcmd::zw(i,"");}
				else if(PDV[i][LogIn])
				{
					format(str,sizeof(str),"Ping:%i FPS:%i",GetPlayerPing(i),GetPlayerFps(i));
					PlayerTextDrawSetString(i, PTD[i][9], str);
					format(str,sizeof(str),"EXP:%i",PDV[i][Rsp]);
					PlayerTextDrawSetString(i, PTD[i][8], str);
					format(str,sizeof(str),"D:%i",PDV[i][De]);
					PlayerTextDrawSetString(i, PTD[i][6], str);
					format(str,sizeof(str),"K:%i",PDV[i][Ki]);
					PlayerTextDrawSetString(i, PTD[i][5], str);
					format(str,sizeof(str),"SKULL:%i",PDV[i][DeTa]);
					PlayerTextDrawSetString(i, PTD[i][6], str);
					format(str,sizeof(str),"Online:%ih%imin",NetStats_GetConnectedTime(i) / 3600000, (NetStats_GetConnectedTime(i) / 60000)- ((NetStats_GetConnectedTime(i) / 3600000) * 3600));
					PlayerTextDrawSetString(i, PTD[i][0], str);
					if(PDV[i][IGid] != -1){
						format(str,sizeof(str),"Rspkt:%i",PDV[i][Rsp]);
						PlayerTextDrawSetString(i, PTD[i][4], str);
						format(str,sizeof(str),"Gang:%s",GDV[PDV[i][IGid]][gTag]);
						PlayerTextDrawSetString(i, PTD[i][3], str);
					}
					if(GM[drby] == -2 && PDV[i][Plays] == 2){
						if(GM[pl][1] == 1){
							DerbyEnd(i);
						}
						else if(GetPlayerVehicleSeat(i) != 0){
							PDV[i][Plays] = 0;
							GM[pl][1]--;
							ReS(i);
							SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Przegra³eœ na derbach :(");

						}else{
							new Float:x,Float:y,Float:z;
							GetPlayerPos(i, x,y,z);
							if(z <= 1.0){
								RemovePlayerFromVehicle(i);
								DestroyVehicle(PDV[i][cID]);
								PDV[i][Plays] = 0;
								PDV[i][cID] = -1;
								GM[pl][1]--;
								ReS(i);
								SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Przegra³eœ na derbach :(");
							}
						}
					}
					if(PDV[i][Arena] == 4 && PDV[i][MinIn] != -1){
						if(PDV[i][MinIn] <= GetTickCount()){SetPlayerHealth(i, 0); PDV[i][MinIn] = -1;}
					}
					else if(PDV[i][Plays] == 3 && PDV[i][WGIn] != -1){
						if(PDV[i][WGIn] <= GetTickCount()){SetPlayerHealth(i, 0); PDV[i][WGIn] = -1; PDV[i][Plays] = 0;}
					}
					if(TSecG0 >= 10){PDV[i][ChSp] = 0;PDV[i][CmU] = 0; PDV[i][TpSp] = false;}
					if(TSecG1 >= 30){PDV[i][RpCl] = false;}
					if(TSecG3 >= 2 && PDV[i][SGod]){PDV[i][SGod] = false; SetPlayerHealth(i,100);}
					if(PDV[i][ToKick] == true){Kick(i);}
					if(PDV[i][JaT] < gettime() && PDV[i][Jailed]){UJL(i);}

					new Float:Arm;
					GetPlayerArmour(i, Arm);
					if(Arm > 0){
						format(str,sizeof(str),"%.0f%%",Arm);
						PlayerTextDrawSetString(i, PTDHA[i][1],str);
						PlayerTextDrawShow(i,PTDHA[i][1]);
					}
					if(Arm <= 0)
					{
						PlayerTextDrawHide(i,PTDHA[i][1]);
					}
					GetPlayerHealth(i,Arm);
					format(str,sizeof(str),"%.0f%%",Arm);
					PlayerTextDrawSetString(i,PTDHA[i][0],str);
					if(PDV[i][CtD] != 0){
						if(PDV[i][CtD] <= GetTickCount()){
							GameTextForPlayer(i, "~r~~h~>>>~g~~h~~h~Go!~r~~h~<<<", 1000, 3);
							PlayerPlaySound(i, 1057, 0,0,0);
							if(PDV[i][SetF] != 0){ CallF(i);}
							PDV[i][CtD] = 0;

						}
						else{
							format(str,128,"~g~~h~~h~%i",(PDV[i][CtD] - GetTickCount())/1000);
							GameTextForPlayer(i,str,1000,3);
							PlayerPlaySound(i, 1056, 0,0,0);
						}
					}
					if(PDV[i][nCtD] != 0 && PDV[i][SetF] != 0){
						if(PDV[i][nCtD] <= GetTickCount()){
							CallF(i);
							PDV[i][nCtD] = 0;
						}else {
							PDV[i][nCtD]--;
						}
					}
					if(GetPlayerVehicleSeat(i) == 0){
						new Float:x,Float:y,Float:z;
						new veid = GetPlayerVehicleID(i);
						if(PDV[i][VehGod]){
							RepairVehicle(veid);
						}
						GetVehicleVelocity(veid, x,y,z);
						GetVehicleHealth(veid, Arm);
						Arm = Arm / 10;
						x = x+y+z * 14.663;
						format(str,sizeof(str),"Pojazd:%s~n~Stan:%.0f%%~n~KM/H:%.0f",VehNam[GetVehicleModel(veid)-400],Arm,x);
						PlayerTextDrawSetString(i,PTD[i][10],str);
						if(veid == PCDV[PDV[i][OwOfP]][pveh]){
							GetVehicleVelocity(veid, x,y,z);
							PCDV[PDV[i][OwOfP]][przebieg] += floatsqroot(x+y+z) / 3600.0;
							UpdPriv3DTxT(PDV[i][OwOfP]);
						}
					}
					if(TSecG4 >= 3600){
						SVPlayer(i);
					}
					if(PDV[i][Plays] == 5 && GM[Smo] == -2){
						new Float:z;
						GetPlayerPos(i,z,z,z);
						if(z <= 401.000){
							PDV[i][Plays] = 0;
							ReS(i);
							GM[pl][3]--; 
							if(GM[pl][3] <= 1){OnSmoEnd();}
							SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Odpad³eœ z sumo :(");
						}
						
					}
				}
				GM[players]++;
			}
		}
		format(str,sizeof(str),"ONLINE: %i/~y~%i~w~/~r~%i",GM[players],GM[Vips],GM[Admins]);
		TextDrawSetString(red[22], str);
		if(TSecG4 >= 3600){TSecG4 = 0;}
		if(GM[Yas] && TSecG0 >= 5){
			GM[Yas] = false;
			foreach(new i : Privs){
				if(PCDV[i][pOid] != -1 && (PCDV[i][pcexpc] > 0 || PCDV[i][pcmoc] > 0)){
					new mo,cxp;
					switch(PCDV[i][pcmodel]){
						case 557:{PCDV[i][pcmoc] -= 600000;mo = 600000; PCDV[i][pcexpc]-= 15000;cxp = 15000;}
						case 592:{PCDV[i][pcmoc] -= 450000;mo = 450000; PCDV[i][pcexpc]-= 8600;cxp = 8600;}
						case 409:{PCDV[i][pcmoc] -= 350000;mo = 350000; PCDV[i][pcexpc]-= 7400;cxp = 7400;}
						case 519:{PCDV[i][pcmoc] -= 200000;mo = 200000; PCDV[i][pcexpc]-= 6300;cxp = 6300;}
						case 503:{PCDV[i][pcmoc] -=  80000;mo =  80000; PCDV[i][pcexpc]-= 5200;cxp = 5200;}//This
						case 502:{PCDV[i][pcmoc] -=  80000;mo =  80000; PCDV[i][pcexpc]-= 5200;cxp = 5200;}//Equals This
						case 411:{PCDV[i][pcmoc] -=  75000;mo =  75000; PCDV[i][pcexpc]-= 3700;cxp = 3700;}
						case 513:{PCDV[i][pcmoc] -=  66000;mo =  66000; PCDV[i][pcexpc]-= 3650;cxp = 3650;}
						case 511:{PCDV[i][pcmoc] -=  64000;mo =  64000; PCDV[i][pcexpc]-= 3550;cxp = 3550;}
						case 495:{PCDV[i][pcmoc] -=  55000;mo =  55000; PCDV[i][pcexpc]-= 3400;cxp = 3400;}
						case 541:{PCDV[i][pcmoc] -=  47000;mo =  47000; PCDV[i][pcexpc]-= 3300;cxp = 3300;}
						case 593:{PCDV[i][pcmoc] -=  43000;mo =  43000; PCDV[i][pcexpc]-= 3100;cxp = 3100;}
						case 521:{PCDV[i][pcmoc] -=  39000;mo =  39000; PCDV[i][pcexpc]-= 3000;cxp = 3000;}
						case 562:{PCDV[i][pcmoc] -=  36000;mo =  36000; PCDV[i][pcexpc]-= 2800;cxp = 2800;}
						case 461:{PCDV[i][pcmoc] -=  34000;mo =  34000; PCDV[i][pcexpc]-= 2600;cxp = 2600;}
						case 429:{PCDV[i][pcmoc] -=  22000;mo =  22000; PCDV[i][pcexpc]-= 2400;cxp = 2400;}
						case 451:{PCDV[i][pcmoc] -=  20000;mo =  20000; PCDV[i][pcexpc]-= 2350;cxp = 2350;}
						case 559:{PCDV[i][pcmoc] -=  19500;mo =  19500; PCDV[i][pcexpc]-= 2140;cxp = 2140;}
						case 468:{PCDV[i][pcmoc] -=  18500;mo =  18500; PCDV[i][pcexpc]-= 2050;cxp = 2050;}
						case 500:{PCDV[i][pcmoc] -=  16500;mo =  16500; PCDV[i][pcexpc]-= 1950;cxp = 1950;}
						case 581:{PCDV[i][pcmoc] -=  15400;mo =  15400; PCDV[i][pcexpc]-= 1850;cxp = 1850;}
						case 560:{PCDV[i][pcmoc] -=  14000;mo =  14000; PCDV[i][pcexpc]-= 1730;cxp = 1730;}
						case 477:{PCDV[i][pcmoc] -=  13990;mo =  13990; PCDV[i][pcexpc]-= 1500;cxp = 1500;}
						case 506:{PCDV[i][pcmoc] -=  11000;mo =  11000; PCDV[i][pcexpc]-= 1350;cxp = 1350;}
						case 415:{PCDV[i][pcmoc] -=   9900;mo =   9900; PCDV[i][pcexpc]-= 1250;cxp = 1250;}
						case 475:{PCDV[i][pcmoc] -=   8700;mo =   8700; PCDV[i][pcexpc]-= 1100;cxp = 1100;}
						case 402:{PCDV[i][pcmoc] -=   7600;mo =   7600; PCDV[i][pcexpc]-= 1000;cxp = 1000;}
						case 603:{PCDV[i][pcmoc] -=   6500;mo =   6500; PCDV[i][pcexpc]-= 999;cxp = 999;}
						case 561:{PCDV[i][pcmoc] -=   6300;mo =   6300; PCDV[i][pcexpc]-= 970;cxp = 970;}
						case 558:{PCDV[i][pcmoc] -=   5500;mo =   5500; PCDV[i][pcexpc]-= 960;cxp = 960;}
						case 471:{PCDV[i][pcmoc] -=   5400;mo =   5400; PCDV[i][pcexpc]-= 940;cxp = 940;}
						case 565:{PCDV[i][pcmoc] -=   4400;mo =   4400; PCDV[i][pcexpc]-= 900;cxp = 900;}
						case 480:{PCDV[i][pcmoc] -=   3900;mo =   3900; PCDV[i][pcexpc]-= 840;cxp = 840;}
						case 579:{PCDV[i][pcmoc] -=   3400;mo =   3400; PCDV[i][pcexpc]-= 820;cxp = 820;}
						case 445:{PCDV[i][pcmoc] -=   3200;mo =   3200; PCDV[i][pcexpc]-= 800;cxp = 800;}
						case 496:{PCDV[i][pcmoc] -=   3000;mo =   3000; PCDV[i][pcexpc]-= 780;cxp = 780;}
						case 542:{PCDV[i][pcmoc] -=   2600;mo =   2600; PCDV[i][pcexpc]-= 760;cxp = 760;}
						case 404:{PCDV[i][pcmoc] -=   2300;mo =   2300; PCDV[i][pcexpc]-= 740;cxp = 740;}
					}
					mysql_format(DBM, str, sizeof(str), "SELECT `csh`,`rsp` FROM `plys` WHERE `id`='%i'",PCDV[i][pOid]);
					tmq(str,"SetIstP","iii",i,mo,cxp);
				}
			}
		}
		if(TSecG0 >= 10){TSecG0= 0;}
		if(TSecG1 >= 30){TSecG1= 0;}
		if(TSecG2 >= 240){
			TSecG2 = 0;
			new ran = random(sizeof(RandomMsg));
			SCMA(-1,RandomMsg[ran]);
		}
		if(TSecG3 >= 2){TSecG3 = 0;}
		if(GM[svTx] <= GetTickCount()){
			TextDrawHideForAll(Save);
		}

		foreach(new i : SkI){
			if(PSku[i][3] <= GetTickCount() && PSku[i][3] != 0){
				DestroyDynamicPickup(PSku[i][2]);
				PSku[i][0] = 0;
				PSku[i][1] = 0;
				PSku[i][3] = 0;
			}
		}
		if(GM[Rest] <= GetTickCount() && GM[Rest] != -1){SendRconCommand("gmx");}
		if(GM[wyp] <= GetTickCount() && (GM[wyp] != -1 && GM[wyp] != -2)){Wysp();}
		if(GM[drby] <= GetTickCount() && (GM[drby] != -1 && GM[drby] != -2)){Derby();}
		if(GM[wgs] <= GetTickCount() && (GM[wgs] != -1 && GM[wgs] != -2)){StartWG();}
		new h,m,s;
		gettime(h,m,s);
		if(h == 3 && m == 0 && (5 > s > 0)){
			foreach(Player,i){
				if(IsPlayerConnected(i)){
					Kick(i);
				}
			}
			SendRconCommand("gmx");
		}
		foreach(new x : aZones){
			if(GZDV[x][GZTis] != -1){
				if(GZDV[x][GZTis] <= GetTickCount()){
					AttckEnd(x);
				}
			}
		}
	}
//Publics
	public OnGameModeInit(){
		CreatingF = false;
		new Cache:cA = mysql_query(DBM, "SELECT COUNT(*) FROM `RCa`", true);
		cache_get_value_index_int(0, 0, numRC);
		cache_delete(cA);
		LoadInrcP();
		Iter_Add(IHo, 0);
		HDV[0][hID] = 0;
		HDV[0][XP] = 0.000;
		HDV[0][YP]= 0.000;
		HDV[0][ZP]= 0.000;
		HDV[0][Iid] = -1;
		HDV[0][Oid] = -1;
		HDV[0][Bin] = false;
		HDV[0][hpass][23] = EOS;
		HDV[0][hidP] = -1;
		HDV[0][hidMI] = -1;
		HDV[0][ExP] = 0;
		HDV[0][MoP] = 0;
		HDV[0][expi] = -1;
		HDV[0][moni] = -1;
		HDV[0][Lck] = false;
		HDV[0][estanam][23] = EOS;
		HDV[0][ONck][23] = EOS;
		GM[wyp] = -1;
		GM[Rest] = -1;
		GM[wgs] = -1;
		GM[Smo] = -1;
		Iter_Add(Privs, 0);
		MiniZ[0] = CreateDynamicRectangle(99.7316,1797.8527,284.1687,1940.0529, 52, 0);
		MiniZ[1] = GangZoneCreate(99.7316,1797.8527,284.1687,1940.0529);
		WGZ[0] = CreateDynamicRectangle(2422.4507,1467.5620,2612.2961,1620.9795,53,0);
		WGZ[1] = GangZoneCreate(2422.4507,1467.5620,2612.2961,1620.9795);
		SendRconCommand("language PL | Polish | English");
		SendRconCommand("gamemodetext | Jamaica Server | V0.4.3");
		//SendRconCommand("hostname • [PL] •••• Jamaica Server •••• [JS] • @LiveServer.pl");
		SendRconCommand("hostname Jamaica Server@LiveServer.pl");
		SendRconCommand("mapname Jamaica™");
		ZjebUmysl = true;
		mysqlcon();
		new qu[56];
		mysql_format(DBM, qu, sizeof(qu), "UPDATE `plys` SET `tkd`='0'");
		mq(qu);
		DisableInteriorEnterExits();
		UsePlayerPedAnims();
		EnableStuntBonusForAll(0);
	 	CrGlTxD();
	 	LHouses();
		LObj();
		LOpt();
		LVehS();
		CreateTop();
		for(new i=0;i<311;i++)
		{
			AddPlayerClass(i, 0.00,0.00,0.0,0.0,0,0,0,0,0,0);
		}
		for(new i=0,x=sizeof(RandomSpawns);i<x;i++)
		{
			CreateDynamicPickup(1314, 1, RandomSpawns[i][0],RandomSpawns[i][1],RandomSpawns[i][2], -1, -1, -1, 15);
			CreateDynamic3DTextLabel(""SITE_A"\nSerwer mo¿e byæ bardziej popularny!\nZAPROŒ ZNAJOMYCH!\nStwórzcie w³asny gang i grajcie razem!", 0x008080FF, RandomSpawns[i][0], RandomSpawns[i][1], RandomSpawns[i][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1, 100.0);

		}
		SetTimer("Glob", 1000, true);
		return 1;}
	public OnGameModeExit(){
		return 1;}
	public OnIncomingConnection(playerid, ip_address[], port){
		PDV[playerid][LogIn] = false;
		return 1;}
	public OnPlayerConnect(playerid){
		PDV[playerid][WGIn] = -1;
		PDV[playerid][nAPL] = 0;
		PDV[playerid][APL] = 0;
		PDV[playerid][PFai] = 0;
		PDV[playerid][CmU] = 0;
		PDV[playerid][SPM] = false;
		PDV[playerid][Nck][0] = EOS;
		callcmd::jj(playerid,"");

		PDV[playerid][Wat] = -1;
		PDV[playerid][CorP] = 0;
		PDV[playerid][Ptp] = -1;
		PDV[playerid][Csh] = 0;
		PDV[playerid][Rsp] = 0;
		PDV[playerid][De] = 0;
		PDV[playerid][Ki] = 0;
		PDV[playerid][KS] = 0;
		PDV[playerid][DeTa] = 0;
		PDV[playerid][cID] = 0;
		PDV[playerid][ChSp] = 0;
		PDV[playerid][CMT] = 0;
		PDV[playerid][JaT] = 0;
		PDV[playerid][BaT] = 0;
		PDV[playerid][Ba] = 0;
		PDV[playerid][BaG] = 0;
		PDV[playerid][CmU] = 0;
		PDV[playerid][wrn] = 0;
		PDV[playerid][SCl] = 0;
		PDV[playerid][Arena] = 0;
		PDV[playerid][SoBr] = 0;
		PDV[playerid][SoP] = -1;
		PDV[playerid][SKi] = 0;
		PDV[playerid][SoA] = 0;
		PDV[playerid][SDe] = 0;
		PDV[playerid][SetF] = -1;
		PDV[playerid][CtD] = 0;
		PDV[playerid][APL] = 0;
		PDV[playerid][nAPL] = 0;
		PDV[playerid][SPM] = false;
		PDV[playerid][VIP] = 0;
		PDV[playerid][TpOf] = false;
		PDV[playerid][FrP] = false;
		PDV[playerid][RpCl] = false;
		PDV[playerid][Btle] = 0;
		PDV[playerid][TpSp] = false;
		PDV[playerid][SolOff] = false;
		PDV[playerid][LogIn] = false;
		PDV[playerid][God] = false;
		PDV[playerid][ToKick] = false;
		PDV[playerid][BlCMD] = false;
		PDV[playerid][Wypociny] = false;
		PDV[playerid][Plays] = 0;
		PDV[playerid][Spect] = -1;
		PDV[playerid][AntiFD] = GetTickCount()+1000;
		PDV[playerid][ipP][0] = EOS;
		PDV[playerid][ColDr] = 0;
		PDV[playerid][zw] = false;
		PDV[playerid][Dying] = false;
		PDV[playerid][IGid] = -1;
		PDV[playerid][GPid] = -1;
		PDV[playerid][gSpar] = false;
		for(new i=0;i<200;i++){
			SCM(playerid,-1," ");
		}
		if(FindSQLInject(GetPN(playerid))){KP(playerid,"SQL INJECT",INVALID_PLAYER_ID);}
		format(PDV[playerid][Nck],24, GetPN(playerid));
		GetPlayerIp(playerid, PDV[playerid][ipP], 16);
		gpci(playerid,PDV[playerid][ngpci],41);
		foreach(Player,i){
			if(PDV[i][APL] > 3){
				SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ddaaaa}%s:{aaffaa}%s",PDV[playerid][Nck],PDV[playerid][ipP]);
				SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ddaaaa}GPCI:%s",PDV[playerid][ngpci]);
			}
		}
		PlayAudioStreamForPlayer(playerid, "https://www.dropbox.com/s/sq5tb774o6dvg1z/Snoop%20Lion.mp3?dl=1");
		LPlayer(playerid);
		TogglePlayerSpectating(playerid,true);
		TextDrawShowForPlayer(playerid, LogOnS[0]);
		TextDrawShowForPlayer(playerid, LogOnS[2]);
		TextDrawShowForPlayer(playerid, LogOnS[3]);
		TextDrawShowForPlayer(playerid, LogOnS[4]);
		TextDrawShowForPlayer(playerid, LogOnS[5]);
		TextDrawShowForPlayer(playerid, LogOnS[6]);
		TextDrawShowForPlayer(playerid, LogOnS[7]);
		TextDrawShowForPlayer(playerid, LogOnS[8]);
		TextDrawShowForPlayer(playerid, LogOnS[9]);
		TextDrawShowForPlayer(playerid, LogOnS[10]);
		TextDrawShowForPlayer(playerid, LogOnS[11]);
		TextDrawShowForPlayer(playerid, LogOnS[12]);
		TextDrawShowForPlayer(playerid, LogOnS[13]);
		SelectTextDraw(playerid, 0x565656aa);
		crPlTxD(playerid);
		return 1;}
	public OnPlayerExitVehicle(playerid, vehicleid){
		PDV[playerid][VehGod] = false;
		return 1;}
	public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
		for(new i=0,l=sizeof(SVehs);i<l;i++){
			if(SVehs[i] == vehicleid){
				PDV[playerid][PrivR] = vehicleid;
				Dialog_Show(playerid, PrivBD, DIALOG_STYLE_LIST, "Salon - Kup Auto", "{00ff00}Informacje\n{ffffff}Kup\nWeŸ na raty", "Wybierz", "Nie");
			}
		}	
		return 1;}
	public OnPlayerRequestClass(playerid, classid){
		SetPlayerSkin(playerid, PDV[playerid][PSk]);
		SetPlayerPos(playerid,-586.3630,3318.1284,61.6205);
		SetPlayerFacingAngle(playerid,66.0196);
		SetPlayerCameraPos(playerid, -590.8448,3319.7219,61.6205);
		SetPlayerCameraLookAt(playerid, -584.3630,3317.5284,63.6205, CAMERA_CUT);
		return 1;}
	public OnPlayerRequestSpawn(playerid){
		SCM(playerid,-1,"{7fffd4}Witamy na Serwerze {9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {007fff}Server {9b9da0}|");
		if(PDV[playerid][VIP] == 1){
			PDV[playerid][Rank] = CreateDynamic3DTextLabel("{ffd700}V.I.P", -1, 0.0,0.0,1.3, 15.0,playerid);
			GM[Vips]++;
		}
		foreach(new zid : aZones){
			if(GZDV[zid][GZGang] == -1){
				GangZoneShowForPlayer(playerid,zid,0xAAAAAAAA);
			}else {
				GangZoneShowForPlayer(playerid,zid,GDV[GZDV[zid][GZoid]][gcolo] + 170);
			}
		}
		StopAudioStreamForPlayer(playerid);
		return 1;}
	public OnPlayerSpawn(playerid){
		ReS(playerid);
		return 1;}
	public OnPlayerDeath(playerid, killerid, reason){
		SendDeathMessage(killerid, playerid, reason);
		if(GetTickCount()+500 - PDV[playerid][AntiFD] < 0){
			KP(playerid,"Fake Death",INVALID_PLAYER_ID);
			return 1;
		}
		PDV[playerid][Dying] = true;
		PDV[playerid][AntiFD] = GetTickCount();
		if(PDV[playerid][Plays] != 0 && killerid == INVALID_PLAYER_ID && (GM[wyp] < 0 || GM[drby] < 0 || GM[wgs] < 0)){
			switch(PDV[playerid][Plays]){
				case 1:{
					GM[pl][0]--;
				}

				case 2:{
					GM[pl][1]--;
				}
				case 3:{
					GM[pl][2]--;
				}
			}
			PDV[playerid][Plays] = 0;
		}
		if(killerid == INVALID_PLAYER_ID) {return 1;}
		if(PDV[killerid][Arena] == 1 && !(reason == 24 || reason == 0)){
			KP(killerid,"Weapon Hack na OneDe",INVALID_PLAYER_ID);
			return 1;
		}
		PDV[killerid][Ki]++;
		PDV[playerid][De]++;
		PDV[killerid][KS]++;
		TkPlRe(playerid,1);
		PDV[playerid][KS] = 0;
		if(Busy(playerid)){GiRe(killerid,2*PDV[killerid][KS]);}
		else { GiRe(killerid,1*PDV[killerid][KS]);}
		if(PDV[killerid][Arena] == 2 && PDV[playerid][Arena] == 2){
			PDV[killerid][SKi]++;
			PDV[playerid][SDe]++;
			PDV[playerid][Arena] = 0;
			PDV[killerid][CtD] = GetTickCount()+5000;
			PDV[killerid][SetF] = 2;
			unwatch(playerid);
			unwatch(killerid);
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³(a) solówkê gratulacje",PDV[killerid][Nck]);
			PDV[playerid][SoP] = PDV[killerid][SoP] = -1;
		}
		else if(PDV[killerid][Arena] == 1 && PDV[playerid][Arena] == 1){
			PDV[killerid][OKi]++;
			PDV[playerid][ODe]++;
		}
		else if(PDV[killerid][Arena] == 3 && PDV[playerid][Arena] == 3){
			PDV[killerid][PKi]++;
			PDV[playerid][ODe]++;
		}
		else if(PDV[killerid][Arena] == 4 && PDV[playerid][Arena] == 4){
			PDV[killerid][MKi]++;
			PDV[playerid][MDe]++;
		}
		else if(PDV[killerid][Arena] == 5 && PDV[playerid][Arena] == 5){
			PDV[killerid][SpKi]++;
			PDV[playerid][SpDe]++;
		}
		else if(GM[wyp] == -2 && PDV[killerid][Plays] == 1){
			GM[pl][0]--;
			if(GM[pl][0] == 1){
				GiRe(killerid,30);
				PDV[killerid][CtD] = GetTickCount()+5000;
				PDV[killerid][SetF] = 2;
				PDV[killerid][Plays] = 0;
				GM[wyp] = -1;
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³(a) Wyspe Przetrwania",PDV[killerid][Nck]);
				DPWyp();
			}
			PDV[playerid][Plays] = 0;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Przegra³eœ(aœ) Wyspe Przetrwania :C");
			GiRe(killerid,10);
		}
		if(GDV[PDV[playerid][IGid]][gWar]){
			foreach(new x : aZones){
				if(IsPlayerInDynamicArea(playerid, GZDV[x][GZZone])){
					if(GZDV[x][GZTis] != -1){
						if(GZDV[x][GZoid] == PDV[playerid][IGid]){
							UpdateGZHud(x);
							GZDV[x][GZCas0]++;
							GZDV[x][GZTis] += 10000;
						}else if(GZDV[x][GZWWG] == PDV[playerid][IGid]){
							GZDV[x][GZCas1]++;
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
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		new ite = Iter_Free(SkI);
		PSku[ite][0] = PDV[playerid][Rsp] / 100;
		PSku[ite][1] = PDV[playerid][Csh] / 2;
		PSku[ite][3] = GetTickCount()+900000;
		TkPlRe(playerid,PSku[ite][0]);
		TkPlMo(playerid,PSku[ite][1]);
		Iter_Add(SkI, ite);
		PSku[ite][2] = CreateDynamicPickup(1254, 8, x,y,z, GetPlayerVirtualWorld(killerid), GetPlayerInterior(playerid));
		PDV[playerid][Btle] = 0;
		return 1;}
	public OnPlayerDisconnect(playerid, reason){
		if(PDV[playerid][LogIn]){
			switch(PDV[playerid][Arena]){
				case 1:{
					GM[arP][0]--;
					new str[64];
					format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
					TextDrawSetString(red[21], str);
				}
				case 2:{
					PDV[PDV[playerid][SoP]][SKi]++;
					PDV[PDV[playerid][SoP]][Ki]++;
					PDV[playerid][SDe]++;
					PDV[playerid][De]++;
					PDV[PDV[playerid][SoP]][CtD] = GetTickCount()+5000;
					PDV[PDV[playerid][SoP]][SetF] = 2;
					new Float:x,Float:y,Float:z;
					GetPlayerPos(playerid,x,y,z);
					new ite = Iter_Free(SkI);
					PSku[ite][0] = PDV[playerid][Rsp] / 100;
					PSku[ite][1] = PDV[playerid][Csh] / 2;
					PSku[ite][3] = GetTickCount()+900000;
					TkPlRe(playerid,PSku[ite][0]);
					TkPlMo(playerid,PSku[ite][1]);
					Iter_Add(SkI, ite);
					unwatch(playerid);
					unwatch(PDV[playerid][SoP]);
					PSku[ite][2] = CreateDynamicPickup(1254, 8, x,y,z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³ solówkê, Gratulacje!",PDV[PDV[playerid][SoP]][Nck]);
					PDV[playerid][SoP] = PDV[PDV[playerid][SoP]][SoP] = -1;
				}
				case 3:{
					GM[arP][1]--;
					new str[64];
					format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
					TextDrawSetString(red[21], str);
				}
				case 4:{
					GM[arP][2]--;
					new str[64];
					format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
					TextDrawSetString(red[21], str);
				}
				case 5:{
					GM[arP][3]--;
					new str[64];
					format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
					TextDrawSetString(red[21], str);
				}
				case 6:{
					GM[arP][4]--;
					new str[64];
					format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
					TextDrawSetString(red[21], str);
				}
			}
			if(PDV[playerid][VIP] == 1){
				DestroyDynamic3DTextLabel(PDV[playerid][Rank]);
				GM[Vips]--;
			}
			if(PDV[playerid][APL] >= 1){
				DestroyDynamic3DTextLabel(PDV[playerid][Rank]);
				GM[Admins]--;
			}
			if(GM[Rest] != -1){SVPlayerNT(playerid);}
			else{SVPlayer(playerid);}
			if(PDV[playerid][Plays] != 0){
				if(GM[wyp] == -2 && PDV[playerid][Plays] == 1){
					GM[pl][0]--;
					if(GM[pl][0] == 1){
						foreach(Player,i){
							if(PDV[i][Plays] == 1){
								GiRe(i,30);
								PDV[i][CtD] = GetTickCount()+5000;
								PDV[i][SetF] = 2;
								PDV[i][Plays] = 0;
								GM[wyp] = -1;
								SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³(a) Wyspe Przetrwania!",PDV[i][Nck]);
								DPWyp();
								break;
							}
						}
					}
					else if(GM[pl][0] < 1){
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wyspy przetrwania nikt nie wygra³? CO?");
						GM[wyp] = -1;
						DPWyp();
					}
					PDV[playerid][Plays] = 0;
				}
				else if(GM[drby] == -2 && PDV[playerid][Plays] == 2){
					GM[pl][1]--;
					if(GM[pl][1] == 1){
						foreach(Player,i){
							if(PDV[i][Plays] == 2){DerbyEnd(i);break;}
						}
					}
					else if(GM[pl][1] < 1){
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wyspy przetrwania nikt nie wygra³?");
						DPWyp();
					}
				}
				else if(GM[wgs] == -2 && PDV[playerid][Plays] == 3){
					GM[pl][2]--;
					new t1,t2;
					foreach(Player,i){
						if(PDV[i][Plays] == 3){
							if(GetPlayerTeam(i) == 1){
								t1++;
							}
							else if(GetPlayerTeam(i) == 2){
								t2++;
							}
						}
					}
					if(t1 == 0 && t2 == 0){
						OnWGed(-1);
					}
					else if(t1 == 0){
						OnWGed(1);
					}
					else{
						OnWGed(2);
					}
				}
			}else if(PDV[playerid][Plays] == 5 && GM[Smo] == -2){
				GM[pl][3]--; 
				if(GM[pl][3] <= 1){OnSmoEnd();}
			}						
			SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
			PDV[playerid][CorP] = 1;
			if(PDV[playerid][cID] != -1){
				DestroyVehicle(PDV[playerid][cID]);
				PDV[playerid][cID] = -1;
			}
			DesPHUD(playerid);
		}
		foreach(Player,i){
			if(PDV[i][APL] > 3){
				SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ddaaaa}%s:{aaffaa}%s",PDV[playerid][Nck],PDV[playerid][ipP]);
			}
		}
		foreach(new i : Privs){
			if(PCDV[i][pOid] == PDV[playerid][iDP]){
				UnLoadPrivC(i);
				break;
			}
		}
		return 1;}
	public OnPlayerText(playerid, text[]){
		if(!PDV[playerid][LogIn]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Oh nie zaloguj siê najpierw"); return 0;}
		if(PDV[playerid][ChSp] >= 4) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ffffff}Hej oszczêdzaj swoje rêce z tym pisaniem"); return 0;}
		if(PDV[playerid][CMT] > gettime()) {
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ffffff}Jesteœ zakneblowany wstydŸ siê!");
			foreach(Player,i){
				if(PDV[i][Wypociny]){
					SCM(i,-1,"{FF1111}MUTE:{FFFFFF}%s:%s",PDV[playerid][Nck],text);
				}
			}
			return 0;
		}
		if(PDV[playerid][APL] >= 1){
			if(strfind(text, "@", false, 0) == 0){
				foreach(Player,i){
					if(PDV[i][APL] >= 1){
						strdel(text, 0, 0);
						SCM(i,-1,"[@]%s:{cc0000}%s",PDV[playerid][Nck],text);
					}
				}
				return 0;
			}
		}
		switch(PDV[playerid][APL])
		{
			case 0:
			{
			if(PDV[playerid][VIP] == 1)
			{	SCMAS(-1,"|%i| {ffffff}({ffd700}VIP{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			else
			{	SCMA(-1,"|%i| {ffffff}({7c7c7c}G{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			}
			case 1:
			{	SCMAS(-1,"|%i| {ffffff}({006400}Support{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			case 2: 
			{	SCMAS(-1,"|%i| {ffffff}({32CD32}Mod{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			case 3: 
			{	SCMAS(-1,"|%i| {ffffff}({0000CD}@{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			case 4:
			{	SCMAS(-1,"|%i| {ffffff}({191970}S@{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			case 5: 
			{	SCMAS(-1,"|%i| {ffffff}({00ff00}Rcon{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
			case 6:
			{	SCMAS(-1,"|%i| {ffffff}({ff0000}Zarz¹d{ffffff}) {%06x}%s : {ffffff}%s",playerid,GetPlayerColor(playerid) >>> 8,GetPN(playerid),text);}
		}
		if(PDV[playerid][APL] <= 1){ PDV[playerid][ChSp]++;}
		return 0;}
	public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart){
		if(issuerid != INVALID_PLAYER_ID){
			if(PDV[playerid][BlDM]){
				new Float:F;
				GetPlayerHealth(issuerid,F);
				SetPlayerHealth(issuerid,F-33.4);
				GameTextForPlayer(issuerid,"Oof, nie wolno tego gracza biæ!",1000,3);
			}
			else {
				PDV[playerid][Btle] = GetTickCount()+15000;
			}
		}
		return 1;}
	public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart){
		if(playerid != INVALID_PLAYER_ID){
			PlayerPlaySound(playerid,17802,0.0,0.0,0.0);
		}
		return 1;}
	public OnVehicleDeath(vehicleid, killerid){
		foreach(Player,i){
		if(vehicleid == PDV[i][cID])
		{
			DestroyVehicle(PDV[i][cID]);
			PDV[i][cID] = -1;
		}}
		foreach(new i : Privs){
			if(vehicleid == PCDV[i][pveh]){
				DestroyVehicle(vehicleid);
				PCDV[i][pveh] = INVALID_VEHICLE_ID;
			}
		}
		return 1;}
	public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z){
		if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 50.0){
			return 0;
		}
		for(new i=0;i<18;i++){
			if(vehicleid == SVehs[i]){
				new Float:x,Float:y,Float:z,Float:an;
				GetVehiclePos(vehicleid, x,y,z);
				GetVehicleZAngle(vehicleid, an);
				SetVehicleZAngle(vehicleid,an);
				SetVehiclePos(vehicleid, x,y,z);
				return 0;
			}
		}
		return 1;}
	public OnPlayerPickUpDynamicPickup(playerid,pickupid){
		if(pickupid == GM[wal])
		{
			new r = random(20)+15;
			GiRe(playerid,r);
			new r2 = random(50000)+10000;
			GiPlMo(playerid,r2);
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz ID:%i Podniós³ walizke i znalaz³(a) w niej %i expa i %i$",playerid,r,r2);
			TextDrawHideForAll(waltxd);
			DestroyDynamicPickup(GM[wal]);
			return 1;
		}
		foreach(new i : SkI)
		{
			if(pickupid == PSku[i][2]){
				PDV[playerid][DeTa]++;
				GiRe(playerid,PSku[i][0]);
				GiPlMo(playerid,PSku[i][1]);
				DestroyDynamicPickup(PSku[i][2]);
				PSku[i][1] = 0;
				PSku[i][0] = 0;
				PSku[i][3] = 0;
				Iter_Remove(SkI, i);
				PlayerPlaySound(playerid, 1138,	0,0,0);
				return 1;
			}
		}
		foreach(new i : IHo){
			if(i == 0){}
			else{
			if(pickupid == HDV[i][hidP]){
				if(HDV[i][Bin]){
					new c = IPAH(playerid);
					if(HDV[c][Oid] == PDV[playerid][iDP]){
						Dialog_Show(playerid, DomMDO, DIALOG_STYLE_TABLIST, "Dom - {ff0000}Zajêty", "WejdŸ", "OK","Cofaj!");
					}else {
						Dialog_Show(playerid, DomMDO, DIALOG_STYLE_TABLIST, "Dom - {ff0000}Zajêty", "WejdŸ\nSpróbuj Obrobiæ\nPuk Puk", "OK","Cofaj!");
					}
				}else{
					Dialog_Show(playerid, DomMD, DIALOG_STYLE_TABLIST, "Dom - {00ff00}NieZajêty", "Zwiedzaj\nKup","OK","Cofaj!");
				}
				return 1;
			}}
		}
		if(PDV[playerid][Plays] == 1){
			new i;
			for(i=0;i<47;i++)
			{
				if(pickupid == wyWeap[i]){
					if(i < 47){DestroyDynamicPickup(wyWeap[i]);}
					GivePlayerWeapon(playerid, random(12)+22, random(60)+4);
					break;
				}
			}
			for(i=0;i<2;i++)
			{
				if(pickupid == wyHP[i]){
					DestroyDynamicPickup(wyHP[i]);
					SetPlayerHealth(playerid, 100.0);
					break;
				}
			}
			for(i=0;i<3;i++)
			{
				if(pickupid == wyKam[i]){
					if(i != 0){DestroyDynamicPickup(wyKam[i]);}
					SetPlayerArmour(playerid, 100.0);
					break;
				}
			}
		}
		return 1;}
	public OnPlayerClickTextDraw(playerid, Text:clickedid){
		if(_:clickedid != INVALID_TEXT_DRAW){
			if(clickedid == LogOnS[8]){
				TextDrawHideForPlayer(playerid,LogOnS[2]);
				TextDrawHideForPlayer(playerid,LogOnS[3]);
				TextDrawHideForPlayer(playerid,LogOnS[4]);
				TextDrawHideForPlayer(playerid,LogOnS[5]);
				TextDrawHideForPlayer(playerid,LogOnS[6]);
				TextDrawHideForPlayer(playerid,LogOnS[7]);
				TextDrawHideForPlayer(playerid,LogOnS[8]);
				TextDrawHideForPlayer(playerid,LogOnS[9]);
				TextDrawHideForPlayer(playerid,LogOnS[10]);
				TextDrawHideForPlayer(playerid,LogOnS[11]);
				TextDrawHideForPlayer(playerid,LogOnS[12]);
				TextDrawHideForPlayer(playerid,LogOnS[13]);
				CancelSelectTextDraw(playerid);
				Regulamin(playerid);
			}
			if(clickedid == LogOnS[7]){
				if(PDV[playerid][NoAcc]){
					TextDrawHideForPlayer(playerid,LogOnS[2]);
					TextDrawHideForPlayer(playerid,LogOnS[3]);
					TextDrawHideForPlayer(playerid,LogOnS[4]);
					TextDrawHideForPlayer(playerid,LogOnS[5]);
					TextDrawHideForPlayer(playerid,LogOnS[6]);
					TextDrawHideForPlayer(playerid,LogOnS[7]);
					TextDrawHideForPlayer(playerid,LogOnS[8]);
					TextDrawHideForPlayer(playerid,LogOnS[9]);
					TextDrawHideForPlayer(playerid,LogOnS[10]);
					TextDrawHideForPlayer(playerid,LogOnS[11]);
					TextDrawHideForPlayer(playerid,LogOnS[12]);
					TextDrawHideForPlayer(playerid,LogOnS[13]);
					CancelSelectTextDraw(playerid);
					Dialog_Show(playerid, Register, DIALOG_STYLE_PASSWORD, "Rejestracja", "Zarejestruj siê by mieæ pe³ne mo¿liwoœci korzystania z\nnaszego serwera", "Zarejestruj","Wyjdz");
				}
				else{
					TextDrawHideForPlayer(playerid,LogOnS[2]);
					TextDrawHideForPlayer(playerid,LogOnS[3]);
					TextDrawHideForPlayer(playerid,LogOnS[4]);
					TextDrawHideForPlayer(playerid,LogOnS[5]);
					TextDrawHideForPlayer(playerid,LogOnS[6]);
					TextDrawHideForPlayer(playerid,LogOnS[7]);
					TextDrawHideForPlayer(playerid,LogOnS[8]);
					TextDrawHideForPlayer(playerid,LogOnS[9]);
					TextDrawHideForPlayer(playerid,LogOnS[10]);
					TextDrawHideForPlayer(playerid,LogOnS[11]);
					TextDrawHideForPlayer(playerid,LogOnS[12]);
					TextDrawHideForPlayer(playerid,LogOnS[13]);
					CancelSelectTextDraw(playerid);
					Dialog_Show(playerid,LogIn, DIALOG_STYLE_PASSWORD,"Logowanie","Zaloguj siê by potwierdziæ swoj¹ to¿samoœæ","Zaloguj","Wyjdz");
				}
				return 1;
			}
			if(clickedid == LogOnS[9]){
				TextDrawHideForPlayer(playerid,LogOnS[2]);
				TextDrawHideForPlayer(playerid,LogOnS[3]);
				TextDrawHideForPlayer(playerid,LogOnS[4]);
				TextDrawHideForPlayer(playerid,LogOnS[5]);
				TextDrawHideForPlayer(playerid,LogOnS[6]);
				TextDrawHideForPlayer(playerid,LogOnS[7]);
				TextDrawHideForPlayer(playerid,LogOnS[8]);
				TextDrawHideForPlayer(playerid,LogOnS[9]);
				TextDrawHideForPlayer(playerid,LogOnS[10]);
				TextDrawHideForPlayer(playerid,LogOnS[11]);
				TextDrawHideForPlayer(playerid,LogOnS[12]);
				TextDrawHideForPlayer(playerid,LogOnS[13]);
				CancelSelectTextDraw(playerid);
				Kontakt(playerid);
			}
			if(clickedid == LogOnS[12]){
				TextDrawHideForPlayer(playerid,LogOnS[2]);
				TextDrawHideForPlayer(playerid,LogOnS[3]);
				TextDrawHideForPlayer(playerid,LogOnS[4]);
				TextDrawHideForPlayer(playerid,LogOnS[5]);
				TextDrawHideForPlayer(playerid,LogOnS[6]);
				TextDrawHideForPlayer(playerid,LogOnS[7]);
				TextDrawHideForPlayer(playerid,LogOnS[8]);
				TextDrawHideForPlayer(playerid,LogOnS[9]);
				TextDrawHideForPlayer(playerid,LogOnS[10]);
				TextDrawHideForPlayer(playerid,LogOnS[11]);
				TextDrawHideForPlayer(playerid,LogOnS[12]);
				TextDrawHideForPlayer(playerid,LogOnS[13]);
				CancelSelectTextDraw(playerid);
				Autor(playerid);
			}
			if(clickedid == LogOnS[13]){
				TextDrawHideForPlayer(playerid,LogOnS[2]);
				TextDrawHideForPlayer(playerid,LogOnS[3]);
				TextDrawHideForPlayer(playerid,LogOnS[4]);
				TextDrawHideForPlayer(playerid,LogOnS[5]);
				TextDrawHideForPlayer(playerid,LogOnS[6]);
				TextDrawHideForPlayer(playerid,LogOnS[7]);
				TextDrawHideForPlayer(playerid,LogOnS[8]);
				TextDrawHideForPlayer(playerid,LogOnS[9]);
				TextDrawHideForPlayer(playerid,LogOnS[10]);
				TextDrawHideForPlayer(playerid,LogOnS[11]);
				TextDrawHideForPlayer(playerid,LogOnS[12]);
				TextDrawHideForPlayer(playerid,LogOnS[13]);
				CancelSelectTextDraw(playerid);
				TogglePlayerSpectating(playerid, 0);
				PDV[playerid][ToKick] = true;
			}
		}
		return 1;}
	public OnPlayerCommandReceived(playerid,cmd[],params[],flags){
		if(!PDV[playerid][LogIn]){
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Oh nie zaloguj siê najpierw");
			return 0;
		}
		if(PDV[playerid][APL] < 6){
			if(PDV[playerid][BlCMD]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{ffffff} Zablokowano ci CMD o jakie przykre :C"); return 1;}
			if(PDV[playerid][Wat] != -1 && strcmp(cmd,"czsolo",true) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Jestes na solówce mo¿esz u¿ywaæ tylko /czsolo"); return 1;}
			if(PDV[playerid][CmU] >= 5) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Woah wstrzymaj konie kowboju z tymi CMD"); return 0;}
			if((strcmp(cmd,"opusc",true) != 0 && strcmp(cmd,"exit",true) != 0) && PDV[playerid][Arena] >= 1){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Mozesz u¿yæ tylko cmd /opusc i /exit by wyjœæ");
				return 0;
			}
			if((strcmp(cmd,"opusc",true) != 0 && strcmp(cmd,"exit",true) != 0) && PDV[playerid][Plays] == 1 && GM[wyp] == -2){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Mozesz u¿yæ tylko cmd /opusc i /exit by wyjœæ");
				return 0;
			}
			else if((strcmp(cmd,"opusc",true) != 0 && strcmp(cmd,"exit",true) != 0) && PDV[playerid][Plays] == 2 && GM[drby] == -2){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Mozesz u¿yæ tylko cmd /opusc i /exit by wyjœæ");
				return 0;
			}
			else if((strcmp(cmd,"opusc",true) != 0 && strcmp(cmd,"exit",true) != 0) && PDV[playerid][Plays] == 3 && GM[wgs] == -2){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Mozesz u¿yæ tylko cmd /opusc i /exit by wyjœæ");
				return 0;
			}
			if(PDV[playerid][zw] && strcmp(cmd,"jj",true)){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{ffffff} U¿yj:/jj by wróciæ z afk");
				return 0;
			}
			if(PDV[playerid][Dying]){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{ffffff} Aktualnie umierasz prosimy czekaæ . . . . . . . . ");
				return 0;
			}
		}
		return 1;}
	public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags) {
		if(result == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taka Komenda nie istnieje"); return 0;}
		else {
			PDV[playerid][CmU]++;
		}
		return 1;}
	public OnPlayerStateChange(playerid, newstate, oldstate){
		new vehicleid = GetPlayerVehicleID(playerid);
		if(newstate == 2){
			PlayerTextDrawShow(playerid, PTD[10][playerid]);
			foreach(new i : Privs){
				if(vehicleid == PCDV[i][pveh]){
					if(PDV[playerid][iDP] != PCDV[i][pOid]){
						RemovePlayerFromVehicle(playerid);
						break;
					}
				}
			}
			/*for(new i=0,x=sizeof(SVehs);i<x;i++){
				if(vehicleid == SVehs[i]){
					Dialog_Show(playerid, PrivBD, DIALOG_STYLE_LIST, "Salon - Kup Auto", "{00ff00}Informacje\n{ffffff}Kup\nWeŸ na raty", "Wybierz", "Nie");
					break;
				}
			}*/
		}
		else if(newstate == 3){
			foreach(new i : Privs){
				if(vehicleid == PCDV[i][pveh]){
					if(PDV[playerid][iDP] != PCDV[i][pOid] && GetPlayerVehicleSeat(playerid) == 0){
						RemovePlayerFromVehicle(playerid);
						break;
					}
				}
			}
		}
		else if(newstate == 2 || newstate == 3){
			foreach(Player,i){
				if(IsPlayerConnected(i)){
					if(PDV[i][Spect] == playerid){
						new vehid = GetPlayerVehicleID(playerid);
						PlayerSpectateVehicle(i, vehid, SPECTATE_MODE_NORMAL);
					}
				}
			}
		}
		else if(newstate == 1 || newstate == 8){
			PlayerTextDrawShow(playerid, PTD[10][playerid]);
			foreach(Player,i){
				if(IsPlayerConnected(i)){
					if(PDV[i][Spect] == playerid){
						PlayerSpectatePlayer(i, playerid, SPECTATE_MODE_NORMAL);
					}
				}
			}
		}
		return 1;}
	public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
		if(PDV[playerid][Spect] != -1){
			if(newkeys & KEY_FIRE){
				c:
				PDV[playerid][Spect]++;
				t:
				if(!IsPlayerConnected(PDV[playerid][Spect])){
					if(PDV[playerid][Spect] > GetPlayerPoolSize()){
						PDV[playerid][Spect] = 0;
						goto t;
					}
					goto c;
				}
				if(GetPlayerVehicleSeat(PDV[playerid][Spect]) == -1){
					SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PDV[playerid][Spect]));
					SetPlayerInterior(playerid, GetPlayerInterior(PDV[playerid][Spect]));
					PlayerSpectatePlayer(playerid, PDV[playerid][Spect], SPECTATE_MODE_NORMAL);
				}else{
					SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PDV[playerid][Spect]));
					SetPlayerInterior(playerid, GetPlayerInterior(PDV[playerid][Spect]));
					new vehid = GetPlayerVehicleID(PDV[playerid][Spect]);
					PlayerSpectateVehicle(playerid, vehid, SPECTATE_MODE_NORMAL);
				}
				return 1;
			}
		}
		if(GetPlayerVehicleSeat(playerid) == 0)
		{
			if((((newkeys & (KEY_FIRE)) != (KEY_FIRE)) && ((oldkeys & (KEY_FIRE)) == (KEY_FIRE))))
			{
				new vehid = GetPlayerVehicleID(playerid);
				RemoveVehicleComponent(vehid, 1010);
			}
			else if(newkeys & (KEY_FIRE))
			{
				new vehid = GetPlayerVehicleID(playerid);
				AddVehicleComponent(vehid, 1010);
			}
			else if(newkeys & KEY_SUBMISSION)
			{
				callcmd::repair(playerid,"");
			}
			else if(newkeys & KEY_YES){
				callcmd::flip(playerid,"");
			}
		}
		return 1;}
	public OnRconLoginAttempt(ip[], password[], success){
		foreach(Player,i)
		{
			new ip2[18];
			GetPlayerIp(i, ip2, 16);
			if(!strcmp(ip2,ip)){
				if(PDV[i][APL] >= 5){
					if(!success)
					{
						BP(i,"B³êdne Has³o RCON",INVALID_PLAYER_ID);
						return 0;
					}
					else {return 1;}
				}
				else {
					KP(i,"Nieautoryzowane logowanie na RCON",INVALID_PLAYER_ID);
					return 0;
				}
				
			}
		}
		return 0;}
	public OnPlayerEnterDynamicArea(playerid,areaid){
		if(PDV[playerid][Arena] == 4 && areaid == MiniZ[0]){
			PDV[playerid][MinIn] = -1;
		}
		else if(areaid == WGZ[0] && PDV[playerid][Plays] == 3 && GetPlayerInterior(playerid) != 3 && GM[wgs] == -2){
			PDV[playerid][WGIn] = -1;	
		}
		else if(PDV[playerid][gSpar]){
			new l;
			if(GDV[PDV[playerid][IGid]][sprT] == -1){
				l = GDV[PDV[playerid][IGid]][SprW];
			}
			if(GDV[l][sprzone] == areaid){
				GameTextForPlayer(playerid, "~g~~h~~h~Powrociles do gry", 1500, 3);
				PDV[playerid][SetF] = 0;
				PDV[playerid][nCtD] = 0;
			}
		}else{
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
		}
		return 1;}
	public OnPlayerLeaveDynamicArea(playerid, areaid){
		if(PDV[playerid][Arena] == 4 && areaid == MiniZ[0]){
			GameTextForPlayer(playerid, "~r~~h~~h~Masz 4 sekundy na powrót do strefy gry", 2000, 4);
			PDV[playerid][MinIn] = GetTickCount()+4000;
		}
		else if(areaid == WGZ[0] && PDV[playerid][Plays] == 3 && GetPlayerInterior(playerid) != 3 && GM[wgs] == -2){
			GameTextForPlayer(playerid, "~r~~h~~h~Masz 4 sekundy na powrót do strefy gry", 2000, 4);
			PDV[playerid][WGIn] = GetTickCount()+4000;	
		}else{
			foreach(new x : aZones){
				if(GZDV[x][GZZone] == areaid){
					if(GZDV[x][GZWar] != -1){
						GZDV[x][GZWar]--;
					}
				}else if(PDV[playerid][IGid] == GZDV[x][GZoid]){
					GZDV[x][GZWar2]--;
				}
			}
		}
		return 1;}
	public OnPlayerClickPlayer(playerid, clickedplayerid, source){
		if(!PDV[clickedplayerid][LogIn]){return 1;}
		new str[3500];
		strcat(str,"{565656}********{afffd4}Statystyki Gracza{565656}********\n",3500);
		new str2[150];
		format(str2,sizeof(str2),"\t{ffffff}iDP:{565656}%i        \n",PDV[clickedplayerid][iDP]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Nick:{565656}%s        \n",PDV[clickedplayerid][Nck]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Gang:{565656}%s        \n",GDV[PDV[clickedplayerid][IGid]][gName]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Totalny Czas pobytu:{565656}%ih%imin        \n",(PDV[clickedplayerid][TotOnl]+(NetStats_GetConnectedTime(clickedplayerid)/1000)) / 3600,((PDV[clickedplayerid][TotOnl]+(NetStats_GetConnectedTime(clickedplayerid)/1000)) / 60) - (((PDV[clickedplayerid][TotOnl]+(NetStats_GetConnectedTime(clickedplayerid)/1000)) / 3600) * 60));
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Wejœcia na serwer:{565656}%i        \n\n\n");
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Iloœæ Achievementów:{565656}%i/67        \n",PDV[clickedplayerid][AchievC]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Iloœæ Czaszek:{565656}%i        \n",PDV[clickedplayerid][DeTa]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Respekt Gangu:{565656}%i        \n",GDV[PDV[clickedplayerid][IGid]][gRspkt]);
		strcat(str,str2,3500);

		format(str2,sizeof(str2),"\t{ffffff}Zabójstwa:{565656}%i        \n",PDV[clickedplayerid][Ki]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Œmierci:{565656}%i        \n",PDV[clickedplayerid][De]);
		strcat(str,str2,3500);
		if(PDV[clickedplayerid][Ki] != 0 && PDV[clickedplayerid][De] != 0){
			format(str2,sizeof(str2),"\t{ffffff}KD Ratio:{565656}%.2f        \n",PDV[clickedplayerid][Ki]/PDV[clickedplayerid][De]);
			strcat(str,str2,3500);
		}else{
			format(str2,sizeof(str2),"\t{ffffff}KD Ratio:{565656}Brak        \n");
			strcat(str,str2,3500);
		}
		//kurwa daj tutaj "odwiedziny"-wejscie na serwer ilosc, "Odznaczenie" poprzez cmd zarz¹d moze daæ odznaczenie typu Maskotka Serwera
		//Ilosc czaszek, Doœwiadczenie, [Tag]Nazwa Gangu, osiagniecia 0/X (x-nie wiemy czy jeszcze ich dojdzie) 
		//to co tu masz napisane dodaj, a nie te gowienka o pompie, onede, mini, i wywal przegrane solowki bo tym to sie raczej nikt nie chwali XD
		//Chuj mnie to ~Korwin
		format(str2,sizeof(str2),"\t{ffffff}Warny:{565656}%i|3        \n\n",PDV[clickedplayerid][wrn]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Wygrane Solówki:{565656}%i        \n",PDV[clickedplayerid][SKi]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Zabójstw na Onede:{565656}%i        \n",PDV[clickedplayerid][OKi]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Zabójstw Na Pompie:{565656}        %i\n",PDV[clickedplayerid][PKi]);
		strcat(str,str2,3500);
		format(str2,sizeof(str2),"\t{ffffff}Zabójstw Na Mini:{565656}%i        \n",PDV[clickedplayerid][MKi]);
		strcat(str,str2,3500);
		if(PDV[clickedplayerid][VIP]){
		strcat(str,"\t{ffdd22}VIP:{565656}Tak        \n",3500);}else {
		strcat(str,"\t{ffdd22}VIP:{565656}Nie        \n",3500);}
		Dialog_Show(playerid,Stat,DIALOG_STYLE_MSGBOX,"Statystyki Gracza",str,"OK","OK");	
		return 1;}
//Functions For Query
	forward GetGDat(gid);
	public GetGDat(gid){
		if(Iter_Contains(GTHC, gid)){print("ERROR: zid alerady exists"); return 1;}
		if(cache_num_rows() == 1){
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
	forward GetZDat(zid);
	public GetZDat(zid){
		if(Iter_Contains(aZones, zid)){print("ERROR: zid alerady exists"); return 1;}
		if(cache_num_rows() == 1){
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
			GZDV[zid][GZCas0] = 0;
			GZDV[zid][GZCas1] = 0;
			GZDV[zid][GZWWG] = -1;
			GZDV[zid][GZTis] = -1;
			GZDV[zid][GZGang] = GangZoneCreate(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
			GZDV[zid][GZZone] = CreateDynamicRectangle(GZDV[zid][GZPos][0],GZDV[zid][GZPos][1],GZDV[zid][GZPos][2],GZDV[zid][GZPos][3]);
		}else {
			printf("ERROR: zid of id:%i doesn't exist",zid);
		}
		return 1;
	}
	forward SetIstP(iDp,mo,cxp);
	public SetIstP(iDp,mo,cxp){
		if(cache_num_rows() == 1){
			new moneyp,xpp;
			cache_get_value_index_int(0, 0, moneyp);
			cache_get_value_index_int(0, 1, xpp);
			new quer[50];
			if(moneyp < mo || xpp < cxp){
				foreach(new i : Privs){
					if(PCDV[i][pOid] == iDp){
						Iter_Remove(Privs, i);
						PCDV[i][Komornik] = true;
						DestroyVehicle(PCDV[i][pveh]);
						DestroyDynamic3DTextLabel(PCDV[i][pc3d]);
						mysql_format(DBM, quer, sizeof(quer),"UPDATE `plys` SET `Kmrnik`='1' WHERE `id`='%i'",iDp);
						mysql_query(DBM,quer,false);
						break;
					}
				}
			}
			else {
				moneyp -= mo;
				xpp -= cxp;
				mysql_format(DBM,quer,sizeof(quer),"UPDATE `plys` SET `rsp`='%i',`csh`='%i' WHERE `id`='%i'",moneyp,xpp,iDp);
				mysql_query(DBM,quer,false);
			}
		}
		return 1;
	}
	forward GetGMDat();
	public GetGMDat(){
		if(cache_num_rows() == 1){
			new DRrR;
			cache_get_value_index_int(0,0,DRrR);
			new d;
			getdate(d, d, d);
			if(DRrR != d){
				GM[Yas] = true;
				new qu[32];
				mysql_format(DBM, qu, sizeof(qu),"UPDATE `GM` SET `DR`='%i'", d);
				mysql_query(DBM,qu,false);
			}
		}
		return 1;
	}
	forward GetPCDat();
	public GetPCDat(){
		if(cache_num_rows() == 1){
			new cidp = Iter_Free(Privs);
			Iter_Add(Privs, cidp);
			new Float:x,Float:y,Float:z,Float:ang;
			cache_get_value_index_int(0, 0, PCDV[cidp][pcidp]);
			cache_get_value_index_int(0, 1, PCDV[cidp][PCcolor][0]);
			cache_get_value_index_int(0, 2, PCDV[cidp][PCcolor][1]);
			cache_get_value_index(0, 3,PCDV[cidp][PJB]);
			cache_get_value_index(0, 4,PCDV[cidp][pccomp],75);
			cache_get_value_index_int(0, 5, PCDV[cidp][PCN]);
			cache_get_value_index_int(0, 6, PCDV[cidp][pOid]);
			cache_get_value_index_float(0, 7, x);
			cache_get_value_index_float(0, 8, y);
			cache_get_value_index_float(0, 9, z);
			cache_get_value_index_float(0, 10, ang);
			cache_get_value_index_int(0, 11, PCDV[cidp][pcmodel]);
			cache_get_value_index_int(0, 12, PCDV[cidp][pcmoc]);
			cache_get_value_index_int(0, 13, PCDV[cidp][pcexpc]);
			cache_get_value_index_float(0, 14, PCDV[cidp][przebieg]);
			PCDV[cidp][pveh] = CreateVehicle(PCDV[cidp][pcmodel], x,y,z, ang, PCDV[cidp][PCcolor][0],PCDV[cidp][PCcolor][1], -1);
			new comp[14];
			sscanf(PCDV[cidp][pccomp],"p<,>iiiiiiiiiiiiii",comp[0],comp[1],comp[2],comp[3],comp[4],comp[5],comp[6],comp[7],comp[8],comp[9],comp[10],comp[11],comp[12],comp[13]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[0]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[1]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[2]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[3]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[4]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[5]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[6]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[7]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[8]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[9]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[10]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[11]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[12]);
			AddVehicleComponent(PCDV[cidp][pveh], comp[13]);
			ChangeVehiclePaintjob(PCDV[cidp][pveh], PCDV[cidp][PJB]);
			new str[156];
			switch(PCDV[cidp][pOid]){
				case -1:{
					format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}Do Kupienia\nExp:{aaffc6}%i\n{ffffff}Pieni¹dze:{fff0aa}%i\n{ffffff}ID:%i",PCDV[cidp][pcexpc],PCDV[cidp][pcmoc],PCDV[cidp][pcidp]);
				}
				default:{
					foreach(Player,i){
						if(PDV[i][iDP] == PCDV[cidp][pOid]){
							PDV[i][OwOfP] = cidp;
							strcat(PCDV[cidp][pcONi],PDV[i][Nck],24);
							break;
						}
					}	
					format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}W³aœciciel:%s\nPrzebieg:%i\nID:%i",PCDV[cidp][pcONi],floatround(PCDV[cidp][przebieg],floatround_round),PCDV[cidp][pcidp]);
				}
			}
			PCDV[cidp][pc3d] = CreateDynamic3DTextLabel(str, -1, 0.0,0.0,0.0,20.0, INVALID_PLAYER_ID, PCDV[cidp][pveh]);
			new bool:b;
			foreach(Player,i){
				if(PDV[i][iDP] == PCDV[cidp][pOid]){
					b = true;
					PDV[i][pvidp] = cidp;
				}
			}
			if(!b){
				UnLoadPrivC(cidp);
			}
		}else{}

		return 1;
	}
	forward GetPDat(pid);
	public GetPDat(pid){
		if(cache_num_rows() == 1)
		{
			new str[250];
			cache_get_value_index_int(0, 0, PDV[pid][iDP]);
			cache_get_value_index(0, 1, PDV[pid][Nck],25);
			cache_get_value_index_int(0, 2, PDV[pid][Csh]);
			cache_get_value_index_int(0, 3, PDV[pid][Rsp]);
			cache_get_value_index_int(0, 4, PDV[pid][Ki]);
			cache_get_value_index_int(0, 5, PDV[pid][De]);
			cache_get_value_index_int(0, 6, PDV[pid][DeTa]);
			cache_get_value_index(0, 7, PDV[pid][pass],65);
			cache_get_value_index(0, 8, PDV[pid][slt],11);
			cache_get_value_index_int(0, 9, PDV[pid][nAPL]);
			cache_get_value_index(0, 10, PDV[pid][AdP],45);
			cache_get_value_index_int(0, 11, PDV[pid][Ba]);
			cache_get_value_index_int(0, 12, PDV[pid][BaT]);
			cache_get_value_index(0, 13, PDV[pid][BaR],48);
			cache_get_value_index_int(0, 14, PDV[pid][CMT]);
			cache_get_value_index_int(0, 15, PDV[pid][JaT]);
			cache_get_value_index(0, 16, PDV[pid][JaTR],48);
			cache_get_value_index_int(0, 17, PDV[pid][PSk]);
			cache_get_value_index_bool(0, 18, PDV[pid][TkD]);
			cache_get_value_index_int(0, 19, PDV[pid][SKi]);
			cache_get_value_index_int(0, 20, PDV[pid][SDe]);
			cache_get_value_index_int(0, 21, PDV[pid][OwOf]);
			cache_get_value_index_int(0, 22, PDV[pid][Bounty][1]);
			cache_get_value_index_int(0, 23, PDV[pid][Bounty][0]);
			cache_get_value_index_int(0, 24, PDV[pid][wrn]);
			cache_get_value_index_bool(0, 25, PDV[pid][kmrnik]);
			cache_get_value_index(0, 26, str,sizeof(str));
			cache_get_value_index_int(0, 27, PDV[pid][OKi]);
			cache_get_value_index_int(0, 28, PDV[pid][ODe]);
			cache_get_value_index_int(0, 29, PDV[pid][PKi]);
			cache_get_value_index_int(0, 30, PDV[pid][PDe]);
			cache_get_value_index_int(0, 31, PDV[pid][MKi]);
			cache_get_value_index_int(0, 32, PDV[pid][MDe]);
			cache_get_value_index_int(0, 32, PDV[pid][MDe]);
			cache_get_value_index_int(0, 32, PDV[pid][MDe]);
			cache_get_value_index_int(0, 33, PDV[pid][SpKi]);
			cache_get_value_index_int(0, 34, PDV[pid][SpDe]);
			cache_get_value_index_int(0, 35, PDV[pid][TotOnl]);
			cache_get_value_index_int(0, 36, PDV[pid][pcolo]);
			cache_get_value_index_int(0, 37, PDV[pid][last_ip]);
			cache_get_value_index_int(0, 38, PDV[pid][last_gpci]);
			cache_get_value_index_int(0, 39, PDV[pid][GPid]);
			cache_get_value_index_int(0, 40, PDV[pid][IGid]);
			sscanf(str,"p<,>lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll",PDV[pid][Achiev][0],PDV[pid][Achiev][1],PDV[pid][Achiev][2],PDV[pid][Achiev][3],PDV[pid][Achiev][4],PDV[pid][Achiev][5],PDV[pid][Achiev][6],PDV[pid][Achiev][7],PDV[pid][Achiev][8],PDV[pid][Achiev][9],PDV[pid][Achiev][10],PDV[pid][Achiev][11],PDV[pid][Achiev][12],PDV[pid][Achiev][13],PDV[pid][Achiev][14],PDV[pid][Achiev][15],PDV[pid][Achiev][16],PDV[pid][Achiev][17],PDV[pid][Achiev][18],
				PDV[pid][Achiev][19],PDV[pid][Achiev][20],PDV[pid][Achiev][21],PDV[pid][Achiev][22],PDV[pid][Achiev][23],PDV[pid][Achiev][24],PDV[pid][Achiev][25],PDV[pid][Achiev][26],PDV[pid][Achiev][27],PDV[pid][Achiev][28],PDV[pid][Achiev][29],PDV[pid][Achiev][30],PDV[pid][Achiev][31],
				PDV[pid][Achiev][32],PDV[pid][Achiev][33],PDV[pid][Achiev][34],PDV[pid][Achiev][35],PDV[pid][Achiev][36],PDV[pid][Achiev][37],PDV[pid][Achiev][38],PDV[pid][Achiev][39],PDV[pid][Achiev][40],PDV[pid][Achiev][41],PDV[pid][Achiev][42],PDV[pid][Achiev][43],PDV[pid][Achiev][44],
				PDV[pid][Achiev][45],PDV[pid][Achiev][46],PDV[pid][Achiev][47],PDV[pid][Achiev][48],PDV[pid][Achiev][49],PDV[pid][Achiev][50],PDV[pid][Achiev][51],PDV[pid][Achiev][52],PDV[pid][Achiev][53],
				PDV[pid][Achiev][54],PDV[pid][Achiev][55],PDV[pid][Achiev][56],PDV[pid][Achiev][57],PDV[pid][Achiev][58],PDV[pid][Achiev][59],PDV[pid][Achiev][60],PDV[pid][Achiev][61],PDV[pid][Achiev][62],PDV[pid][Achiev][63],PDV[pid][Achiev][64],PDV[pid][Achiev][65],PDV[pid][Achiev][66]);
		}
		else {
			PDV[pid][NoAcc] = true;
			return PlayerPlaySound(pid, 1147, 0.0,0.0,0.0);
		}
		if(PDV[pid][Ba] >= 1) {
			ShB(pid);
			PDV[pid][ToKick] = true;
			return 1;
		}
		CreatePrivCar(PDV[pid][iDP]);
		return 1;
	}
	stock hElemCr(Hid){
		if(HDV[Hid][Bin]){
			new str[256];
			mysql_format(DBM,str,sizeof(str),"SELECT `nck` FROM `plys` WHERE `id`='%i'",HDV[Hid][Oid]);
			new Cache:res = mysql_query(DBM, str, true);
			cache_get_value_index(0,0,HDV[Hid][ONck],24);
			cache_delete(res);
			format(str,sizeof(str),"{ff0000}Zajete\n{56ff56}Posiad³oœæ:{ffffff}%s\n{56ff56}Wlasciciel:{ffffff}%s\n{56ff56}Interior:{ffffff}%i\nID:%i",HDV[Hid][estanam],HDV[Hid][ONck],HDV[Hid][Iid],HDV[Hid][hID]);
			HDV[Hid][hidP] = CreateDynamicPickup(1272, 1, HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP], 0, 0);
			HDV[Hid][hidMI] = CreateDynamicMapIcon(HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP], 32, 0);
			HDV[Hid][hid3D] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP],15.0);
		}
		else{
			HDV[Hid][hidP] = CreateDynamicPickup(1273, 1, HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP], 0, 0);
			HDV[Hid][hidMI] = CreateDynamicMapIcon(HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP], 31, 0);
			new str[256];
			format(str,sizeof(str),"{00ff00}NA SPRZEDAZ!\n{56ff56}Dom:{ffffff}%s\n{56ff56}Czynsz:{ffffff}%i{00aa00}${ffffff}/%i{ffaaaa}Exp\n{56ff56}Interior:{ffffff}%i\nID:%i",HDV[Hid][estanam],HDV[Hid][MoP],HDV[Hid][ExP],HDV[Hid][Iid],HDV[Hid][hID]);
			HDV[Hid][hid3D] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP],15.0);
		}
		return 1;
	}
	forward GetHDat(Hid);
	public GetHDat(Hid){
		if(cache_num_rows() == 1){
			cache_get_value_index_int(0,0,HDV[Hid][hID]);
			cache_get_value_index(0,1,HDV[Hid][estanam],24);
			cache_get_value_index_float(0,2,HDV[Hid][XP]);
			cache_get_value_index_float(0,3,HDV[Hid][YP]);
			cache_get_value_index_float(0,4,HDV[Hid][ZP]);
			cache_get_value_index_int(0,5,HDV[Hid][Iid]);
			cache_get_value_index_int(0,6,HDV[Hid][Oid]);
			cache_get_value_index_bool(0,7,HDV[Hid][Bin]);
			cache_get_value_index(0,8,HDV[Hid][hpass],24);
			cache_get_value_index_int(0,9,HDV[Hid][ExP]);
			cache_get_value_index_int(0,10,HDV[Hid][MoP]);
			cache_get_value_index_bool(0,11,HDV[Hid][Lck]);
			cache_get_value_index_int(0,12,HDV[Hid][moni]);
			cache_get_value_index_int(0,13,HDV[Hid][expi]);
			cache_get_value_index_int(0,14,HDV[Hid][Security]);
			Iter_Add(IHo,HDV[Hid][hID]);
			hElemCr(Hid);
		}
		else {return 0;}
		return 1;
	}
//It's PayDay Fellas!
	stock DeOwnH(hous){
		new quer[188];
		foreach(Player,i){
			if(PDV[i][OwOf] == hous){
				GiRe(i,HDV[hous][expi]);
				GiPlMo(i,HDV[hous][moni]);
				HDV[hous][expi] = 0;
				HDV[hous][moni] = 0;
				HDV[hous][Bin] = false;
				HDV[hous][Oid] = -1;
				HDV[hous][ONck][23] = EOS;
				PDV[i][OwOf] = -1;
				mysql_format(DBM, quer, sizeof(quer), "UPDATE `HoS` SET `Bin`='1',`Oid`='-1',`expi`='0',`moi`='0' WHERE `id`='%i'",HDV[hous][hID]);
				mq(quer);
				SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie op³aca³eœ domu i Komornik ci go zabra³");
				return 1;
			}
		}
		mysql_format(DBM, quer,sizeof(quer), "UPDATE `plys` SET `csh`='csh + %i',`rsp`='rsp + %i',`OwOf`='-1' WHERE `id`='%i'",HDV[hous][expi],HDV[hous][moni]);		
		mq(quer);
		HDV[hous][expi] = 0;
		HDV[hous][moni] = 0;
		HDV[hous][Bin] = false;
		HDV[hous][Oid] = -1;
		HDV[hous][ONck][23] = EOS;
		mysql_format(DBM, quer, sizeof(quer), "UPDATE `HoS` SET `Bin`='1',`Oid`='-1',`expi`='0',`moi`='0' WHERE `id`='%i'",HDV[hous][hID]);
		mq(quer);
		return 1;
	}
//Domy
	stock IPAH(pid){
		foreach(new i : IHo){
			if(i == 0){}
			else{
			if(IsPlayerInRangeOfPoint(pid, 2.0, HDV[i][XP],HDV[i][YP],HDV[i][ZP])){
			return i;
			}}
		}
		return -1;
	}
	stock AddHous(pid,Inter,prey,pcshy,estatename[24]){
		new ite = Iter_Free(IHo);
		GetPlayerPos(pid, HDV[ite][XP],HDV[ite][YP],HDV[ite][ZP]);
		new quer[150];
		mysql_format(DBM,quer,150,"INSERT INTO `HoS`(`XP`,`YP`,`ZP`,`Iid`,`pre`,`pcsh`,`id`,`Estate`) VALUES ('%f','%f','%f','%i','%i','%i','%i','%s')",HDV[ite][XP],HDV[ite][YP],HDV[ite][ZP],Inter,prey,pcshy,ite,estatename);
		mq(quer);
		HDV[ite][hID] = ite;
		HDV[ite][Iid] = Inter;
		HDV[ite][Oid] = -1;
		HDV[ite][Bin] = false;
		HDV[ite][hpass][23] = EOS;
		HDV[ite][ExP] = prey;
		HDV[ite][MoP] = pcshy;
		strcat(HDV[ite][estanam], estatename, 24);
		Iter_Add(IHo, ite);
		HDV[ite][hidP] = CreateDynamicPickup(1273, 1, HDV[ite][XP],HDV[ite][YP],HDV[ite][ZP], 0, 0);
		HDV[ite][hidMI] = CreateDynamicMapIcon(HDV[ite][XP],HDV[ite][YP],HDV[ite][ZP], 31, 0);
		new str[256];
		format(str,sizeof(str),"{00ff00}NA SPRZEDAZ!\n{56ff56}Posiad³oœæ:{ffffff}%s\n{56ff56}Czynsz:{ffffff}%i{00aa00}${ffffff}/%i{ffaaaa}Exp\n{56ff56}Interior:{ffffff}%i\nID:%i",HDV[ite][estanam],HDV[ite][MoP],HDV[ite][ExP],HDV[ite][Iid],HDV[ite][hID]);
		HDV[ite][hid3D] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, HDV[ite][XP],HDV[ite][YP],HDV[ite][ZP],15.0);
		return 1;
	}
	stock DelHous(Hid){
		new quer[48];
		mysql_format(DBM,quer, 48, "DELETE * FROM `HoS` WHERE `id`='%i'",Hid);
		mq(quer);
		DestroyDynamicPickup(HDV[Hid][hidP]);
		DestroyDynamicMapIcon(HDV[Hid][hidMI]);
		DestroyDynamic3DTextLabel(HDV[Hid][hid3D]);
		HDV[Hid][hID] = 0;
		HDV[Hid][XP] = 0.0;
		HDV[Hid][YP] = 0.0;
		HDV[Hid][ZP] = 0.0;
		HDV[Hid][Iid] = 0;
		HDV[Hid][Oid] = 0;
		HDV[Hid][Bin] = false;
		HDV[Hid][hpass][23] = EOS;
		HDV[Hid][ExP] = 0;
		HDV[Hid][MoP] = 0;
		HDV[Hid][estanam][23] = EOS;
		Iter_Remove(IHo,HDV[Hid][hID]);
		return 1;
	}
	stock UpdHous(Hid){
		new quer[90];
		mysql_format(DBM,quer,90,"UPDATE `HoS` SET `pre`='%i',`pcsh`='%i',`Security`='%i' WHERE `id`='%i'",HDV[Hid][expi],HDV[Hid][moni],HDV[Hid][Security],Hid);
		mq(quer);
		return 1;
	}
//Must have
	stock IsNumeric(const string[])
	{
		for (new i = 0, j = strlen(string); i < j; i++)
		{
			if (string[i] > '9' || string[i] < '0') return 0;
		}
		return 1;
	}
	stock LOpt(){
		tmq("SELECT * FROM `GM`","GetGMDat","");
		return 1;
	}
	stock LVehS(){
		SVehs[0] = AddStaticVehicle(411,-1648.8081,1206.8046,20.8800,60.7617,54,75); // infernus salon sf
		SVehs[1] = AddStaticVehicle(562,-1665.7750,1223.5532,20.8160,223.1721,253,140); // elegy salon sf
		SVehs[2] = AddStaticVehicle(451,-1652.6555,1211.9418,6.9555,245.7978,57,230); // turismo salon sf
		SVehs[3] = AddStaticVehicle(477,-1668.4117,1205.8629,7.0086,331.7169,87,89); // zr3 salon sf
		SVehs[4] = AddStaticVehicle(429,-1669.3915,1217.3671,6.9301,233.4938,4,110); // banshee salon sf
		SVehs[5] = AddStaticVehicle(560,-1678.3787,1208.9696,13.3763,233.2286,136,144); // sultan salon sf
		SVehs[6] = AddStaticVehicle(475,-1647.7534,1206.5590,13.4715,38.3200,208,223); // sabre salon sf
		SVehs[7] = AddStaticVehicle(480,-1665.1783,1224.3749,13.4402,228.5453,115,48); // comet salon sf
		SVehs[8] = AddStaticVehicle(541,-1677.5464,1208.0137,20.7721,237.6636,218,74); // bullet salon sf
		SVehs[9] = AddStaticVehicle(542,-1955.4155,302.8697,35.2123,143.9799,250,233); // clover salon sf 2
		SVehs[10] = AddStaticVehicle(533,-1959.8674,287.1400,35.2073,148.7577,202,255); // feltzer salon sf 2
		SVehs[11] = AddStaticVehicle(561,-1960.2941,274.2420,35.2673,151.3418,40,68); // stratum salon sf 2
		SVehs[12] = AddStaticVehicle(496,-1960.0736,261.1280,35.2101,147.6932,13,55); // blista salon sf 2
		SVehs[13] = AddStaticVehicle(426,-1946.9537,259.7915,35.2599,82.7817,145,248); // premier salon sf 2
		SVehs[14] = AddStaticVehicle(589,-1945.3551,266.3045,35.1586,76.4741,70,17); // club salon sf 2
		SVehs[15] = AddStaticVehicle(565,-1953.7754,298.8857,40.6699,164.4009,166,127); // flash salon sf 2
		SVehs[16] = AddStaticVehicle(603,-1953.8118,257.8965,40.8237,304.4945,125,95); // phoenix salon sf 2
		SVehs[17] = AddStaticVehicle(402,-1954.4430,265.3450,40.8646,308.1511,246,49); // bufallo salon sf 2
		SetVehicleParamsEx(SVehs[0], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[1], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[2], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[3], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[4], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[5], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[6], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[7], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[8], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[9], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[10], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[11], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[12], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[13], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[14], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[15], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[16], 0, 0, 0, 1, 0, 0, 1);
		SetVehicleParamsEx(SVehs[17], 0, 0, 0, 1, 0, 0, 1);
		new str[128];
		
		format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}Do Kupienia");		
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[0]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[1]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[2]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[3]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[4]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[5]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[6]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[7]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[8]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[9]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[10]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[11]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[12]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[13]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[14]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[15]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[16]);
		CreateDynamic3DTextLabel(str, -1,0.0,0.0,0.0,15.0, INVALID_PLAYER_ID, SVehs[17]);
		return 1;
	}
	stock LObj(){
		//Sumo
		ExceptionalObj[0] = CreateDynamicObject(8355, -1228.87732, 506.76413, 446.11990,   0.00000, 13.00000, 0.00000);
		ExceptionalObj[1] = CreateDynamicObject(8355, -1179.20129, 556.44360, 446.11990,   0.00000, 13.00000, 270.00000);
		ExceptionalObj[2] = CreateDynamicObject(8355, -1129.51892, 506.77155, 446.11990,   0.00000, 13.00000, 180.00000);
		ExceptionalObj[590] = CreateDynamicObject(8355, -1179.19885, 457.10410, 446.11990,   0.00000, 13.00000, 90.00000);
		//
		CreateDynamicObject(19466, 1417.17639, 7.52020, 1008.46979,   0.00000, 0.00000, 90.00000);
		//
		CreateObject(19376, -588.50415, 3318.00513, 60.53460,   0.00000, 90.00000, 0.00000);
		CreateObject(19973, -586.98419, 3316.09155, 60.61780,   0.00000, 0.00000, 256.00000);
		CreateObject(11700, -585.79218, 3319.93652, 60.61520,   0.00000, 0.00000, -91.00000);
		CreateObject(19527, -586.82123, 3320.32300, 60.61512,   0.00000, 0.00000, 0.00000);
		CreateObject(19528, -586.78467, 3320.35815, 61.39800,   0.00000, -90.00000, 47.00000);
		CreateObject(17031, -578.42834, 3329.87402, 50.61210,   0.00000, 0.00000, 0.00000);
		CreateObject(17027, -588.05945, 3310.93384, 53.97590,   0.00000, 0.00000, -185.00000);
		CreateObject(19335, -564.02283, 3293.19434, 69.26440,   0.00000, 0.00000, 0.00000);
		CreateObject(3528, -583.98090, 3319.07788, 66.93430,   4.00000, 18.00000, 185.00000);
		// Sol Ar 2
		ExceptionalObj[3] = CreateDynamicObject(18857, -460.24069, -1811.64490, 1756.87952,   0.00000, 0.00000, 360.00000);
		ExceptionalObj[4] = CreateDynamicObject(18857, -440.72989, -1811.80273, 1751.86658,   0.00000, 180.00000, 0.00000);
		ExceptionalObj[5] = CreateDynamicObject(18857, -440.71179, -1831.80908, 1751.86658,   0.00000, 180.00000, 0.00000);
		ExceptionalObj[6] = CreateDynamicObject(18857, -460.28439, -1831.66443, 1756.87952,   0.00000, 0.00000, 360.00000);
		ExceptionalObj[7] = CreateDynamicObject(18857, -420.71240, -1831.66443, 1756.87952,   0.00000, 0.00000, 360.00000);
		ExceptionalObj[8] = CreateDynamicObject(18857, -420.70154, -1811.64490, 1756.87952,   0.00000, 0.00000, 360.00000);
		ExceptionalObj[9] = CreateDynamicObject(8355, -443.12231, -1841.69592, 1754.37280,   0.00000, 90.00000, 270.00000);
		ExceptionalObj[10] = CreateDynamicObject(8355, -438.68420, -1801.46179, 1754.37280,   0.00000, 90.00000, 90.00000);
		ExceptionalObj[11] = CreateDynamicObject(982, -451.12421, -1829.20679, 1759.89612,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[12] = CreateDynamicObject(982, -451.17032, -1814.76050, 1761.15063,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[13] = CreateDynamicObject(982, -451.18149, -1814.82959, 1759.89612,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[14] = CreateDynamicObject(982, -451.13687, -1829.19702, 1761.11072,   -0.06000, 0.00000, 0.00000);
		ExceptionalObj[15] = CreateDynamicObject(982, -430.47021, -1829.01782, 1759.89612,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[16] = CreateDynamicObject(982, -430.41968, -1814.67017, 1761.15063,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[17] = CreateDynamicObject(982, -430.44135, -1814.61780, 1759.89612,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[18] = CreateDynamicObject(2000, -2429.61401, 7092.94727, -2536.73682,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[19] = CreateDynamicObject(3524, -2429.61401, 7092.94727, -2536.73682,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[20] = CreateDynamicObject(3524, -449.87830, -1801.90601, 1757.17065,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[21] = CreateDynamicObject(3524, -431.63879, -1801.90601, 1757.17065,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[22] = CreateDynamicObject(3524, -431.56470, -1840.88599, 1757.17065,   0.00000, 0.00000, 171.00000);
		ExceptionalObj[23] = CreateDynamicObject(3524, -449.86331, -1840.88599, 1757.17065,   0.00000, 0.00000, 171.00000);
		ExceptionalObj[24] = CreateDynamicObject(7090, -451.18759, -1806.25708, 1761.01672,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[25] = CreateDynamicObject(7090, -430.40689, -1806.41199, 1761.01672,   0.00000, 0.00000, 178.00000);
		ExceptionalObj[26] = CreateDynamicObject(7090, -430.48010, -1830.24524, 1761.01672,   0.00000, 0.00000, 178.00000);
		ExceptionalObj[27] = CreateDynamicObject(7090, -451.06369, -1830.05188, 1761.01672,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[28] = CreateDynamicObject(1703, -10116.64941, -928.93726, 3.11365,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[29] = CreateDynamicObject(1703, -461.57446, -1835.79456, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[30] = CreateDynamicObject(1703, -461.78381, -1831.49109, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[31] = CreateDynamicObject(1703, -461.73389, -1827.57214, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[32] = CreateDynamicObject(19058, -457.98859, -1832.52820, 1755.03992,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[33] = CreateDynamicObject(19058, -456.07370, -1837.77820, 1755.03992,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[34] = CreateDynamicObject(19058, -456.45154, -1840.52197, 1755.03992,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[35] = CreateDynamicObject(19056, -456.18961, -1834.38379, 1754.93872,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[36] = CreateDynamicObject(18654, -466.62482, -1829.27527, 1754.19348,   0.00000, 0.00000, 185.00000);
		ExceptionalObj[37] = CreateDynamicObject(18654, -468.11658, -1832.83435, 1754.19348,   0.00000, 0.00000, 185.00000);
		ExceptionalObj[38] = CreateDynamicObject(19129, -460.24899, -1831.72925, 1754.32751,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[39] = CreateDynamicObject(1703, -459.57190, -1820.23779, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[40] = CreateDynamicObject(1703, -458.12369, -1814.08374, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[41] = CreateDynamicObject(1703, -464.75525, -1817.82007, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[42] = CreateDynamicObject(1703, -465.90787, -1808.51501, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[43] = CreateDynamicObject(1703, -460.87994, -1810.65967, 1754.37854,   0.00000, 0.00000, 91.00000);
		ExceptionalObj[44] = CreateDynamicObject(19129, -460.19479, -1811.67334, 1754.32751,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[45] = CreateDynamicObject(18654, -464.07590, -1811.46277, 1754.19348,   0.00000, 0.00000, 185.00000);
		ExceptionalObj[46] = CreateDynamicObject(1703, -423.16299, -1838.04675, 1754.37854,   0.00000, 0.00000, 244.00000);
		ExceptionalObj[47] = CreateDynamicObject(1703, -421.62091, -1832.54553, 1754.37854,   0.00000, 0.00000, 280.00000);
		ExceptionalObj[48] = CreateDynamicObject(1703, -424.17920, -1827.91064, 1754.37854,   0.00000, 0.00000, 287.00000);
		ExceptionalObj[49] = CreateDynamicObject(19129, -420.76071, -1811.67334, 1754.32751,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[50] = CreateDynamicObject(19056, -425.26520, -1832.63196, 1754.93872,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[51] = CreateDynamicObject(19056, -428.39322, -1828.88550, 1754.93872,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[52] = CreateDynamicObject(19129, -420.76480, -1831.72925, 1754.32751,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[53] = CreateDynamicObject(18654, -424.65973, -1811.95654, 1754.19348,   0.00000, 0.00000, 185.00000);
		ExceptionalObj[54] = CreateDynamicObject(18654, -424.66605, -1807.53186, 1754.19348,   0.00000, 0.00000, 185.00000);
		ExceptionalObj[55] = CreateDynamicObject(982, -430.40970, -1828.94714, 1761.11072,   -0.06000, 0.00000, 0.00000);
		//Jail
		ExceptionalObj[56] = CreateDynamicObject(19550, 4324.64893, -5612.21387, 15.49430,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[57] = CreateDynamicObject(17030, 4376.14307, -5556.02490, 14.61480,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[58] = CreateDynamicObject(17030, 4342.18018, -5547.80957, 14.61480,   0.00000, 0.00000, 50.00000);
		ExceptionalObj[59] = CreateDynamicObject(17030, 4297.39941, -5547.75391, 14.61480,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[60] = CreateDynamicObject(17030, 4271.34375, -5572.65283, 14.61480,   0.00000, 0.00000, 105.00000);
		ExceptionalObj[61] = CreateDynamicObject(17030, 4260.59717, -5613.51514, 14.61480,   0.00000, 0.00000, 145.00000);
		ExceptionalObj[62] = CreateDynamicObject(17030, 4259.49268, -5658.02490, 14.61480,   0.00000, 0.00000, 145.00000);
		ExceptionalObj[63] = CreateDynamicObject(17030, 4290.82324, -5673.38965, 14.61480,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[64] = CreateDynamicObject(17030, 4337.34863, -5674.30469, 14.61480,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[65] = CreateDynamicObject(17030, 4372.86865, -5657.66553, 14.61480,   0.00000, 0.00000, -76.00000);
		ExceptionalObj[66] = CreateDynamicObject(17030, 4387.34424, -5624.18213, 14.61480,   0.00000, 0.00000, -33.00000);
		ExceptionalObj[67] = CreateDynamicObject(17030, 4387.35986, -5584.46729, 14.61480,   0.00000, 0.00000, -33.00000);
		ExceptionalObj[68] = CreateDynamicObject(616, 4291.00000, 9204.00000, -5647.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[69] = CreateDynamicObject(616, 4297.00000, 5645.00000, -5642.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[70] = CreateDynamicObject(615, 4296.64746, -5630.49609, 15.43423,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[71] = CreateDynamicObject(615, 4347.70020, -5628.09814, 15.43420,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[72] = CreateDynamicObject(615, 4366.35107, -5591.44580, 15.43420,   0.00000, 0.00000, -76.00000);
		ExceptionalObj[73] = CreateDynamicObject(617, 4313.19775, -5601.45947, 15.31980,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[74] = CreateDynamicObject(617, 4297.56689, -5571.81592, 15.31980,   0.00000, 0.00000, -76.00000);
		ExceptionalObj[75] = CreateDynamicObject(617, 4348.09082, -5580.51172, 15.31980,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[76] = CreateDynamicObject(669, 4330.33252, -5602.17139, 15.27800,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[77] = CreateDynamicObject(669, 4301.85400, -5600.63379, 15.27800,   0.00000, 0.00000, -62.00000);
		ExceptionalObj[78] = CreateDynamicObject(669, 4314.87744, -5564.66113, 15.27800,   0.00000, 0.00000, -113.00000);
		ExceptionalObj[79] = CreateDynamicObject(703, 4324.17480, -5584.34326, 15.31160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[80] = CreateDynamicObject(703, 4349.43799, -5595.74609, 15.31160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[81] = CreateDynamicObject(709, 4323.07910, -5638.86963, 15.16020,   0.00000, 0.00000, -69.00000);
		ExceptionalObj[82] = CreateDynamicObject(715, 4279.20020, -5595.59521, 15.17600,   0.00000, 0.00000, -62.00000);
		ExceptionalObj[83] = CreateDynamicObject(8355, 4264.96631, -5617.53076, 33.67000,   0.00000, 90.00000, 180.00000);
		ExceptionalObj[84] = CreateDynamicObject(8355, 4382.20117, -5613.27344, 33.67000,   0.00000, 90.00000, 0.00000);
		ExceptionalObj[85] = CreateDynamicObject(8355, 4357.15771, -5669.63867, 33.67000,   0.00000, 90.00000, -55.00000);
		ExceptionalObj[86] = CreateDynamicObject(8355, 4307.32764, -5670.43164, 33.67000,   0.00000, 90.00000, 270.00000);
		ExceptionalObj[87] = CreateDynamicObject(8355, 4375.27490, -5562.83838, 33.67000,   0.00000, 90.00000, 33.00000);
		ExceptionalObj[88] = CreateDynamicObject(8355, 4327.66699, -5551.32373, 33.67000,   0.00000, 90.00000, 90.00000);
		ExceptionalObj[89] = CreateDynamicObject(8355, 4281.33936, -5607.84814, 52.35858,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[90] = CreateDynamicObject(8355, 4321.72705, -5608.92871, 52.35858,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[91] = CreateDynamicObject(8355, 4362.73486, -5610.98877, 52.35858,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[92] = CreateDynamicObject(19588, 4342.00000, 6543.00000, -5612.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[93] = CreateDynamicObject(19588, 4343.83936, -5616.48242, 16.44660,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[94] = CreateDynamicObject(19865, 4294.98340, -5645.79639, 14.77840,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[95] = CreateDynamicObject(19865, 4292.47998, -5648.27979, 14.77840,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[96] = CreateDynamicObject(19865, 4292.49707, -5643.27832, 14.77840,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[97] = CreateDynamicObject(19865, 4289.98779, -5645.75928, 14.77840,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[98] = CreateDynamicObject(19833, 4292.61621, -5646.67334, 15.48770,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[99] = CreateDynamicObject(19833, 4292.69141, -5646.34326, 16.02770,   310.00000, 0.00000, 0.00000);
		ExceptionalObj[100] = CreateDynamicObject(19978, 4289.99316, -5643.31445, 15.48790,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[101] = CreateDynamicObject(19979, 4294.94922, -5648.25537, 15.48760,   0.00000, 0.00000, -207.00000);
		ExceptionalObj[102] = CreateDynamicObject(3472, 4290.32373, -5649.76660, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[103] = CreateDynamicObject(3472, 4313.61963, -5633.36670, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[104] = CreateDynamicObject(3472, 4279.49756, -5622.18896, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[105] = CreateDynamicObject(3472, 4303.77002, -5585.56592, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[106] = CreateDynamicObject(3472, 4366.34082, -5611.82520, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[107] = CreateDynamicObject(3472, 4334.20020, -5652.71436, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[108] = CreateDynamicObject(3472, 4343.62939, -5618.89795, 12.48120,   0.00000, 0.00000, 30.00000);
		ExceptionalObj[109] = CreateDynamicObject(3472, 4343.63623, -5613.65479, 12.48120,   0.00000, 0.00000, -30.00000);
		ExceptionalObj[110] = CreateDynamicObject(3472, 4334.09912, -5563.96875, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[111] = CreateDynamicObject(3472, 4367.73047, -5582.35303, 12.48120,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[112] = CreateDynamicObject(1280, 4287.08984, -5645.76416, 15.87930,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[113] = CreateDynamicObject(1280, 4297.47510, -5645.84570, 15.87930,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[114] = CreateDynamicObject(3279, 4290.42676, -5611.80469, 15.29860,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[115] = CreateDynamicObject(3279, 4307.20313, -5576.54736, 15.29860,   0.00000, 0.00000, -62.00000);
		//Battle Royale
		ExceptionalObj[116] = CreateDynamicObject(19547, 2977.93579, -3351.25195, 1.29860,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[117] = CreateDynamicObject(19536, 2977.93726, -3257.58057, 1.29800,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[118] = CreateDynamicObject(19529, 2853.03589, -3351.24927, 1.29800,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[119] = CreateDynamicObject(19536, 2977.94263, -3444.95728, 1.29800,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[120] = CreateDynamicObject(19529, 3102.91748, -3413.72070, 1.29860,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[121] = CreateDynamicObject(19529, 3102.94458, -3538.66235, 1.29800,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[122] = CreateDynamicObject(19546, 3040.53052, -3476.17847, 1.29000,   0.00000, 0.00000, 270.00000);
		ExceptionalObj[123] = CreateDynamicObject(19549, 2961.80225, -3476.16235, 1.29040,   0.00000, 0.00000, 270.00000);
		ExceptionalObj[124] = CreateDynamicObject(19549, 2929.37305, -3476.13281, 1.29000,   0.00000, 0.00000, 270.00000);
		ExceptionalObj[125] = CreateDynamicObject(19549, 3040.62500, -3554.84961, 1.29040,   0.00000, 0.00000, -180.00000);
		ExceptionalObj[126] = CreateDynamicObject(19549, 3040.45459, -3587.33594, 1.29000,   0.00000, 0.00000, -180.00000);
		ExceptionalObj[127] = CreateDynamicObject(11696, 3094.68433, -3689.17285, -8.13410,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[128] = CreateDynamicObject(11695, 3251.67139, -3512.83643, 1.62740,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[129] = CreateDynamicObject(17026, 3168.83667, -3391.38965, 0.75950,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[130] = CreateDynamicObject(17026, 3152.42700, -3359.65771, 0.53950,   0.00000, 0.00000, 11.00000);
		ExceptionalObj[131] = CreateDynamicObject(17026, 3119.14868, -3350.08789, 1.17950,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[132] = CreateDynamicObject(17030, 3071.51831, -3348.19580, 0.30710,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[133] = CreateDynamicObject(18228, 3050.58325, -3331.50488, 0.69320,   0.00000, 0.00000, -113.00000);
		ExceptionalObj[134] = CreateDynamicObject(17031, 3044.54736, -3277.52734, 0.35930,   0.00000, 0.00000, 4.00000);
		ExceptionalObj[135] = CreateDynamicObject(17031, 3036.39941, -3241.52930, 0.35930,   0.00000, 0.00000, 222.00000);
		ExceptionalObj[136] = CreateDynamicObject(17026, 2988.97241, -3223.72388, 1.00410,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[137] = CreateDynamicObject(17026, 2941.45923, -3225.84155, 1.00410,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[138] = CreateDynamicObject(11695, 2835.17383, -3502.98315, 1.62740,   0.00000, 0.00000, 171.00000);
		ExceptionalObj[139] = CreateDynamicObject(17027, 2915.69507, -3237.92651, 1.24140,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[140] = CreateDynamicObject(17031, 2910.68750, -3260.83521, 0.30330,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[141] = CreateDynamicObject(17026, 2880.14868, -3286.28467, 0.48820,   0.00000, 0.00000, 59.00000);
		ExceptionalObj[142] = CreateDynamicObject(17026, 2836.46436, -3287.61499, 0.70820,   0.00000, 0.00000, 59.00000);
		ExceptionalObj[143] = CreateDynamicObject(18228, 2800.51929, -3297.96460, 0.87970,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[144] = CreateDynamicObject(17027, 2787.81689, -3337.74561, 1.07200,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[145] = CreateDynamicObject(17030, 2784.56982, -3375.46777, 1.02800,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[146] = CreateDynamicObject(17027, 2792.06396, -3352.50708, 1.06210,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[147] = CreateDynamicObject(689, 3068.01196, -3492.42358, 0.81070,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[148] = CreateDynamicObject(689, 3080.06372, -3493.46436, 0.81070,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[149] = CreateDynamicObject(689, 3067.21631, -3473.70166, 0.81070,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[150] = CreateDynamicObject(689, 3091.20337, -3483.52319, 0.81070,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[151] = CreateDynamicObject(689, 3084.14722, -3467.97339, 0.81070,   0.00000, 0.00000, 76.00000);
		ExceptionalObj[152] = CreateDynamicObject(728, 3062.16528, -3575.73438, 1.15220,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[153] = CreateDynamicObject(728, 3063.05957, -3579.16650, 1.15220,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[154] = CreateDynamicObject(715, 2964.30420, -3455.68213, 1.07160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[155] = CreateDynamicObject(715, 2972.28735, -3456.97681, 1.07160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[156] = CreateDynamicObject(16061, 3083.33447, -3377.23413, 1.03630,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[157] = CreateDynamicObject(855, 3008.60718, -3586.50269, -0.03700,   0.00000, 0.00000, 84.00000);
		ExceptionalObj[158] = CreateDynamicObject(855, 3008.10986, -3575.83130, -0.03700,   0.00000, 0.00000, 84.00000);
		ExceptionalObj[159] = CreateDynamicObject(855, 3008.10718, -3573.46045, -0.03700,   0.00000, 0.00000, 84.00000);
		ExceptionalObj[160] = CreateDynamicObject(855, 3008.05884, -3571.93115, -0.03700,   0.00000, 0.00000, 84.00000);
		ExceptionalObj[161] = CreateDynamicObject(855, 3007.51270, -3568.35107, -0.03700,   0.00000, 0.00000, 84.00000);
		ExceptionalObj[162] = CreateDynamicObject(855, 3007.95996, -3565.54858, -0.03700,   0.00000, 0.00000, 120.00000);
		ExceptionalObj[163] = CreateDynamicObject(806, 3010.48340, -3581.29102, 0.67310,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[164] = CreateDynamicObject(806, 3011.01245, -3559.18433, 1.71310,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[165] = CreateDynamicObject(806, 3010.61548, -3556.56787, 1.71310,   0.00000, 0.00000, 25.00000);
		ExceptionalObj[166] = CreateDynamicObject(855, 2930.88257, -3506.84790, 0.10647,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[167] = CreateDynamicObject(855, 2935.55347, -3507.41797, 0.10647,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[168] = CreateDynamicObject(855, 2939.97998, -3508.08374, 0.10650,   0.00000, 0.00000, 28.00000);
		ExceptionalObj[169] = CreateDynamicObject(855, 2944.67920, -3508.25415, 0.10650,   0.00000, 0.00000, 28.00000);
		ExceptionalObj[170] = CreateDynamicObject(855, 2949.19263, -3507.75977, 0.10650,   0.00000, 0.00000, 28.00000);
		ExceptionalObj[171] = CreateDynamicObject(855, 2963.52100, -3508.72656, 0.10650,   0.00000, 0.00000, 28.00000);
		ExceptionalObj[172] = CreateDynamicObject(855, 2967.61133, -3508.70801, 0.10650,   0.00000, 0.00000, 47.00000);
		ExceptionalObj[173] = CreateDynamicObject(855, 2971.46704, -3508.05029, 0.10650,   0.00000, 0.00000, 47.00000);
		ExceptionalObj[174] = CreateDynamicObject(855, 2989.55933, -3507.27856, 0.10650,   0.00000, 0.00000, 47.00000);
		ExceptionalObj[175] = CreateDynamicObject(855, 2994.56958, -3507.33032, 0.10650,   0.00000, 0.00000, 47.00000);
		ExceptionalObj[176] = CreateDynamicObject(827, 3009.66113, -3521.81079, 3.62770,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[177] = CreateDynamicObject(827, 3009.44653, -3517.19507, 3.62770,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[178] = CreateDynamicObject(827, 3009.50073, -3513.48779, 3.62770,   0.00000, 0.00000, -47.00000);
		ExceptionalObj[179] = CreateDynamicObject(827, 3008.68286, -3509.75659, 3.62770,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[180] = CreateDynamicObject(872, 3009.28394, -3542.31030, -0.07819,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[181] = CreateDynamicObject(872, 3009.38550, -3538.42651, -0.07819,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[182] = CreateDynamicObject(11428, 3130.63843, -3573.59131, 6.71900,   0.00000, 0.00000, -55.00000);
		ExceptionalObj[183] = CreateDynamicObject(11457, 3078.34595, -3545.48096, 0.85380,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[184] = CreateDynamicObject(11472, 3078.94434, -3382.89429, 0.12560,   0.00000, 0.00000, -11.00000);
		ExceptionalObj[185] = CreateDynamicObject(11427, 3136.61108, -3402.72388, 8.42680,   0.00000, 0.00000, 33.00000);
		ExceptionalObj[186] = CreateDynamicObject(11445, 3012.39771, -3459.56250, 1.38030,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[187] = CreateDynamicObject(11457, 3006.14282, -3250.79297, 0.84730,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[188] = CreateDynamicObject(16770, 2946.43970, -3251.59277, 2.83190,   0.00000, 0.00000, -69.00000);
		ExceptionalObj[189] = CreateDynamicObject(12943, 3063.84473, -3428.72119, 1.26170,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[190] = CreateDynamicObject(12943, 3080.03589, -3428.72144, 1.26170,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[191] = CreateDynamicObject(3866, 2828.16284, -3361.03271, 9.05570,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[192] = CreateDynamicObject(3866, 2857.26123, -3370.53857, 9.05570,   0.00000, 0.00000, -45.00000);
		ExceptionalObj[193] = CreateDynamicObject(3887, 2895.14990, -3331.65405, 9.19200,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[194] = CreateDynamicObject(967, 3032.39233, -3283.04419, 1.25570,   0.00000, 0.00000, -47.00000);
		ExceptionalObj[195] = CreateDynamicObject(967, 2818.83545, -3327.40991, 1.28060,   0.00000, 0.00000, 47.00000);
		ExceptionalObj[196] = CreateDynamicObject(967, 2817.13428, -3328.32886, 1.28060,   0.00000, 0.00000, 11.00000);
		ExceptionalObj[197] = CreateDynamicObject(967, 2819.38843, -3325.44922, 1.28060,   0.00000, 0.00000, 11.00000);
		ExceptionalObj[198] = CreateDynamicObject(8397, 2859.16797, -3325.90479, 11.71390,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[199] = CreateDynamicObject(14409, 2837.35645, -3360.23535, 1.86640,   0.00000, 0.00000, 45.00000);
		ExceptionalObj[200] = CreateDynamicObject(6295, 2981.27856, -3352.85400, 37.40780,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[201] = CreateDynamicObject(3515, 3079.43359, -3479.51172, 1.58520,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[202] = CreateDynamicObject(3461, 3084.06152, -3477.64404, 2.76870,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[203] = CreateDynamicObject(3461, 3079.66724, -3485.48291, 2.76870,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[204] = CreateDynamicObject(3461, 3075.84058, -3475.61230, 2.76870,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[205] = CreateDynamicObject(18762, 2997.42114, -3461.57129, 3.77440,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[206] = CreateDynamicObject(18764, 2995.25708, -3453.89282, -1.14780,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[207] = CreateDynamicObject(18764, 2995.25537, -3458.56592, -1.14740,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[208] = CreateDynamicObject(19376, 2997.84253, -3456.23291, 1.34591,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[209] = CreateDynamicObject(19376, 2992.84106, -3456.22974, 1.34591,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[210] = CreateDynamicObject(18762, 2993.27100, -3461.57129, 3.77440,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[211] = CreateDynamicObject(18764, 2995.25708, -3453.89282, -1.14780,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[212] = CreateDynamicObject(18766, 2995.37012, -3461.57007, -2.37570,   0.00000, 90.00000, 0.00000);
		ExceptionalObj[213] = CreateDynamicObject(18766, 2995.30688, -3451.86987, -2.37570,   0.00000, 90.00000, 0.00000);
		ExceptionalObj[214] = CreateDynamicObject(18766, 2995.36133, -3457.05371, 6.37570,   90.00000, 90.00000, 0.00000);
		ExceptionalObj[215] = CreateDynamicObject(715, 2988.35596, -3450.62061, 1.07160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[216] = CreateDynamicObject(715, 2995.07813, -3468.57764, 1.07160,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[217] = CreateDynamicObject(16060, 3004.88428, -3439.54541, 0.87770,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[218] = CreateDynamicObject(715, 3139.83789, -3557.27393, 1.09770,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[219] = CreateDynamicObject(715, 3121.04761, -3565.57715, 1.09770,   0.00000, 0.00000, -18.00000);
		ExceptionalObj[220] = CreateDynamicObject(705, 3111.50879, -3578.51660, 1.00350,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[221] = CreateDynamicObject(705, 3058.32935, -3547.95679, 1.00350,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[222] = CreateDynamicObject(705, 3057.54077, -3416.12256, 1.00350,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[223] = CreateDynamicObject(751, 2967.73486, -3392.21118, 5.86290,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[224] = CreateDynamicObject(751, 2967.81567, -3389.83423, 5.86290,   0.00000, 0.00000, 33.00000);
		ExceptionalObj[225] = CreateDynamicObject(13635, 3046.16016, -3384.46387, 3.98350,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[226] = CreateDynamicObject(16104, 2948.06616, -3372.76489, -5.35070,   0.00000, 0.00000, -33.00000);
		ExceptionalObj[227] = CreateDynamicObject(900, 2976.41553, -3261.61304, 1.26030,   0.00000, 0.00000, 40.00000);
		ExceptionalObj[228] = CreateDynamicObject(691, 2932.80029, -3239.84717, 0.88630,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[229] = CreateDynamicObject(671, 2986.96851, -3237.41089, 1.08920,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[230] = CreateDynamicObject(690, 3015.45605, -3269.37695, 1.05980,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[231] = CreateDynamicObject(690, 2970.37036, -3287.90259, 1.05980,   0.00000, 0.00000, 98.00000);
		ExceptionalObj[232] = CreateDynamicObject(715, 2923.30737, -3295.56616, 1.12140,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[233] = CreateDynamicObject(715, 2945.92529, -3360.66479, 6.83452,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[234] = CreateDynamicObject(715, 3007.59375, -3335.15894, 6.83452,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[235] = CreateDynamicObject(703, 2836.56494, -3307.91675, 1.06440,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[236] = CreateDynamicObject(703, 2818.61279, -3351.87036, 1.06440,   0.00000, 0.00000, -69.00000);
		ExceptionalObj[237] = CreateDynamicObject(715, 2852.12061, -3403.43164, 1.02870,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[238] = CreateDynamicObject(617, 2877.46045, -3349.40503, 0.96210,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[239] = CreateDynamicObject(617, 2866.74341, -3377.28784, 0.96210,   0.00000, 0.00000, 98.00000);
		ExceptionalObj[240] = CreateDynamicObject(618, 2926.53052, -3396.93213, 2.65780,   0.00000, 0.00000, -33.00000);
		ExceptionalObj[241] = CreateDynamicObject(693, 2815.70557, -3389.39868, 0.83220,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[242] = CreateDynamicObject(3279, 3137.15552, -3514.76636, 1.19280,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[243] = CreateDynamicObject(730, 3134.35718, -3499.50928, 1.06260,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[244] = CreateDynamicObject(730, 3104.14844, -3510.84351, 1.06260,   0.00000, 0.00000, -62.00000);
		ExceptionalObj[245] = CreateDynamicObject(730, 3128.46826, -3536.80200, 1.06260,   0.00000, 0.00000, 4.00000);
		ExceptionalObj[246] = CreateDynamicObject(789, 3118.71216, -3502.37061, 1.00800,   0.00000, 0.00000, 40.00000);
		ExceptionalObj[247] = CreateDynamicObject(3279, 3044.22192, -3444.90918, 1.18410,   0.00000, 0.00000, 33.00000);
		ExceptionalObj[248] = CreateDynamicObject(3279, 2971.87939, -3355.18115, 13.36110,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[249] = CreateDynamicObject(3279, 2932.38916, -3292.82739, 1.13520,   0.00000, 0.00000, -156.00000);
		ExceptionalObj[250] = CreateDynamicObject(3279, 2995.33667, -3283.67358, 1.11950,   0.00000, 0.00000, -215.00000);
		ExceptionalObj[251] = CreateDynamicObject(3279, 2881.91357, -3333.55444, 0.96110,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[252] = CreateDynamicObject(3279, 3095.99585, -3369.55859, 1.11950,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[253] = CreateDynamicObject(3279, 2965.32031, -3465.79053, 1.12080,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[254] = CreateDynamicObject(3279, 3047.90942, -3571.59033, 1.07710,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[255] = CreateDynamicObject(714, 3140.81152, -3412.03174, 1.13970,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[256] = CreateDynamicObject(714, 2989.85596, -3374.77368, 8.50280,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[257] = CreateDynamicObject(715, 2962.51270, -3392.82251, 6.83452,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[258] = CreateDynamicObject(715, 2911.90088, -3321.89502, 1.12140,   0.00000, 0.00000, 142.00000);
		ExceptionalObj[259] = CreateDynamicObject(18849, 2971.35156, -3376.00659, 34.73630,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[260] = CreateDynamicObject(19905, 3112.56006, -3425.76123, 1.11730,   0.00000, 0.00000, 280.00000);
		ExceptionalObj[261] = CreateDynamicObject(19865, 3107.41626, -3442.17871, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[262] = CreateDynamicObject(19865, 3106.54468, -3437.25977, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[263] = CreateDynamicObject(19865, 3105.63208, -3432.27417, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[264] = CreateDynamicObject(19865, 3103.85010, -3422.21680, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[265] = CreateDynamicObject(19865, 3102.88062, -3416.99194, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[266] = CreateDynamicObject(19865, 3102.00879, -3412.07666, 1.31030,   0.00000, 0.00000, 10.00000);
		ExceptionalObj[267] = CreateDynamicObject(19509, 3132.06348, -3377.59033, 3.98820,   0.00000, 0.00000, 105.00000);
		ExceptionalObj[268] = CreateDynamicObject(19510, 3132.06348, -3377.59009, 3.98820,   0.00000, 0.00000, 105.00000);
		ExceptionalObj[269] = CreateDynamicObject(3415, 2934.72192, -3274.28125, 1.26090,   0.00000, 0.00000, 32.00000);
		ExceptionalObj[270] = CreateDynamicObject(10357, 3155.89429, -3447.17212, 90.00110,   0.00000, 40.00000, 149.00000);
		ExceptionalObj[271] = CreateDynamicObject(17027, 3177.19873, -3449.99585, 33.80740,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[272] = CreateDynamicObject(18367, 2899.02197, -3358.42969, 6.43130,   20.00000, 0.00000, 0.00000);
		ExceptionalObj[273] = CreateDynamicObject(18367, 2836.23267, -3371.82031, 8.78420,   22.00000, 0.00000, -135.00000);
		ExceptionalObj[274] = CreateDynamicObject(18367, 2849.12769, -3359.44214, 8.78420,   22.00000, 0.00000, -135.00000);
		ExceptionalObj[275] = CreateDynamicObject(18367, 2868.59839, -3366.77344, 8.78420,   26.00000, 0.00000, -225.00000);
		ExceptionalObj[276] = CreateDynamicObject(18367, 2997.91333, -3252.67358, 6.47380,   10.00000, 0.00000, -62.00000);
		ExceptionalObj[277] = CreateDynamicObject(18367, 3119.61938, -3442.73511, 5.60330,   15.00000, 0.00000, 11.00000);
		ExceptionalObj[278] = CreateDynamicObject(18367, 2993.22046, -3461.60742, 6.46110,   18.00000, 0.00000, -33.00000);
		ExceptionalObj[279] = CreateDynamicObject(8355, 2953.40405, -3590.56421, -1.61720,   0.00000, 90.00000, -120.00000);
		ExceptionalObj[280] = CreateDynamicObject(8355, 2787.74805, -3345.91577, 13.61710,   0.00000, 90.00000, -183.00000);
		ExceptionalObj[281] = CreateDynamicObject(8355, 2809.86328, -3298.62378, 13.61710,   0.00000, 90.00000, -236.00000);
		ExceptionalObj[282] = CreateDynamicObject(8355, 2976.51733, -3226.70776, 13.61710,   0.00000, 90.00000, -273.00000);
		ExceptionalObj[283] = CreateDynamicObject(8355, 3167.80396, -3371.85571, 13.61710,   0.00000, 90.00000, 4.00000);
		ExceptionalObj[284] = CreateDynamicObject(8355, 3150.90479, -3356.57007, 13.61710,   0.00000, 90.00000, 47.00000);
		ExceptionalObj[285] = CreateDynamicObject(17026, 2910.98462, -3241.35938, 13.49750,   0.00000, 50.00000, -40.00000);
		ExceptionalObj[286] = CreateDynamicObject(17026, 2907.74316, -3262.03174, 13.49750,   0.00000, 50.00000, -40.00000);
		ExceptionalObj[287] = CreateDynamicObject(17026, 2890.55469, -3272.77856, 13.49750,   0.00000, 50.00000, -120.00000);
		ExceptionalObj[288] = CreateDynamicObject(17026, 2860.56030, -3273.39429, 13.49750,   0.00000, 50.00000, -120.00000);
		ExceptionalObj[289] = CreateDynamicObject(17026, 2827.24927, -3275.24805, 13.49750,   0.00000, 50.00000, -120.00000);
		ExceptionalObj[290] = CreateDynamicObject(8355, 3033.66260, -3243.78906, 13.61710,   0.00000, 90.00000, -309.00000);
		ExceptionalObj[291] = CreateDynamicObject(17031, 3051.33496, -3272.39868, 18.27760,   0.00000, 40.00000, -185.00000);
		ExceptionalObj[292] = CreateDynamicObject(17031, 3054.21704, -3313.95337, 18.27760,   0.00000, 40.00000, -185.00000);
		ExceptionalObj[293] = CreateDynamicObject(17031, 3070.80664, -3337.72607, 18.27760,   0.00000, 40.00000, -127.00000);
		ExceptionalObj[294] = CreateDynamicObject(17031, 3109.35864, -3340.14038, 18.27760,   0.00000, 40.00000, -91.00000);
		ExceptionalObj[295] = CreateDynamicObject(17031, 3151.37842, -3347.39478, 18.27760,   0.00000, 40.00000, -113.00000);

		//Derby 1
		ExceptionalObj[296] = CreateDynamicObject(3458, 448.87408, 5257.90039, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[297] = CreateDynamicObject(8838, 411.99301, 5257.90186, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[298] = CreateDynamicObject(3458, 375.12970, 5257.89844, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[299] = CreateDynamicObject(8838, 338.20880, 5257.90186, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[300] = CreateDynamicObject(3458, 318.49774, 5293.26123, 23.20295,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[301] = CreateDynamicObject(8838, 378.59900, 5410.60400, 7.54300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[302] = CreateDynamicObject(3458, 318.95300, 5387.85010, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[303] = CreateDynamicObject(8838, 318.95599, 5350.95215, 7.54300,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[304] = CreateDynamicObject(8838, 471.65500, 5391.35010, 7.54300,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[305] = CreateDynamicObject(8838, 452.38519, 5410.60400, 7.54300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[306] = CreateDynamicObject(3458, 471.65302, 5354.45898, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[307] = CreateDynamicObject(8838, 471.65601, 5317.55713, 7.54300,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[308] = CreateDynamicObject(3458, 471.65399, 5280.66602, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[309] = CreateDynamicObject(3458, 341.70801, 5410.60400, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[310] = CreateDynamicObject(8838, 333.08981, 5410.60400, 7.52000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[311] = CreateDynamicObject(3458, 336.59698, 5257.90869, 7.52000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[312] = CreateDynamicObject(8838, 471.65710, 5272.04297, 7.52000,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[313] = CreateDynamicObject(3458, 454.02011, 5410.60400, 7.52000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[314] = CreateDynamicObject(8838, 318.95569, 5277.16016, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[315] = CreateDynamicObject(3458, 415.49899, 5410.60400, 7.54530,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[316] = CreateDynamicObject(17026, 320.68961, 5468.40918, -2.02440,   0.00000, 0.00000, 244.00000);
		ExceptionalObj[317] = CreateDynamicObject(17026, 532.55847, 5386.87988, -2.02440,   0.00000, 0.00000, 157.00000);
		ExceptionalObj[318] = CreateDynamicObject(17026, 430.45477, 5195.63232, -2.02440,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[319] = CreateDynamicObject(17026, 250.15207, 5240.91504, -2.02440,   0.00000, 0.00000, -15.00000);
		ExceptionalObj[320] = CreateDynamicObject(17027, 488.46719, 5199.41455, 7.12475,   0.00000, 0.00000, 164.00000);
		ExceptionalObj[321] = CreateDynamicObject(17026, 521.34882, 5205.08008, -2.02440,   0.00000, 0.00000, 110.79424);
		ExceptionalObj[322] = CreateDynamicObject(17027, 374.22290, 5194.26904, 7.12470,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[323] = CreateDynamicObject(17026, 324.87646, 5196.56787, -2.02440,   0.00000, 0.00000, 55.00000);
		ExceptionalObj[324] = CreateDynamicObject(17027, 267.92383, 5193.16943, 7.12470,   0.00000, 0.00000, 113.00000);
		ExceptionalObj[325] = CreateDynamicObject(17027, 256.43799, 5277.00928, 7.12470,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[326] = CreateDynamicObject(17026, 251.18324, 5337.14844, -2.02440,   0.00000, 0.00000, -47.00000);
		ExceptionalObj[327] = CreateDynamicObject(17027, 259.12271, 5368.03564, 7.12470,   0.00000, 0.00000, 62.00000);
		ExceptionalObj[328] = CreateDynamicObject(17026, 255.65231, 5420.95361, -2.02440,   0.00000, 0.00000, -47.00000);
		ExceptionalObj[329] = CreateDynamicObject(17027, 257.04886, 5449.71582, 7.12470,   0.00000, 0.00000, 4.00000);
		ExceptionalObj[330] = CreateDynamicObject(17027, 354.17993, 5461.80664, 7.12470,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[331] = CreateDynamicObject(17026, 407.89627, 5471.96191, -2.02440,   0.00000, 0.00000, 236.00000);
		ExceptionalObj[332] = CreateDynamicObject(17027, 437.70007, 5463.35156, 7.12470,   0.00000, 0.00000, -25.00000);
		ExceptionalObj[333] = CreateDynamicObject(17026, 518.78992, 5462.36523, -2.02440,   0.00000, 0.00000, 200.00000);
		ExceptionalObj[334] = CreateDynamicObject(17027, 524.85419, 5440.13867, 7.12470,   0.00000, 0.00000, -91.00000);
		ExceptionalObj[335] = CreateDynamicObject(17027, 525.50000, 5353.85498, 7.12470,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[336] = CreateDynamicObject(17026, 481.16666, 5478.39551, -2.02440,   0.00000, 0.00000, 200.00000);
		ExceptionalObj[337] = CreateDynamicObject(17026, 535.31677, 5253.79688, -2.02440,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[338] = CreateDynamicObject(17027, 401.17630, 5195.79150, 7.12470,   0.00000, 0.00000, 149.00000);
		ExceptionalObj[339] = CreateDynamicObject(17026, 283.59872, 5197.91650, -2.02440,   0.00000, 0.00000, 48.00000);
		ExceptionalObj[340] = CreateDynamicObject(17026, 536.35132, 5299.83447, -2.02440,   0.00000, 0.00000, 157.00000);
		ExceptionalObj[341] = CreateDynamicObject(8838, 452.41821, 5317.22314, 7.54300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[342] = CreateDynamicObject(8838, 419.03909, 5317.22314, 7.54300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[343] = CreateDynamicObject(8838, 437.79410, 5275.57227, 23.31570,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[344] = CreateDynamicObject(8838, 455.41440, 5275.56738, 23.31500,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[345] = CreateDynamicObject(8838, 404.44861, 5275.57227, 23.31570,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[346] = CreateDynamicObject(8838, 470.00342, 5326.53271, 23.31570,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[347] = CreateDynamicObject(8838, 470.00131, 5359.88330, 23.31570,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[348] = CreateDynamicObject(8838, 451.55707, 5353.73291, 23.31570,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[349] = CreateDynamicObject(8838, 470.00131, 5393.26025, 23.31500,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[350] = CreateDynamicObject(8838, 453.19269, 5407.42041, 23.31570,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[351] = CreateDynamicObject(1634, 432.32959, 5353.77930, 25.17730,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[352] = CreateDynamicObject(8838, 392.76749, 5353.77930, 23.31640,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[353] = CreateDynamicObject(1634, 411.05420, 5353.77930, 24.81730,   0.00000, 0.00000, 270.12000);
		ExceptionalObj[354] = CreateDynamicObject(8838, 385.69739, 5317.22314, 7.54350,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[355] = CreateDynamicObject(8838, 363.16159, 5353.77930, 23.31570,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[356] = CreateDynamicObject(8838, 371.06049, 5275.57227, 23.31570,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[357] = CreateDynamicObject(8838, 333.20291, 5353.77930, 14.78360,   0.00000, 32.00000, 180.00000);
		ExceptionalObj[358] = CreateDynamicObject(8838, 366.55380, 5329.21338, 7.54300,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[359] = CreateDynamicObject(3458, 366.55380, 5365.30176, 7.54350,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[360] = CreateDynamicObject(8838, 333.34528, 5407.05713, 23.31570,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[361] = CreateDynamicObject(8838, 337.71402, 5275.57227, 23.31570,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[362] = CreateDynamicObject(3458, 318.95300, 5314.06006, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[363] = CreateDynamicObject(8838, 318.75430, 5329.14941, 23.31570,   0.00000, 0.00000, 89.40002);
		ExceptionalObj[364] = CreateDynamicObject(3458, 318.95908, 5364.70752, 23.20295,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[365] = CreateDynamicObject(3458, 366.51895, 5403.93799, 7.54530,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[366] = CreateDynamicObject(3437, 414.39371, 5405.25830, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[367] = CreateDynamicObject(3437, 414.47900, 5408.84033, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[368] = CreateDynamicObject(3437, 403.28860, 5408.84033, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[369] = CreateDynamicObject(3437, 403.03061, 5405.25830, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[370] = CreateDynamicObject(8838, 366.55380, 5297.12305, 7.54350,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[371] = CreateDynamicObject(8838, 366.55380, 5275.84473, 7.54300,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[372] = CreateDynamicObject(3458, 386.09180, 5347.75293, 7.54400,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[373] = CreateDynamicObject(8838, 422.10931, 5347.75293, 7.54400,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[374] = CreateDynamicObject(3458, 454.06265, 5347.75293, 7.54500,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[375] = CreateDynamicObject(8838, 318.98178, 5387.81494, 23.22191,   0.00000, 0.00000, 89.40002);
		ExceptionalObj[376] = CreateDynamicObject(8838, 366.76712, 5407.10059, 23.31570,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[377] = CreateDynamicObject(3437, 392.22400, 5408.84033, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[378] = CreateDynamicObject(3437, 392.19641, 5405.25830, 24.60210,   92.00000, 90.00000, 0.00000);
		ExceptionalObj[379] = CreateDynamicObject(1633, 385.83740, 5407.10791, 24.69110,   -16.00000, 0.00000, 90.00000);
		ExceptionalObj[380] = CreateDynamicObject(1633, 431.59796, 5407.17969, 24.55110,   -16.00000, 0.00000, 90.00000);
		ExceptionalObj[381] = CreateDynamicObject(1633, 423.19000, 5407.16895, 24.69110,   -14.00000, 0.00000, 90.00000);
		ExceptionalObj[382] = CreateDynamicObject(17563, 413.15591, 5289.56201, -2.50850,   0.00000, 0.00000, -96.06000);
		ExceptionalObj[383] = CreateDynamicObject(19840, 427.71194, 5450.84326, 2.80810,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[384] = CreateDynamicObject(19840, 380.89557, 5451.54199, 2.80810,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[385] = CreateDynamicObject(19840, 342.67551, 5451.06299, 2.80810,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[386] = CreateDynamicObject(19840, 304.51096, 5448.27832, 2.80810,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[387] = CreateDynamicObject(19840, 269.10986, 5396.40283, 2.80810,   0.00000, 0.00000, 95.10001);
		ExceptionalObj[388] = CreateDynamicObject(19840, 268.60403, 5303.20068, 2.80810,   0.00000, 0.00000, 95.10001);
		ExceptionalObj[389] = CreateDynamicObject(19840, 328.50476, 5211.56836, 2.80810,   0.00000, 0.00000, 180.18002);
		ExceptionalObj[390] = CreateDynamicObject(19840, 446.26620, 5211.72705, 2.80810,   0.00000, 0.00000, 180.18002);
		ExceptionalObj[391] = CreateDynamicObject(19840, 518.55688, 5237.17383, 2.80810,   0.00000, 0.00000, 263.34003);
		ExceptionalObj[392] = CreateDynamicObject(19840, 510.40512, 5332.66602, 2.80810,   0.00000, 0.00000, 263.34003);
		ExceptionalObj[393] = CreateDynamicObject(19840, 516.02936, 5412.22070, 2.80810,   0.00000, 0.00000, 263.34003);
		ExceptionalObj[394] = CreateDynamicObject(19840, 500.37125, 5454.54053, 2.80810,   0.00000, 0.00000, 352.86002);
		ExceptionalObj[395] = CreateDynamicObject(18751, 412.88040, 5144.65527, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[396] = CreateDynamicObject(18751, 510.81561, 5150.39697, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[397] = CreateDynamicObject(18751, 313.11652, 5145.02197, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[398] = CreateDynamicObject(18751, 208.62407, 5176.91553, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[399] = CreateDynamicObject(18751, 207.15034, 5279.37451, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[400] = CreateDynamicObject(18751, 205.76608, 5382.84131, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[401] = CreateDynamicObject(18751, 209.99866, 5489.19531, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[402] = CreateDynamicObject(18751, 298.93332, 5524.89990, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[403] = CreateDynamicObject(18751, 400.46701, 5525.50098, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[404] = CreateDynamicObject(18751, 494.16202, 5525.58545, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[405] = CreateDynamicObject(18751, 580.36707, 5478.65625, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[406] = CreateDynamicObject(18751, 579.75220, 5374.21533, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[407] = CreateDynamicObject(18751, 584.89752, 5266.76855, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[408] = CreateDynamicObject(18751, 575.39838, 5170.03174, 6.11376,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[409] = CreateDynamicObject(615, 239.46068, 5284.78320, 8.03763,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[410] = CreateDynamicObject(616, 242.98500, 5273.21777, 12.32911,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[411] = CreateDynamicObject(656, 213.20074, 5264.12305, 12.32911,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[412] = CreateDynamicObject(3898, 254.80383, 5226.71094, 12.57407,   0.00000, 0.00000, -67.98000);
		ExceptionalObj[413] = CreateDynamicObject(16061, 244.43306, 5219.36182, 18.36366,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[414] = CreateDynamicObject(622, 266.47290, 5167.32422, 4.47977,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[415] = CreateDynamicObject(710, 301.83313, 5160.63574, 20.26498,   0.00000, 0.00000, 0.24000);
		ExceptionalObj[416] = CreateDynamicObject(712, 298.70416, 5170.09180, 15.92619,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[417] = CreateDynamicObject(620, 285.02289, 5191.70264, 15.83975,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[418] = CreateDynamicObject(9105, 404.73712, 5112.86328, 27.83077,   0.00000, 0.00000, 3.00000);
		ExceptionalObj[419] = CreateDynamicObject(3898, 178.07484, 5277.73096, 12.57407,   0.00000, 0.00000, -2.45999);
		ExceptionalObj[420] = CreateDynamicObject(620, 340.75241, 5165.70361, 6.11140,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[421] = CreateDynamicObject(3898, 244.90239, 5458.00342, 14.79896,   0.00000, 0.00000, -126.47999);
		ExceptionalObj[422] = CreateDynamicObject(620, 404.01547, 5187.07910, 17.73137,   0.00000, 0.00000, 6.12226);
		ExceptionalObj[423] = CreateDynamicObject(3898, 315.45657, 5505.99951, 14.79896,   0.00000, 0.00000, -173.81999);
		ExceptionalObj[424] = CreateDynamicObject(3898, 483.66058, 5489.23096, 14.79896,   0.00000, 0.00000, -219.41998);
		ExceptionalObj[425] = CreateDynamicObject(3898, 283.58954, 5539.09668, 14.79896,   0.00000, 0.00000, -83.82001);
		ExceptionalObj[426] = CreateDynamicObject(3898, 379.69571, 5559.47607, 14.79896,   0.00000, 0.00000, -83.16001);
		ExceptionalObj[427] = CreateDynamicObject(3898, 174.26376, 5332.51318, 14.79896,   0.00000, 0.00000, -356.03992);
		ExceptionalObj[428] = CreateDynamicObject(3898, 361.58542, 5112.45850, 12.57407,   0.00000, 0.00000, 100.08001);
		ExceptionalObj[429] = CreateDynamicObject(3898, 469.03244, 5117.59131, 12.57407,   0.00000, 0.00000, 100.08001);
		ExceptionalObj[430] = CreateDynamicObject(3898, 510.95773, 5081.19385, 12.57407,   0.00000, 0.00000, 100.08001);
		ExceptionalObj[431] = CreateDynamicObject(3898, 535.60345, 5467.65186, 14.79896,   0.00000, 0.00000, -219.41998);
		ExceptionalObj[432] = CreateDynamicObject(3898, 557.30792, 5450.73145, 14.79896,   0.00000, 0.00000, -244.91995);
		ExceptionalObj[433] = CreateDynamicObject(3898, 568.80408, 5436.64990, 14.79896,   0.00000, 0.00000, -262.07996);
		ExceptionalObj[434] = CreateDynamicObject(3898, 565.37317, 5377.48730, 14.79896,   0.00000, 0.00000, -274.43994);
		ExceptionalObj[435] = CreateDynamicObject(3898, 563.60358, 5330.96191, 14.79896,   0.00000, 0.00000, -281.87991);
		ExceptionalObj[436] = CreateDynamicObject(3898, 568.44098, 5308.72607, 14.79896,   0.00000, 0.00000, -281.87991);
		ExceptionalObj[437] = CreateDynamicObject(3898, 543.64166, 5268.56543, 14.79896,   0.00000, 0.00000, -293.03992);
		ExceptionalObj[438] = CreateDynamicObject(3898, 612.20117, 5302.02637, 14.79896,   0.00000, 0.00000, 186.90311);
		ExceptionalObj[439] = CreateDynamicObject(3898, 636.32806, 5195.66211, 14.79896,   0.00000, 0.00000, 186.90311);
		ExceptionalObj[440] = CreateDynamicObject(8483, 254.12317, 5336.59277, 9.38617,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[441] = CreateDynamicObject(620, 375.24652, 5184.70410, 20.34479,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[442] = CreateDynamicObject(620, 490.48682, 5187.83643, 18.91077,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[443] = CreateDynamicObject(8483, 512.63617, 5213.51953, 5.27306,   0.00000, 0.00000, 123.96000);
		ExceptionalObj[444] = CreateDynamicObject(8483, 524.39063, 5289.28516, 5.12026,   0.00000, 0.00000, -175.86000);
		ExceptionalObj[445] = CreateDynamicObject(8483, 349.65451, 5203.04834, 8.45252,   0.00000, 0.00000, 66.95999);
		ExceptionalObj[446] = CreateDynamicObject(8483, 319.70349, 5455.21973, 3.04735,   0.00000, 0.00000, -100.92000);
		ExceptionalObj[447] = CreateDynamicObject(8483, 415.08261, 5454.93896, 3.04735,   0.00000, 0.00000, -100.92000);
		ExceptionalObj[448] = CreateDynamicObject(8483, 491.13507, 5457.27393, 3.04735,   0.00000, 0.00000, -100.92000);
		ExceptionalObj[449] = CreateDynamicObject(8483, 521.96271, 5389.66504, 5.88835,   0.00000, 0.00000, -158.34000);
		ExceptionalObj[450] = CreateDynamicObject(18752, 383.11014, 5607.33496, -0.46428,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[451] = CreateDynamicObject(712, 538.22479, 5371.10596, 17.31300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[452] = CreateDynamicObject(712, 534.72546, 5398.47510, 17.31300,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[453] = CreateDynamicObject(712, 443.86337, 5193.94775, 17.38360,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[454] = CreateDynamicObject(710, 423.58749, 5195.44336, 22.80767,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[455] = CreateDynamicObject(710, 311.92557, 5179.41602, 7.31580,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[456] = CreateDynamicObject(710, 317.94131, 5197.41504, 13.17187,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[457] = CreateDynamicObject(710, 251.04883, 5228.83252, 13.25874,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[458] = CreateDynamicObject(710, 252.20433, 5311.10645, 12.05434,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[459] = CreateDynamicObject(710, 258.87015, 5427.63623, 8.86552,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[460] = CreateDynamicObject(712, 233.13255, 5398.01123, 8.86552,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[461] = CreateDynamicObject(712, 247.49049, 5379.12061, 19.17722,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[462] = CreateDynamicObject(712, 257.06540, 5364.75635, 27.32660,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[463] = CreateDynamicObject(622, 485.69092, 5202.56299, 17.32776,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[464] = CreateDynamicObject(622, 539.83423, 5286.84033, 8.37158,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[465] = CreateDynamicObject(622, 524.93298, 5443.84180, 14.82643,   0.00000, 0.00000, 117.17999);
		ExceptionalObj[466] = CreateDynamicObject(622, 436.87347, 5461.83398, 12.82629,   0.00000, 0.00000, -117.12000);
		ExceptionalObj[467] = CreateDynamicObject(622, 368.71841, 5464.95801, 13.56563,   0.00000, 0.00000, -229.56000);
		ExceptionalObj[468] = CreateDynamicObject(1225, 366.69299, 5422.72363, 9.78142,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[469] = CreateDynamicObject(712, 341.28543, 5213.13672, 3.18145,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[470] = CreateDynamicObject(11489, 342.78088, 5391.59229, 0.14577,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[471] = CreateDynamicObject(11489, 342.16544, 5373.16650, 0.14577,   0.00000, 0.00000, -183.48003);
		ExceptionalObj[472] = CreateDynamicObject(11489, 337.50995, 5272.80664, 0.14577,   0.00000, 0.00000, -183.48003);
		ExceptionalObj[473] = CreateDynamicObject(11489, 336.80789, 5288.21240, 0.14577,   0.00000, 0.00000, -359.69998);
		ExceptionalObj[474] = CreateDynamicObject(8838, 470.00131, 5289.73291, 23.31570,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[475] = CreateDynamicObject(8838, 469.98709, 5295.26367, 23.31500,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[476] = CreateDynamicObject(10357, 532.68384, 5186.44727, 90.81540,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[477] = CreateDynamicObject(3458, 318.49634, 5293.28125, 23.20295,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[478] = CreateDynamicObject(3458, 237.00000, 7047.00000, 5289.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[479] = CreateDynamicObject(3458, 236.00000, 1624.00000, 5286.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[480] = CreateDynamicObject(3458, 237.00000, 6929.00000, 5289.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[481] = CreateDynamicObject(3458, 237.00000, 7468.00000, 5289.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[482] = CreateDynamicObject(3458, 237.00000, 7794.00000, 5289.00000,   11.00000, 0.00000, 0.00000);
		ExceptionalObj[483] = CreateDynamicObject(3458, 237.00000, 7749.00000, 5289.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[484] = CreateDynamicObject(3458, 237.00000, 2371.00000, 5289.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[485] = CreateDynamicObject(3458, 236.00000, 9989.00000, 5288.00000,   178.00000, 0.00000, 0.00000);
		ExceptionalObj[486] = CreateDynamicObject(3458, 434.28699, 5295.70557, 15.55600,   0.00000, 23.00000, -270.00000);
		ExceptionalObj[487] = CreateDynamicObject(17563, 409.93640, 5384.13574, -2.50850,   0.00000, 0.00000, 98.00000);
		//Derby 2
		ExceptionalObj[488] = CreateDynamicObject(971, 3652.06104, -2041.82007, 453.67130,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[489] = CreateDynamicObject(971, 3654.86279, -2045.42261, 453.67130,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[490] = CreateDynamicObject(971, 3649.49219, -2045.42261, 453.67130,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[491] = CreateDynamicObject(971, 3652.06104, -2048.87061, 453.67130,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[492] = CreateDynamicObject(972, 3733.81738, -2035.45520, 449.97147,   0.00000, 0.00000, -180.00000);
		ExceptionalObj[493] = CreateDynamicObject(972, 3657.84619, -1963.64160, 449.97147,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[494] = CreateDynamicObject(972, 3733.86816, -2050.87964, 449.97147,   0.00000, 0.00000, -180.00000);
		ExceptionalObj[495] = CreateDynamicObject(972, 3653.54395, -2044.61023, 449.22556,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[496] = CreateDynamicObject(972, 3642.49756, -1963.64282, 449.97147,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[497] = CreateDynamicObject(972, 3651.87549, -2047.50989, 449.22556,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[498] = CreateDynamicObject(972, 3653.54395, -2052.10742, 449.22556,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[499] = CreateDynamicObject(972, 3646.19629, -2047.50989, 449.22556,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[500] = CreateDynamicObject(972, 3662.09521, -2126.90454, 449.97147,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[501] = CreateDynamicObject(972, 3570.54395, -2039.60840, 449.97147,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[502] = CreateDynamicObject(972, 3646.47461, -2126.90698, 449.97147,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[503] = CreateDynamicObject(972, 3570.54639, -2055.18042, 449.97147,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[504] = CreateDynamicObject(1482, 3671.50928, -2026.02490, 448.73581,   0.00000, 0.00000, 45.00000);
		ExceptionalObj[505] = CreateDynamicObject(1482, 3633.14233, -2026.22766, 448.68594,   0.00000, 0.00000, -45.00000);
		ExceptionalObj[506] = CreateDynamicObject(1482, 3670.97266, -2064.24219, 448.68613,   0.00000, 0.00000, -45.00000);
		ExceptionalObj[507] = CreateDynamicObject(1482, 3633.31958, -2064.25000, 448.68613,   0.00000, 0.00000, 45.00000);
		ExceptionalObj[508] = CreateDynamicObject(1633, 3674.74048, -2014.61768, 449.92520,   -15.47000, 0.00000, 225.00000);
		ExceptionalObj[509] = CreateDynamicObject(1633, 3682.71680, -2022.71423, 449.90521,   -15.47000, 0.00000, 45.00000);
		ExceptionalObj[510] = CreateDynamicObject(1633, 3682.64673, -2067.73022, 449.87521,   -15.47000, 0.00000, 135.00000);
		ExceptionalObj[511] = CreateDynamicObject(1633, 3629.59033, -2014.86523, 449.88000,   -15.47000, 0.00000, 135.00000);
		ExceptionalObj[512] = CreateDynamicObject(1633, 3674.63013, -2075.83447, 449.87521,   -15.47000, 0.00000, -45.00000);
		ExceptionalObj[513] = CreateDynamicObject(1633, 3621.85938, -2022.66528, 449.88000,   -15.47000, 0.00000, 315.00000);
		ExceptionalObj[514] = CreateDynamicObject(1633, 3629.85742, -2075.77344, 449.87479,   -15.47000, 0.00000, 45.00000);
		ExceptionalObj[515] = CreateDynamicObject(1633, 3621.90186, -2067.81909, 449.85480,   -15.47000, 0.00000, 225.00000);
		ExceptionalObj[516] = CreateDynamicObject(1634, 3652.28613, -2037.38672, 456.19675,   30.08000, 0.00000, -180.00000);
		ExceptionalObj[517] = CreateDynamicObject(1634, 3660.00732, -2045.33765, 456.22174,   30.08000, 0.00000, -270.00000);
		ExceptionalObj[518] = CreateDynamicObject(1634, 3652.28613, -2034.26086, 452.54691,   18.04800, 0.00000, -180.00000);
		ExceptionalObj[519] = CreateDynamicObject(1634, 3663.15186, -2045.31165, 452.54691,   18.04800, 0.00000, -270.00000);
		ExceptionalObj[520] = CreateDynamicObject(1634, 3652.28613, -2053.08203, 456.19675,   30.08000, 0.00000, -360.00000);
		ExceptionalObj[521] = CreateDynamicObject(1634, 3644.40576, -2045.33765, 456.22174,   30.08000, 0.00000, -450.00000);
		ExceptionalObj[522] = CreateDynamicObject(1634, 3652.28613, -2056.18604, 452.54691,   18.04800, 0.00000, -360.00000);
		ExceptionalObj[523] = CreateDynamicObject(1634, 3641.27832, -2045.31165, 452.54691,   18.04800, 0.00000, -450.00000);
		ExceptionalObj[524] = CreateDynamicObject(3458, 3686.71216, -2010.75854, 448.59607,   0.00000, 0.00000, 45.00000);
		ExceptionalObj[525] = CreateDynamicObject(3458, 3669.88062, -1987.21106, 448.59106,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[526] = CreateDynamicObject(3458, 3710.23315, -2027.63623, 448.59232,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[527] = CreateDynamicObject(3458, 3687.50903, -2045.26160, 448.59607,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[528] = CreateDynamicObject(3458, 3652.21021, -2009.93579, 448.59607,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[529] = CreateDynamicObject(3458, 3710.23315, -2045.26160, 448.59607,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[530] = CreateDynamicObject(3458, 3710.23315, -2045.26160, 448.59106,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[531] = CreateDynamicObject(3458, 3652.21021, -1987.21106, 448.59607,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[532] = CreateDynamicObject(3458, 3652.21021, -1987.21106, 448.58231,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[533] = CreateDynamicObject(3458, 3652.21021, -2027.56067, 448.58856,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[534] = CreateDynamicObject(3458, 3652.21021, -2027.56067, 448.58606,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[535] = CreateDynamicObject(3458, 3669.85962, -2045.26160, 448.59607,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[536] = CreateDynamicObject(3458, 3669.85962, -2045.26160, 448.59357,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[537] = CreateDynamicObject(3458, 3727.83179, -2045.26160, 448.59607,   0.00000, 0.00000, -90.00000);
		ExceptionalObj[538] = CreateDynamicObject(3458, 3652.21021, -1969.58545, 448.59607,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[539] = CreateDynamicObject(3458, 3710.23315, -2062.88525, 448.59232,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[540] = CreateDynamicObject(3458, 3634.58667, -1987.21106, 448.59232,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[541] = CreateDynamicObject(3458, 3634.55981, -2045.26160, 448.59607,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[542] = CreateDynamicObject(3458, 3634.55981, -2045.26160, 448.59357,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[543] = CreateDynamicObject(3458, 3652.20728, -2062.93677, 448.59357,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[544] = CreateDynamicObject(3458, 3652.20728, -2062.93677, 448.59106,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[545] = CreateDynamicObject(3458, 3686.60181, -2079.86035, 448.59607,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[546] = CreateDynamicObject(3458, 3617.60767, -2010.83264, 448.59607,   0.00000, 0.00000, 135.00000);
		ExceptionalObj[547] = CreateDynamicObject(3458, 3616.93530, -2045.26160, 448.59607,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[548] = CreateDynamicObject(3458, 3652.20728, -2080.58325, 448.59607,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[549] = CreateDynamicObject(3458, 3669.85474, -2103.26440, 448.59357,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[550] = CreateDynamicObject(3458, 3594.18237, -2027.61023, 448.59232,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[551] = CreateDynamicObject(3458, 3652.20728, -2103.26440, 448.59607,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[552] = CreateDynamicObject(3458, 3652.20728, -2103.26440, 448.58981,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[553] = CreateDynamicObject(3458, 3594.18237, -2045.26160, 448.59607,   0.00000, 0.00000, 270.00000);
		ExceptionalObj[554] = CreateDynamicObject(3458, 3594.18237, -2045.26160, 448.59232,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[555] = CreateDynamicObject(3458, 3617.76001, -2079.70801, 448.59607,   0.00000, 0.00000, 45.00000);
		ExceptionalObj[556] = CreateDynamicObject(3458, 3634.58081, -2103.26440, 448.59357,   0.00000, 0.00000, 90.00000);
		ExceptionalObj[557] = CreateDynamicObject(3458, 3594.18237, -2062.91016, 448.59106,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[558] = CreateDynamicObject(3458, 3652.20728, -2120.86108, 448.59607,   0.00000, 0.00000, 180.00000);
		ExceptionalObj[559] = CreateDynamicObject(3458, 3576.41748, -2044.93420, 448.59607,   0.00000, 0.00000, 270.00000);
		ExceptionalObj[560] = CreateDynamicObject(9321, 3652.19702, -2045.35181, 449.21002,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[561] = CreateDynamicObject(18750, 3579.11401, -1964.18127, 470.15909,   -265.00000, 0.00000, 47.00000);
		ExceptionalObj[562] = CreateDynamicObject(1225, 3653.62305, -2042.87891, 450.46716,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[563] = CreateDynamicObject(1225, 3651.54150, -2042.85767, 450.46716,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[564] = CreateDynamicObject(1225, 3651.44800, -2045.00732, 450.46716,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[565] = CreateDynamicObject(1225, 3651.51147, -2047.11658, 450.46716,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[566] = CreateDynamicObject(1225, 3653.42358, -2047.10657, 450.46716,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[567] = CreateDynamicObject(1225, 3653.42993, -2045.09607, 450.46716,   0.00000, 0.00000, 0.00000);
		//pompa
		ExceptionalObj[568] = CreateDynamicObject(13657, 16.38046, 428.88748, 1045.52014,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[569] = CreateDynamicObject(3569, 10.00000, 2836.00000, 407.00000,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[570] = CreateDynamicObject(3569, 10.53379, 409.59656, 1044.69226,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[571] = CreateDynamicObject(3761, 118.88610, 497.77621, 1044.21228,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[572] = CreateDynamicObject(3761, 105.69804, 497.66635, 1044.21228,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[573] = CreateDynamicObject(3761, 96.00443, 497.73618, 1044.21228,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[574] = CreateDynamicObject(2669, 124.48818, 484.45605, 1043.56165,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[575] = CreateDynamicObject(11011, 22.70380, 428.01431, 1045.59766,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[576] = CreateDynamicObject(11428, -13.77240, 487.12201, 1047.77783,   0.00000, 0.00000, 142.00000);
		ExceptionalObj[577] = CreateDynamicObject(11445, -6.28860, 469.02069, 1042.40234,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[578] = CreateDynamicObject(11441, -10.47500, 451.55719, 1042.39624,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[579] = CreateDynamicObject(11443, -10.11870, 426.39871, 1042.41064,   0.00000, 0.00000, -207.00000);
		ExceptionalObj[580] = CreateDynamicObject(11088, 93.00860, 446.84210, 1048.67725,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[581] = CreateDynamicObject(3866, 50.59662, 416.84149, 1050.02844,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[582] = CreateDynamicObject(5126, 12.79540, 488.23019, 1057.50134,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[583] = CreateDynamicObject(11401, 38.78463, 488.32059, 1054.20752,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[584] = CreateDynamicObject(3474, 32.60287, 464.34247, 1049.16565,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[585] = CreateDynamicObject(1395, 53.71811, 463.01044, 1074.83044,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[586] = CreateDynamicObject(1394, 53.52235, 463.08606, 1126.91003,   0.00000, 0.00000, -127.00000);
		ExceptionalObj[587] = CreateDynamicObject(3865, 92.94690, 481.09351, 1044.03296,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[588] = CreateDynamicObject(3865, 96.87507, 480.98328, 1044.03296,   0.00000, 0.00000, 0.00000);
		ExceptionalObj[589] = CreateDynamicObject(3865, 100.84382, 480.93631, 1044.03296,   0.00000, 0.00000, 0.00000);
		return 1;
	}
	stock LHouses(){
		new resi,Cache:res = mysql_query(DBM, "SELECT COUNT(*) FROM `HoS`", true);
		cache_get_value_index_int(0,0,resi);
		cache_delete(res);
		new query[256],x=sizeof(query);
		resi++;
		for(new i=0;i<resi;i++)
		{
			mysql_format(DBM,query,x,"SELECT * FROM `HoS` WHERE `id`='%i'",i);
			tmq(query,"GetHDat","i",i);
		}
		return 1;
	}
//LogIn
	//NieLaguj¹cy ale nie dobry w spójnoœci danych
	stock SVPlayer(pid){
		new quer[119];
		new x = sizeof(quer);
		new str[250];
		for(new i=0;i<65;i++){
			format(quer,x,"%i,",PDV[pid][Achiev][i]);
			strcat(str,quer,sizeof(str));
		}
		format(quer,x,"%i",PDV[pid][Achiev][66]);
		strcat(str,quer,sizeof(str));
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `csh`='%d', `rsp`='%d' WHERE `id`='%i'",PDV[pid][Csh],PDV[pid][Rsp],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `kills`='%d',`deaths`='%d' WHERE `id`='%d'",PDV[pid][Ki],PDV[pid][De],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `deta`='%d',`sk`='%d' WHERE `id`='%d'",PDV[pid][DeTa],PDV[pid][SKi],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `ski`='%i',`sde`='%d' WHERE `id`='%d'",GetPlayerSkin(pid),PDV[pid][SDe],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `OwOf`='%d',`Bcsh`='%d' WHERE `id`='%d'",PDV[pid][OwOf],PDV[pid][Bounty][0],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `Achievs`='%s' WHERE `id`='%d'",str,PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET  `Brsp`='%d',`OKi`='%i',`ODe`='%i',`PKi`='%i' WHERE `id`='%d'",PDV[pid][Bounty][1],PDV[pid][OKi],PDV[pid][ODe],PDV[pid][PKi],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `PDe`='%i',`MKi`='%i',`MDe`='%i' WHERE `id`='%d'",PDV[pid][PDe],PDV[pid][MKi],PDV[pid][MDe],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `TotOnl`='%i',`last_ip`='%s' WHERE `id`='%d'",PDV[pid][TotOnl]+(NetStats_GetConnectedTime(pid)/1000),PDV[pid][ipP],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `colour`='%i',`SpKi`='%i',`SpDe`='%i' WHERE `id`='%d'",PDV[pid][pcolo],PDV[pid][SpKi],PDV[pid][SpDe],PDV[pid][iDP]);
		mq(quer);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `last_gpci`='%s' WHERE `id`='%d'",PDV[pid][ngpci],PDV[pid][iDP]);
		mq(quer);
		return 1;
	}
	//Lagujacy Ale dobry w spójnoœci danych
	stock SVPlayerNT(pid){
		new quer[119];
		new str[250];
		new x = sizeof(quer);
		for(new i=0;i<65;i++){
			format(quer,x,"%i,",PDV[pid][Achiev][i]);
			strcat(str,quer,sizeof(str));
		}
		format(quer,x,"%i",PDV[pid][Achiev][66]);
		strcat(str,quer,sizeof(str));
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `csh`='%d', `rsp`='%d' WHERE `id`='%i'",PDV[pid][Csh],PDV[pid][Rsp],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `kills`='%d',`deaths`='%d' WHERE `id`='%d'",PDV[pid][Ki],PDV[pid][De],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `deta`='%d',`sk`='%d' WHERE `id`='%d'",PDV[pid][DeTa],PDV[pid][SKi],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `ski`='%i',`sde`='%d' WHERE `id`='%d'",GetPlayerSkin(pid),PDV[pid][SDe],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `OwOf`='%d',`Bcsh`='%d' WHERE `id`='%d'",PDV[pid][OwOf],PDV[pid][Bounty][0],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `Achievs`='%s' WHERE `id`='%d'",str,PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET  `Brsp`='%d',`OKi`='%i',`ODe`='%i',`PKi`='%i' WHERE `id`='%d'",PDV[pid][Bounty][1],PDV[pid][OKi],PDV[pid][ODe],PDV[pid][PKi],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `PDe`='%i',`MKi`='%i',`MDe`='%i' WHERE `id`='%d'",PDV[pid][PDe],PDV[pid][MKi],PDV[pid][MDe],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `TotOnl`='%i',`last_ip`='%s' WHERE `id`='%d'",PDV[pid][TotOnl]+(NetStats_GetConnectedTime(pid)/1000),PDV[pid][ipP],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `colour`='%i',`SpKi`='%i',`SpDe`='%i' WHERE `id`='%d'",PDV[pid][pcolo],PDV[pid][SpKi],PDV[pid][SpDe],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		mysql_format(DBM,quer,x,"UPDATE `plys` SET `last_gpci`='%s' WHERE `id`='%d'",PDV[pid][ngpci],PDV[pid][iDP]);
		mysql_query(DBM,quer,false);
		return 1;
	}
	stock RPlayer(pid,pss[65])
	{
		new nick[25];
		strcat(nick, GetPN(pid),sizeof(nick));
		
		for(new i=0; i< 10;i++)
			{PDV[pid][slt][i] = random(49) + 47;}		
		PDV[pid][slt][10] = 0;
		SHA256_PassHash(pss, PDV[pid][slt], PDV[pid][pass], 65);
		SqlEscStr(nick,nick);
		new query[170];
		mysql_format(DBM, query, sizeof(query), "INSERT INTO `plys`(`nck`, `pass`,`salt`) VALUES ('%s','%s','%s')",nick,PDV[pid][pass],PDV[pid][slt]);
		mq(query);
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {33ff33}Gracz: %s wybra³(a) {ff0033}Ja{ffff33}mai{33cc00}ca{33ff33}, Witamy nowego kumpla!",nick);
		PDV[pid][NoAcc] = false;
		TogglePlayerSpectating(pid, 0);
		PDV[pid][LogIn] = true;
		SendDeathMessage(INVALID_PLAYER_ID,pid,200);
		SRe(pid,PDV[pid][Rsp]);	
		return 1;
	}
	stock PPCheck(pid,pss[])
	{
		if(6 > strlen(pss)||strlen(pss) > 32) return -1;
		if(!IsPlayerConnected(pid)) return 2;
		new pas[65];
		SHA256_PassHash(pss, PDV[pid][slt], pas, 65);
		if(!strcmp(pas,PDV[pid][pass],false) && !isnull(pas) && !isnull(PDV[pid][pass])) {
			return 1;
		}
		else return 0;
	}
	stock LPlayer(pid)
	{
		new query[63];
		mysql_format(DBM, query, sizeof(query),"SELECT * FROM `plys` WHERE `nck` = '%s'", GetPN(pid));
		tmq(query,"GetPDat","i",pid);
		return 1;
	}
	stock Autor(pid){
		new str[479],iz = sizeof(str);
		strcat(str,"{ff0033}Ja{ffff33}mai{33cc00}ca {007fff}Server {00ff66}Wersja:"VER"\n",iz);
		strcat(str,"\n",iz);
		strcat(str,"{00ff66}Projekt powsta³ 25 listopada 2018 roku.\n",iz);
		strcat(str,"     {00ff66}Gamemod pisany przez {00cc99}KorwinPresident\n",iz);
		strcat(str,"\n",iz);
		strcat(str,"    {00ff66} Podziêkowania dla:\n",iz);
		strcat(str,"\n",iz);
		strcat(str,"{00cc99}\tEMTI - Za Obiekty\n",iz);
		strcat(str,"{00cc99}\tStrajger_ - Za paczkê obiektów z Polski Serwer Zabawy\n",iz);
		strcat(str,"{00cc99}\tBlueG - Za MySQL R40\n",iz);
		strcat(str,"{00cc99}\tYourShadow - Za Pawn.CMD i Pawn.Raknet\n",iz);
		strcat(str,"{00cc99}\tEmmet_ - Za edialog.inc\n",iz);
		strcat(str,"{00cc99}\tY_Less - Za sscanf2\n",iz);

		Dialog_Show(pid,Autor,DIALOG_STYLE_MSGBOX,"Autorzy",str,"Powrót","Powrót");
		return 1;
	}
	stock Kontakt(pid){
		new str[128],iz = sizeof(str);
		strcat(str,"{00cccc}\tEMTI:\n",iz);
		strcat(str,"{00cc99}\t-GG:61694533\n",iz);
		strcat(str,"{00cc99}\t-Discord:EMTI#5934\n",iz);
		strcat(str,"\n",iz);
		strcat(str,"{00cccc}\tKorwinPresident:\n",iz);
		strcat(str,"{00cc99}\t-Discord:MigelOwO#2167\n",iz);
		Dialog_Show(pid,Kon,DIALOG_STYLE_MSGBOX,"Kontakt",str,"Powrót","Powrót");
		return 1;
	}
	stock Regulamin(playerid){
		new str[1755],iz=sizeof(str);
		strcat(str,"{3399cc}REGULAMIN {ffffff}| {ff0033}Ja{ffff33}mai{33cc00}ca {007fff}Server{FFFFFF}\n{66ff66}1.{00cccc}Zakazuje siê reklamowania serwerów poprzez wysy³anie adresów ip czy te¿ nazw.\n",iz);
		strcat(str,"{66ff66}2.{00cccc}Surowo zakazuje siê podszywania pod administratorów i graczy.\n{66ff66}3.{00cccc}Zakazuje siê wysy³ania fa³szywych zg³oszeñ do administracji.\n{66ff66}4.{00cccc}Zakazuje siê wy³udzania rangi, doœwiadczenia 'exp' oraz pieniêdzy wirtualnych jak i realnych.\n",iz);
		strcat(str,"{66ff66}5.{00cccc}Zakazuje siê u¿ywania jakichkolwiek modyfikacji integruj¹cych w gre (np: Spider-mod, s0beit, aim-bot, god)\n{66ff66}6.{00cccc}Zakazuje siê wykorzystywania b³êdów serwera do czerpania w³asnych korzyœci.\n",iz);
		strcat(str,"{66ff66}7.{00cccc}Zabronione jest ukrywanie 'cheatera' ze wzglêdów kole¿eñskich czy posiadania z niego korzyœci.\n{66ff66}8.{00cccc}Zakazuje siê prowokowaæ do k³ótni, obra¿aæ i wyœmiewaæ.\n{66ff66}9.{00cccc}Zakazuje siê omijania cenzury i zaœmiecania chatów flood'owaniem, spam'em.\n",iz);
		strcat(str,"{66ff66}10.{00cccc}Zakazuje siê uciekania z podjêtych walk poprzez minimalizowanie, wy³¹czenie gry.\n{66ff66}11.{00cccc}Zakazuje siê wykonywaæ SpawnKill na sparingach gangowych.\n",iz);
		strcat(str,"{66ff66}12.{00cccc}Zakazuje siê omijanie kary skutkujac jej wyd³u¿eniem b¹dŸ zmian¹ (tyczy sie równie¿ multi kont).\n{66ff66}13.{00cccc}Zakazuje siê obra¿ania uczuæ religijnych i ich wyznawców.\n{66ff66}14.{00cccc}Zakazuje siê znêcania nad graczami pod wzglêdem psychicznym.\n{66ff66}15.{00cccc}Zakazuje siê udostêpniania danych osobowych bez jej zgody.\n",iz);
		strcat(str,"{66ff66}16.{00cccc}Wszelkie wykroczenia które stawiaj¹ serwer w z³ym swietle bêd¹ karane zale¿nie od sytuacji.\n",iz);
		strcat(str,"{ff0033}REGULAMIN NIE MOZE BYÆ KOPIOWANY BEZ ZGODY AUTORA!\n{ff0033}Ja{ffff33}ma{33cc00}ica {007fff}Server {3399cc}2018{ffffff}-{3399cc}2019\n",iz);
		Dialog_Show(playerid, ShowRD, DIALOG_STYLE_MSGBOX, "REGULAMIN",str, "OK", "OK");
		return 1;
	}
	stock areg(playerid){
		new str[1310],iz = sizeof(str);
		strcat(str,"{3399cc}REGULAMIN ADMINISTRACJI {ffffff}| {ff0033}Ja{ffff33}ma{33cc00}ica {007fff}Server{FFFFFF}\n",iz);
		strcat(str,"{66ff66}1.{00cccc}Zabronione jest obra¿anie, poni¿anie, stawianie w negatywnym œwietle i wyœmiewanie graczy.\n",iz);
		strcat(str,"{66ff66}2.{00cccc}Katygoryczny zakaz ujawniania jakichkolwiek informacji z dzia³u administracji dla osób nieupowa¿nionych.\n",iz);
		strcat(str,"{66ff66}3.{00cccc}Zakazuje siê wstrzymywania czy te¿ przeci¹gania do ukarania / odbanowania gracza ze wzglêdów na znajomoœci.\n",iz);
		strcat(str,"{66ff66}4.{00cccc}Zakaz pomagania graczom w formie leczenia ich czy te¿ uzupe³niania kamizelki w momencie ich walki.\n",iz);
		strcat(str,"{66ff66}5.{00cccc}Zakaz pomagania graczom daj¹c im jak¹kolwiek przewagê nad innymi b¹dŸ daj¹c mu korzyœci.\n",iz);
		strcat(str,"{66ff66}6.{00cccc}Katygoryczny zakaz wykorzystywania swojej rangi do w³asnych celów prywatnych.\n",iz);
		strcat(str,"{66ff66}7.{00cccc}Administrator ma obowi¹zek reagowaæ na zg³oszenia graczy i ich proœby jeœli s¹ mo¿liwe.\n",iz);
		strcat(str,"{66ff66}8.{00cccc}Spory miêdzy administracj¹ i graczami powinny byæ wyjaœniane b¹dŸ zapobiegane.\n",iz);
		strcat(str,"{66ff66}9.{00cccc}Administrator ma obowi¹zek zmieniaæ has³o dostêpu do rangi raz na miesi¹c.\n",iz);
		strcat(str,"{ff0033}Z³amanie regulaminu skutkuje zale¿nie od sytuacji utrat¹ rangi.\n",iz);
		strcat(str,"{ff0033}REGULAMIN NIE MOZE BYÆ KOPIOWANY BEZ ZGODY AUTORA!\n",iz);

		strcat(str,"{ff0033}Ja{ffff33}ma{33cc00}ica {007fff}Server {3399cc}2018{ffffff}-{3399cc}2019\n",iz);
		Dialog_Show(playerid, ShowRD, DIALOG_STYLE_MSGBOX, "REGULAMIN ADMINISTRACJI", str, "OK", "OK");
		return 1;
	}
//ZABAWY
	stock StartCh(){
		GM[pl][4] = 0;
		foreach(Player,i){
			if(PDV[i][Plays] == 5){
				GM[pl][4]++;
			}
		}
		if(GM[pl][4] >= 3){
			GM[gCh] = -2;
			new c = GM[aCh] = random(sizeof(ChS));
			foreach(Player,i){
				if(PDV[i][Plays] == 5){
					SetPlayerPos(i, ChS[c][0],ChS[c][1],ChS[c][2]);
					SetPlayerFacingAngle(i, ChS[c][3]);
					SetPlayerVirtualWorld(i,55);
					SetPlayerInterior(i, floatround(ChS[c][4],floatround_round));
				}
				else if(PDV[i][Plays] == 6){
					PDV[i][CtD] = GetTickCount()+20000;
					PDV[i][SetF] = 5;
				}
			}
		}
		return 1;
	}
	stock EndCh(bool:Wii){
		switch(Wii){
			case 0:{
				foreach(Player,i){
					if(PDV[i][Plays] == 5){
						GiRe(i,25);
						GiPlMo(i,10000);
						PDV[i][Plays] = 0;
						ReS(i);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wygra³eœ Chowanego otrzyma³eœ 25 Expa i 10k$");

					}
				}
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Chowany zakonczony wygran¹ chowaj¹cych");
			}
			case 1:{
				foreach(Player,i){
					if(PDV[i][Plays] == 6){
						GiRe(i,35);
						GiPlMo(i,20000);
						ResetPlayerWeapons(i);
						PDV[i][Plays] = 0;
						ReS(i);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wygra³eœ Chowanego otrzyma³eœ 35 Expa i 20k$");
						break;
					}
				}
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ffaaaa}Chowany zakonczony wygran¹ szukaj¹cego");				
			}
		}
		GM[gCh] = -1;
		return 1;
	}
	CMD:ch(playerid,params[]){
		if(GM[gCh] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Chowany ju¿ trwa!");return 1;}
		new c=0;
		foreach(Player,i){
			if(c >= 10){
				break;
			}
			else if(PDV[i][Plays] == 5){
				if(c == 2){PDV[i][Plays] = 6;}
				c++;
			}
		}
		if(c >= 2 && GM[gCh] == -1){
			GM[gCh] = GetTickCount()+10000;
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}/ch rozpocznie siê za 10 sekund");
		}
		if(c <= 10){
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisa³eœ siê na chowany");
			PDV[playerid][Plays] = 5;
			GM[pl][5] = c;
		}else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| Ju¿ jest max graczy na chowanym");}
		return 1;
	}
	CMD:kch(playerid,params[]){
		if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
		foreach(Player,i){
			if(PDV[i][Plays] == 5 || PDV[i][Plays] == 6){
				PDV[i][Plays] = 0;
				ReS(i);
			}
		}
		GM[pl][4] = 0;
		GM[gCh] = -1;
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Admin zakoñczy³ Chowanego!");
		return 1;
	}
	stock StartSmo(){
		GM[pl][3] = 0;
		new c;
		foreach(Player,i){
			if(PDV[i][Plays] == 4){
				GM[pl][3]++;
				c++;
			}
		}	
		if(GM[pl][3] >= 2){
			GM[Smo] = -2;
			foreach(Player,i){
				if(PDV[i][Plays] == 4){
					PDV[i][cID] = CreateVehicle(556,SmoS[c][0],SmoS[c][1],SmoS[c][2],SmoS[c][3],-1,-1,-1);
					SetPlayerPos(i,SmoS[c][0],SmoS[c][1],SmoS[c][2]);
					SetPlayerFacingAngle(i,SmoS[c][3]);
					SetVehicleVirtualWorld(PDV[i][cID], 54);
					SetPlayerVirtualWorld(i, 54);
					PutPlayerInVehicle(i,PDV[i][cID],0);
					c--;
				}
			}
		}		
		return 1;
	}
	stock OnSmoEnd(){
		if(GM[pl][3] <= 1){
			foreach(Player,i){
				if(PDV[i][Plays] == 4){
					GiRe(i,25);
					GiPlMo(i,3000);
					SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sumo wygra³ gracz %s",PDV[i][Nck]);
					GM[pl][3] = -1;
					GM[Smo] = -1;
					break;
				}
			}
		}else{}
		return 1;
	}
	CMD:sumo(playerid,params[]){
		if(GM[Smo] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sumo ju¿ trwa!");return 1;}
		new c=0;
		foreach(Player,i){
			if(c >= 10){
				break;
			}
			else if(PDV[i][Plays] == 4){
				c++;
			}
		}
		if(c >= 2 && GM[Smo] == -1){
			GM[Smo] = GetTickCount()+10000;
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}/sumo rozpocznie siê za 10 sekund");
		}
		if(c <= 10){
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisa³eœ siê na ");
			PDV[playerid][Plays] = 4;
		}else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| Ju¿ jest max graczy na sumo");}
		return 1;
	}
	CMD:ksum(playerid,params[]){
		if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
		foreach(Player,i){
			if(PDV[i][Plays] == 4){
				PDV[i][Plays] = 0;
				ReS(i);
			}
		}
		GM[pl][3] = 0;
		GM[Smo] = -1;
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Admin zakoñczy³ sumo!");
		return 1;
	}
	stock StartWG(){
		if(GM[pl][2] >= 2){
			new m = random(2);
			new r;
			foreach(Player,i){
				if(PDV[i][Plays] == 3){
					if(r == 1){
						SetPlayerTeam(i,1);
						r = random(15);
						if(m != 1){r += 30 * m;}
					}
					else{
						SetPlayerTeam(i, 2);
						r = random(15)+15;
						if(m != 1){r += 30 * m;}
					}
					SetPlayerVirtualWorld(i, 53);
					if(m == 0){
						SetPlayerInterior(i, 3);
					}
					else{
						GangZoneShowForPlayer(i, WGZ[1], 0xAAFFAAAA);
					}
					SetPlayerPos(i,wgsp[r][0]+i,wgsp[r][1],wgsp[r][2]);
					SetPlayerFacingAngle(i,wgsp[r][3]);
					GivePlayerWeapon(i,24,3000);
					GivePlayerWeapon(i,27,3000);
					GivePlayerWeapon(i,28,3000);
					r = GetPlayerTeam(i) - 1;
				}
			}
			GM[wgs] = -2;
		}
		return 1;
	}
	stock OnWGed(Team){
		GM[wgs] = -1;
		GM[pl][2] = 0;
		if(Team == -1){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}WG zakoñczy³o siê bez wygranych");
			return 1;
		}
		foreach(Player,i){
			if(GetPlayerTeam(i) == Team){
				GiRe(i,40);
				GiPlMo(i,35000);
				SetPlayerTeam(i, NO_TEAM);
				SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Twój team wygra³ jej! Dosta³eœ 40 Expa i 35k$");
			}
		}
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}WG siê zakoñczy³o wygra³ team",(Team == 1) ? ("RED") : ("BLUE"));
		return 1;
	}
	CMD:wg(playerid,params[]){
		if(GM[wgs] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gra jest w toku");return 1;}//Add message
		if(PDV[playerid][Plays] == 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ jesteœ zapisany");return 1;}//Add message
		GM[pl][2] = 0;
		foreach(Player,i){
			if(PDV[i][Plays] == 3){
				GM[pl][2]++;
			}
		}
		if(GM[pl][2] >= 30){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Osi¹gnieto maksymaln¹ iloœæ graczy"); return 1;}
		GM[pl][2]++;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisa³eœ siê na wg %i/2",GM[pl][2]);
		PDV[playerid][Plays] = 3;
		if(GM[pl][2] >= 2 && GM[wgs] == -1){
			GM[wgs] = GetTickCount()+10000;
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}WG zacznie siê za 10 sekund !!/wg!!");
		}
		return 1;
	}
	CMD:kwg(playerid,params[]){
		if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
		foreach(Player,i){
			if(PDV[i][Plays] == 3){
				PDV[i][Plays] = 0;
				ReS(i);
			}
		}
		GM[pl][2] = 0;
		GM[wgs] = -1;
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Admin zakoñczy³ WG!");
		return 1;
	}
	stock Derby(){
		new a;
		foreach(Player,i){
			if(PDV[i][Plays] == 2 && !Busy(i)){
				a++;
			}
		}
		if(a >=3){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Derby wystartowa³y");
			new r = random(2);
			a = 0;
			foreach(Player,i){
				if(r == 1){a = 15;}
				if(PDV[i][Plays] == 2){
					GetPlayerPos(i,PDV[i][LaX],PDV[i][LaY],PDV[i][LaZ]);
					SetPlayerPos(i, DBSp[a][0],DBSp[a][1],DBSp[a][2]);
					SetPlayerVirtualWorld(i, 30);
					if(IsValidVehicle(PDV[i][cID])){
						DestroyVehicle(PDV[i][cID]);
					}
					PDV[i][cID] = CreateVehicle(506, DBSp[a][0],DBSp[a][1],DBSp[a][2],DBSp[a][3], random(255),random(255),-1);
					SetVehicleVirtualWorld(PDV[i][cID], 30);
					PutPlayerInVehicle(i, PDV[i][cID], 0);
					a++;
					TogglePlayerControllable(i, 0);
					PDV[i][CtD] = GetTickCount()+3000;
					PDV[i][SetF] = 1;
				}
			}
			if(r == 2){a -= 15;}
			GM[pl][1] = a;
			GM[drby] = -2;
		}
		return 1;
	}
	stock DerbyEnd(pid){
		GM[drby] = -1;
		GM[pl][1] = 0;
		if(pid == INVALID_PLAYER_ID){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nikt nie wygra³ derb O.o");
			return 1;
		}
		PDV[pid][Plays] = 0;
		DestroyVehicle(PDV[pid][cID]);
		GiRe(pid,15);
		GiPlMo(pid,25000);
		ReS(pid);
		SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wygra³eœ Derby Nagroda: 15 Expa i 25000$");
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³ Derby Gratulacje",PDV[pid][Nck]);
		return 1;
	}
	alias:db("derby");
	CMD:db(playerid,params[])
	{
		if(GM[drby] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gra w toku"); return 1;}
		if(PDV[playerid][Plays] == 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ jesteœ zapisany"); return 1;}
		new a;
		foreach(Player,i){
			if(PDV[playerid][Plays] == 2 && !Busy(playerid)){
				a++;
			}
		}
		if(a >= 15){
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Osi¹gnieto limit graczy na derbach");
			return 1;
		}
		a++;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Zapisa³eœ siê na derby %i/3",a);
		PDV[playerid][Plays] = 2;
		if(a >=3 && GM[drby] == -1){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Za 10 sekund zacznie siê gra Derby zapisz siê /db");
			GM[drby] = GetTickCount()+10000;	
		}
		return 1;
	}
	CMD:kdb(playerid,params[])
	{
		if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
		if(GM[drby] != -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Derby siê nie zacze³y"); return 1;}
		foreach(Player,i){
			if(PDV[i][Plays] == 2){
				PDV[i][Plays] = 0;
				ReS(i);
			}
		}
		GM[drby] = -1;
		GM[pl][1] = 0;
		return 1;
	}
	stock DPWyp(){
		if(IsValidDynamicPickup(wyKam[0])){DestroyDynamicPickup(wyKam[0]);}
		if(IsValidDynamicPickup(wyKam[1])){DestroyDynamicPickup(wyKam[1]);}
		if(IsValidDynamicPickup(wyKam[2])){DestroyDynamicPickup(wyKam[2]);}
		if(IsValidDynamicPickup(wyHP[0])){DestroyDynamicPickup(wyHP[0]);}
		if(IsValidDynamicPickup(wyHP[1])){DestroyDynamicPickup(wyHP[1]);}
		if(IsValidDynamicPickup(wyWeap[0])){DestroyDynamicPickup(wyWeap[0]);}
		if(IsValidDynamicPickup(wyWeap[1])){DestroyDynamicPickup(wyWeap[1]);}
		if(IsValidDynamicPickup(wyWeap[2])){DestroyDynamicPickup(wyWeap[2]);}
		if(IsValidDynamicPickup(wyWeap[3])){DestroyDynamicPickup(wyWeap[3]);}
		if(IsValidDynamicPickup(wyWeap[4])){DestroyDynamicPickup(wyWeap[4]);}
		if(IsValidDynamicPickup(wyWeap[5])){DestroyDynamicPickup(wyWeap[5]);}
		if(IsValidDynamicPickup(wyWeap[6])){DestroyDynamicPickup(wyWeap[6]);}
		if(IsValidDynamicPickup(wyWeap[7])){DestroyDynamicPickup(wyWeap[7]);}
		if(IsValidDynamicPickup(wyWeap[8])){DestroyDynamicPickup(wyWeap[8]);}
		if(IsValidDynamicPickup(wyWeap[9])){DestroyDynamicPickup(wyWeap[9]);}
		if(IsValidDynamicPickup(wyWeap[10])){DestroyDynamicPickup(wyWeap[10]);}
		if(IsValidDynamicPickup(wyWeap[11])){DestroyDynamicPickup(wyWeap[11]);}
		if(IsValidDynamicPickup(wyWeap[12])){DestroyDynamicPickup(wyWeap[12]);}
		if(IsValidDynamicPickup(wyWeap[13])){DestroyDynamicPickup(wyWeap[13]);}
		if(IsValidDynamicPickup(wyWeap[14])){DestroyDynamicPickup(wyWeap[14]);}
		if(IsValidDynamicPickup(wyWeap[15])){DestroyDynamicPickup(wyWeap[15]);}
		if(IsValidDynamicPickup(wyWeap[16])){DestroyDynamicPickup(wyWeap[16]);}
		if(IsValidDynamicPickup(wyWeap[17])){DestroyDynamicPickup(wyWeap[17]);}
		if(IsValidDynamicPickup(wyWeap[18])){DestroyDynamicPickup(wyWeap[18]);}
		if(IsValidDynamicPickup(wyWeap[19])){DestroyDynamicPickup(wyWeap[19]);}
		if(IsValidDynamicPickup(wyWeap[20])){DestroyDynamicPickup(wyWeap[20]);}
		if(IsValidDynamicPickup(wyWeap[21])){DestroyDynamicPickup(wyWeap[21]);}
		if(IsValidDynamicPickup(wyWeap[22])){DestroyDynamicPickup(wyWeap[22]);}
		if(IsValidDynamicPickup(wyWeap[23])){DestroyDynamicPickup(wyWeap[23]);}
		if(IsValidDynamicPickup(wyWeap[24])){DestroyDynamicPickup(wyWeap[24]);}
		if(IsValidDynamicPickup(wyWeap[25])){DestroyDynamicPickup(wyWeap[25]);}
		if(IsValidDynamicPickup(wyWeap[26])){DestroyDynamicPickup(wyWeap[26]);}
		if(IsValidDynamicPickup(wyWeap[27])){DestroyDynamicPickup(wyWeap[27]);}
		if(IsValidDynamicPickup(wyWeap[28])){DestroyDynamicPickup(wyWeap[28]);}
		if(IsValidDynamicPickup(wyWeap[29])){DestroyDynamicPickup(wyWeap[29]);}
		if(IsValidDynamicPickup(wyWeap[30])){DestroyDynamicPickup(wyWeap[30]);}
		if(IsValidDynamicPickup(wyWeap[31])){DestroyDynamicPickup(wyWeap[31]);}
		if(IsValidDynamicPickup(wyWeap[32])){DestroyDynamicPickup(wyWeap[32]);}
		if(IsValidDynamicPickup(wyWeap[33])){DestroyDynamicPickup(wyWeap[33]);}
		if(IsValidDynamicPickup(wyWeap[34])){DestroyDynamicPickup(wyWeap[34]);}
		if(IsValidDynamicPickup(wyWeap[35])){DestroyDynamicPickup(wyWeap[35]);}
		if(IsValidDynamicPickup(wyWeap[36])){DestroyDynamicPickup(wyWeap[36]);}
		if(IsValidDynamicPickup(wyWeap[37])){DestroyDynamicPickup(wyWeap[37]);}
		if(IsValidDynamicPickup(wyWeap[38])){DestroyDynamicPickup(wyWeap[38]);}
		if(IsValidDynamicPickup(wyWeap[39])){DestroyDynamicPickup(wyWeap[39]);}
		if(IsValidDynamicPickup(wyWeap[40])){DestroyDynamicPickup(wyWeap[40]);}
		if(IsValidDynamicPickup(wyWeap[41])){DestroyDynamicPickup(wyWeap[41]);}
		if(IsValidDynamicPickup(wyWeap[42])){DestroyDynamicPickup(wyWeap[42]);}
		if(IsValidDynamicPickup(wyWeap[43])){DestroyDynamicPickup(wyWeap[43]);}
		if(IsValidDynamicPickup(wyWeap[44])){DestroyDynamicPickup(wyWeap[44]);}
		if(IsValidDynamicPickup(wyWeap[45])){DestroyDynamicPickup(wyWeap[45]);}
		if(IsValidDynamicPickup(wyWeap[46])){DestroyDynamicPickup(wyWeap[46]);}
		return 1;
	}
	stock ChWyp(){
		new a;
		foreach(Player,i){
			if(PDV[i][Plays] == 1){
				a++;
			}
		}
		if(a >= 2 && GM[wyp] == -1){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {22EE22}Za 10 sekund zacznie siê Wyspa Przetrwania zapisuj siê /wyp");
			GM[wyp] = GetTickCount()+10000;
		}
		return 1;
	}
	stock Wysp(){
		new a;
		foreach(Player,i){
			if(PDV[i][Plays] == 1)
			{
				a++;
			}
		}
		if(a >= 2){
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {22EE22}Wyspa siê rozpocze³a");
			foreach(Player,i){
				if(PDV[i][Plays] == 1){
					GetPlayerPos(i,PDV[i][LaX],PDV[i][LaY],PDV[i][LaZ]);
					new r = random(15);
					SetPlayerVirtualWorld(i,20);
					SetPlayerPos(i, WyspS[r][0],WyspS[r][1],WyspS[r][2]);
					PDV[i][CtD] = GetTickCount()+5000;
					TogglePlayerControllable(i, 0);
					SetPlayerColor(i,0xFFFFFF00);
					PDV[i][SetF] = 3;
				}
			}
			wyKam[0] = CreateDynamicPickup(1242,2,2972.0850,-3355.1833,30.4392,20);
			wyKam[1] = CreateDynamicPickup(1242,2,2961.0447,-3392.2571,6.4902,20);
			wyKam[2] = CreateDynamicPickup(1242,2,3139.0435,-3556.2932,2.2980,20);
			wyHP[0] = CreateDynamicPickup(1240,2,3079.4207,-3479.4963,3.4896,20);
			wyHP[1] = CreateDynamicPickup(1240,2,2839.2593,-3332.1746,2.2980,20);
			wyWeap[0] = CreateDynamicPickup(19832,2,3073.8232,-3551.9897,2.2980,20);
			wyWeap[1] = CreateDynamicPickup(19832,2,3078.7112,-3555.0330,7.9319,20);
			wyWeap[2] = CreateDynamicPickup(19832,2,3122.6785,-3579.3193,2.2980,20);
			wyWeap[3] = CreateDynamicPickup(19832,2,3125.2605,-3575.7695,2.2980,20);
			wyWeap[4] = CreateDynamicPickup(19832,2,3137.8752,-3514.6492,9.8710,20);
			wyWeap[5] = CreateDynamicPickup(19832,2,3070.3511,-3431.3965,2.2986,20);
			wyWeap[6] = CreateDynamicPickup(19832,2,3060.8586,-3415.8657,2.2986,20);
			wyWeap[7] = CreateDynamicPickup(19832,2,3076.3853,-3383.1873,2.2986,20);
			wyWeap[8] = CreateDynamicPickup(19832,2,3096.0464,-3369.7341,18.1976,20);
			wyWeap[9] = CreateDynamicPickup(19832,2,3045.3789,-3379.8564,2.2986,20);
			wyWeap[10] = CreateDynamicPickup(19832,2,3009.9937,-3336.8062,7.1720,20);
			wyWeap[11] = CreateDynamicPickup(19832,2,3035.1375,-3299.5376,2.8771,20);
			wyWeap[12] = CreateDynamicPickup(19832,2,3006.2410,-3250.3311,4.9489,20);
			wyWeap[13] = CreateDynamicPickup(19832,2,2988.8450,-3235.9839,2.2980,20);
			wyWeap[14] = CreateDynamicPickup(19832,2,2952.8640,-3251.7451,2.2980,20);
			wyWeap[15] = CreateDynamicPickup(19832,2,2947.4158,-3254.3069,2.2980,20);
			wyWeap[16] = CreateDynamicPickup(19832,2,2962.3633,-3317.8025,8.3016,20);
			wyWeap[17] = CreateDynamicPickup(19832,2,2913.6130,-3323.1514,2.2980,20);
			wyWeap[18] = CreateDynamicPickup(19832,2,2922.2490,-3297.1555,2.2986,20);
			wyWeap[19] = CreateDynamicPickup(19832,2,2889.1821,-3308.3323,2.2980,20);
			wyWeap[20] = CreateDynamicPickup(19832,2,2888.9287,-3334.5559,9.0123,20);
			wyWeap[21] = CreateDynamicPickup(19832,2,2889.7810,-3311.9985,18.3795,20);
			wyWeap[22] = CreateDynamicPickup(19832,2,2819.1987,-3325.2085,2.2980,20);
			wyWeap[23] = CreateDynamicPickup(19832,2,2835.0828,-3304.7537,2.2980,20);
			wyWeap[24] = CreateDynamicPickup(19832,2,2835.5859,-3366.4900,2.2980,20);
			wyWeap[25] = CreateDynamicPickup(19832,2,2818.7424,-3354.4531,2.2980,20);
			wyWeap[26] = CreateDynamicPickup(19832,2,2812.1123,-3391.9431,2.2980,20);
			wyWeap[27] = CreateDynamicPickup(19832,2,2849.1636,-3364.5000,2.2980,20);
			wyWeap[28] = CreateDynamicPickup(19832,2,2851.5212,-3403.2261,2.2980,20);
			wyWeap[29] = CreateDynamicPickup(19832,2,2880.3015,-3406.0144,2.2980,20);
			wyWeap[30] = CreateDynamicPickup(19832,2,2961.0447,-3392.2571,6.4902,20);
			wyWeap[31] = CreateDynamicPickup(19832,2,2965.2529,-3455.8826,2.2980,20);
			wyWeap[32] = CreateDynamicPickup(19832,2,2995.4065,-3460.2605,2.3526,20);
			wyWeap[33] = CreateDynamicPickup(19832,2,2993.2646,-3466.8228,2.2980,20);
			wyWeap[34] = CreateDynamicPickup(19832,2,2965.7881,-3466.2046,18.1989,20);
			wyWeap[35] = CreateDynamicPickup(19832,2,3009.6680,-3510.9937,0.8210,20);
			wyWeap[36] = CreateDynamicPickup(19832,2,3008.1484,-3569.8843,0.6001,20);
			wyWeap[37] = CreateDynamicPickup(19832,2,3119.1514,-3439.6943,2.3173,20);
			wyWeap[38] = CreateDynamicPickup(19832,2,3115.5161,-3409.0261,2.3173,20);
			wyWeap[39] = CreateDynamicPickup(19832,2,3145.4341,-3410.8101,2.2986,20);
			wyWeap[40] = CreateDynamicPickup(19832,2,3148.5557,-3373.6318,2.2986,20);
			wyWeap[41] = CreateDynamicPickup(19832,2,3129.2239,-3375.1147,2.3085,20);
			wyWeap[42] = CreateDynamicPickup(19832,2,3139.8237,-3377.1177,2.2986,20);
			wyWeap[43] = CreateDynamicPickup(19832,2,2890.7522,-3342.9783,2.2980,20);
			wyWeap[44] = CreateDynamicPickup(19832,2,2937.1638,-3271.7764,2.2980,20);
			wyWeap[45] = CreateDynamicPickup(19832,2,2928.8938,-3277.5105,2.2980,20);
			wyWeap[46] = CreateDynamicPickup(19832,2,2969.0845,-3369.6458,11.6894,20);
			GM[wyp] = -2;
			GM[pl][0] = a;
		}else {
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Przerwano start wyspy z powodu braku graczy");
			GM[wyp] = -1;
		}
		return 1;
	}
	alias:wyp("wyspaprzetrwania");
	CMD:wyp(playerid,params[])
	{
		if(GM[wyp] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gra jest w toku >.<"); return 1;}
		if(PDV[playerid][Plays] == 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Jesteœ ju¿ zapisany"); return 1;}		
		PDV[playerid][Plays] = 1;
		SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisa³eœ siê na BattleRoyale!");
		ChWyp();
		return 1;
	}
	CMD:kwyp(playerid,params[])
	{
		if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
		if(GM[wyp] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie ma czego przerywaæ OwO"); return 1;}
		foreach(Player,i){
			if(PDV[i][Plays] == 1){
				ReS(i);
			}
		}
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zakoñczono zabawê Wyspy Przetrwania");
		GM[wyp] = -1;
		return 1;
	}
//SQL Manip.
	stock FindSQLInject(String[])
	{
		if(strfind(String, "INSERT", false) != -1) return 1;
	 	if(strfind(String, "UPDATE", false) != -1) return 1;
	  	if(strfind(String, "DELETE", false) != -1) return 1;
	   	if(strfind(String, "FROM", false) != -1) return 1;
	   	if(strfind(String, "TRUNCATE", false) != -1) return 1;
	    if(strfind(String, "DROP", false) != -1) return 1;
	    if(strfind(String, "ALTER", false) != -1) return 1;
	    if(strfind(String, "TABLE", false) != -1) return 1;
	    if(strfind(String, "WHERE", false) != -1) return 1;
	    if(strfind(String, "SELECT", false) != -1) return 1;
	    if(strfind(String, "NULL", false) != -1) return 1;
	    if(strfind(String, "EXISTS", false) != -1) return 1;
	    if(strfind(String, "EMPTY", false) != -1) return 1;
	    if(strfind(String, "TRUNCATE", false) != -1) return 1;

		return 0;
	}
	stock mysqlcon(){
		DBM = mysql_connect_file("mysql.ini");
		mysql_log(ALL);
		return 1;
	}
//Player Stock's
	//HuD
		stock ShowHUD(&pid){
			TextDrawShowForPlayer(pid, red[0]);
			TextDrawShowForPlayer(pid, red[1]);
			TextDrawShowForPlayer(pid, red[2]);
			TextDrawShowForPlayer(pid, red[3]);
			TextDrawShowForPlayer(pid, red[4]);
			TextDrawShowForPlayer(pid, red[5]);
			TextDrawShowForPlayer(pid, red[6]);
			TextDrawShowForPlayer(pid, red[7]);
			TextDrawShowForPlayer(pid, red[8]);
			TextDrawShowForPlayer(pid, red[9]);
			TextDrawShowForPlayer(pid, red[10]);
			TextDrawShowForPlayer(pid, red[11]);
			TextDrawShowForPlayer(pid, red[12]);
			TextDrawShowForPlayer(pid, red[13]);
			TextDrawShowForPlayer(pid, red[14]);
			TextDrawShowForPlayer(pid, red[15]);
			TextDrawShowForPlayer(pid, red[16]);
			TextDrawShowForPlayer(pid, red[17]);
			TextDrawShowForPlayer(pid, red[18]);
			TextDrawShowForPlayer(pid, red[19]);
			TextDrawShowForPlayer(pid, red[20]);
			TextDrawShowForPlayer(pid, red[21]);
			TextDrawShowForPlayer(pid, red[22]);
			TextDrawShowForPlayer(pid, red[23]);
			TextDrawShowForPlayer(pid, red[24]);
			PlayerTextDrawShow(pid, PTD[pid][0]);
			PlayerTextDrawShow(pid, PTD[pid][1]);
			PlayerTextDrawShow(pid, PTD[pid][2]);
			PlayerTextDrawShow(pid, PTD[pid][3]);
			PlayerTextDrawShow(pid, PTD[pid][4]);
			PlayerTextDrawShow(pid, PTD[pid][5]);
			PlayerTextDrawShow(pid, PTD[pid][6]);
			PlayerTextDrawShow(pid, PTD[pid][7]);
			PlayerTextDrawShow(pid, PTD[pid][8]);
			PlayerTextDrawShow(pid, PTD[pid][9]);
			PlayerTextDrawShow(pid, PTDHA[pid][0]);
			PlayerTextDrawShow(pid, PTDHA[pid][1]);
			TextDrawShowForPlayer(pid, Zegar);
			PDV[pid][hudon] = true;
			return 1;
		}
		stock DesPHUD(&pid){
			PlayerTextDrawDestroy(pid, PTD[0][pid]);
			PlayerTextDrawDestroy(pid, PTD[1][pid]);
			PlayerTextDrawDestroy(pid, PTD[2][pid]);
			PlayerTextDrawDestroy(pid, PTD[3][pid]);
			PlayerTextDrawDestroy(pid, PTD[4][pid]);
			PlayerTextDrawDestroy(pid, PTD[5][pid]);
			PlayerTextDrawDestroy(pid, PTD[6][pid]);
			PlayerTextDrawDestroy(pid, PTD[7][pid]);
			PlayerTextDrawDestroy(pid, PTD[8][pid]);
			PlayerTextDrawDestroy(pid, PTD[9][pid]);
			PlayerTextDrawDestroy(pid, PTD[10][pid]);
			PlayerTextDrawDestroy(pid, PTDHA[0][pid]);
			PlayerTextDrawDestroy(pid, PTDHA[1][pid]);
			return 1;
		}
		stock HideHud(&pid){
			TextDrawHideForPlayer(pid, red[0]);
			TextDrawHideForPlayer(pid, red[1]);
			TextDrawHideForPlayer(pid, red[2]);
			TextDrawHideForPlayer(pid, red[3]);
			TextDrawHideForPlayer(pid, red[4]);
			TextDrawHideForPlayer(pid, red[5]);
			TextDrawHideForPlayer(pid, red[6]);
			TextDrawHideForPlayer(pid, red[7]);
			TextDrawHideForPlayer(pid, red[8]);
			TextDrawHideForPlayer(pid, red[9]);
			TextDrawHideForPlayer(pid, red[10]);
			TextDrawHideForPlayer(pid, red[11]);
			TextDrawHideForPlayer(pid, red[12]);
			TextDrawHideForPlayer(pid, red[13]);
			TextDrawHideForPlayer(pid, red[14]);
			TextDrawHideForPlayer(pid, red[15]);
			TextDrawHideForPlayer(pid, red[16]);
			TextDrawHideForPlayer(pid, red[17]);
			TextDrawHideForPlayer(pid, red[18]);
			TextDrawHideForPlayer(pid, red[19]);
			TextDrawHideForPlayer(pid, red[20]);
			TextDrawHideForPlayer(pid, red[21]);
			TextDrawHideForPlayer(pid, red[22]);
			TextDrawHideForPlayer(pid, red[23]);
			TextDrawHideForPlayer(pid, red[24]);
			PlayerTextDrawHide(pid, PTD[pid][0]);
			PlayerTextDrawHide(pid, PTD[pid][1]);
			PlayerTextDrawHide(pid, PTD[pid][2]);
			PlayerTextDrawHide(pid, PTD[pid][3]);
			PlayerTextDrawHide(pid, PTD[pid][4]);
			PlayerTextDrawHide(pid, PTD[pid][5]);
			PlayerTextDrawHide(pid, PTD[pid][6]);
			PlayerTextDrawHide(pid, PTD[pid][7]);
			PlayerTextDrawHide(pid, PTD[pid][8]);
			PlayerTextDrawHide(pid, PTD[pid][9]);
			PlayerTextDrawHide(pid, PTDHA[pid][0]);
			PlayerTextDrawHide(pid, PTDHA[pid][1]);
			TextDrawHideForPlayer(pid, Zegar);
			PDV[pid][hudon] = false;
			return 1;
		}		
		stock CrGlTxD(){
			red[0] = TextDrawCreate(26.488128, 429.866699, "LD_POKE:cd10h");
			TextDrawLetterSize(red[0], 0.000000, 0.000000);
			TextDrawTextSize(red[0], 581.000000, 26.000000);
			TextDrawAlignment(red[0], 1);
			TextDrawColor(red[0], 52);
			TextDrawSetShadow(red[0], 0);
			TextDrawSetOutline(red[0], 0);
			TextDrawBackgroundColor(red[0], 255);
			TextDrawFont(red[0], 4);
			TextDrawSetProportional(red[0], 0);
			TextDrawSetShadow(red[0], 0);

			red[1] = TextDrawCreate(21.534002, 467.200408, "box");
			TextDrawLetterSize(red[1], 0.000000, -4.008780);
			TextDrawTextSize(red[1], 25.000000, 0.000000);
			TextDrawAlignment(red[1], 1);
			TextDrawColor(red[1], 65535);
			TextDrawUseBox(red[1], 1);
			TextDrawBoxColor(red[1], 16720216);
			TextDrawSetShadow(red[1], 0);
			TextDrawSetOutline(red[1], 0);
			TextDrawBackgroundColor(red[1], 255);
			TextDrawFont(red[1], 1);
			TextDrawSetProportional(red[1], 1);
			TextDrawSetShadow(red[1], 0);

			red[2] = TextDrawCreate(13.739700, 470.900634, "box");
			TextDrawLetterSize(red[2], 0.000000, -4.055634);
			TextDrawTextSize(red[2], 17.399993, 0.000000);
			TextDrawAlignment(red[2], 1);
			TextDrawColor(red[2], 65535);
			TextDrawUseBox(red[2], 1);
			TextDrawBoxColor(red[2], -520290216);
			TextDrawSetShadow(red[2], 0);
			TextDrawSetOutline(red[2], 0);
			TextDrawBackgroundColor(red[2], 255);
			TextDrawFont(red[2], 1);
			TextDrawSetProportional(red[2], 1);
			TextDrawSetShadow(red[2], 0);

			red[3] = TextDrawCreate(7.071309, 476.600982, "box");
			TextDrawLetterSize(red[3], 0.000000, -4.008780);
			TextDrawTextSize(red[3], 10.000000, 0.000000);
			TextDrawAlignment(red[3], 1);
			TextDrawColor(red[3], 65535);
			TextDrawUseBox(red[3], 1);
			TextDrawBoxColor(red[3], -14614440);
			TextDrawSetShadow(red[3], 0);
			TextDrawSetOutline(red[3], 0);
			TextDrawBackgroundColor(red[3], 255);
			TextDrawFont(red[3], 1);
			TextDrawSetProportional(red[3], 1);
			TextDrawSetShadow(red[3], 0);

			red[4] = TextDrawCreate(7.071309, 476.600982, "box");
			TextDrawLetterSize(red[4], 0.000000, -4.008780);
			TextDrawTextSize(red[4], 10.000000, 0.000000);
			TextDrawAlignment(red[4], 1);
			TextDrawColor(red[4], 65535);
			TextDrawUseBox(red[4], 1);
			TextDrawBoxColor(red[4], -14614440);
			TextDrawSetShadow(red[4], 0);
			TextDrawSetOutline(red[4], 0);
			TextDrawBackgroundColor(red[4], 255);
			TextDrawFont(red[4], 1);
			TextDrawSetProportional(red[4], 1);
			TextDrawSetShadow(red[4], 0);

			red[5] = TextDrawCreate(490.571014, 433.049804, "ld_grav:timer");
			TextDrawLetterSize(red[5], 0.000000, 0.000000);
			TextDrawTextSize(red[5], 9.279983, 9.170003);
			TextDrawAlignment(red[5], 1);
			TextDrawColor(red[5], -1);
			TextDrawSetShadow(red[5], 0);
			TextDrawSetOutline(red[5], 0);
			TextDrawBackgroundColor(red[5], 255);
			TextDrawFont(red[5], 4);
			TextDrawSetProportional(red[5], 0);
			TextDrawSetShadow(red[5], 0);

			red[6] = TextDrawCreate(618.898620, 452.033569, "box");
			TextDrawLetterSize(red[6], 0.000000, -2.441085);
			TextDrawTextSize(red[6], 606.000000, 0.000000);
			TextDrawAlignment(red[6], 1);
			TextDrawColor(red[6], 65535);
			TextDrawUseBox(red[6], 1);
			TextDrawBoxColor(red[6], 16720216);
			TextDrawSetShadow(red[6], 0);
			TextDrawSetOutline(red[6], 0);
			TextDrawBackgroundColor(red[6], 255);
			TextDrawFont(red[6], 0);
			TextDrawSetProportional(red[6], 1);
			TextDrawSetShadow(red[6], 0);

			red[7] = TextDrawCreate(627.034545, 462.200805, "box");
			TextDrawLetterSize(red[7], 0.000000, -3.118592);
			TextDrawTextSize(red[7], 615.000000, 0.000000);
			TextDrawAlignment(red[7], 1);
			TextDrawColor(red[7], 65535);
			TextDrawUseBox(red[7], 1);
			TextDrawBoxColor(red[7], -520290216);
			TextDrawSetShadow(red[7], 0);
			TextDrawSetOutline(red[7], 0);
			TextDrawBackgroundColor(red[7], 255);
			TextDrawFont(red[7], 1);
			TextDrawSetProportional(red[7], 1);
			TextDrawSetShadow(red[7], 0);

			red[8] = TextDrawCreate(635.767517, 474.550903, "box");
			TextDrawLetterSize(red[8], 0.000000, -4.008780);
			TextDrawTextSize(red[8], 623.000000, 0.000000);
			TextDrawAlignment(red[8], 1);
			TextDrawColor(red[8], -65281);
			TextDrawUseBox(red[8], 1);
			TextDrawBoxColor(red[8], -14679984);
			TextDrawSetShadow(red[8], 0);
			TextDrawSetOutline(red[8], 1);
			TextDrawBackgroundColor(red[8], -1);
			TextDrawFont(red[8], 1);
			TextDrawSetProportional(red[8], 1);
			TextDrawSetShadow(red[8], 0);

			red[9] = TextDrawCreate(301.323516, 407.167358, "Ja");
			TextDrawLetterSize(red[9], 0.431858, 1.454166);
			TextDrawAlignment(red[9], 2);
			TextDrawColor(red[9], -65994497);
			TextDrawSetShadow(red[9], 0);
			TextDrawSetOutline(red[9], 1);
			TextDrawBackgroundColor(red[9], 65);
			TextDrawFont(red[9], 0);
			TextDrawSetProportional(red[9], 1);
			TextDrawSetShadow(red[9], 0);

			red[10] = TextDrawCreate(9.824331, 422.633270, "-");
			TextDrawLetterSize(red[10], 43.014060, 1.209998);
			TextDrawAlignment(red[10], 1);
			TextDrawColor(red[10], -16776961);
			TextDrawSetShadow(red[10], 0);
			TextDrawSetOutline(red[10], 0);
			TextDrawBackgroundColor(red[10], 255);
			TextDrawFont(red[10], 1);
			TextDrawSetProportional(red[10], 1);
			TextDrawSetShadow(red[10], 0);

			red[11] = TextDrawCreate(33.524391, 420.033111, "-");
			TextDrawLetterSize(red[11], 40.000000, 1.200000);
			TextDrawAlignment(red[11], 1);
			TextDrawColor(red[11], -65281);
			TextDrawSetShadow(red[11], 0);
			TextDrawSetOutline(red[11], 0);
			TextDrawBackgroundColor(red[11], 255);
			TextDrawFont(red[11], 1);
			TextDrawSetProportional(red[11], 1);
			TextDrawSetShadow(red[11], 0);

			red[12] = TextDrawCreate(59.623992, 418.132995, "-");
			TextDrawLetterSize(red[12], 36.017349, 1.205832);
			TextDrawAlignment(red[12], 1);
			TextDrawColor(red[12], 1224671487);
			TextDrawSetShadow(red[12], 0);
			TextDrawSetOutline(red[12], 0);
			TextDrawBackgroundColor(red[12], 255);
			TextDrawFont(red[12], 1);
			TextDrawSetProportional(red[12], 1);
			TextDrawSetShadow(red[12], 0);

			red[13] = TextDrawCreate(263.457153, 435.649963, "hud:radar_gym");
			TextDrawLetterSize(red[13], 0.000000, 0.000000);
			TextDrawTextSize(red[13], 5.059978, 6.499988);
			TextDrawAlignment(red[13], 1);
			TextDrawColor(red[13], -1);
			TextDrawSetShadow(red[13], 0);
			TextDrawSetOutline(red[13], 0);
			TextDrawBackgroundColor(red[13], 255);
			TextDrawFont(red[13], 4);
			TextDrawSetProportional(red[13], 0);
			TextDrawSetShadow(red[13], 0);

			red[14] = TextDrawCreate(68.807273, 435.233245, "hud:radar_flag");
			TextDrawLetterSize(red[14], 0.000000, 0.000000);
			TextDrawTextSize(red[14], 5.400032, 7.600036);
			TextDrawAlignment(red[14], 1);
			TextDrawColor(red[14], -1);
			TextDrawSetShadow(red[14], 0);
			TextDrawSetOutline(red[14], 0);
			TextDrawBackgroundColor(red[14], 255);
			TextDrawFont(red[14], 4);
			TextDrawSetProportional(red[14], 0);
			TextDrawSetShadow(red[14], 0);

			red[15] = TextDrawCreate(101.506759, 443.350036, "hud:radar_centre");
			TextDrawLetterSize(red[15], 0.000000, 0.000000);
			TextDrawTextSize(red[15], 5.959953, -7.289983);
			TextDrawAlignment(red[15], 1);
			TextDrawColor(red[15], 8781823);
			TextDrawSetShadow(red[15], 0);
			TextDrawSetOutline(red[15], 0);
			TextDrawBackgroundColor(red[15], 255);
			TextDrawFont(red[15], 4);
			TextDrawSetProportional(red[15], 0);
			TextDrawSetShadow(red[15], 0);

			red[16] = TextDrawCreate(216.222763, 435.849975, "hud:radar_fire");
			TextDrawLetterSize(red[16], 0.000000, 0.000000);
			TextDrawTextSize(red[16], 5.070024, 6.400009);
			TextDrawAlignment(red[16], 1);
			TextDrawColor(red[16], -1);
			TextDrawSetShadow(red[16], 0);
			TextDrawSetOutline(red[16], 0);
			TextDrawBackgroundColor(red[16], 255);
			TextDrawFont(red[16], 4);
			TextDrawSetProportional(red[16], 0);
			TextDrawSetShadow(red[16], 0);

			red[17] = TextDrawCreate(313.360229, 435.633270, "hud:radar_locosyndicate");
			TextDrawLetterSize(red[17], 0.000000, 0.000000);
			TextDrawTextSize(red[17], 5.100024, 6.680015);
			TextDrawAlignment(red[17], 1);
			TextDrawColor(red[17], -16776961);
			TextDrawSetShadow(red[17], 0);
			TextDrawSetOutline(red[17], 0);
			TextDrawBackgroundColor(red[17], 255);
			TextDrawFont(red[17], 4);
			TextDrawSetProportional(red[17], 0);
			TextDrawSetShadow(red[17], 0);

			red[18] = TextDrawCreate(353.057159, 435.149902, "hud:radar_locosyndicate");
			TextDrawLetterSize(red[18], 0.000000, 0.000000);
			TextDrawTextSize(red[18], 5.070024, 6.400009);
			TextDrawAlignment(red[18], 1);
			TextDrawColor(red[18], 65535);
			TextDrawSetShadow(red[18], 0);
			TextDrawSetOutline(red[18], 0);
			TextDrawBackgroundColor(red[18], 255);
			TextDrawFont(red[18], 4);
			TextDrawSetProportional(red[18], 0);
			TextDrawSetShadow(red[18], 0);

			red[19] = TextDrawCreate(393.459625, 435.049896, "hud:radar_triads");
			TextDrawLetterSize(red[19], 0.000000, 0.000000);
			TextDrawTextSize(red[19], 5.070024, 6.400009);
			TextDrawAlignment(red[19], 1);
			TextDrawColor(red[19], -1);
			TextDrawSetShadow(red[19], 0);
			TextDrawSetOutline(red[19], 0);
			TextDrawBackgroundColor(red[19], 255);
			TextDrawFont(red[19], 4);
			TextDrawSetProportional(red[19], 0);
			TextDrawSetShadow(red[19], 0);

			red[20] = TextDrawCreate(444.531250, 435.249908, "hud:radar_datedisco");
			TextDrawLetterSize(red[20], 0.000000, 0.000000);
			TextDrawTextSize(red[20], 5.390031, 6.760017);
			TextDrawAlignment(red[20], 1);
			TextDrawColor(red[20], -1);
			TextDrawSetShadow(red[20], 0);
			TextDrawSetOutline(red[20], 0);
			TextDrawBackgroundColor(red[20], 255);
			TextDrawFont(red[20], 4);
			TextDrawSetProportional(red[20], 0);
			TextDrawSetShadow(red[20], 0);

			red[23] = TextDrawCreate(317.155975, 407.384063, "mai");
			TextDrawLetterSize(red[23], 0.431858, 1.454166);
			TextDrawAlignment(red[23], 2);
			TextDrawColor(red[23], -808517377);
			TextDrawSetShadow(red[23], 0);
			TextDrawSetOutline(red[23], 1);
			TextDrawBackgroundColor(red[23], 79);
			TextDrawFont(red[23], 0);
			TextDrawSetProportional(red[23], 1);
			TextDrawSetShadow(red[23], 0);

			red[24] = TextDrawCreate(330.656799, 407.384063, "ca");
			TextDrawLetterSize(red[24], 0.431858, 1.454166);
			TextDrawAlignment(red[24], 2);
			TextDrawColor(red[24], 16711935);
			TextDrawSetShadow(red[24], 0);
			TextDrawSetOutline(red[24], 1);
			TextDrawBackgroundColor(red[24], 84);
			TextDrawFont(red[24], 0);
			TextDrawSetProportional(red[24], 1);
			TextDrawSetShadow(red[24], 0);

			//Changeable

			red[21] = TextDrawCreate(562.211608, 4.500000, "ARENY_.RPG_55_.MINI_55_.ONEDE_55_.SNAJPER_55_.POMPA_55");
			TextDrawLetterSize(red[21], 0.137628, 0.625834);
			TextDrawAlignment(red[21], 2);
			TextDrawColor(red[21], -1);
			TextDrawSetShadow(red[21], 0);
			TextDrawSetOutline(red[21], 1);
			TextDrawBackgroundColor(red[21], 48);
			TextDrawFont(red[21], 1);
			TextDrawSetProportional(red[21], 1);
			TextDrawSetShadow(red[21], 0);

			red[22] = TextDrawCreate(557.994689, 12.083381, "ONLINE: 35/~y~5~w~/~r~5");
			TextDrawLetterSize(red[22], 0.187290, 0.812500);
			TextDrawAlignment(red[22], 3);
			TextDrawColor(red[22], -1);
			TextDrawSetShadow(red[22], 0);
			TextDrawSetOutline(red[22], 1);
			TextDrawBackgroundColor(red[22], 255);
			TextDrawFont(red[22], 2);
			TextDrawSetProportional(red[22], 1);
			TextDrawSetShadow(red[22], 0);
			
			//Enter HUD

			LogOnS[1] = TextDrawCreate(219.116363, 160.366378, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[1], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[1], 207.000000, 200.000000);
			TextDrawAlignment(LogOnS[1], 1);
			TextDrawColor(LogOnS[1], 46);
			TextDrawSetShadow(LogOnS[1], 0);
			TextDrawSetOutline(LogOnS[1], 0);
			TextDrawBackgroundColor(LogOnS[1], 255);
			TextDrawFont(LogOnS[1], 4);
			TextDrawSetProportional(LogOnS[1], 0);
			TextDrawSetShadow(LogOnS[1], 0);

			LogOnS[0] = TextDrawCreate(306.081451, 133.133346, "Ja");
			TextDrawLetterSize(LogOnS[0], 0.904128, 3.227499);
			TextDrawAlignment(LogOnS[0], 3);
			TextDrawColor(LogOnS[0], -15400705);
			TextDrawSetShadow(LogOnS[0], 0);
			TextDrawSetOutline(LogOnS[0], 1);
			TextDrawBackgroundColor(LogOnS[0], 116);
			TextDrawFont(LogOnS[0], 0);
			TextDrawSetProportional(LogOnS[0], 1);
			TextDrawSetShadow(LogOnS[0], 0);

			LogOnS[2] = TextDrawCreate(229.392318, 169.200500, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[2], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[2], 186.000000, 31.000000);
			TextDrawAlignment(LogOnS[2], 1);
			TextDrawColor(LogOnS[2], 65);
			TextDrawSetShadow(LogOnS[2], 0);
			TextDrawSetOutline(LogOnS[2], 0);
			TextDrawBackgroundColor(LogOnS[2], 255);
			TextDrawFont(LogOnS[2], 4);
			TextDrawSetProportional(LogOnS[2], 0);
			TextDrawSetShadow(LogOnS[2], 0);

			LogOnS[3] = TextDrawCreate(341.583618, 133.133346, "mai");
			TextDrawLetterSize(LogOnS[3], 0.904128, 3.227499);
			TextDrawAlignment(LogOnS[3], 3);
			TextDrawColor(LogOnS[3], -65281);
			TextDrawSetShadow(LogOnS[3], 0);
			TextDrawSetOutline(LogOnS[3], 1);
			TextDrawBackgroundColor(LogOnS[3], 116);
			TextDrawFont(LogOnS[3], 0);
			TextDrawSetProportional(LogOnS[3], 1);
			TextDrawSetShadow(LogOnS[3], 0);

			LogOnS[4] = TextDrawCreate(361.953369, 133.216705, "ca");
			TextDrawLetterSize(LogOnS[4], 0.904128, 3.227499);
			TextDrawAlignment(LogOnS[4], 3);
			TextDrawColor(LogOnS[4], 16711935);
			TextDrawSetShadow(LogOnS[4], 0);
			TextDrawSetOutline(LogOnS[4], 1);
			TextDrawBackgroundColor(LogOnS[4], 116);
			TextDrawFont(LogOnS[4], 0);
			TextDrawSetProportional(LogOnS[4], 1);
			TextDrawSetShadow(LogOnS[4], 0);

			LogOnS[5] = TextDrawCreate(229.392318, 205.951385, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[5], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[5], 186.000000, 31.000000);
			TextDrawAlignment(LogOnS[5], 1);
			TextDrawColor(LogOnS[5], 65);
			TextDrawSetShadow(LogOnS[5], 0);
			TextDrawSetOutline(LogOnS[5], 0);
			TextDrawBackgroundColor(LogOnS[5], 255);
			TextDrawFont(LogOnS[5], 4);
			TextDrawSetProportional(LogOnS[5], 0);
			TextDrawSetShadow(LogOnS[5], 0);

			LogOnS[6] = TextDrawCreate(229.118331, 242.784927, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[6], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[6], 186.680725, 31.689992);
			TextDrawAlignment(LogOnS[6], 1);
			TextDrawColor(LogOnS[6], 65);
			TextDrawSetShadow(LogOnS[6], 0);
			TextDrawSetOutline(LogOnS[6], 0);
			TextDrawBackgroundColor(LogOnS[6], 255);
			TextDrawFont(LogOnS[6], 4);
			TextDrawSetProportional(LogOnS[6], 0);
			TextDrawSetShadow(LogOnS[6], 0);

			LogOnS[7] = TextDrawCreate(319.317016, 211.401306, "REGULAMIN");
			TextDrawLetterSize(LogOnS[8], 0.400000, 1.600000);
			TextDrawAlignment(LogOnS[8], 2);
			TextDrawColor(LogOnS[8], -1);
			TextDrawSetShadow(LogOnS[8], 0);
			TextDrawSetOutline(LogOnS[8], 1);
			TextDrawBackgroundColor(LogOnS[8], 255);
			TextDrawFont(LogOnS[8], 2);
			TextDrawSetProportional(LogOnS[8], 1);
			TextDrawSetShadow(LogOnS[8], 0);
			TextDrawSetSelectable(LogonS[8], 1);

			LogOnS[8] = TextDrawCreate(319.317016, 249.503631, "Kontakt");
			TextDrawLetterSize(LogOnS[9], 0.400000, 1.600000);
			TextDrawAlignment(LogOnS[9], 2);
			TextDrawColor(LogOnS[9], -1);
			TextDrawSetShadow(LogOnS[9], 0);
			TextDrawSetOutline(LogOnS[9], 1);
			TextDrawBackgroundColor(LogOnS[9], 255);
			TextDrawFont(LogOnS[9], 2);
			TextDrawSetProportional(LogOnS[9], 1);
			TextDrawSetShadow(LogOnS[9], 0);
			TextDrawSetSelectable(LogonS[9], 1);

			LogOnS[9] = TextDrawCreate(229.118331, 318.289489, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[10], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[10], 186.680725, 31.689992);
			TextDrawAlignment(LogOnS[10], 1);
			TextDrawColor(LogOnS[10], 65);
			TextDrawSetShadow(LogOnS[10], 0);
			TextDrawSetOutline(LogOnS[10], 0);
			TextDrawBackgroundColor(LogOnS[10], 255);
			TextDrawFont(LogOnS[10], 4);
			TextDrawSetProportional(LogOnS[10], 0);
			TextDrawSetShadow(LogOnS[10], 0);

			LogOnS[10] = TextDrawCreate(229.118331, 279.687286, "LD_POKE:cd10h");
			TextDrawLetterSize(LogOnS[11], 0.000000, 0.000000);
			TextDrawTextSize(LogOnS[11], 186.680725, 31.689992);
			TextDrawAlignment(LogOnS[11], 1);
			TextDrawColor(LogOnS[11], 65);
			TextDrawSetShadow(LogOnS[11], 0);
			TextDrawSetOutline(LogOnS[11], 0);
			TextDrawBackgroundColor(LogOnS[11], 255);
			TextDrawFont(LogOnS[11], 4);
			TextDrawSetProportional(LogOnS[11], 0);
			TextDrawSetShadow(LogOnS[11], 0);

			LogOnS[11] = TextDrawCreate(319.917053, 286.989379, "AUTOR");
			TextDrawLetterSize(LogOnS[12], 0.400000, 1.600000);
			TextDrawAlignment(LogOnS[12], 2);
			TextDrawColor(LogOnS[12], -1);
			TextDrawSetShadow(LogOnS[12], 0);
			TextDrawSetOutline(LogOnS[12], 1);
			TextDrawBackgroundColor(LogOnS[12], 255);
			TextDrawFont(LogOnS[12], 2);
			TextDrawSetProportional(LogOnS[12], 1);
			TextDrawSetShadow(LogOnS[12], 0);
			TextDrawSetSelectable(LogonS[12], 1);

			LogOnS[12] = TextDrawCreate(319.917053, 324.091339, "WYJSCIE");
			TextDrawLetterSize(LogOnS[13], 0.400000, 1.600000);
			TextDrawAlignment(LogOnS[13], 2);
			TextDrawColor(LogOnS[13], -1);
			TextDrawSetShadow(LogOnS[13], 0);
			TextDrawSetOutline(LogOnS[13], 1);
			TextDrawBackgroundColor(LogOnS[13], 255);
			TextDrawFont(LogOnS[13], 2);
			TextDrawSetProportional(LogOnS[13], 1);
			TextDrawSetShadow(LogOnS[13], 0);
			TextDrawSetSelectable(LogonS[13], 1);

			return 1;
		}
		stock crPlTxD(&pid){
			new str[30];
			if(PDV[pid][NoAcc]){
				format(str,sizeof(str),"Rejestracja");
			}else {
				format(str,sizeof(str),"Logowanie");
			}
			LogOnSP[pid] = CreatePlayerTextDraw(pid,319.317016, 175.800582, str);
			PlayerTextDrawLetterSize(pid,LogOnSP[pid], 0.400000, 1.600000);
			PlayerTextDrawAlignment(pid,LogOnSP[pid], 2);
			PlayerTextDrawColor(pid,LogOnSP[pid], -1);
			PlayerTextDrawSetShadow(pid,LogOnSP[pid], 0);
			PlayerTextDrawSetOutline(pid,LogOnSP[pid], 1);
			PlayerTextDrawBackgroundColor(pid,LogOnSP[pid], 255);
			PlayerTextDrawFont(pid,LogOnSP[pid], 2);
			PlayerTextDrawSetProportional(pid,LogOnSP[pid], 1);
			PlayerTextDrawSetShadow(pid,LogOnSP[pid], 0);
			PlayerTextDrawSetSelectable(pid,LogonSP[pid], 1);

			PTD[pid][0] = CreatePlayerTextDraw(pid, 500.256866, 434.099609, "ONLINE.23h.59min");
			PlayerTextDrawLetterSize(pid, PTD[pid][0], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][0], 1);
			PlayerTextDrawColor(pid, PTD[pid][0], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][0], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][0], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][0], 70);
			PlayerTextDrawFont(pid, PTD[pid][0], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][0], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][0], 0);
			format(str,sizeof(str),"ID:%i",pid);
			PTD[pid][1] = CreatePlayerTextDraw(pid, 75.229454, 435.499694, str);
			PlayerTextDrawLetterSize(pid, PTD[pid][1], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][1], 1);
			PlayerTextDrawColor(pid, PTD[pid][1], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][1], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][1], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][1], 69);
			PlayerTextDrawFont(pid, PTD[pid][1], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][1], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][1], 0);
			format(str,sizeof(str),"Nick:%s",GetPN(pid));
			PTD[pid][2] = CreatePlayerTextDraw(pid, 108.897468, 435.566314, str);
			PlayerTextDrawLetterSize(pid, PTD[pid][2], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][2], 1);
			PlayerTextDrawColor(pid, PTD[pid][2], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][2], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][2], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][2], 70);
			PlayerTextDrawFont(pid, PTD[pid][2], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][2], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][2], 0);

			PTD[pid][3] = CreatePlayerTextDraw(pid, 222.339889, 434.699645, "Gang.Tag123");
			PlayerTextDrawLetterSize(pid, PTD[pid][3], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][3], 1);
			PlayerTextDrawColor(pid, PTD[pid][3], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][3], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][3], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][3], 70);
			PlayerTextDrawFont(pid, PTD[pid][3], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][3], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][3], 0);

			PTD[pid][4] = CreatePlayerTextDraw(pid, 269.742767, 434.982971, "Rspkt.124005");
			PlayerTextDrawLetterSize(pid, PTD[pid][4], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][4], 1);
			PlayerTextDrawColor(pid, PTD[pid][4], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][4], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][4], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][4], 70);
			PlayerTextDrawFont(pid, PTD[pid][4], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][4], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][4], 0);

			PTD[pid][5] = CreatePlayerTextDraw(pid, 319.140350, 434.299591, "K.5000000");
			PlayerTextDrawLetterSize(pid, PTD[pid][5], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][5], 1);
			PlayerTextDrawColor(pid, PTD[pid][5], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][5], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][5], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][5], 70);
			PlayerTextDrawFont(pid, PTD[pid][5], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][5], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][5], 0);

			PTD[pid][6] = CreatePlayerTextDraw(pid, 358.974273, 434.066192, "D.5000000");
			PlayerTextDrawLetterSize(pid, PTD[pid][6], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][6], 1);
			PlayerTextDrawColor(pid, PTD[pid][6], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][6], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][6], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][6], 70);
			PlayerTextDrawFont(pid, PTD[pid][6], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][6], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][6], 0);

			PTD[pid][7] = CreatePlayerTextDraw(pid, 399.845275, 434.299591, "SKULL.500000");
			PlayerTextDrawLetterSize(pid, PTD[pid][7], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][7], 1);
			PlayerTextDrawColor(pid, PTD[pid][7], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][7], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][7], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][7], 64);
			PlayerTextDrawFont(pid, PTD[pid][7], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][7], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][7], 0);

			PTD[pid][8] = CreatePlayerTextDraw(pid, 450.248352, 434.016265, "EXP.2500000");
			PlayerTextDrawLetterSize(pid, PTD[pid][8], 0.151626, 0.871662);
			PlayerTextDrawAlignment(pid, PTD[pid][8], 1);
			PlayerTextDrawColor(pid, PTD[pid][8], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][8], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][8], -1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][8], 70);
			PlayerTextDrawFont(pid, PTD[pid][8], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][8], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][8], 0);

			PTD[pid][9] = CreatePlayerTextDraw(pid, 594.190063, 10.933319, "Ping.300_FPS.120");
			PlayerTextDrawLetterSize(pid, PTD[pid][9], 0.166676, 0.999166);
			PlayerTextDrawAlignment(pid, PTD[pid][9], 2);
			PlayerTextDrawColor(pid, PTD[pid][9], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][9], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][9], 1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][9], 47);
			PlayerTextDrawFont(pid, PTD[pid][9], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][9], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][9], 0);

			PTD[pid][10] = CreatePlayerTextDraw(pid, 596.881164, 333.300170, "Predkosc:500km/h~n~Pojazd:TwojaStara~n~Stan:100%");
			PlayerTextDrawLetterSize(pid, PTD[pid][10], 0.159963, 0.928333);
			PlayerTextDrawAlignment(pid, PTD[pid][10], 2);
			PlayerTextDrawColor(pid, PTD[pid][10], -1);
			PlayerTextDrawSetShadow(pid, PTD[pid][10], 0);
			PlayerTextDrawSetOutline(pid, PTD[pid][10], 1);
			PlayerTextDrawBackgroundColor(pid, PTD[pid][10], 255);
			PlayerTextDrawFont(pid, PTD[pid][10], 2);
			PlayerTextDrawSetProportional(pid, PTD[pid][10], 1);
			PlayerTextDrawSetShadow(pid, PTD[pid][10], 0);

			PTDHA[0][pid] = CreatePlayerTextDraw(pid, 578.000000, 68.000000, "100%");
			PlayerTextDrawFont(pid, PTDHA[0][pid], 1);
			PlayerTextDrawLetterSize(pid, PTDHA[0][pid], 0.241666, 0.599996);
			PlayerTextDrawTextSize(pid, PTDHA[0][pid], 399.500000, -468.500000);
			PlayerTextDrawSetOutline(pid, PTDHA[0][pid], 1);
			PlayerTextDrawSetShadow(pid, PTDHA[0][pid], 0);
			PlayerTextDrawAlignment(pid, PTDHA[0][pid], 2);
			PlayerTextDrawColor(pid, PTDHA[0][pid], -1);
			PlayerTextDrawBackgroundColor(pid, PTDHA[0][pid], 255);
			PlayerTextDrawBoxColor(pid, PTDHA[0][pid], 50);
			PlayerTextDrawUseBox(pid, PTDHA[0][pid], 0);
			PlayerTextDrawSetProportional(pid, PTDHA[0][pid], 1);
			PlayerTextDrawSetSelectable(pid, PTDHA[0][pid], 0);
			PlayerTextDrawSetPreviewVehCol(pid, PTDHA[0][pid], 1, 1);

			PTDHA[1][pid] = CreatePlayerTextDraw(pid, 578.000000, 46.000000, "100%");
			PlayerTextDrawFont(pid, PTDHA[1][pid], 1);
			PlayerTextDrawLetterSize(pid, PTDHA[1][pid], 0.241666, 0.599999);
			PlayerTextDrawTextSize(pid, PTDHA[1][pid], 398.500000, 18.000000);
			PlayerTextDrawSetOutline(pid, PTDHA[1][pid], 1);
			PlayerTextDrawSetShadow(pid, PTDHA[1][pid], 0);
			PlayerTextDrawAlignment(pid, PTDHA[1][pid], 2);
			PlayerTextDrawColor(pid, PTDHA[1][pid], -1);
			PlayerTextDrawBackgroundColor(pid, PTDHA[1][pid], 255);
			PlayerTextDrawBoxColor(pid, PTDHA[1][pid], 50);
			PlayerTextDrawUseBox(pid, PTDHA[1][pid], 0);
			PlayerTextDrawSetProportional(pid, PTDHA[1][pid], 1);
			PlayerTextDrawSetSelectable(pid, PTDHA[1][pid], 0);
			PlayerTextDrawSetPreviewVehCol(pid, PTDHA[1][pid], 1, 1);

			StatTXD[pid][0] = CreatePlayerTextDraw(pid,621.711730, 304.916442, "Exp ~b~+500");
			PlayerTextDrawLetterSize(pid,StatTXD[pid][0], 0.555548, 1.745832);
			PlayerTextDrawAlignment(pid,StatTXD[pid][0], 3);
			PlayerTextDrawColor(pid,StatTXD[pid][0], -694091521);
			PlayerTextDrawSetShadow(pid,StatTXD[pid][0], 0);
			PlayerTextDrawSetOutline(pid,StatTXD[pid][0], 1);
			PlayerTextDrawBackgroundColor(pid,StatTXD[pid][0], 255);
			PlayerTextDrawFont(pid,StatTXD[pid][0], 3);
			PlayerTextDrawSetProportional(pid,StatTXD[pid][0], 1);
			PlayerTextDrawSetShadow(pid,StatTXD[pid][0], 0);

			StatTXD[pid][1] = CreatePlayerTextDraw(pid,621.711730, 320.717407, "Kasa ~g~+5000$");
			PlayerTextDrawLetterSize(pid,StatTXD[pid][1], 0.555548, 1.745832);
			PlayerTextDrawAlignment(pid,StatTXD[pid][1], 3);
			PlayerTextDrawColor(pid,StatTXD[pid][1], -694091521);
			PlayerTextDrawSetShadow(pid,StatTXD[pid][1], 0);
			PlayerTextDrawSetOutline(pid,StatTXD[pid][1], 1);
			PlayerTextDrawBackgroundColor(pid,StatTXD[pid][1], 255);
			PlayerTextDrawFont(pid,StatTXD[pid][1], 3);
			PlayerTextDrawSetProportional(pid,StatTXD[pid][1], 1);
			PlayerTextDrawSetShadow(pid,StatTXD[pid][1], 0);

			return 1;
		}
	//Unsorted
		stock unwatch(pid){
			if(Iter_Count(SWaI[pid]) != 0){
				foreach(new i : SWaI[pid]){
					TogglePlayerSpectating(PDV[pid][SWat][i], 0);
					PDV[PDV[pid][SWat][i]][BlDM] = false;
					if(IsValidDynamic3DTextLabel(PDV[PDV[pid][SWat][i]][DMS])){
						DestroyDynamic3DTextLabel(PDV[PDV[pid][SWat][i]][DMS]);
					}
					Iter_Remove(SWaI[pid],i);
				}
			}
			return 1;
		}
		stock ShB(pid){
			if(PDV[pid][Ba] == 1)
				{
					new stry[128];
					format(stry,sizeof(stry),"Zosta³eœ(aœ) zbanowan(a) permamentnie za naruszanie regulaminu serwera zapraszamy na "SITE_A" i przeczytaj sekcje regulamin\n\n\nA jeœli czujesz siê niewinny(a) zrob ss'a i przedstaw proœbe o ub w dziale o ub\n\nPowód: %s\nAdmin Nadaj¹cy:%s",PDV[pid][BaR],PDV[pid][BaG]);
					Dialog_Show(pid,BaD,DIALOG_STYLE_MSGBOX,"{ffffff}BAN :(",stry,"OK","OK"); return 1;
				}
			else if(PDV[pid][Ba] == 2)
				{
					new stry[128];
					new Float:x,Float:y;
					x = floatround(PDV[pid][BaT] - gettime()/86400,floatround_tozero);
					y = floatabs(floatround(PDV[pid][BaT] - gettime()/86400,floatround_tozero) * 1440 - floatround(PDV[pid][BaT] - gettime()/1440,floatround_tozero));
					format(stry,sizeof(stry),"Zosta³eœ(aœ) zbanowany(a) czasowo za naruszanie regulaminu serwera zapraszamy na "SITE_A" i przeczytaj sekcje regulamin\n\n\nA jeœli czujesz siê niewinny(a) zrob ss'a i przedstaw proœbe o ub w dziale o ub\n\nPowód: %s\nCzas Pozosta³y:%i Dni %i Minut\nAdmin Nadaj¹cy:%s",PDV[pid][BaR],x,y,PDV[pid][BaG]);
					Dialog_Show(pid,BaD,DIALOG_STYLE_MSGBOX,"{ffffff}BAN :(",stry,"OK","OK"); return 1;
				}
			else {
				Dialog_Show(pid,BaD,DIALOG_STYLE_MSGBOX,"{ffffff}á¿¹á¿³á¿¹???","á¿¹á¿³á¿¹ - á¿¹á¿³á¿¹ uá¿³u á¿¹á¿³á¿¹ á¿¹á¿³á¿¹ á¿¹á¿³á¿¹ uá¿³u uá¿³u á¿¹á¿³á¿¹ á¿¹á¿³á¿¹ uá¿³u uá¿³u uá¿³u á¿¹á¿³á¿¹ uá¿³u á¿¹á¿³á¿¹ uá¿³u á¿¹á¿³á¿¹ uá¿³u uá¿³u á¿¹á¿³á¿¹ á¿¹á¿³á¿¹ á¿¹á¿³á¿¹ uá¿³u uá¿³u á¿¹á¿³á¿¹ uá¿³u uá¿³u á¿¹á¿³á¿¹ uá¿³u á¿¹á¿³á¿¹ uá¿³u uá¿³u","A-H-A","Co kurwa?");
			}
			return 1;
		}
		stock GetPN(pid){
			new nick[24];
			GetPlayerName(pid, nick, MAX_PLAYER_NAME + 1);
			return nick;
		}
	//AdministrativeF
		stock KP(pid,str[64],AID){
			if(INVALID_PLAYER_ID == AID) {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ wyrzucony przez {565656}Bota {72000b}Powód: {8c000d}%s",PDV[pid][Nck],str);}
			else { SCMAS(-1,"{72000b}Gracz {565656}%s{72000b} zosta³(a) wyrzucony(a) przez {565656}%s{72000b} Powód: {8c000d}%s",PDV[pid][Nck],PDV[AID][Nck],str);}
			PDV[pid][ToKick] = true;
			return 1;
		}
		stock UBP(Idp,AID)
		{
			new query[120];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET Ban='0',BaT='0',reas='Erased' WHERE id='%d'",Idp);
			new queres = mq(query);
			if(queres == 0) {SCM(AID,-1,"Cos poszlo nie tak z odbanowywaniem gracza o iDP %i",Idp); return 1;}
			SCM(AID,-1,"Gracz o iDP %i zosta³ odbanowany",Idp);
			return 1;
		}
		stock BP(pid,str[64],AID){
			if(INVALID_PLAYER_ID == AID) {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ zbanowany przez {565656}Bota {72000b}Powód: %s",PDV[pid][Nck],str);}
			else { SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ zbanowany przez {565656}%s {72000b}Powód: %s",PDV[pid][Nck],PDV[AID][Nck],str);}
			new query[120];
			mysql_format(DBM, query, sizeof(query), "UPDATE `plys` SET `Ban`='1',`reas`='%s' WHERE `id`='%d'",str,PDV[pid][iDP]);
			mq(query);
			PDV[pid][ToKick] = true;
			return 1;
		}
		stock BPT(pid,str[64],AID,td,tm){
			if(INVALID_PLAYER_ID == AID) {SCMAS(-1,"{72000b}Gracz {565656}%s zosta³ zbanowany przez {565656}Bota {72000b}na czas {565656}%i Dni i %i Minut {72000b}Powód:{8c000d}%s",PDV[pid][Nck],td,tm,str);}
			else {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ zbanowany przez {565656}%s{72000b} na czas {565656}%i Dni{72000b}Powód:{8c000d}%s",PDV[pid][Nck],PDV[AID][Nck],td,str);}
			td=gettime() + (td * 86400 + tm * 60);
			new query[148];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET `Ban`='2', `reas`='%s', 'BaT'='%i' WHERE `id`='%i'",str,td,PDV[pid][iDP]);
			mq(query);
			PDV[pid][ToKick] = true;
			return 1;
		}
		stock MPl(pid,str[64],AID,t)
		{
			if(INVALID_PLAYER_ID == AID) {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ uciszony przez {565656}Bota {72000b}Powód:{8c000d}%s",PDV[pid][Nck],str);}
			else {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ uciszony przez {565656}%s {72000b}Powód:{8c000d}%s",PDV[pid][Nck],PDV[AID][Nck],str);}
			t = gettime() + t;
			new query[125];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET `Mute`='%i' WHERE `id`='%i'",t,PDV[pid][iDP]);
			PDV[pid][CMT] = t;
			return 1;
		}
		stock UMPl(pid,AID)
		{
			new query[125];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET `Mute`='0' WHERE `id`='%i'",PDV[pid][iDP]);
			PDV[pid][CMT] = 0;
			SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Admin %s odmutowa³ ciê",PDV[AID][Nck]);
			return 1;
		}
		stock JL(pid,t,AID,reas[64])
		{
			if(INVALID_PLAYER_ID == AID) {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ uwiêziony przez {565656}Bota {72000b}Powód:{8c000d}%s",PDV[pid][Nck],reas);}
			else {SCMAS(-1,"{72000b}Gracz {565656}%s {72000b}zosta³ uwieziony przez {565656}%s {72000b}Powód:{8c000d}%s",PDV[pid][Nck],PDV[AID][Nck],reas);}
			if(Busy(pid)){UnBusy(pid);}
			t = PDV[pid][JaT] = gettime() + t;
			PDV[pid][BlCMD] = true;
			PDV[pid][CMT] = t;
			SqlEscStr(reas,reas);
			PDV[pid][Jailed] = true;
			new query[150];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET `JaTi`='%i',`JaTR`='%s' WHERE `id`='%i'",PDV[pid][JaT],reas,PDV[pid][iDP]);
			mq(query);
			SetPlayerPos(pid, JP_X,JP_Y,JP_Z);
			SetPlayerVirtualWorld(pid, pid+201);
			return 1;
		}
		stock UJL(pid)
		{
			PDV[pid][JaT] = gettime()-1;
			PDV[pid][BlCMD] = false;
			PDV[pid][Jailed] = false;
			new query[71];
			mysql_format(DBM,query,sizeof(query),"UPDATE `plys` SET `JaTi`='%i',`JaTR`='Erased' WHERE `id`='%i'",gettime()-1,PDV[pid][iDP]);
			mq(query);
			ReS(pid);
			return 1;
		}
	//Resp
		stock ReS(pid)
		{
			PDV[pid][Dying] = false;
			if(PDV[pid][CorP] == 1){
				return 1;
			}
			foreach(Player,i)
			{
				if(PDV[i][Spect] == pid){
					TogglePlayerSpectating(i, 1);
					PlayerSpectatePlayer(i, pid, SPECTATE_MODE_NORMAL);
				}
			}
			if(PDV[pid][pcolo] != 0){
				SetPlayerColor(pid, PDV[pid][pcolo]);
			}else {
				new ran = random(sizeof(PlCol));
				SetPlayerColor(pid,PlCol[ran]);
			}
			ResetPlayerWeapons(pid);
			SetPlayerSkin(pid,PDV[pid][PSk]);
			if(PDV[pid][Arena] == 0){
				PDV[pid][SGod] = true;
				SetPlayerHealth(pid,0x7F800000);
			}
			if((GM[wyp] == -2 || GM[drby] == -2) && PDV[pid][Plays] > 0){PDV[pid][Plays] = 0;}
			if(PDV[pid][JaT] > gettime()){JL(pid,PDV[pid][JaT] - gettime(),INVALID_PLAYER_ID,"Ucieczka"); return 1;}
			SPlMo(pid, PDV[pid][Csh]);
			switch(PDV[pid][Arena]){
				case 1:return SeUpODP(pid);
				case 3:return SeUpPP(pid);
				case 4:return SeUpMin(pid);
			}
			HideHud(pid);
			ShowHUD(pid);
			if(PDV[pid][LaX] != 0.000){
				SetPlayerPos(pid,PDV[pid][LaX],PDV[pid][LaY],PDV[pid][LaZ]);
				PDV[pid][LaX] = 0.000;
				PDV[pid][LaY] = 0.000;
				PDV[pid][LaZ] = 0.000;
			}else {
				new rand = random(sizeof(RandomSpawns));
				SetPlayerPos(pid,RandomSpawns[rand][0],RandomSpawns[rand][1],RandomSpawns[rand][2]);
			}
			SetPlayerVirtualWorld(pid,0);
			SetPlayerInterior(pid,0);
			GivePlayerWeapon(pid, 24, 4000);
			GivePlayerWeapon(pid, 25, 4000);
			GivePlayerWeapon(pid, 30, 4000);
			GivePlayerWeapon(pid, 7, 1);
			GivePlayerWeapon(pid, 28, 4000);
			SRe(pid,PDV[pid][Rsp]);
			if(PDV[pid][Csh] == 0 && GetPlayerMoney(pid) == 0){GiPlMo(pid,15000);}
			return 1;
		}
	//Report
		stock InfAd(pid,rID,inf[32])
		{
			new FrSpa = Iter_Free(ReporI);
			if(FrSpa == -1) {SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Raportów jest pe³no"); return 0;}
			Iter_Add(ReporI, FrSpa);
			format(Repor[FrSpa],40,"%i\t%i\t%s\n",pid,rID,inf);

			return 1;
		}
	//Csh/Money
		stock GiPlMo(pid,AoM)
		{
			new string[25];
			format(string,sizeof(string),"Kasa ~g~+%i",AoM);
			PlayerTextDrawSetString(pid,StatTXD[pid][1], string);
			PlayerTextDrawShow(pid, StatTXD[pid][1]);
			PlayerPlaySound(pid, 1083, 0.0,0.0,0.0);
			PDV[pid][nCtD] += GetTickCount()+3000;
			PDV[pid][SetF] = 8;
			PDV[pid][Csh] = PDV[pid][Csh] + AoM;
			GivePlayerMoney(pid, AoM);
			return 1;
		}
		stock SPlMo(pid,AoM){
			PDV[pid][Csh] = AoM;
			GivePlayerMoney(pid,-GetPlayerMoney(pid));
			GivePlayerMoney(pid,PDV[pid][Csh]);
			return 1;
		}
		stock TkPlMo(pid,AoM)
		{
			if(GetPlayerMoney(pid) > PDV[pid][Csh]){InfAd(INVALID_PLAYER_ID,pid,"Prawdopodobny Money Hack");}
			if(PDV[pid][Csh] < AoM) {PlayerPlaySound(pid, 1085, 0.0,0.0,0.0); return 0;}
			PDV[pid][Csh] = PDV[pid][Csh] - AoM;
			AoM = -AoM;
			new string[25];
			format(string,sizeof(string),"Kasa ~g~-%i",AoM);
			PlayerTextDrawSetString(pid,StatTXD[pid][1], string);
			PlayerTextDrawShow(pid, StatTXD[pid][1]);
			PlayerPlaySound(pid, 1084, 0.0,0.0,0.0);
			PDV[pid][nCtD] += GetTickCount()+3000;
			PDV[pid][SetF] = 8;
			GivePlayerMoney(pid,AoM);
			return 1;
		}
		stock SRe(pid,AoR)
		{
			PDV[pid][Rsp] = AoR;
			SetPlayerScore(pid,PDV[pid][Rsp]);
			return 1;
		}
		stock GiRe(pid,AoR)
		{
			new string[25];
			format(string,sizeof(string),"EXP ~b~+%i",AoR);
			PlayerTextDrawSetString(pid,StatTXD[pid][0], string);
			PlayerTextDrawShow(pid, StatTXD[pid][0]);
			PlayerPlaySound(pid, 1083, 0.0,0.0,0.0);
			PDV[pid][nCtD] += GetTickCount()+3000;
			PDV[pid][SetF] = 7;
			PDV[pid][Rsp] += AoR;
			SetPlayerScore(pid, PDV[pid][Rsp]);
			return 1;
		}
		stock TkPlRe(pid,AoR)
		{
			if(GetPlayerScore(pid) > PDV[pid][Rsp]){InfAd(pid,INVALID_PLAYER_ID,"Prawdopodobny Score Hack");}
			if(PDV[pid][Rsp] < AoR) {PlayerPlaySound(pid, 1085, 0.0,0.0,0.0);return 0;}
			new string[25];
			format(string,sizeof(string),"EXP ~r~-%i",AoR);
			PlayerTextDrawSetString(pid,StatTXD[pid][0], string);
			PlayerTextDrawShow(pid, StatTXD[pid][0]);
			PlayerPlaySound(pid, 1084, 0.0,0.0,0.0);
			PDV[pid][nCtD] += GetTickCount()+3000;
			PDV[pid][SetF] = 7;
			PDV[pid][Rsp] -= AoR;
			SetPlayerScore(pid,PDV[pid][Rsp]);
			return 1;
		}
	//IDK
		forward cidponx(pid,name[32]);public cidponx(pid,name[32]){
			if(cache_num_rows() > 0){
				new ret;
				cache_get_value_index_int(0, 0, ret);
				new str[32];

				format(str,sizeof(str),"Nick:%s\n\n\nIDP:%i",name,ret);
				Dialog_Show(pid,retidp,DIALOG_STYLE_MSGBOX,"IDP",str,"OK","Yep");
			}
			else {
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000} Nie ma takiego gracza, pewnie uciek³");
			}
			return 1;
		}
	//Areny
		stock SeUpODP(pid)
		{
			if(PDV[pid][Arena] == 0){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz {afffd4}%s {00ff00}do³¹czy³ na {aa0000}/onede !",PDV[pid][Nck]);
				PDV[pid][Arena] = 1;
				GM[arP][0]++;
				new str[64];
				format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
				TextDrawSetString(red[21], str);
			}
			new rand = random(sizeof(OdeS));
			SetPlayerInterior(pid, 3);
			SetPlayerVirtualWorld(pid,2);
			SetPlayerPos(pid,OdeS[rand][0],OdeS[rand][1],OdeS[rand][2]);
			SetPlayerHealth(pid,30);
			SetPlayerArmour(pid,0);
			ResetPlayerWeapons(pid);
			GivePlayerWeapon(pid,24,10000);
			return 1;
		}
		stock SeUpRPG(pid)
		{
			if(PDV[pid][Arena] == 0){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz {afffd4}%s {00ff00}do³¹czy³ na {aa0000}/onede !",PDV[pid][Nck]);
				PDV[pid][Arena] = 6;
				GM[arP][4]++;
				new str[64];
				format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
				TextDrawSetString(red[21], str);
			}
			new rand = random(sizeof(OdeS));
			SetPlayerInterior(pid, 3);
			SetPlayerVirtualWorld(pid,54);
			SetPlayerPos(pid,OdeS[rand][0],OdeS[rand][1],OdeS[rand][2]);
			SetPlayerHealth(pid,100);
			SetPlayerArmour(pid,0);
			ResetPlayerWeapons(pid);
			GivePlayerWeapon(pid,35,10000);
			return 1;
		}
		stock SeUpPP(pid){
			if(PDV[pid][Arena] == 0){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz {afffd4}%s {00ff00}do³¹czy³ na {aa0000}/pompa !",PDV[pid][Nck]);
				PDV[pid][Arena] = 3;
				GM[arP][1]++;
				new str[64];
				format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
				TextDrawSetString(red[21], str);
			}
			new r = random(sizeof(PompS));
			SetPlayerInterior(pid, 1);
			SetPlayerVirtualWorld(pid, 51);
			SetPlayerPos(pid,PompS[r][0],PompS[r][1],PompS[r][2]);
			SetPlayerFacingAngle(pid, PompS[r][3]);
			SetPlayerHealth(pid, 30);
			SetPlayerArmour(pid, 0);
			ResetPlayerWeapons(pid);
			GivePlayerWeapon(pid, 25, 4000);
			return 1;
		}
		stock SeUpMin(pid){
			if(PDV[pid][Arena] == 0){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz {afffd4}%s {00ff00}do³¹czy³ na {aa0000}/minigun !",PDV[pid][Nck]);
				PDV[pid][Arena] = 4;
				GM[arP][2]++;
				new str[64];
				format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
				TextDrawSetString(red[21], str);
			}
			new r = random(sizeof(MiniS));
			SetPlayerVirtualWorld(pid, 52);
			SetPlayerFacingAngle(pid, MiniS[r][3]);
			SetPlayerPos(pid,MiniS[r][0],MiniS[r][1],MiniS[r][2]);
			SetPlayerHealth(pid, 100);
			SetPlayerArmour(pid, 100);
			PDV[pid][MinIn] = -1;
			GangZoneShowForPlayer(pid, MiniZ[1], 0xaaffaaaa);
			ResetPlayerWeapons(pid);
			GivePlayerWeapon(pid, 38, 100000);
			return 1;
		}
		stock SeUpSP(pid){
			if(PDV[pid][Arena] == 0){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz {afffd4}%s {00ff00}do³¹czy³ na {aa0000}/sniper !",PDV[pid][Nck]);
				PDV[pid][Arena] = 5;
				GM[arP][3]++;
				new str[64];
				format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
				TextDrawSetString(red[21], str);
			}
			new r = random(sizeof(SnipS));
			SetPlayerInterior(pid, 10);
			SetPlayerVirtualWorld(pid, 53);
			SetPlayerPos(pid,SnipS[r][0],SnipS[r][1],SnipS[r][2]);
			SetPlayerFacingAngle(pid, SnipS[r][3]);
			SetPlayerHealth(pid, 50);
			SetPlayerArmour(pid, 0);
			ResetPlayerWeapons(pid);
			GivePlayerWeapon(pid, 34, 100000);
			return 1;
		}
		stock Busy(pid){
			if(PDV[pid][Arena] >= 1) return 1;
			if(PDV[pid][Wat] != -1) return 1;
			switch(PDV[pid][Plays]){
				case 1:if(GM[wyp] == -2)return 1;
				case 2:if(GM[drby] == -2)return 1;
				case 3:if(GM[wgs] == -2)return 1;
				case 4:if(GM[Smo] == -2)return 1;
			}
			return 0;
		}
		stock UnBusy(pid){
			if(PDV[pid][Arena] >= 1){callcmd::opusc(pid,"");}
			if(PDV[pid][Plays] >= 1){callcmd::opusc(pid,"");}
			return 1;
		}
		stock SetUpSol(pid,Cpid){
			GetPlayerPos(pid,PDV[pid][LaX],PDV[pid][LaY],PDV[pid][LaZ]);
			GetPlayerPos(Cpid,PDV[Cpid][LaX],PDV[Cpid][LaY],PDV[Cpid][LaZ]);
			if(PDV[pid][SoA] == 1){
				SetPlayerPos(pid,1414.9468,-18.7296,1000.9255);
				SetPlayerInterior(pid,1);
				SetPlayerInterior(Cpid,1);
				SetPlayerVirtualWorld(pid,pid);
				SetPlayerVirtualWorld(Cpid,pid);
				SetPlayerPos(Cpid,1362.6240,-21.9134,1000.9219);
				SetPlayerFacingAngle(pid,89.4061);
				SetPlayerFacingAngle(Cpid,269.5744);
			}
			else if(PDV[pid][SoA] == 2){
				SetPlayerPos(pid,-440.8009,-1810.2782,1755.3666);
				SetPlayerFacingAngle(pid,178.3393);
				SetPlayerPos(Cpid,-441.0726,-1832.9063,1755.3666);
				SetPlayerFacingAngle(Cpid,3.1843);
				SetPlayerInterior(pid,5);
				SetPlayerInterior(Cpid,5);
				SetPlayerVirtualWorld(pid,pid);
				SetPlayerVirtualWorld(Cpid,pid);
			}
			else{
			}
			
			GivePlayerWeapon(pid,PDV[pid][SoBr],5000);
			GivePlayerWeapon(Cpid,PDV[pid][SoBr],5000);
			SetPlayerHealth(pid,100);
			SetPlayerHealth(Cpid,100);
			SetPlayerArmour(Cpid,100);
			SetPlayerArmour(pid,100);
			TogglePlayerControllable(pid,0);
			TogglePlayerControllable(Cpid,0);
			PDV[pid][Arena] = PDV[Cpid][Arena] = 2;

			PDV[pid][SoBr] = 0;


			PDV[pid][SetF] = PDV[Cpid][SetF] = 1;
			PDV[pid][CtD] = PDV[Cpid][CtD] = GetTickCount()+5000;
			return 1;
		}
	//Cars
		stock RspCars(){
			new bool:d=false;
			for(new i=0;i<MAX_VEHICLES;i++){
				d=false;
				if(IsValidVehicle(i)){
					for(new b=0,x=sizeof(SVehs);b<x;b++)
					{
						if(i == SVehs[b]){d = true;}
					}
					foreach(new b : Privs){
						if(i == PCDV[b][pveh]){d = true;}
					}
					if(!d){
						foreach(Player,x){
							if(GetPlayerVehicleID(x) == i){
								d=true;
							}
						}
						if(!d){DestroyVehicle(i);}
					}
				}
			}
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaeeaa}Zrespawnowano pojazdy");
			return 1;
		}
		stock GetVehidByName(str[24])
		{
			for(new i=0;i<212;i++){
				if(strfind(VehNam[i],str,true) != -1) return i+400;
			}
			return -1;
		}
		stock TuneVeh(vid){
			new i = GetVehicleModel(vid);
			switch(i){
				case 400:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1024);
				}
				case 401:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 404:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 405:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1014);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1023);
				}
				case 410:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1024);
				}
				case 415:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1023);
				}
				case 418:{
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 420:{
					AddVehicleComponent(vid,1087);
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1021);
				}
				case 421:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1014);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1023);
				}
				case 422:{
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 426:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1021);
				}
				case 436:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1022);
				}
				case 439:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 477:{
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 478:{
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1012);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1022);
					AddVehicleComponent(vid,1024);
				}
				case 489:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1024);
				}
				case 491:{
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1014);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 492:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1016);
				}
				case 496:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1011);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
				}
				case 500:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1024);
				}
				case 505:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1024);
				}
				case 516:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1015);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 517:{
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 518:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 527:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1014);
					AddVehicleComponent(vid,1015);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 529:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1011);
					AddVehicleComponent(vid,1012);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
				}
				case 534:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1100);
					AddVehicleComponent(vid,1101);
					AddVehicleComponent(vid,1106);
					AddVehicleComponent(vid,1122);
					AddVehicleComponent(vid,1123);
					AddVehicleComponent(vid,1124);
					AddVehicleComponent(vid,1125);
					AddVehicleComponent(vid,1126);
					AddVehicleComponent(vid,1127);
					AddVehicleComponent(vid,1178);
					AddVehicleComponent(vid,1179);
					AddVehicleComponent(vid,1180);
					AddVehicleComponent(vid,1185);
				}
				case 535:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1109);
					AddVehicleComponent(vid,1110);
					AddVehicleComponent(vid,1111);
					AddVehicleComponent(vid,1112);
					AddVehicleComponent(vid,1113);
					AddVehicleComponent(vid,1114);
					AddVehicleComponent(vid,1115);
					AddVehicleComponent(vid,1116);
					AddVehicleComponent(vid,1117);
					AddVehicleComponent(vid,1118);
					AddVehicleComponent(vid,1119);
					AddVehicleComponent(vid,1120);
					AddVehicleComponent(vid,1121);
				}
				case 536:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1103);
					AddVehicleComponent(vid,1104);
					AddVehicleComponent(vid,1105);
					AddVehicleComponent(vid,1107);
					AddVehicleComponent(vid,1108);
					AddVehicleComponent(vid,1128);
					AddVehicleComponent(vid,1181);
					AddVehicleComponent(vid,1182);
					AddVehicleComponent(vid,1183);
					AddVehicleComponent(vid,1184);
				}
				case 540:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1024);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 542:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1014);
					AddVehicleComponent(vid,1015);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 546:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1024);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 547:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
				}
				case 549:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1011);
					AddVehicleComponent(vid,1012);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 550:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 551:{
					AddVehicleComponent(vid,1002);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1021);
					AddVehicleComponent(vid,1023);
				}
				case 558:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1088);
					AddVehicleComponent(vid,1089);
					AddVehicleComponent(vid,1090);
					AddVehicleComponent(vid,1091);
					AddVehicleComponent(vid,1092);
					AddVehicleComponent(vid,1093);
					AddVehicleComponent(vid,1094);
					AddVehicleComponent(vid,1095);
					AddVehicleComponent(vid,1163);
					AddVehicleComponent(vid,1164);
					AddVehicleComponent(vid,1165);
					AddVehicleComponent(vid,1166);
					AddVehicleComponent(vid,1167);
					AddVehicleComponent(vid,1168);
				}
				case 559:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1065);
					AddVehicleComponent(vid,1066);
					AddVehicleComponent(vid,1067);
					AddVehicleComponent(vid,1068);
					AddVehicleComponent(vid,1069);
					AddVehicleComponent(vid,1070);
					AddVehicleComponent(vid,1071);
					AddVehicleComponent(vid,1072);
					AddVehicleComponent(vid,1158);
					AddVehicleComponent(vid,1159);
					AddVehicleComponent(vid,1160);
					AddVehicleComponent(vid,1161);
					AddVehicleComponent(vid,1162);
					AddVehicleComponent(vid,1173);
				}
				case 560:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1026);
					AddVehicleComponent(vid,1027);
					AddVehicleComponent(vid,1028);
					AddVehicleComponent(vid,1029);
					AddVehicleComponent(vid,1030);
					AddVehicleComponent(vid,1031);
					AddVehicleComponent(vid,1032);
					AddVehicleComponent(vid,1033);
					AddVehicleComponent(vid,1138);
					AddVehicleComponent(vid,1139);
					AddVehicleComponent(vid,1140);
					AddVehicleComponent(vid,1141);
					AddVehicleComponent(vid,1169);
					AddVehicleComponent(vid,1170);
				}
				case 561:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1055);
					AddVehicleComponent(vid,1056);
					AddVehicleComponent(vid,1057);
					AddVehicleComponent(vid,1058);
					AddVehicleComponent(vid,1059);
					AddVehicleComponent(vid,1060);
					AddVehicleComponent(vid,1061);
					AddVehicleComponent(vid,1062);
					AddVehicleComponent(vid,1063);
					AddVehicleComponent(vid,1064);
					AddVehicleComponent(vid,1154);
					AddVehicleComponent(vid,1155);
					AddVehicleComponent(vid,1156);
					AddVehicleComponent(vid,1157);
				}
				case 562:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1034);
					AddVehicleComponent(vid,1035);
					AddVehicleComponent(vid,1036);
					AddVehicleComponent(vid,1037);
					AddVehicleComponent(vid,1038);
					AddVehicleComponent(vid,1039);
					AddVehicleComponent(vid,1040);
					AddVehicleComponent(vid,1041);
					AddVehicleComponent(vid,1146);
					AddVehicleComponent(vid,1147);
					AddVehicleComponent(vid,1148);
					AddVehicleComponent(vid,1149);
					AddVehicleComponent(vid,1171);
					AddVehicleComponent(vid,1172);
				}
				case 565:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1045);
					AddVehicleComponent(vid,1046);
					AddVehicleComponent(vid,1047);
					AddVehicleComponent(vid,1048);
					AddVehicleComponent(vid,1049);
					AddVehicleComponent(vid,1050);
					AddVehicleComponent(vid,1051);
					AddVehicleComponent(vid,1052);
					AddVehicleComponent(vid,1053);
					AddVehicleComponent(vid,1054);
					AddVehicleComponent(vid,1150);
					AddVehicleComponent(vid,1151);
					AddVehicleComponent(vid,1152);
					AddVehicleComponent(vid,1153);
				}
				case 567:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1102);
					AddVehicleComponent(vid,1129);
					AddVehicleComponent(vid,1130);
					AddVehicleComponent(vid,1131);
					AddVehicleComponent(vid,1132);
					AddVehicleComponent(vid,1133);
					AddVehicleComponent(vid,1186);
					AddVehicleComponent(vid,1187);
					AddVehicleComponent(vid,1188);
					AddVehicleComponent(vid,1189);
				}
				case 575:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1042);
					AddVehicleComponent(vid,1043);
					AddVehicleComponent(vid,1044);
					AddVehicleComponent(vid,1099);
					AddVehicleComponent(vid,1174);
					AddVehicleComponent(vid,1175);
					AddVehicleComponent(vid,1176);
					AddVehicleComponent(vid,1177);
				}
				case 576:{
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1134);
					AddVehicleComponent(vid,1135);
					AddVehicleComponent(vid,1136);
					AddVehicleComponent(vid,1137);
					AddVehicleComponent(vid,1190);
					AddVehicleComponent(vid,1191);
					AddVehicleComponent(vid,1192);
					AddVehicleComponent(vid,1193);
				}
				case 580:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
				}
				case 585:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1003);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 589:{
					AddVehicleComponent(vid,1000);
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1016);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1024);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
				case 600:{
					AddVehicleComponent(vid,1004);
					AddVehicleComponent(vid,1005);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1013);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1022);
				}
				case 603:{
					AddVehicleComponent(vid,1001);
					AddVehicleComponent(vid,1006);
					AddVehicleComponent(vid,1007);
					AddVehicleComponent(vid,1009);
					AddVehicleComponent(vid,1010);
					AddVehicleComponent(vid,1017);
					AddVehicleComponent(vid,1018);
					AddVehicleComponent(vid,1019);
					AddVehicleComponent(vid,1020);
					AddVehicleComponent(vid,1023);
					AddVehicleComponent(vid,1024);
					AddVehicleComponent(vid,1142);
					AddVehicleComponent(vid,1143);
					AddVehicleComponent(vid,1144);
					AddVehicleComponent(vid,1145);
				}
			}
			return 0;
		}
	//Function calling
		stock CallF(i){
			if(PDV[i][CorP] == 1){
				return 1;
			}
			switch(PDV[i][SetF])
			{
				case 1:
				{TogglePlayerControllable(i,1);}
				case 2:
				{ReS(i);PDV[i][Arena] = 0;}
				case 3:
				{new Float:x,Float:y,Float:z; GetPlayerPos(i,x,y,z); SetPlayerPos(i, x,y,z+200); TogglePlayerControllable(i, 1); ResetPlayerWeapons(i);GivePlayerWeapon(i, 46, 1); SetPlayerArmedWeapon(i, 46);}
				case 4:
				{callcmd::wyjdz(i,"");}
				case 5:{
					ResetPlayerWeapons(i); 
					SetPlayerPos(i, ChS[GM[aCh]][0],ChS[GM[aCh]][1],ChS[GM[aCh]][2]);
					SetPlayerFacingAngle(i, ChS[GM[aCh]][3]); 
					SetPlayerVirtualWorld(i, 55);
					SetPlayerInterior(i,floatround(ChS[GM[aCh]][4],floatround_round));
					GivePlayerWeapon(i, 38, 10000);
				}
				case 6:{SetPlayerHealth(i, 0);}
				case 7:{PlayerTextDrawHide(i, StatTXD[i][0]);}
				case 8:{PlayerTextDrawHide(i, StatTXD[i][1]);}
			}
			PDV[i][SetF] = 0;
			return 1;
		}
	//GetBots ibiza
		stock getBots(test_ip[])
		{
			new against_ip[16], ip_count;

			foreach(Player, playerid)
			{
				GetPlayerIp(playerid, against_ip, 16);

				if(!strcmp(against_ip, test_ip)) ip_count++;
			}
			return ip_count;
		}
	//GetFps
		stock GetPlayerFps(playerid){
		    new drunknew;
    		drunknew = GetPlayerDrunkLevel(playerid);
    
			if(drunknew < 100) {
				SetPlayerDrunkLevel(playerid, 2000);
			}
			else
			{
				if(PDV[playerid][drunklevellast] != drunknew)
				{
					new wfps = PDV[playerid][drunklevellast] - drunknew;
					if ((wfps > 0) && (wfps < 200))
						PDV[playerid][Fps] = wfps;
				
					PDV[playerid][drunklevellast] = drunknew;
        		}
        	}  
        	return PDV[playerid][Fps];
		}
	//Osi¹gniecia
	//PrivCar
		stock UpdPriv3DTxT(cidp){
			new str[200];
			format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}W³aœciciel:%s\nPrzebieg:%iKM\nID:%i",PCDV[cidp][pcONi],floatround(PCDV[cidp][przebieg],floatround_round),PCDV[cidp][pcidp]);
			UpdateDynamic3DTextLabelText(PCDV[cidp][pc3d], -1, str);
			return 1;
		}
		stock CreatePrivCar(owidp){
			new quer[45];
			mysql_format(DBM,quer,sizeof(quer),"SELECT * FROM `privc` WHERE `Oid`='%i'",owidp);
			tmq(quer,"GetPCDat","");
			return 1;
		}
		stock UnLoadPrivC(cidp){
			if(!Iter_Contains(Privs, cidp)){return 0;}
			SvPrivC(cidp);
			Iter_Remove(Privs, cidp);
			if(IsValidVehicle(PCDV[cidp][pveh])){DestroyVehicle(PCDV[cidp][pveh]);}
			if(IsValidDynamic3DTextLabel(PCDV[cidp][pc3d])){DestroyDynamic3DTextLabel(PCDV[cidp][pc3d]);}
			PCDV[cidp][pcidp] = -1;
			PCDV[cidp][PJB] = -1;
			PCDV[cidp][PCcolor][0] = -1;
			PCDV[cidp][PCN] = -1;
			PCDV[cidp][pOid] = -1;
			PCDV[cidp][pcmodel] = -1;
			PCDV[cidp][pccomp][0] = EOS;
			PCDV[cidp][pveh] = -1;
			PCDV[cidp][pcexpc] = -1;
			PCDV[cidp][pcmoc] = -1;
			PCDV[cidp][pcONi][0] = EOS;
			PCDV[cidp][Komornik] = false;
			return 1;
		}
		stock SvPrivC(id){
			new quer[306];
			new Float:x,Float:y,Float:z,Float:an;
			GetVehicleZAngle(PCDV[id][pveh], an);
			GetVehiclePos(PCDV[id][pveh],x,y,z);
			GVC(PCDV[id][pveh],PCDV[id][PCcolor][0],PCDV[id][PCcolor][1]);
			new comp[75];
			format(comp,sizeof(comp),"%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i",GetVehicleComponentInSlot(PCDV[id][pveh], 0),GetVehicleComponentInSlot(PCDV[id][pveh], 1),GetVehicleComponentInSlot(PCDV[id][pveh], 2),GetVehicleComponentInSlot(PCDV[id][pveh], 3),GetVehicleComponentInSlot(PCDV[id][pveh], 4),GetVehicleComponentInSlot(PCDV[id][pveh], 5),GetVehicleComponentInSlot(PCDV[id][pveh], 6),GetVehicleComponentInSlot(PCDV[id][pveh], 7),GetVehicleComponentInSlot(PCDV[id][pveh], 8),
			GetVehicleComponentInSlot(PCDV[id][pveh], 9),GetVehicleComponentInSlot(PCDV[id][pveh], 10),GetVehicleComponentInSlot(PCDV[id][pveh], 11),GetVehicleComponentInSlot(PCDV[id][pveh], 12),GetVehicleComponentInSlot(PCDV[id][pveh], 13));
			mysql_format(DBM, quer,sizeof(quer),"UPDATE `privc` SET `color1`='%i',`color2`='%i',`LaX`='%f',`LaY`='%f',`LaZ`='%f',`LaAn`='%f',`Components`='%s',`PaintJob`='%i',`Neon`='%i',`przebieg`='%f' WHERE `id`='%i'",PCDV[id][PCcolor][0],PCDV[id][PCcolor][1],x,y,z,an,comp,GPj(PCDV[id][pveh]),PCDV[id][PCN],PCDV[id][przebieg],PCDV[id][pcidp]);
			mysql_query(DBM,quer,false);
			return 1;
		}
		stock AddPriCar(Float:x,Float:y,Float:z,Float:an,mod,mon,xp,color1,color2,oid){
			new id = Iter_Free(Privs);
			Iter_Add(Privs,id);
			PCDV[id][pveh] = CreateVehicle(mod, x,y,z,an, color1,color2, -1);
			PCDV[id][pcmodel] = mod;
			PCDV[id][pcidp] = id;
			PCDV[id][pcexpc] = xp;
			PCDV[id][pcmoc] = mon;
			PCDV[id][PCcolor][0] = color1;
			PCDV[id][PCcolor][1] = color2;
			PCDV[id][pOid] = oid;
			new str[156];
			if(oid == -1){format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}Do Kupienia\nExp:{aaffc6}%i\n{ffffff}Pieni¹dze:{fff0aa}%i\n{ffffff}ID:%i",PCDV[id][pcexpc],PCDV[id][pcmoc],PCDV[id][pcidp]);}
			else{
				new quer[64];
				mysql_format(DBM, quer,64, "SELECT `nck` FROM `plys` WHERE `id`='%i'",oid);
				new Cache:res = mysql_query(DBM, quer,true);
				cache_get_value_index(0, 0, PCDV[id][pcONi],24);
				cache_delete(res);
				format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}W³aœciciel:%s\n{ffffff}ID:%i",PCDV[id][pcONi],PCDV[id][pcidp]);
			}
			PCDV[id][pc3d] = CreateDynamic3DTextLabel(str, -1, 0.0,0.0,0.0,20.0, INVALID_PLAYER_ID, PCDV[id][pveh]);
			new quer[600];
			mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `privc`(`id`,`color1`,`color2`,`LaX`,`LaY`,`LaZ`,`LaAn`,`pcmodel`,`cxp`,`cmo`,`Oid`) VALUES('%i','%i','%i','%f','%f','%f','%f','%i','%i','%i','%i')",id, color1, color2,x,y,z,an,mod,mon,xp,oid);
			mq(quer);
			return 1;
		}
		stock RemPriCar(cidp){
			DestroyVehicle(PCDV[cidp][pveh]);
			DestroyDynamic3DTextLabel(PCDV[cidp][pc3d]);
			new quer[128];
			mysql_format(DBM, quer, sizeof(quer), "DELETE FROM `privc` WHERE `id`='%i'",cidp);
			mq(quer);
			return 1;
		}
		CMD:przywolaj(playerid,params[]){
			if(IsPlayerInAnyVehicle(playerid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}WyjdŸ z auta wpierw"); return 1;}
			if(PDV[playerid][kmrnik]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Miej pieni¹dze na jutro a mo¿e twoje auto zostanie przywrócone"); return 1;}
			new c=-1;
			foreach(new i : Privs){
				if(PDV[playerid][iDP] == PCDV[i][pOid]){
					c = i;
					break;
				}
			}
			if(c == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie posiadasz prywatnego auta :C"); return 1;}
			if(!IsValidVehicle(PCDV[c][pveh])){
				new str[256];
				PCDV[c][pveh] = CreateVehicle(PCDV[c][pcmodel], 0.0000,0.000,0.000,0.000,PCDV[c][PCcolor][0],PCDV[c][PCcolor][1], -1);
				format(str, sizeof(str), "{ff0000}-{aaffaa}PRIVCAR{ff0000}-\n{ffffff}W³aœciciel:%s\n{ffffff}ID:%i",PCDV[c][pcONi],PCDV[c][pcidp]);
				DestroyDynamic3DTextLabel(PCDV[c][pc3d]);
				PCDV[c][pc3d] = CreateDynamic3DTextLabel(str, -1, 0.000,0.000,0.000,15.0, INVALID_PLAYER_ID, PCDV[c][pveh]);
				new comp[14];
				sscanf(PCDV[c][pccomp],"p<,>iiiiiiiiiiiiii",comp[0],comp[1],comp[2],comp[3],comp[4],comp[5],comp[6],comp[7],comp[8],comp[9],comp[10],comp[11],comp[12],comp[13]);
				AddVehicleComponent(PCDV[c][pveh], comp[0]);
				AddVehicleComponent(PCDV[c][pveh], comp[1]);
				AddVehicleComponent(PCDV[c][pveh], comp[2]);
				AddVehicleComponent(PCDV[c][pveh], comp[3]);
				AddVehicleComponent(PCDV[c][pveh], comp[4]);
				AddVehicleComponent(PCDV[c][pveh], comp[5]);
				AddVehicleComponent(PCDV[c][pveh], comp[6]);
				AddVehicleComponent(PCDV[c][pveh], comp[7]);
				AddVehicleComponent(PCDV[c][pveh], comp[8]);
				AddVehicleComponent(PCDV[c][pveh], comp[9]);
				AddVehicleComponent(PCDV[c][pveh], comp[10]);
				AddVehicleComponent(PCDV[c][pveh], comp[11]);
				AddVehicleComponent(PCDV[c][pveh], comp[12]);
				AddVehicleComponent(PCDV[c][pveh], comp[13]);
				ChangeVehiclePaintjob(PCDV[c][pveh], PCDV[c][PJB]);
			}
			new Float:x,Float:y,Float:z,Float:ang;
			GetPlayerPos(playerid, x,y,z);
			GetPlayerFacingAngle(playerid, ang);
			SetVehiclePos(PCDV[c][pveh], x,y,z);
			SetVehicleZAngle(PCDV[c][pveh], ang);
			PutPlayerInVehicle(playerid, PCDV[c][pveh], 0);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Przywo³a³eœ swoje auto!");
			return 1;
		}
		CMD:svpriv(playerid,params[]){
			if(PDV[playerid][psved] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zapisywaæ auto mo¿esz co 15 minut"); return 1;}
			new c=-1;
			foreach(new i : Privs){
				if(PCDV[i][pOid] == PDV[playerid][iDP]){
					c = i;
					break;
				}
			}
			if(c == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie posiadasz auta"); return 1;}
			SvPrivC(c);
			PDV[playerid][psved] = GetTickCount()+900000;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisano auto pomyœlnie");
			return 1;
		}
	//Top
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
			res = mysql_query(DBM,"SELECT `kills`,`nck` FROM `plys` ORDER BY `kills` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `deaths`,`nck` FROM `plys` ORDER BY `deaths` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `TopDeta`,`nck` FROM `plys` ORDER BY `TopDeta` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `PKi`,`nck` FROM `plys` ORDER BY `PKi` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `OKi`,`nck` FROM `plys` ORDER BY `OKi` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `MKi`,`nck` FROM `plys` ORDER BY `MKi` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `TotOnl`,`nck` FROM `plys` ORDER BY `TotOnl` DESC LIMIT 10",true);
			cache_get_value_index_int(0, 0, Top[0][TopOnline]);
			cache_get_value_index_int(1, 0, Top[1][TopOnline]);
			cache_get_value_index_int(2, 0, Top[2][TopOnline]);
			cache_get_value_index_int(3, 0, Top[3][TopOnline]);
			cache_get_value_index_int(4, 0, Top[4][TopOnline]);
			cache_get_value_index_int(5, 0, Top[5][TopOnline]);
			cache_get_value_index_int(6, 0, Top[6][TopOnline]);
			cache_get_value_index_int(7, 0, Top[7][TopOnline]);
			cache_get_value_index_int(8, 0, Top[8][TopOnline]);
			cache_get_value_index_int(9, 0, Top[9][TopOnline]);
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
			Top[0][TopOnline] = Top[0][TopOnline] / 3600;
			Top[1][TopOnline] = Top[1][TopOnline] / 3600;
			Top[2][TopOnline] = Top[2][TopOnline] / 3600;
			Top[3][TopOnline] = Top[3][TopOnline] / 3600;
			Top[4][TopOnline] = Top[4][TopOnline] / 3600;
			Top[5][TopOnline] = Top[5][TopOnline] / 3600;
			Top[6][TopOnline] = Top[6][TopOnline] / 3600;
			Top[7][TopOnline] = Top[7][TopOnline] / 3600;
			Top[8][TopOnline] = Top[8][TopOnline] / 3600;
			Top[9][TopOnline] = Top[9][TopOnline] / 3600;
			res = mysql_query(DBM,"SELECT `SKi`,`nck` FROM `plys` ORDER BY `SKi` DESC LIMIT 10",true);
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
			res = mysql_query(DBM,"SELECT `rspkt`,`name` FROM `GaS` ORDER BY `rspkt` DESC LIMIT 10",true);
			cache_get_value_index_int(0, 0, Top[0][TopGang]);
			cache_get_value_index_int(1, 0, Top[1][TopGang]);
			cache_get_value_index_int(2, 0, Top[2][TopGang]);
			cache_get_value_index_int(3, 0, Top[3][TopGang]);
			cache_get_value_index_int(4, 0, Top[4][TopGang]);
			cache_get_value_index_int(5, 0, Top[5][TopGang]);
			cache_get_value_index_int(6, 0, Top[6][TopGang]);
			cache_get_value_index_int(7, 0, Top[7][TopGang]);
			cache_get_value_index_int(8, 0, Top[8][TopGang]);
			cache_get_value_index_int(9, 0, Top[9][TopGang]);
			cache_get_value_index(0, 1, Top[0][TopGangT],6);
			cache_get_value_index(1, 1, Top[1][TopGangT],6);
			cache_get_value_index(2, 1, Top[2][TopGangT],6);
			cache_get_value_index(3, 1, Top[3][TopGangT],6);
			cache_get_value_index(4, 1, Top[4][TopGangT],6);
			cache_get_value_index(5, 1, Top[5][TopGangT],6);
			cache_get_value_index(6, 1, Top[6][TopGangT],6);
			cache_get_value_index(7, 1, Top[7][TopGangT],6);
			cache_get_value_index(8, 1, Top[8][TopGangT],6);
			cache_get_value_index(9, 1, Top[9][TopGangT],6);
			cache_delete(res);
			return 1;
		}
	//Gangi
		stock CreateGang(gname[24],goid,gtag[6]){
			new gid = Iter_Free(GTHC);
			if(gid == ITER_NONE){return 0;}
			GDV[gid][idG] = gid;
			strcat(GDV[gid][gName],gname,24);
			strcat(GDV[gid][gTag],gtag,6);
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
			strcat(GDV[gid][gName],"\0",sizeof(gName));
			strcat(GDV[gid][gtag],"\0",sizeof(gTag));
			new quer[64];
			mysql_format(DBM, quer, sizeof(quer),"UPDATE `plys` SET `iGid`='-1',`GPid`='0' WHERE `iGid`='%i'",gid);
			mq(quer);
			mysql_format(DBM,quer,sizeof(quer),"DELETE FROM `GaS` WHERE `id`='%i'",gid);
			mq(quer);
			foreach(Player,i){
				if(PDV[i][IGid] == gId){
					PDV[i][IGid] = -1;
					PDV[i][GPid] = 0;
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Twój gang zosta³ zlikwidowany");
				}
			}
			foreach(new i : aZones){
				if(GZDV[i][GZoid] == gId){
					ChangeGZOw(i,-1);
				}
			}
			mysql_format(DBM, quer,sizeof(quer),"UPDATE `GZones` SET `owner`='-1' WHERE `owner`='%i'",gId);
			mq(quer);
			GDV[gId][gRspkt] = 0;
			GDV[gId][gSpawnX] = 0.0;
			GDV[gId][gSpawnY] = 0.0;
			GDV[gId][gSpawnZ] = 0.0;
			GDV[gId][GOid] = 0;
			GDV[gId][gcolo] = 0;
			GDV[gId][gTrtCoun] = 0;
			GDV[gId][gPick] = 0;
			GDV[gId][gWar] = false;
			GDV[gId][g3DTxt] = 0;
			GDV[gId][gMem] = 0;
			GDV[gId][Gspar = 0;
			GDV[gId][sprGzon] = 0;
			GDV[gId][sprzone] = 0;
			GDV[gId][SprKillC] = 0;
			GDV[gId][sprT] = 0;
			GDV[gId][sprST] = 0;
			GDV[gId][SprT] = 0;
			GDV[gId][SparT] = 0;
			GDV[gId][SprW] = 0;
			GDV[gId][gExpire] = 0;
			GDV[gId][LVL] = 0;
			Iter_Remove(GTHC, gid);
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
			format(str,sizeof(str),"Za 60 sekund rozpocznie siê sparing z %s",GDV[gid1][gName]);
			MSGGang(gid2,INVALID_PLAYER_ID,str);
			format(str,sizeof(str),"Za 60 sekund rozpocznie siê sparing z %s",GDV[gid2][gName]);
			MSGGang(gid1,INVALID_PLAYER_ID,str);
			GDV[gid1][SparT] 	=	SetTimer("Spar", 1000, true,gid1,gid2);
			return 1;
		}
		stock StartSpar(gid1,gid2){
			IniSparTxD(gid1,gid2);
			new r = random(sizeof(gSparAr));
			if(!(GDV[gid1][Gspar] && GDV[gid1][Gspar])){
				KillTimer(GDV[gid1][SparT]);
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sparing nie móg³ siê zacz¹æ");
				return 1;
			}
			new c1,c2;
			GDV[gid1][sprGzon] = GangZoneCreate(gSparAr[r][6],gSparAr[r][7],gSparAr[r][8],gSparAr[r][9]);
			foreach(Player,i){
				if((PDV[i][IGid] == gid1 || PDV[i][IGid] == gid2) && !Busy(i)){
					SetPlayerVirtualWorld(i, gid1+10);
					GetPlayerPos(i, PDV[i][LaX],PDV[i][LaY],PDV[i][LaZ]);
					if(PDV[i][IGid] == gid1){
						SetPlayerPos(i, gSparAr[r][0],gSparAr[r][1],gSparAr[r][2]);
						c1++;
					}
					else if(PDV[i][IGid] == gid2){
						SetPlayerPos(i, gSparAr[r][3],gSparAr[r][4],gSparAr[r][5]);
						c2++;
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
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Sparing nie móg³ siê zacz¹æ");
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
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Sparing wygra³ %s",GDV[gid1][gName]);
				foreach(Player,i){
					if(PDV[i][IGid] == gid1){
						PDV[i][gSpar] = false;
						TkPlRe(i,30);
						TkPlMo(i,30000);
						SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Przegra³eœ sparing trac¹c 30 exp i 30k$");
						ReS(i);
					}
					else if(PDV[i][IGid] == gid2){
						PDV[i][gSpar] = false;
						GiRe(i,20);
						GiPlMo(i,20000);
						SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wygra³eœ sparing zyskuj¹c 20 exp i 20k$");
						ReS(i);
					}
				}
			}else if(GDV[gid1][SprKillC] < GDV[gid2][SprKillC]){
				KillTimer(GDV[gid1][SparT]);
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Sparing wygra³ %s",GDV[gid2][gName]);
				GDV[gid2][gRspkt] += 10;
				foreach(Player,i){
					if(PDV[i][IGid] == gid1){
						PDV[i][gSpar] = false;
						TkPlRe(i,30);
						TkPlMo(i,30000);
						SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Przegra³eœ sparing trac¹c 30 exp i 30k$");
						ReS(i);
					}
					else if(PDV[i][IGid] == gid2){
						PDV[i][gSpar] = false;
						GiRe(i,20);
						GiPlMo(i,20000);
						SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wygra³eœ sparing zyskuj¹c 20 exp i 20k$");
						ReS(i);
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
			GDV[gid1][Gspar] = false;
			GDV[gid2][Gspar] = false;
			return 1;
		}
		stock IniGZHud(zid){
			GZDV[zid][GZTxd0] = TextDrawCreate(-12.833065, 231.416671, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd0], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd0], 121.000000, 78.000000);
			TextDrawAlignment(GZDV[zid][GZTxd0], 1);
			TextDrawColor(GZDV[zid][GZTxd0], 97);
			TextDrawSetShadow(GZDV[zid][GZTxd0], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd0], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd0], 255);
			TextDrawFont(GZDV[zid][GZTxd0], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd0], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd0], 0);

			GZDV[zid][GZTxd1] = TextDrawCreate(27.519060, 215.200134, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd1], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd1], 51.000000, 16.000000);
			TextDrawAlignment(GZDV[zid][GZTxd1], 1);
			TextDrawColor(GZDV[zid][GZTxd1], 79);
			TextDrawSetShadow(GZDV[zid][GZTxd1], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd1], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd1], 255);
			TextDrawFont(GZDV[zid][GZTxd1], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd1], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd1], 0);

			GZDV[zid][GZTxd2] = TextDrawCreate(35.515312, 218.200027, "WOJNA");
			TextDrawLetterSize(GZDV[zid][GZTxd2], 0.255694, 0.999162);
			TextDrawAlignment(GZDV[zid][GZTxd2], 1);
			TextDrawColor(GZDV[zid][GZTxd2], 10420479);
			TextDrawSetShadow(GZDV[zid][GZTxd2], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd2], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd2], 255);
			TextDrawFont(GZDV[zid][GZTxd2], 2);
			TextDrawSetProportional(GZDV[zid][GZTxd2], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd2], 0);

			GZDV[zid][GZTxd3] = TextDrawCreate(6.544661, 247.749984, "TAG12345.");
			TextDrawLetterSize(GZDV[zid][GZTxd3], 0.218213, 1.034165);
			TextDrawAlignment(GZDV[zid][GZTxd3], 1);
			TextDrawColor(GZDV[zid][GZTxd3], -1);
			TextDrawSetShadow(GZDV[zid][GZTxd3], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd3], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd3], 255);
			TextDrawFont(GZDV[zid][GZTxd3], 2);
			TextDrawSetProportional(GZDV[zid][GZTxd3], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd3], 0);

			GZDV[zid][GZTxd4] = TextDrawCreate(6.544661, 260.000000, "TAG12345.");
			TextDrawLetterSize(GZDV[zid][GZTxd4], 0.218213, 1.034165);
			TextDrawAlignment(GZDV[zid][GZTxd4], 1);
			TextDrawColor(GZDV[zid][GZTxd4], -1);
			TextDrawSetShadow(GZDV[zid][GZTxd4], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd4], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd4], 255);
			TextDrawFont(GZDV[zid][GZTxd4], 2);
			TextDrawSetProportional(GZDV[zid][GZTxd4], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd4], 0);

			GZDV[zid][GZTxd5] = TextDrawCreate(5.139129, 234.916671, "Wojna_o_teren.123456789111315171921234");
			TextDrawLetterSize(GZDV[zid][GZTxd5], 0.132942, 0.783330);
			TextDrawAlignment(GZDV[zid][GZTxd5], 1);
			TextDrawColor(GZDV[zid][GZTxd5], -1);
			TextDrawSetShadow(GZDV[zid][GZTxd5], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd5], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd5], 255);
			TextDrawFont(GZDV[zid][GZTxd5], 1);
			TextDrawSetProportional(GZDV[zid][GZTxd5], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd5], 0);

			GZDV[zid][GZTxd6] = TextDrawCreate(4.039278, 232.916824, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd6], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd6], 98.000213, 13.000000);
			TextDrawAlignment(GZDV[zid][GZTxd6], 1);
			TextDrawColor(GZDV[zid][GZTxd6], 16);
			TextDrawSetShadow(GZDV[zid][GZTxd6], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd6], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd6], 255);
			TextDrawFont(GZDV[zid][GZTxd6], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd6], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd6], 0);

			GZDV[zid][GZTxd7] = TextDrawCreate(3.570755, 246.916839, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd7], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd7], 98.449882, 13.000000);
			TextDrawAlignment(GZDV[zid][GZTxd7], 1);
			TextDrawColor(GZDV[zid][GZTxd7], 16);
			TextDrawSetShadow(GZDV[zid][GZTxd7], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd7], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd7], 255);
			TextDrawFont(GZDV[zid][GZTxd7], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd7], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd7], 0);

			GZDV[zid][GZTxd8] = TextDrawCreate(4.507800, 260.333526, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd8], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd8], 97.959777, 13.000000);
			TextDrawAlignment(GZDV[zid][GZTxd8], 1);
			TextDrawColor(GZDV[zid][GZTxd8], 16);
			TextDrawSetShadow(GZDV[zid][GZTxd8], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd8], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd8], 255);
			TextDrawFont(GZDV[zid][GZTxd8], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd8], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd8], 0);

			GZDV[zid][GZTxd9] = TextDrawCreate(5.018926, 274.799713, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd9], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd9], 97.509681, 13.020000);
			TextDrawAlignment(GZDV[zid][GZTxd9], 1);
			TextDrawColor(GZDV[zid][GZTxd9], 16);
			TextDrawSetShadow(GZDV[zid][GZTxd9], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd9], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd9], 255);
			TextDrawFont(GZDV[zid][GZTxd9], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd9], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd9], 0);

			GZDV[zid][GZTxd10] = TextDrawCreate(7.481678, 276.366394, "Wynik.12456789");
			TextDrawLetterSize(GZDV[zid][GZTxd10], 0.213059, 1.010831);
			TextDrawAlignment(GZDV[zid][GZTxd10], 1);
			TextDrawColor(GZDV[zid][GZTxd10], -1);
			TextDrawSetShadow(GZDV[zid][GZTxd10], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd10], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd10], 255);
			TextDrawFont(GZDV[zid][GZTxd10], 2);
			TextDrawSetProportional(GZDV[zid][GZTxd10], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd10], 0);

			GZDV[zid][GZTxd11] = TextDrawCreate(4.550405, 294.417602, "LD_POKE:cd10h");
			TextDrawLetterSize(GZDV[zid][GZTxd11], 0.000000, 0.000000);
			TextDrawTextSize(GZDV[zid][GZTxd11], 99.000000, 13.000000);
			TextDrawAlignment(GZDV[zid][GZTxd11], 1);
			TextDrawColor(GZDV[zid][GZTxd11], 16);
			TextDrawSetShadow(GZDV[zid][GZTxd11], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd11], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd11], 255);
			TextDrawFont(GZDV[zid][GZTxd11], 4);
			TextDrawSetProportional(GZDV[zid][GZTxd11], 0);
			TextDrawSetShadow(GZDV[zid][GZTxd11], 0);

			GZDV[zid][GZTxd12] = TextDrawCreate(7.013171, 296.166687, "Czas_pozostaly.60sekund");
			TextDrawLetterSize(GZDV[zid][GZTxd12], 0.120292, 0.719166);
			TextDrawAlignment(GZDV[zid][GZTxd12], 1);
			TextDrawColor(GZDV[zid][GZTxd12], -1);
			TextDrawSetShadow(GZDV[zid][GZTxd12], 0);
			TextDrawSetOutline(GZDV[zid][GZTxd12], 0);
			TextDrawBackgroundColor(GZDV[zid][GZTxd12], 255);
			TextDrawFont(GZDV[zid][GZTxd12], 2);
			TextDrawSetProportional(GZDV[zid][GZTxd12], 1);
			TextDrawSetShadow(GZDV[zid][GZTxd12], 0);
			return 1;
		}
		stock DesGZHud(zid){
			TextDrawDestroy(GZDV[zid][GZTxd0]);
			TextDrawDestroy(GZDV[zid][GZTxd1]);
			TextDrawDestroy(GZDV[zid][GZTxd2]);
			TextDrawDestroy(GZDV[zid][GZTxd3]);
			TextDrawDestroy(GZDV[zid][GZTxd4]);
			TextDrawDestroy(GZDV[zid][GZTxd5]);
			TextDrawDestroy(GZDV[zid][GZTxd6]);
			TextDrawDestroy(GZDV[zid][GZTxd7]);
			TextDrawDestroy(GZDV[zid][GZTxd8]);
			TextDrawDestroy(GZDV[zid][GZTxd9]);
			TextDrawDestroy(GZDV[zid][GZTxd10]);
			TextDrawDestroy(GZDV[zid][GZTxd11]);
			TextDrawDestroy(GZDV[zid][GZTxd12]);
			return 1;
		}
		stock UpdateGZHud(zid){
			new str[128];
			format(str,sizeof(str),"%s:%i",GDV[GZDV[zid][GZoid]][gTag],GZDV[zid][GZCas1]);
			TextDrawSetString(GZDV[zid][GZTxd3], str);
			format(str,sizeof(str),"%s:%i",GDV[GZDV[zid][GZWWG]][gTag],GZDV[zid][GZCas0]);
			TextDrawSetString(GZDV[zid][GZTxd4], str);
			format(str,sizeof(str),"Wynik:%i",GZDV[zid][GZCas1] - GZDV[zid][GZCas0]);
			TextDrawSetString(GZDV[zid][GZTxd10], str);
			format(str,sizeof(str),"Czas pozostaly:%i",GZDV[zid][GZCas1] - GZDV[zid][GZCas0]);
			TextDrawSetString(GZDV[zid][GZTxd12], str);
			return 1;
		}
		stock MSGGang(gid,pid,txt[]){
			foreach(Player,i){
				if(PDV[i][IGid] == gid){
					if(pid == INVALID_PLAYER_ID){
						SCM(i,-1,"{9b9da0}[ {56ff56}Gang-MSG {9b9da0}] {7700cc} BOT{aaaacc} : %s",txt);
					}else{SCM(i,-1,"{9b9da0}[ {56ff56}Gang-MSG {9b9da0}] {7700cc} %s{aaaacc} : %s",PDV[pid][Nck],txt);}
				}
			}
			return 1;
		}
		stock AttckEnd(zid){
			GDV[GZDV[zid][GZoid]][gWar] = false;
			GDV[GZDV[zid][GZWWG]][gWar] = false;
			if(GZDV[zid][GZWar] <= 0){
				SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} Pokona³ Wroga {cc0000}%s",GDV[GZDV[zid][GZoid]][gTag],GDV[GZDV[zid][GZWWG]][gTag]);
				GDV[GZDV[zid][GZWWG]][gRspkt] -= 150;
				GDV[GZDV[zid][GZoid]][gRspkt] += 100;
				MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Wygraliœcie 100 respektu w tej bitwie o teren");
				MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Przegraliœcie i straciliœcie 150 respektu");
			}
			else if(GZDV[zid][GZWar2] <= 0){
				SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przej¹³ teren {cc0000}%s",GDV[GZDV[zid][GZWWG]][gTag],GZDV[zid][GZname]);
				GDV[GZDV[zid][GZWWG]][gRspkt] += 100;
				GDV[GZDV[zid][GZoid]][gRspkt] -= 150;	
				MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Wygraliœcie 100 respektu w tej bitwie o teren");
				MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Przegraliœcie i straciliœcie 150 respektu");
				ChangeGZOw(zid,GZDV[zid][GZWWG]);
			}
			else{
				if(GZDV[zid][GZCas0] > GZDV[zid][GZCas1]){
					SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przej¹³ teren {cc0000}%s",GDV[GZDV[zid][GZWWG]][gTag],GZDV[zid][GZname]);
					GDV[GZDV[zid][GZWWG]][gRspkt] += 100;
					GDV[GZDV[zid][GZoid]][gRspkt] -= 150;
					MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Wygraliœcie 100 respektu w tej bitwie o teren");
					MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Przegraliœcie i straciliœcie 150 respektu");
					ChangeGZOw(zid,GZDV[zid][GZWWG]);
				}else{
					GDV[GZDV[zid][GZWWG]][gRspkt] -= 150;
					GDV[GZDV[zid][GZoid]][gRspkt] += 100;
					MSGGang(GZDV[zid][GZoid],INVALID_PLAYER_ID,"Wygraliœcie 100 respektu w tej bitwie o teren");
					MSGGang(GZDV[zid][GZWWG],INVALID_PLAYER_ID,"Przegraliœcie i straciliœcie 150 respektu");
					SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} Pokona³ Wroga {cc0000}%s",GDV[GZDV[zid][GZoid]][gTag],GDV[GZDV[zid][GZWWG]][gTag]);
				}
			}
			GZDV[zid][GZWar] = -1;
			GZDV[zid][GZWar2] = -1;
			GZDV[zid][GZCas0] = 0;
			GZDV[zid][GZCas1] = 0;
			GZDV[zid][GZWWG] = -1;
			GZDV[zid][GZTis] = -1;
			TextDrawHideForAll(GZDV[zid][GZTxd0]);
			TextDrawHideForAll(GZDV[zid][GZTxd1]);
			TextDrawHideForAll(GZDV[zid][GZTxd2]);
			TextDrawHideForAll(GZDV[zid][GZTxd3]);
			TextDrawHideForAll(GZDV[zid][GZTxd4]);
			TextDrawHideForAll(GZDV[zid][GZTxd5]);
			TextDrawHideForAll(GZDV[zid][GZTxd6]);
			TextDrawHideForAll(GZDV[zid][GZTxd7]);
			TextDrawHideForAll(GZDV[zid][GZTxd8]);
			TextDrawHideForAll(GZDV[zid][GZTxd9]);
			TextDrawHideForAll(GZDV[zid][GZTxd10]);
			TextDrawHideForAll(GZDV[zid][GZTxd11]);
			TextDrawHideForAll(GZDV[zid][GZTxd12]);
			DesGZHud(zid);
			return 1;
		}
		stock InitateAttack(zid,agid,prs){
			if(prs == -1){
				SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {56ff56}Gang {ff5656}%s{56ff56} przej¹³ teren {cc0000}%s",GDV[agid][gTag],GZDV[zid][GZname]);
				GDV[agid][gRspkt] += 80;
				MSGGang(agid,INVALID_PLAYER_ID,"Wygraliœcie 80 respektu w tej bitwie o teren");
				ChangeGZOw(zid,agid);
				return 1;
			}
			GDV[GZDV[zid][GZoid]][gWar] = true;
			GDV[GZDV[zid][GZWWG]][gWar] = true;
			SCMA(-1,"{9b9da0}| {ff5656}Wojny{ffffff}-{56ff56}Gangów {9b9da0}| {ff5656}%s {56ff56}vs {ff5656}%s {56ff56}o teren {cc0000}%s",GDV[agid][gTag],GDV[GZDV[zid][GZoid]][gTag],GZDV[zid][GZname]);
			GZDV[zid][GZWWG] = agid;
			GZDV[zid][GZWar] = prs;
			IniGZHud(zid);
			new c;
			foreach(Player,i){
				if(PDV[i][IGid] == agid || PDV[i][IGid] == GZDV[zid][GZoid]){
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd0]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd0]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd1]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd2]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd3]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd4]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd5]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd6]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd7]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd8]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd9]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd10]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd11]);
					TextDrawShowForPlayer(i, GZDV[zid][GZTxd12]);
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
	//Zones
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
				new Float:x = pos3;
				pos3 = pos1;
				pos1 = x;
			}
			if(pos2 > pos4){
				new Float:x = pos4;
				pos4 = pos2;
				pos2 = x;
			}
			GZDV[zid][GZid] = -1;
			GZDV[zid][GZoid] = -1;
			strcat(GZDV[zid][GZname],gzname,24);
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
	//Race
		forward fetchRCa();
		public fetchRCa(){
			if(cache_num_rows() != 0){
				cache_get_value_index_int(0, 0, RCl[Rid]);
				cache_get_value_index_int(0, 1, RCl[RCc]);
				cache_get_value_index_int(0, 2, RCl[RCi]);
				cache_get_value_index(0, 3, RCl[RCn],sizeof(RCl[RCn]));
			}
			return 1;
		}
		forward fetchRCcp(&rcid);
		public fetchRCcp(&rcid){
			new c=cache_num_rows(),b;
			while(c != b){
				cache_get_value_index_float(b, 0,RCC[b][RCcx]);
				cache_get_value_index_float(b, 1,RCC[b][RCcy]);
				cache_get_value_index_float(b, 2,RCC[b][RCcz]);
				cache_get_value_index_int(b, 3,RCC[b][rP]);
				cache_get_value_index_int(b, 4,RCC[b][rType]);
				Iter_Add(RCcp, b);
				b++;
			}//Praktycznie petla For nwm czemu uzylem while tho ....
			return 1;
		}
		forward fetchRCsp();
		public fetchRCsp(){
			new c=cache_num_rows(),b;
			while(c != b){
				cache_get_value_index_float(b,0,RCS[b][Srcx]);
				cache_get_value_index_float(b,1,RCS[b][Srcy]);
				cache_get_value_index_float(b,2,RCS[b][Srcz]);
				cache_get_value_index_float(b,3,RCS[b][Srca]);
				b++;
			}
			return 1;
		}
		CMD:nowrace(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			SCM(pid,-1,"{191970}---------------------------------------RC Script----------------------------------------");
			SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Teraz odbêdzie siê wyscig o id:%i",RCl[Rid]);
			SCM(pid,-1,"{00ff00}o nazwie:%s",RCl[RCn]);
			SCM(pid,-1,"{191970}----------------------------------------------------------------------------------------");
			return 1;
		}
		CMD:newrc(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			if(!LoadInrcP()){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak wyscigow w bazie"); return 1;}
			SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Poprawnie naprawiono");
			return 1;
		}
		stock LoadInrcP(){
			if(numRC <= 0) return 0;
			new x[E_Rc],X[EC_Rc];
			RCl = x;
			foreach(new i : RCcp){
				DestroyDynamicRaceCP(RCC[i][RCcid]);
				RCC[i] = X;
				Iter_Remove(RCcp, i);
			}
			RCl[RCn][0] = EOS;
			new quer[40],r = random(numRC);
			mysql_format(DBM, quer, sizeof(quer), "SELECT * FROM `RCa` WHERE `id`='%i'",r);
			tmq(quer,"fetchRCa","");
			mysql_format(DBM,quer,sizeof(quer),"SELECT * FROM `RCcp` WHERE `id`='%i'",r);
			tmq(quer,"fetchRCcp","i",r);
			mysql_format(DBM,quer,sizeof(quer),"SELECT * FROM `RCsp` WHERE `id`='%i'",r);
			tmq(quer,"fetchRCsp","");
			return 1;
		}
		public OnPlayerEnterDynamicRaceCP(playerid, checkpointid){
			foreach(new i : RCcp){
				if(checkpointid == RCC[i][RCcid]){
					if(RCC[i][rType] == 1){
						EndRC(playerid);
						break;
					}else {
						TogglePlayerDynamicCP(playerid, checkpointid, 0);
						PDT[i][ChkP]++;
						i++;
						TogglePlayerDynamicCP(playerid, RCC[i][RCcid], 1);
						break;
					}
				}
			}
			return 1;
		}

		stock StartRC(){
			GM[pl][5] = 0;
			foreach(Player,i){
				if(PDV[i][Plays] == 7){
					GM[pl][5]++;
				}
			}
			foreach(new i : RCcp){
				RCC[i][RCcid] = CreateDynamicRaceCP(RCC[i][rType],RCC[i][RCcx],RCC[i][RCcy],RCC[i][RCcz],RCC[i+1][RCcx],RCC[i+1][RCcy],RCC[i+1][RCcz], 2,56);
			}
			if(GM[pl][5] >= 3){
				GM[gRC] = -2;
				new c;
				foreach(Player,i){
					if(PDV[i][Plays] == 7){
						SetPlayerVirtualWorld(i,56);
						SetPlayerInterior(i, RCl[RCi]);
						PDV[i][cID] = CreateVehicle(RCl[RCc], , RCl[RCa], -1,-1,-1,0);
						LinkVehicleToInterior(PDV[i][cID], RCl[RCi]);
						PutPlayerInVehicle(i, PDV[i][cID], 0);
						SetVehicleParamsEx(PDV[i][cID],0,0,0, 1, 0,0,0);
						TogglePlayerControllable(playerid, 0);
						PDV[i][CtD] = GetTickCount()+7000;
						PDV[i][SetF] = 1;
						TogglePlayerDynamicCP(i, RCC[0][RCcid], 1);
						PDT[i][ChkP] = 0;
						c++;
					}
				}
			}
			return 1;
		}



		stock EndRC(&pid){
			switch(rcw[4]){
				case 0:{
					GiRe(pid,25);
					GiPlMo(pid,20000);
					GM[pl][5]--;
					PDV[pid][Plays] = 0;
					SpawnPlayer(pid);
					rcw[0] = pid;
					rcw[4]++;
				}
				case 1:{
					GiRe(pid,20);
					GiPlMo(pid,15000);
					GM[pl][5]--;
					PDV[pid][Plays] = 0;
					SpawnPlayer(pid);
					rcw[1] = pid;
					rcw[4]++;
				}
				case 2:{
					GiRe(pid,15);
					GiPlMo(pid,10000);
					GM[pl][5]--;
					PDV[pid][Plays] = 0;
					SpawnPlayer(pid);
					rcw[2] = pid;
					rcw[4]++;
				}
				case 3:{
					GiRe(pid,5);
					GiPlMo(pid,3000);
					GM[pl][5]--;
					PDV[pid][Plays] = 0;
					rcw[3] = pid;
					rcw[4]++;
					foreach(Player,i){
						if(PDV[i][Plays] == 7){
							SpawnPlayer(i);
							DestroyVehicle(PDV[i][cID]);
						}
					}
					SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wyœcig siê zakonczy³ wygrali:");
					SCMA(-1,"1 Miejsce:%s",PDV[rcw[0]][Nck]);
					SCMA(-1,"2 Miejsce:%s",PDV[rcw[1]][Nck]);
					SCMA(-1,"3 Miejsce:%s",PDV[rcw[2]][Nck]);
					SCMA(-1,"4 Miejsce:%s",PDV[rcw[3]][Nck]);
					GM[gRC] = -1;
					rcw[0] = rcw[1] = rcw[2] = rcw[3] = rcw[4] = 0;
					LoadInrcP();
				}	
			}
			return 1;
		}


		alias:race("wyscig");
		CMD:race(playerid,params[]){
			if(GM[gRC] == -2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wyœcig ju¿ trwa!");return 1;}
			new c=0;
			foreach(Player,i){
				if(c >= 10){
					break;
				}
				else if(PDV[i][Plays] == 7){
					c++;
				}
			}
			if(c >= 4 && GM[gRC] != -1){
				GM[gRC] = GetTickCount()+10000;
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}/ch rozpocznie siê za 10 sekund");
			}
			if(c <= 10){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zapisa³eœ siê na wyœcig");
				PDV[playerid][Plays] = 7;
				GM[pl][5] = c;
			}else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| Ju¿ jest max graczy na wyscigu");}
			return 1;
		}
		CMD:crrc(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			else if(numRC >= 100){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Osi¹gnieto limit wyœcigów"); return 1;}
			if(!CreatingF){
				new nm[24];
				if(sscanf(pr,"s[24]",nm)){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nazwe daj jak¹œ plis np wyscig 1"); return 1;}
				numRC++;
				new quer[78];
				mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `RCa` (`car`,`interior`,`name`) VALUES(`%i`,`%i`,`%i`)",GetVehicleModel(GetPlayerVehicleID(pid)),GetPlayerInterior(pid),nm);
				mq(quer);
				CreatingF = true;
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zacz¹³eœ tworzyæ wyœcig");
			}else {
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Coœ pomin¹³êœ jestes pewien ¿e jest 10 spawnów itp.");
			}
			return 1;
		}
		CMD:crcp(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			if(CreatingF){
				new Float:x,Float:y,Float:z;
				GetPlayerPos(pid,x,y,z);
				new quer[118];
				mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `RCcp` (`id`,`x`,`y`,`z`,`p`,`t`) VALUES('%i','%f','%f','%f','%i','1')",numRC,x,y,z,rcpos);		
				mq(quer);
				rcpos++;
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Stworzyles punkt k!");
			}
			return 1;
		}
		CMD:crend(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			if(RcSp != 10){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}YEEEET Zrób cholerne spawny"); return 1;}
			if(CreatingF){
				new Float:x, Float:y, Float:z;
				GetPlayerPos(pid,x,y,z);
				new quer[118];
				mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `RCcp` (`id`,`x`,`y`,`z`,`p`,`t`) VALUES('%i','%f','%f','%f','%i','1')",numRC,x,y,z,rcpos);
				mq(quer);
				CreatingF = false;
				rcpos = RcSp = 0;
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Skonczyles tworzyc wyscig");
			}
			return 1;
		}
		CMD:crsp(pid,pr[]){
			if(PDV[pid][APL] < 5){SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak dostêpu do tej komendy"); return 1;}
			if(CreatingF){
				if(RcSp >= 10){CreatingF = true;}
				RcSp++;
				new Float:x, Float:y, Float:z,Float:a;
				GetPlayerPos(pid, x,y,z);
				GetPlayerFacingAngle(pid, a);
				new quer[118];
				mysql_format(DBM, quer, sizeof(quer), "INSERT INTO `RCsp` (`id`,`x`,`y`,`z`,`a`) VALUES('%i','%f','%f','%f','%f')",numRC,x,y,z,a);
				mq(quer);
				SCM(pid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Stworzy³eœ spawn");
			}
			return 1;
		}
//Chat Manag.
	stock ClsChat() {
		for(new i=0;i<150;i++)
		{SCMA(-1,"");}
		SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{ffffff} Wyczyszczono Czat z ba³aganu!");
		return 1;
	}
//Komendy
	//MORE FPS CMD's
		CMD:hudtoggle(playerid,params[]){
			if(PDV[playerid][hudon]){
				HideHud(playerid);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Schowa³eœ Hud :)");
			}else{
				ShowHUD(playerid);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}W³¹czy³eœ Hud");
			}
			return 1;
		}
		alias:objtoggle("obiekty");
		CMD:objtoggle(playerid,params[]){
			if(PDV[playerid][objon]){
				PDV[playerid][objon] = false;
				Streamer_ToggleAllItems(playerid, 0, 0, ExceptionalObj, sizeof(ExceptionalObj));
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wy³¹czy³eœ obiekty!");
			}else{
				PDV[playerid][objon] = true;
				Streamer_ToggleAllItems(playerid, 0, 1, ExceptionalObj, sizeof(ExceptionalObj));
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}W³¹czy³eœ obiekty!");
			}
			return 1;
		}
	//Unsorted
		CMD:pl(playerid,params[])
		{
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Twój Packet Loss:%.2f",NetStats_PacketLossPercent(playerid));
			return 1;
		}
		CMD:ann(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new s[128],t;
			if(sscanf(params,"is[128]",t,s)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie:/ann [czas] [wiadomosc]");}
			if(30 < t < 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Czas nie wiêcej ni¿ 30 sekund i nie mniej ni¿ 0"); return 1;}
			if(strlen(s) > 127){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Od kiedy gracze bêd¹ czytaæ tasiemca?"); return 1;}
			new count=0;
			for(new i=0,x=sizeof(s);i<x;i++){
				if(strfind(s, "~",true, count)){
					count++;
				}
			}
			if(count%2 == 0){
			}else {
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}prosimy wprowadziæ parzyst¹ liczbê '~' ");
				return 1;
			}
			t= t*1000;
			GameTextForAll(s, t, 3);
			return 1;
		}
		CMD:jetpack(playerid,params[])
		{
			if(PDV[playerid][APL] >= 1){
				SetPlayerSpecialAction(playerid, 2);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zrespi³eœ Jetpack ^.^");
				return 1;
			}
			else if(PDV[playerid][VIP] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zrespi³eœ Jetpack ^.^");
			SetPlayerSpecialAction(playerid, 2);
			return 1;
		}
		CMD:walizka(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			if(IsValidDynamicPickup(GM[wal])){
				DestroyDynamicPickup(GM[wal]);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Koniec poszukiwañ na walizke z³y admin j¹ zniszczy³ :C");
				TextDrawHideForAll(waltxd);
				TextDrawSetString(waltxd, "Walizka");
				return 1;
			}
			new s[48];
			sscanf(params,"s[48]",s);
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid, x,y,z);
			GM[wal] = CreateDynamicPickup(1210, 8, x,y,z);
			if(strlen(s) > 0){
				new st[64];
				format(st,sizeof(st),"Walizka:%s",s);
				TextDrawSetString(waltxd, st);
				TextDrawShowForAll(waltxd);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00aaee}WALIZKA:Podpowiedz:%s",s);
			}
			return 1;
		}
		CMD:pinfo(playerid,params[]){
			if(PDV[playerid][APL] < 4){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie:/pinfo [id]"); return 1;}
			foreach(Player,i){
				if(PDV[i][iDP] == idp){
					new str[144];
					format(str,sizeof(str),"iDP:%i\nNick:%s\nIP:%s\nLastIP:%s\nGPCI%s\nLastGPCI:%s",PDV[playerid][iDP],PDV[playerid][Nck],PDV[playerid][ipP],PDV[playerid][last_ip],PDV[playerid][ngpci],PDV[playerid][last_gpci]);
					Dialog_Show(playerid, Info, DIALOG_STYLE_LIST, "Info O Graczu", str, "OK","");
					return 1;
				}
			}
			new str[144],laip[16],lagpci[41],nickk[24];
			mysql_format(DBM, str, sizeof(str), "SELECT `nck`,`last_ip`,`last_gpci` FROM `plys` WHERE `id`='%i'",idp);
			new Cache:res = mysql_query(DBM,str, true);
			cache_get_value_index(0, 0, nickk,sizeof(nickk));
			cache_get_value_index(0, 1, laip,sizeof(laip));
			cache_get_value_index(0, 2, lagpci,sizeof(lagpci));
			cache_delete(res);
			format(str,sizeof(str),"iDP:%i\nNick:%s\nLastIP:%s\nLastGPCI:%s",idp,nickk,laip,lagpci);
			Dialog_Show(playerid, Info, DIALOG_STYLE_LIST, "Info O Graczu", str, "OK","");
			return 1;
		}
	//Teleporty
		CMD:lsszpital(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1178.3608,-1323.9768,14.1163);
                SetVehicleZAngle(vehid,271.8763);
            }else {
                SetPlayerPos(playerid,1178.3608,-1323.9768,14.1163);
                SetPlayerFacingAngle(playerid,271.8763);
            }
            GameTextForPlayer(playerid, "Szpital w Los Santos", 1000, 3);
            return 1;
        }
		
		CMD:sf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2261.2510,541.6370,35.0545);
                SetVehicleZAngle(vehid,179.4089);
            }else {
                SetPlayerPos(playerid,-2261.2510,541.6370,35.0545);
                SetPlayerFacingAngle(playerid,179.4089);
            }
            GameTextForPlayer(playerid, "San Fierro", 1000, 3);
            return 1;
        }
		
		CMD:majster(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2126.4009,896.1259,13.9150);
                SetVehicleZAngle(vehid,1.5434);
            }else {
                SetPlayerPos(playerid,2126.4009,896.1259,13.9150);
                SetPlayerFacingAngle(playerid,1.5434);
            }
            GameTextForPlayer(playerid, "Mini Stunt Majstra", 1000, 3);
            return 1;
        }
		
		CMD:ls(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2496.2949,-1662.8248,13.1702);
                SetVehicleZAngle(vehid,88.8314);
            }else {
                SetPlayerPos(playerid,2496.2949,-1662.8248,13.1702);
                SetPlayerFacingAngle(playerid,88.8314);
            }
            GameTextForPlayer(playerid, "Los Santos", 1000, 3);
            return 1;
        }
		
		CMD:vm(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,358.5291,2540.2690,16.4435);
                SetVehicleZAngle(vehid,267.1711);
            }else {
                SetPlayerPos(playerid,358.5291,2540.2690,16.4435);
                SetPlayerFacingAngle(playerid,267.1711);
            }
            GameTextForPlayer(playerid, "Pustynia", 1000, 3);
            return 1;
        }
		CMD:farma(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1113.0200,-1650.2000,76.0970);
                SetVehicleZAngle(vehid,89.1800);
            }else {
                SetPlayerPos(playerid,-1113.0200,-1650.2000,76.0970);
                SetPlayerFacingAngle(playerid,89.1800);
            }
            GameTextForPlayer(playerid, "Farma", 1000, 3);
            return 1;
        }
		CMD:calligula(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a)(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2172.0000,1620.7500,999.9792);
                SetVehicleZAngle(vehid,0.1000);
            }else {
                SetPlayerPos(playerid,2172.0000,1620.7500,999.9792);
                SetPlayerFacingAngle(playerid,0.1000);
            }
            GameTextForPlayer(playerid, "Calligula", 1000, 3);
            return 1;
        }
		CMD:miasteczko(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-393.5200,2280.4700,40.5303);
                SetVehicleZAngle(vehid,0.1000);
            }else {
                SetPlayerPos(playerid,-393.5200,2280.4700,40.5303);
                SetPlayerFacingAngle(playerid,0.1000);
            }
            GameTextForPlayer(playerid, "Miasteczko", 1000, 3);
            return 1;
        }
		CMD:rybak(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2148.0425,-86.5715,2.7591);
                SetVehicleZAngle(vehid,218.5538);
            }else {
                SetPlayerPos(playerid,2148.0425,-86.5715,2.7591);
                SetPlayerFacingAngle(playerid,218.5538);
            }
            GameTextForPlayer(playerid, "Rybak", 1000, 3);
            return 1;
        }
		CMD:pgr(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,78.4072,-228.6485,1.5781);
                SetVehicleZAngle(vehid,183.0458);
            }else {
                SetPlayerPos(playerid,78.4072,-228.6485,1.5781);
                SetPlayerFacingAngle(playerid,183.0458);
            }
            GameTextForPlayer(playerid, "PGR", 1000, 3);
            return 1;
        }
		CMD:rcshop(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2238.1919,131.1179,1035.4141);
                SetVehicleZAngle(vehid,272.3640);
            }else {
                SetPlayerPos(playerid,-2238.1919,131.1179,1035.4141);
                SetPlayerFacingAngle(playerid,272.3640);
            }
            GameTextForPlayer(playerid, "RC Shop", 1000, 3);
            return 1;
        }
		CMD:tama(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-912.7800,1997.2800,60.9141);
                SetVehicleZAngle(vehid,310.2600);
            }else {
                SetPlayerPos(playerid,-912.7800,1997.2800,60.9141);
                SetPlayerFacingAngle(playerid,310.2600);
            }
            GameTextForPlayer(playerid, "Tama", 1000, 3);
            return 1;
        }
		CMD:gora(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2346.6619,-1622.7806,483.6635);
                SetVehicleZAngle(vehid,249.2264);
            }else {
                SetPlayerPos(playerid,-2346.6619,-1622.7806,483.6635);
                SetPlayerFacingAngle(playerid,249.2264);
            }
            GameTextForPlayer(playerid, "Gora", 1000, 3);
            return 1;
        }
		CMD:bagno(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-838.7160,-1915.8672,12.8604);
                SetVehicleZAngle(vehid,267.9819);
            }else {
                SetPlayerPos(playerid,-838.7160,-1915.8672,12.8604);
                SetPlayerFacingAngle(playerid,267.9819);
            }
            GameTextForPlayer(playerid, "Bagno", 1000, 3);
            return 1;
        }
        CMD:tor1(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,432.4313, -3617.6753, 77.3310);
                SetVehicleZAngle(vehid,0.0);
            }else {
                SetPlayerPos(playerid,432.4313, -3617.6753, 77.3310);
                SetPlayerFacingAngle(playerid,0.0);
            }
            GameTextForPlayer(playerid, "Tor 1", 1000, 3);
            return 1;
        }
        CMD:tor2(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1801.5314,-2878.6531,2.7271);
                SetVehicleZAngle(vehid,264.4127);
            }else {
                SetPlayerPos(playerid,1801.5314,-2878.6531,2.7271);
                SetPlayerFacingAngle(playerid,264.4127);
            }
            GameTextForPlayer(playerid, "Tor 2", 1000, 3);
            return 1;
        }
        CMD:tor3(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2914.3125,2299.6494,10.5474);
                SetVehicleZAngle(vehid,174.6186);
            }else {
                SetPlayerPos(playerid,2914.3125,2299.6494,10.5474);
                SetPlayerFacingAngle(playerid,174.6186);
            }
            GameTextForPlayer(playerid, "Tor 3", 1000, 3);
            return 1;
        }
        CMD:skocznia1(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,3898.8108, 1062.1049, 1116.6011);
                SetVehicleZAngle(vehid,0.0);
            }else {
                SetPlayerPos(playerid,3898.8108, 1062.1049, 1116.6011);
                SetPlayerFacingAngle(playerid,0.0);
            }
            GameTextForPlayer(playerid, "Skocznia 1", 1000, 3);
            return 1;
        }
        CMD:skocznia2(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-3199.6057, -756.6822, 820.1104);
                SetVehicleZAngle(vehid,0.0);
            }else {
                SetPlayerPos(playerid,-3199.6057, -756.6822, 820.1104);
                SetPlayerFacingAngle(playerid,0.0);
            }
            GameTextForPlayer(playerid, "Skocznia 2", 1000, 3);
            return 1;
        }
        CMD:wyskok1(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1797.0000,2959.5444,253.5291);
                SetVehicleZAngle(vehid,178.4098);
            }else {
                SetPlayerPos(playerid,1797.0000,2959.5444,253.5291);
                SetPlayerFacingAngle(playerid,178.4098);
            }
            GameTextForPlayer(playerid, "Wyskok 1", 1000, 3);
            return 1;
        }
        CMD:wyskok2(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,3033.6069,-1730.7969,231.3785);
                SetVehicleZAngle(vehid,90.2762);
            }else {
                SetPlayerPos(playerid,3033.6069,-1730.7969,231.3785);
                SetPlayerFacingAngle(playerid,90.2762);
            }
            GameTextForPlayer(playerid, "Wyskok 2", 1000, 3);
            return 1;
        }
        CMD:wyskok3(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2213.5115, -1456.9923, 1160.3740);
                SetVehicleZAngle(vehid,90.2762);
            }else {
                SetPlayerPos(playerid,2213.5115, -1456.9923, 1160.3740);
                SetPlayerFacingAngle(playerid,90.2762);
            }
            GameTextForPlayer(playerid, "Wyskok 3", 1000, 3);
            return 1;
        }
        CMD:wyskok4(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1753.1730, -1806.0475, 979.1395);
                SetVehicleZAngle(vehid,-142.0000);
            }else {
                SetPlayerPos(playerid,1753.1730, -1806.0475, 979.1395);
                SetPlayerFacingAngle(playerid,-142.0000);
            }
            GameTextForPlayer(playerid, "Wyskok 4", 1000, 3);
            return 1;
        }
        CMD:wyskok5(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,420.8100, -4.1519, 854.8614);
                SetVehicleZAngle(vehid,0.0000);
            }else {
                SetPlayerPos(playerid,420.8100, -4.1519, 854.8614);
                SetPlayerFacingAngle(playerid,0.0000);
            }
            GameTextForPlayer(playerid, "Wyskok 5", 1000, 3);
            return 1;
        }
        CMD:wyskok6(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2341.6877, -261.5730, 1149.2466);
                SetVehicleZAngle(vehid,180.0000);
            }else {
                SetPlayerPos(playerid,2341.6877, -261.5730, 1149.2466);
                SetPlayerFacingAngle(playerid,180.0000);
            }
            GameTextForPlayer(playerid, "Wyskok 6", 1000, 3);
            return 1;
        }
        CMD:rury(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,975.4968,-840.4242,411.4438);
                SetVehicleZAngle(vehid,182.8721);
            }else {
                SetPlayerPos(playerid,975.4968,-840.4242,411.4438);
                SetPlayerFacingAngle(playerid,182.8721);
            }
            GameTextForPlayer(playerid, "Rury", 1000, 3);
            return 1;
        }
		CMD:parkour1(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-957.2600,1938.7500,9.0000);
                SetVehicleZAngle(vehid,89.1800);
            }else {
                SetPlayerPos(playerid,-957.2600,1938.7500,9.0000);
                SetPlayerFacingAngle(playerid,89.1800);
            }
            GameTextForPlayer(playerid, "Parkour San Fierro", 1000, 3);
            return 1;
        }
        CMD:parkour2(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2118.4758,-93.7546,2.3203);
                SetVehicleZAngle(vehid,122.9806);
            }else {
                SetPlayerPos(playerid,2118.4758,-93.7546,2.3203);
                SetPlayerFacingAngle(playerid,122.9806);
            }
            GameTextForPlayer(playerid, "Parkour 2", 1000, 3);
            return 1;
        }
        CMD:parkour3(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1692.5287,-1180.3373,54.1016);
                SetVehicleZAngle(vehid,179.0159);
            }else {
                SetPlayerPos(playerid,1692.5287,-1180.3373,54.1016);
                SetPlayerFacingAngle(playerid,179.0159);
            }
            GameTextForPlayer(playerid, "Parkour 3", 1000, 3);
            return 1;
        }
		CMD:zadupie(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1389.7600,-1472.8954,101.7269);
                SetVehicleZAngle(vehid,185.9482);
            }else {
                SetPlayerPos(playerid,-1389.7600,-1472.8954,101.7269);
                SetPlayerFacingAngle(playerid,185.9482);
            }
            GameTextForPlayer(playerid, "Zadupie", 1000, 3);
            return 1;
        }
		CMD:wzgorze(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1426.4939,-954.3513,201.0082);
                SetVehicleZAngle(vehid,90.5565);
            }else {
                SetPlayerPos(playerid,-1426.4939,-954.3513,201.0082);
                SetPlayerFacingAngle(playerid,90.5565);
            }
            GameTextForPlayer(playerid, "Wzgorze", 1000, 3);
            return 1;
        }
		CMD:las(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1834.0403,-2189.4741,80.5092);
                SetVehicleZAngle(vehid,63.2553);
            }else {
                SetPlayerPos(playerid,-1834.0403,-2189.4741,80.5092);
                SetPlayerFacingAngle(playerid,63.2553);
            }
            GameTextForPlayer(playerid, "Las", 1000, 3);
            return 1;
        }
		CMD:port(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2294.3386,533.4185,1.7944);
                SetVehicleZAngle(vehid,181.8075);
            }else {
                SetPlayerPos(playerid,2294.3386,533.4185,1.7944);
                SetPlayerFacingAngle(playerid,181.8075);
            }
            GameTextForPlayer(playerid, "Port", 1000, 3);
            return 1;
        }
		CMD:boisko(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1348.4362,2149.4700,11.0349);
                SetVehicleZAngle(vehid,271.6310);
            }else {
                SetPlayerPos(playerid,1348.4362,2149.4700,11.0349);
                SetPlayerFacingAngle(playerid,271.6310);
            }
            GameTextForPlayer(playerid, "Boisko", 1000, 3);
            return 1;
        }
		CMD:molo(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,835.0217,-2055.9451,12.8672);
                SetVehicleZAngle(vehid,183.5605);
            }else {
                SetPlayerPos(playerid,835.0217,-2055.9451,12.8672);
                SetPlayerFacingAngle(playerid,183.5605);
            }
            GameTextForPlayer(playerid, "Molo", 1000, 3);
            return 1;
        }
		CMD:praca(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,881.8466,-1222.7854,16.7036);
                SetVehicleZAngle(vehid,270.3884);
            }else {
                SetPlayerPos(playerid,881.8466,-1222.7854,16.7036);
                SetPlayerFacingAngle(playerid,270.3884);
            }
            GameTextForPlayer(playerid, "Praca", 1000, 3);
            return 1;
        }
		CMD:cmentarz(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,862.3972,-1102.4753,24.0240);
                SetVehicleZAngle(vehid,269.0097);
            }else {
                SetPlayerPos(playerid,862.3972,-1102.4753,24.0240);
                SetPlayerFacingAngle(playerid,269.0097);
            }
            GameTextForPlayer(playerid, "Cmentarz", 1000, 3);
            return 1;
        }
		CMD:cpn(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1006.5395,-933.5594,41.9068);
                SetVehicleZAngle(vehid,96.3775);
            }else {
                SetPlayerPos(playerid,1006.5395,-933.5594,41.9068);
                SetPlayerFacingAngle(playerid,96.3775);
            }
            GameTextForPlayer(playerid, "CPN", 1000, 3);
            return 1;
        }
		CMD:kfc(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1191.6613,-922.5549,42.8357);
                SetVehicleZAngle(vehid,98.7423);
            }else {
                SetPlayerPos(playerid,1191.6613,-922.5549,42.8357);
                SetPlayerFacingAngle(playerid,98.7423);
            }
            GameTextForPlayer(playerid, "KFC", 1000, 3);
            return 1;
        }
		CMD:vinewood(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,921.8981,-788.6381,114.1112);
                SetVehicleZAngle(vehid,270.2955);
            }else {
                SetPlayerPos(playerid,921.8981,-788.6381,114.1112);
                SetPlayerFacingAngle(playerid,270.2955);
            }
            GameTextForPlayer(playerid, "VineWood", 1000, 3);
            return 1;
        }
		CMD:ruina(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,134.3161,-1489.8055,18.4373);
                SetVehicleZAngle(vehid,59.6070);
            }else {
                SetPlayerPos(playerid,134.3161,-1489.8055,18.4373);
                SetPlayerFacingAngle(playerid,59.6070);
            }
            GameTextForPlayer(playerid, "Ruina", 1000, 3);
            return 1;
        }
		CMD:tenis(playerid,params[])
        {
         	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}

            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,755.9744,-1259.6392,13.2666);
                SetVehicleZAngle(vehid,93.1345);
            }else {
                SetPlayerPos(playerid,755.9744,-1259.6392,13.2666);
                SetPlayerFacingAngle(playerid,93.1345);
            }
            GameTextForPlayer(playerid, "Tenis", 1000, 3);
            return 1;
        }
		CMD:plaza(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,312.5515,-1799.5709,4.2466);
                SetVehicleZAngle(vehid,272.0325);
            }else {
                SetPlayerPos(playerid,312.5515,-1799.5709,4.2466);
                SetPlayerFacingAngle(playerid,272.0325);
            }
            GameTextForPlayer(playerid, "Plaza", 1000, 3);
            return 1;
        }
		CMD:marina(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,737.1974,-1435.9344,13.2462);
                SetVehicleZAngle(vehid,88.3569);
            }else {
                SetPlayerPos(playerid,737.1974,-1435.9344,13.2462);
                SetPlayerFacingAngle(playerid,88.3569);
            }
            GameTextForPlayer(playerid, "Marina", 1000, 3);
            return 1;
        }
		CMD:parafia(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2473.5803,912.4630,10.5474);
                SetVehicleZAngle(vehid,2.0801);
            }else {
                SetPlayerPos(playerid,2473.5803,912.4630,10.5474);
                SetPlayerFacingAngle(playerid,2.0801);
            }
            GameTextForPlayer(playerid, "Parafia", 1000, 3);
            return 1;
        }
		CMD:tunelv(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2392.6707,1014.8083,10.5474);
                SetVehicleZAngle(vehid,356.6461);
            }else {
                SetPlayerPos(playerid,2392.6707,1014.8083,10.5474);
                SetPlayerFacingAngle(playerid,356.6461);
            }
            GameTextForPlayer(playerid, "TuneLV", 1000, 3);
            return 1;
        }
		CMD:4smoki(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2023.5978,1007.5933,10.5474);
                SetVehicleZAngle(vehid,271.6972);
            }else {
                SetPlayerPos(playerid,2023.5978,1007.5933,10.5474);
                SetPlayerFacingAngle(playerid,271.6972);
            }
            GameTextForPlayer(playerid, "4 Smoki", 1000, 3);
            return 1;
        }
		CMD:faraon(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2197.1748,1285.1714,10.5474);
                SetVehicleZAngle(vehid,86.7771);
            }else {
                SetPlayerPos(playerid,2197.1748,1285.1714,10.5474);
                SetPlayerFacingAngle(playerid,86.7771);
            }
            GameTextForPlayer(playerid, "Faraon", 1000, 3);
            return 1;
        }
		CMD:kosciol(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2686.4514,-5.6367,5.8599);
                SetVehicleZAngle(vehid,89.4784);
            }else {
                SetPlayerPos(playerid,-2686.4514,-5.6367,5.8599);
                SetPlayerFacingAngle(playerid,89.4784);
            }
            GameTextForPlayer(playerid, "Kosciol", 1000, 3);
            return 1;
        }
		CMD:plazasf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2909.7644,-384.0565,3.0432);
                SetVehicleZAngle(vehid,81.2820);
            }else {
                SetPlayerPos(playerid,-2909.7644,-384.0565,3.0432);
                SetPlayerFacingAngle(playerid,81.2820);
            }
            GameTextForPlayer(playerid, "Plaza San Fierro", 1000, 3);
            return 1;
        }
		CMD:dompapieza(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2758.7964,-289.9935,6.7068);
                SetVehicleZAngle(vehid,178.4540);
            }else {
                SetPlayerPos(playerid,-2758.7964,-289.9935,6.7068);
                SetPlayerFacingAngle(playerid,178.4540);
            }
            GameTextForPlayer(playerid, "Dom Papieza", 1000, 3);
            return 1;
        }
		CMD:golf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2469.6477,-259.8417,39.1606);
                SetVehicleZAngle(vehid,300.8936);
            }else {
                SetPlayerPos(playerid,-2469.6477,-259.8417,39.1606);
                SetPlayerFacingAngle(playerid,300.8936);
            }
            GameTextForPlayer(playerid, "Golf", 1000, 3);
            return 1;
        }
		CMD:mcdonald(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2354.1362,-153.2812,34.9451);
                SetVehicleZAngle(vehid,181.5970);
            }else {
                SetPlayerPos(playerid,-2354.1362,-153.2812,34.9451);
                SetPlayerFacingAngle(playerid,181.5970);
            }
            GameTextForPlayer(playerid, "Mc Donalds", 1000, 3);
            return 1;
        }
		CMD:zlomowisko(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2142.8435,-137.5450,36.1442);
                SetVehicleZAngle(vehid,178.6209);
            }else {
                SetPlayerPos(playerid,-2142.8435,-137.5450,36.1442);
                SetPlayerFacingAngle(playerid,178.6209);
            }
            GameTextForPlayer(playerid, "Zlomowisko", 1000, 3);
            return 1;
        }
		CMD:szkolajazdy(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2047.9388,-94.0331,34.7964);
                SetVehicleZAngle(vehid,181.7182);
            }else {
                SetPlayerPos(playerid,-2047.9388,-94.0331,34.7964);
                SetPlayerFacingAngle(playerid,181.7182);
            }
            GameTextForPlayer(playerid, "Szkola Jazdy", 1000, 3);
            return 1;
        }
		CMD:straz(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2037.9883,56.5993,28.0151);
                SetVehicleZAngle(vehid,266.5229);
            }else {
                SetPlayerPos(playerid,-2037.9883,56.5993,28.0151);
                SetPlayerFacingAngle(playerid,266.5229);
            }
            GameTextForPlayer(playerid, "Straz Pozarna", 1000, 3);
            return 1;
        }
		CMD:dworzec(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1969.0284,137.7729,27.3124);
                SetVehicleZAngle(vehid,90.6477);
            }else {
                SetPlayerPos(playerid,-1969.0284,137.7729,27.3124);
                SetPlayerFacingAngle(playerid,90.6477);
            }
            GameTextForPlayer(playerid, "Dworzec", 1000, 3);
            return 1;
        }
		CMD:dombiskupa(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1982.6643,1114.9310,52.7523);
                SetVehicleZAngle(vehid,0.5770);
            }else {
                SetPlayerPos(playerid,-1982.6643,1114.9310,52.7523);
                SetPlayerFacingAngle(playerid,0.5770);
            }
            GameTextForPlayer(playerid, "Dom Biskupa", 1000, 3);
            return 1;
        }
		CMD:pier(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1699.8862,1326.1569,6.8036);
                SetVehicleZAngle(vehid,44.1826);
            }else {
                SetPlayerPos(playerid,-1699.8862,1326.1569,6.8036);
                SetPlayerFacingAngle(playerid,44.1826);
            }
            GameTextForPlayer(playerid, "Pier 69", 1000, 3);
            return 1;
        }
		CMD:salon(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1641.0906,1203.2655,6.8678);
                SetVehicleZAngle(vehid,71.5632);
            }else {
                SetPlayerPos(playerid,-1641.0906,1203.2655,6.8678);
                SetPlayerFacingAngle(playerid,71.5632);
            }
            GameTextForPlayer(playerid, "Salon", 1000, 3);
            return 1;
        }
		CMD:sfpd(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1589.4548,716.1209,-5.6172);
                SetVehicleZAngle(vehid,268.8622);
            }else {
                SetPlayerPos(playerid,-1589.4548,716.1209,-5.6172);
                SetPlayerFacingAngle(playerid,268.8622);
            }
            GameTextForPlayer(playerid, "Posterunek SFPD", 1000, 3);
            return 1;
        }
		CMD:klub(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2631.4067,1385.2227,6.7942);
                SetVehicleZAngle(vehid,177.2957);
            }else {
                SetPlayerPos(playerid,-2631.4067,1385.2227,6.7942);
                SetPlayerFacingAngle(playerid,177.2957);
            }
            GameTextForPlayer(playerid, "Klub", 1000, 3);
            return 1;
        }
		CMD:park(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2786.2673,1006.9156,50.4809);
                SetVehicleZAngle(vehid,22.4515);
            }else {
                SetPlayerPos(playerid,-2786.2673,1006.9156,50.4809);
                SetPlayerFacingAngle(playerid,22.4515);
            }
            GameTextForPlayer(playerid, "Park", 1000, 3);
            return 1;
        }
		CMD:burger(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2778.7832,766.2106,50.7279);
                SetVehicleZAngle(vehid,88.3252);
            }else {
                SetPlayerPos(playerid,-2778.7832,766.2106,50.7279);
                SetPlayerFacingAngle(playerid,88.3252);
            }
            GameTextForPlayer(playerid, "Burger KING", 1000, 3);
            return 1;
        }
		CMD:sfszpital(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2646.2764,584.4241,14.0782);
                SetVehicleZAngle(vehid,89.0455);
            }else {
                SetPlayerPos(playerid,-2646.2764,584.4241,14.0782);
                SetPlayerFacingAngle(playerid,89.0455);
            }
            GameTextForPlayer(playerid, "Szpital w San Fierro", 1000, 3);
            return 1;
        }
		CMD:wiezienie(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2425.1902,510.6931,29.6564);
                SetVehicleZAngle(vehid,122.1909);
            }else {
                SetPlayerPos(playerid,-2425.1902,510.6931,29.6564);
                SetPlayerFacingAngle(playerid,122.1909);
            }
            GameTextForPlayer(playerid, "Wiezienie", 1000, 3);
            return 1;
        }
		CMD:stacjaradiowa(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2409.8044,-595.4002,132.3749);
                SetVehicleZAngle(vehid,122.3913);
            }else {
                SetPlayerPos(playerid,-2409.8044,-595.4002,132.3749);
                SetPlayerFacingAngle(playerid,122.3913);
            }
            GameTextForPlayer(playerid, "Stacja Radiowa", 1000, 3);
            return 1;
        }
		CMD:korwinolandia(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2020.4321,-859.8535,31.8994);
                SetVehicleZAngle(vehid,91.6406);
            }else {
                SetPlayerPos(playerid,-2020.4321,-859.8535,31.8994);
                SetPlayerFacingAngle(playerid,91.6406);
            }
            GameTextForPlayer(playerid, "Korwino-landia", 1000, 3);
            return 1;
        }
		CMD:wysypisko(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1881.7056,-1722.0585,21.4771);
                SetVehicleZAngle(vehid,121.3061);
            }else {
                SetPlayerPos(playerid,-1881.7056,-1722.0585,21.4771);
                SetPlayerFacingAngle(playerid,121.3061);
            }
            GameTextForPlayer(playerid, "wysypisko", 1000, 3);
            return 1;
        }
		CMD:drwal(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2021.1288,-2399.2766,30.3521);
                SetVehicleZAngle(vehid,48.5135);
            }else {
                SetPlayerPos(playerid,-2021.1288,-2399.2766,30.3521);
                SetPlayerFacingAngle(playerid,48.5135);
            }
            GameTextForPlayer(playerid, "Drwal", 1000, 3);
            return 1;
        }
		CMD:cpn2(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1546.6422,-2748.9751,48.2633);
                SetVehicleZAngle(vehid,147.2018);
            }else {
                SetPlayerPos(playerid,-1546.6422,-2748.9751,48.2633);
                SetPlayerFacingAngle(playerid,147.2018);
            }
            GameTextForPlayer(playerid, "CPN", 1000, 3);
            return 1;
        }
		CMD:doki(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2479.5801,-2565.5801,13.7484);
                SetVehicleZAngle(vehid,270.8580);
            }else {
                SetPlayerPos(playerid,2479.5801,-2565.5801,13.7484);
                SetPlayerFacingAngle(playerid,270.8580);
            }
            GameTextForPlayer(playerid, "Doki", 1000, 3);
            return 1;
        }
		CMD:most(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2670.8486,1933.8684,217.2739);
                SetVehicleZAngle(vehid,90.6153);
            }else {
                SetPlayerPos(playerid,-2670.8486,1933.8684,217.2739);
                SetPlayerFacingAngle(playerid,90.6153);
            }
            GameTextForPlayer(playerid, "Most", 1000, 3);
            return 1;
        }
		CMD:lslot(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1952.1121,-2287.6919,13.6469);
                SetVehicleZAngle(vehid,88.1502);
            }else {
                SetPlayerPos(playerid,1952.1121,-2287.6919,13.6469);
                SetPlayerFacingAngle(playerid,88.1502);
            }
            GameTextForPlayer(playerid, "Lotnisko Los Santos", 1000, 3);
            return 1;
        }
		CMD:lvlot(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1686.3101,1609.5500,10.8203);
                SetVehicleZAngle(vehid,0.1000);
            }else {
                SetPlayerPos(playerid,1686.3101,1609.5500,10.8203);
                SetPlayerFacingAngle(playerid,0.1000);
            }
            GameTextForPlayer(playerid, "Lotnisko Las Venturas", 1000, 3);
            return 1;
        }
		CMD:sflot(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1238.0773,-240.3323,14.1484);
                SetVehicleZAngle(vehid,144.8929);
            }else {
                SetPlayerPos(playerid,-1238.0773,-240.3323,14.1484);
                SetPlayerFacingAngle(playerid,144.8929);
            }
            GameTextForPlayer(playerid, "Lotnisko San Fierro", 1000, 3);
            return 1;
        }
		CMD:tunesf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2688.1809,218.1626,4.1797);
                SetVehicleZAngle(vehid,88.3698);
            }else {
                SetPlayerPos(playerid,-2688.1809,218.1626,4.1797);
                SetPlayerFacingAngle(playerid,88.3698);
            }
            GameTextForPlayer(playerid, "Tune SF", 1000, 3);
            return 1;
        }
		CMD:tunels(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2645.1001,-2006.2900,13.4828);
                SetVehicleZAngle(vehid,178.8800);
            }else {
                SetPlayerPos(playerid,2645.1001,-2006.2900,13.4828);
                SetPlayerFacingAngle(playerid,178.8800);
            }
            GameTextForPlayer(playerid, "Tune LS", 1000, 3);
            return 1;
        }
		CMD:peronls(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1765.2162,-1901.9961,13.6656);
                SetVehicleZAngle(vehid,267.9392);
            }else {
                SetPlayerPos(playerid,1765.2162,-1901.9961,13.6656);
                SetPlayerFacingAngle(playerid,267.9392);
            }
            GameTextForPlayer(playerid, "Peron Los Santos", 1000, 3);
            return 1;
        }
		CMD:peronlv(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1432.4200,2606.8301,10.6719);
                SetVehicleZAngle(vehid,180.2100);
            }else {
                SetPlayerPos(playerid,1432.4200,2606.8301,10.6719);
                SetPlayerFacingAngle(playerid,180.2100);
            }
            GameTextForPlayer(playerid, "Peron Las Venturas", 1000, 3);
            return 1;
        }
		CMD:peronsf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-1989.8900,138.1100,27.5391);
                SetVehicleZAngle(vehid,89.4000);
            }else {
                SetPlayerPos(playerid,-1989.8900,138.1100,27.5391);
                SetPlayerFacingAngle(playerid,89.4000);
            }
            GameTextForPlayer(playerid, "Peron San Fierro", 1000, 3);
            return 1;
        }
		CMD:lvpd(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2292.0945,2451.1628,10.8203);
                SetVehicleZAngle(vehid,88.7638);
            }else {
                SetPlayerPos(playerid,2292.0945,2451.1628,10.8203);
                SetPlayerFacingAngle(playerid,88.7638);
            }
            GameTextForPlayer(playerid, "Posterunek LVPD", 1000, 3);
            return 1;
        }
		CMD:lspd(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1539.9410,-1672.4624,13.6495);
                SetVehicleZAngle(vehid,181.7349);
            }else {
                SetPlayerPos(playerid,1539.9410,-1672.4624,13.6495);
                SetPlayerFacingAngle(playerid,181.7349);
            }
            GameTextForPlayer(playerid, "Posterunek LSPD", 1000, 3);
            return 1;
        }
		CMD:stadionlv(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1097.5591,1610.5920,12.5469);
                SetVehicleZAngle(vehid,359.0456);
            }else {
                SetPlayerPos(playerid,1097.5591,1610.5920,12.5469);
                SetPlayerFacingAngle(playerid,359.0456);
            }
            GameTextForPlayer(playerid, "Stadion Las Venturas", 1000, 3);
            return 1;
        }
		CMD:stadionls(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2680.6799,-1687.9399,9.5137);
                SetVehicleZAngle(vehid,180.9900);
            }else {
                SetPlayerPos(playerid,2680.6799,-1687.9399,9.5137);
                SetPlayerFacingAngle(playerid,180.9900);
            }
            GameTextForPlayer(playerid, "Stadion Los Santos", 1000, 3);
            return 1;
        }
		CMD:stadionsf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2129.2449,-400.2691,35.3359);
                SetVehicleZAngle(vehid,332.4507);
            }else {
                SetPlayerPos(playerid,-2129.2449,-400.2691,35.3359);
                SetPlayerFacingAngle(playerid,332.4507);
            }
            GameTextForPlayer(playerid, "Stadion San Fierro", 1000, 3);
            return 1;
        }
		CMD:bay(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-2462.2720,2240.6738,4.7835);
                SetVehicleZAngle(vehid,9.7181);
            }else {
                SetPlayerPos(playerid,-2462.2720,2240.6738,4.7835);
                SetPlayerFacingAngle(playerid,9.7181);
            }
            GameTextForPlayer(playerid, "baySide", 1000, 3);
            return 1;
        }
		CMD:osiedle(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1385.4746,2529.5996,10.6719);
                SetVehicleZAngle(vehid,359.4208);
            }else {
                SetPlayerPos(playerid,1385.4746,2529.5996,10.6719);
                SetPlayerFacingAngle(playerid,359.4208);
            }
            GameTextForPlayer(playerid, "Osiedle", 1000, 3);
            return 1;
        }
		CMD:kopalnia(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,823.2581,841.0947,10.8191);
                SetVehicleZAngle(vehid,104.2116);
            }else {
                SetPlayerPos(playerid,823.2581,841.0947,10.8191);
                SetPlayerFacingAngle(playerid,104.2116);
            }
            GameTextForPlayer(playerid, "Kopalnia", 1000, 3);
            return 1;
        }
		CMD:lv(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2387.4436,1142.4902,10.5580);
                SetVehicleZAngle(vehid,171.3670);
            }else {
                SetPlayerPos(playerid,2387.4436,1142.4902,10.5580);
                SetPlayerFacingAngle(playerid,171.3670);
            }
            GameTextForPlayer(playerid, "Las Venturas", 1000, 3);
            return 1;
        }
		CMD:statek(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2004.9877,1544.3977,13.5908);
                SetVehicleZAngle(vehid,94.7475);
            }else {
                SetPlayerPos(playerid,2004.9877,1544.3977,13.5908);
                SetPlayerFacingAngle(playerid,94.7475);
            }
            GameTextForPlayer(playerid, "Statek", 1000, 3);
            return 1;
        }
		CMD:fabryka(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2488.7249,2774.2546,10.7865);
                SetVehicleZAngle(vehid,89.6833);
            }else {
                SetPlayerPos(playerid,2488.7249,2774.2546,10.7865);
                SetPlayerFacingAngle(playerid,89.6833);
            }
            GameTextForPlayer(playerid, "Fabryka Broni", 1000, 3);
            return 1;
        }
		CMD:minigolf(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1413.8094,2809.4346,10.8203);
                SetVehicleZAngle(vehid,96.1124);
            }else {
                SetPlayerPos(playerid,1413.8094,2809.4346,10.8203);
                SetPlayerFacingAngle(playerid,96.1124);
            }
            GameTextForPlayer(playerid, "Mini Golf", 1000, 3);
            return 1;
        }
		CMD:wojsko(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,227.9380,1909.1342,17.6406);
                SetVehicleZAngle(vehid,183.1396);
            }else {
                SetPlayerPos(playerid,227.9380,1909.1342,17.6406);
                SetPlayerFacingAngle(playerid,183.1396);
            }
            GameTextForPlayer(playerid, "Wojsko", 1000, 3);
            return 1;
        }
		CMD:klify(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-316.5204,1753.3965,42.7453);
                SetVehicleZAngle(vehid,271.3937);
            }else {
                SetPlayerPos(playerid,-316.5204,1753.3965,42.7453);
                SetPlayerFacingAngle(playerid,271.3937);
            }
            GameTextForPlayer(playerid, "Klify", 1000, 3);
            return 1;
        }
		CMD:eska(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,-296.3636,1538.0322,75.5625);
                SetVehicleZAngle(vehid,148.0860);
            }else {
                SetPlayerPos(playerid,-296.3636,1538.0322,75.5625);
                SetPlayerFacingAngle(playerid,148.0860);
            }
            GameTextForPlayer(playerid, "ESKA", 1000, 3);
            return 1;
        }
		CMD:brickleberry(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,288.6826,-167.5874,1.5781);
                SetVehicleZAngle(vehid,359.7783);
            }else {
                SetPlayerPos(playerid,288.6826,-167.5874,1.5781);
                SetPlayerFacingAngle(playerid,359.7783);
            }
            GameTextForPlayer(playerid, "Brickleberry", 1000, 3);
            return 1;
        }
		CMD:yellowstone(playerid,params[])
        {
            if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,1338.6030,243.3184,19.1318);
                SetVehicleZAngle(vehid,156.8002);
            }else {
                SetPlayerPos(playerid,1338.6030,243.3184,19.1318);
                SetPlayerFacingAngle(playerid,156.8002);
            }
            GameTextForPlayer(playerid, "Yellowstone", 1000, 3);
            return 1;
        }
		CMD:autostrada(playerid,params[])
        {
        	if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2063.8918,311.4436,34.4242);
                SetVehicleZAngle(vehid,95.7849);
            }else {
                SetPlayerPos(playerid,2063.8918,311.4436,34.4242);
                SetPlayerFacingAngle(playerid,95.7849);
            }
            GameTextForPlayer(playerid, "Autostrada A2", 1000, 3);
            return 1;
        }
		CMD:magazyny(playerid,params[])
        {
            if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
            if(GetPlayerVehicleSeat(playerid) == 0)
            {
                new vehid = GetPlayerVehicleID(playerid);
                SetVehiclePos(vehid,2852.8328,1719.1028,10.5483);
                SetVehicleZAngle(vehid,81.9350);
            }else {
                SetPlayerPos(playerid,2852.8328,1719.1028,10.5483);
                SetPlayerFacingAngle(playerid,81.9350);
            }
            GameTextForPlayer(playerid, "Magazyny", 1000, 3);
            return 1;
        }
	//Spol
		CMD:admins(playerid,params[])
		{
			new str[512],s;
			foreach(Player,i)
			{
				strcat(str,"\tDostêpni Admini:        ",512);
				switch(PDV[i][APL]){
					case 1:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {006400}Support        \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;
					}
					case 2:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {32CD32}Moderator            \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;
					}
					case 3:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {0000CD}Admin        \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;
					}
					case 4:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {191970}SuperAdmin        \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;
					}
					case 5:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {00ff00}Rcon        \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;						
					}
					case 6:{
						new str2[108];
						format(str2,sizeof(str2),"\t{ffffff}%s: {ff0000}Zarz¹d        \n",PDV[i][Nck]);
						strcat(str,str2,sizeof(str));
						s++;
					}
				}
			}
			if(s == 0){
				Dialog_Show(playerid, AdDia, DIALOG_STYLE_MSGBOX, "Admini Online", "\t{FF0000}Brak Adminów Online        ", "OK", "OK");
				return 1;
			}
			Dialog_Show(playerid, AdDia, DIALOG_STYLE_MSGBOX, "Admini Online", str, "OK", "OK");
			return 1;
		}
		CMD:colour(playerid,params[]){
			if(PDV[playerid][APL] >= 4){}
			else if(PDV[playerid][VIP] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new h;
			if(sscanf(params,"H",h)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie:/colour [RGB] "); return 1;}
			PDV[playerid][pcolo] = (((h) << 8) | (255));
			SetPlayerColor(playerid, PDV[playerid][pcolo]);
			return 1;
		}
		CMD:zw(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(!PDV[playerid][zw]){
			new res[52];
			sscanf(params,"s[52]",res);
			if(isnull(res)){
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{99ff00} Gracz {aaffaa}%s{99ff00} zaraz wraca",PDV[playerid][Nck]);
			}else{
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{99ff00} Gracz {aaffaa}%s{99ff00} zaraz wraca Powód: {ccaaaa}%s",PDV[playerid][Nck],res);
			}
			TogglePlayerControllable(playerid,0);
			PDV[playerid][zw] = true;
			SetPlayerHealth(playerid,0x7F800000);}
			return 1;
		}
		CMD:jj(playerid,params[])
		{
			if(PDV[playerid][zw]){
				SetPlayerHealth(playerid,100);
				TogglePlayerControllable(playerid,1);
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}|{99ff00} Gracz {aaffaa}%s {99ff00}Ju¿ jest!",PDV[playerid][Nck]);
				PDV[playerid][zw] = false;
			}
			return 1;
		}
		CMD:wypociny(playerid,params[])
		{
			if(PDV[playerid][APL] < 2) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			if(PDV[playerid][Wypociny])
			{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wy³¹czy³eœ wypociny zmutowanych, dziêki Bogu!");
				PDV[playerid][Wypociny] = false;
			}
			else {
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}W³¹czy³eœ wypociny zmutowanych GLHF");
				PDV[playerid][Wypociny] = true;
			}
			return 1;
		}
		CMD:lotto(playerid,params[])
		{
			
			return 1;
		}
	//Areny
		CMD:onede(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			GetPlayerPos(playerid,PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SeUpODP(playerid);
			return 1;
		}
		CMD:pompa(playerid,params[]){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			GetPlayerPos(playerid,PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SeUpPP(playerid);
			return 1;
		}
		alias:minigun("mini");
		CMD:minigun(playerid,params[]){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			GetPlayerPos(playerid, PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SeUpMin(playerid);
			return 1;
		}
		CMD:rpg(playerid,params[]){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			GetPlayerPos(playerid, PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SeUpRPG(playerid);
			return 1;
		}
		alias:snajper("sniper","snipe");
		CMD:snajper(playerid,params){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			GetPlayerPos(playerid, PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SeUpSP(playerid);
			return 1;
		}
		alias:opusc("exit");
		CMD:opusc(playerid,params[])
		{
			if(PDV[playerid][Arena] >= 1){
				switch(PDV[playerid][Arena]){
					case 1:{
						GM[arP][0]--;
						new str[64];
						format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
						TextDrawSetString(red[21], str);		
					}
					case 2:{
						PDV[PDV[playerid][SoP]][SKi]++;
						PDV[PDV[playerid][SoP]][Ki]++;
						PDV[playerid][SDe]++;
						PDV[playerid][De]++;
						PDV[PDV[playerid][SoP]][CtD] = GetTickCount()+5000;
						PDV[PDV[playerid][SoP]][SetF] = 2;
						new Float:x,Float:y,Float:z;
						GetPlayerPos(playerid,x,y,z);
						new ite = Iter_Free(SkI);
						PSku[ite][0] = PDV[playerid][Rsp] / 100;
						PSku[ite][1] = PDV[playerid][Csh] / 2;
						PSku[ite][3] = GetTickCount()+900000;
						TkPlRe(playerid,PSku[ite][0]);
						TkPlMo(playerid,PSku[ite][1]);
						Iter_Add(SkI, ite);
						unwatch(playerid);
						unwatch(PDV[playerid][SoP]);
						PSku[ite][2] = CreateDynamicPickup(1254, 8, x,y,z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Gracz %s Wygra³ solówkê, Gratulacje!",PDV[PDV[playerid][SoP]][Nck]);
						PDV[playerid][SoP] = PDV[PDV[playerid][SoP]][SoP] = -1;
					}
					case 3:{
						GM[arP][1]--;
						new str[64];
						format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
						TextDrawSetString(red[21], str);		
					}
					case 4:{
						GM[arP][2]--;
						new str[64];
						format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
						TextDrawSetString(red[21], str);
					}
					case 5:{
						GM[arP][3]--;
						new str[64];
						format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
						TextDrawSetString(red[21], str);		
					}
					case 6:{
						GM[arP][4]--;
						new str[64];
						format(str,sizeof(str),"ARENY /onede %i /pompa %i /mini %i /sniper %i /rpg %i",GM[arP][0],GM[arP][1],GM[arP][2],GM[arP][3],GM[arP][4]);
						TextDrawSetString(red[21], str);		
					}
				}
				if(PDV[playerid][Arena] == 4){GangZoneHideForPlayer(playerid, MiniZ[1]);}
				PDV[playerid][Arena] = 0;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Opuœci³eœ Arene");
				ReS(playerid);
			}
			else if(PDV[playerid][Plays] >= 1){
				GM[pl][PDV[playerid][Plays]-1]--;
				if(PDV[playerid][Plays] == 3){
					new t1,t2;
					GM[pl][2] = 0;
					foreach(Player,i){
						if(GetPlayerTeam(i) == 1){
							t1++;
							GM[pl][2]++;
						}
						else if(GetPlayerTeam(i) == 2) {
							GM[pl][2]++;
							t2++;
						}
					}
					if(t1 != 0 && t2 != 0){
						GM[pl][2]--;
					}
					else if(t1 != 0){
						OnWGed(2);
					}
					else if(t2 != 0){
						OnWGed(1);
					}
					else{
						OnWGed(-1);
					}
				}
				else if(GM[pl][PDV[playerid][Plays]-1] == 1){
					foreach(Player,i){
						if(PDV[i][Plays] == PDV[playerid][Plays] && i != playerid){
							switch(PDV[playerid][Plays]){
								case 1:{DPWyp();PDV[i][Plays] = 0; PDV[i][SetF] = 2; PDV[i][CtD] = GetTickCount()+6000;}
								case 2:DerbyEnd(i);
							}		
							break;
						}
					}
				}
				PDV[playerid][Plays] = 0;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Opuœci³eœ Arene");
				ReS(playerid);
			}
			else {
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ na arenie");
			}
			return 1;
		}
		alias:staty("statystyki","stats");
		CMD:staty(playerid,params[])
		{
			new str[3500];
			strcat(str,"{565656}********{afffd4}Twoje Statystyki{565656}********\n",3500);
			new str2[150];
			format(str2,sizeof(str2),"\t{ffffff}iDP:{565656}%i        \n",PDV[playerid][iDP]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Nick:{565656}%s        \n",PDV[playerid][Nck]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Totalny Czas pobytu:{565656}%ih%imin        \n",(PDV[playerid][TotOnl]+(NetStats_GetConnectedTime(playerid)/1000)) / 3600,((PDV[playerid][TotOnl]+(NetStats_GetConnectedTime(playerid)/1000)) / 60) - (((PDV[playerid][TotOnl]+(NetStats_GetConnectedTime(playerid)/1000)) / 3600) * 60));

			format(str2,sizeof(str2),"\t{ffffff}Zabójstwa:{565656}%i        \n",PDV[playerid][Ki]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Œmierci:{565656}%i        \n",PDV[playerid][De]);
			strcat(str,str2,3500);
			if(PDV[playerid][Ki] != 0 && PDV[playerid][De] != 0){
				format(str2,sizeof(str2),"\t{ffffff}KD Ratio{565656}%.2f        \n",PDV[playerid][Ki]/PDV[playerid][De]);
				strcat(str,str2,3500);
			}else{
				format(str2,sizeof(str2),"\t{ffffff}KD Ratio{565656}Brak        \n");
				strcat(str,str2,3500);
			}
			format(str2,sizeof(str2),"\t{ffffff}Warny:{565656}%i|3        \n\n",PDV[playerid][wrn]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Wygrane Solówki:{565656}%i        \n",PDV[playerid][SKi]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Przegrane Solówki:{565656}%i        \n\n",PDV[playerid][SDe]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Zabójstw na Onede:{565656}%i        \n",PDV[playerid][OKi]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Œmierci Na Onede:{565656}%i        \n\n",PDV[playerid][ODe]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Zabójstw Na Pompie:{565656}        %i\n",PDV[playerid][PKi]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Œmierci Na Pompie:{565656}%i        \n\n",PDV[playerid][PDe]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Zabójstw Na Mini:{565656}%i        \n",PDV[playerid][MKi]);
			strcat(str,str2,3500);
			format(str2,sizeof(str2),"\t{ffffff}Œmierci Na Mini:{565656}%i        \n\n",PDV[playerid][MDe]);
			strcat(str,str2,3500);
			if(PDV[playerid][VIP]){
			strcat(str,"\t{ffdd22}VIP:{565656}Tak        \n",2000);}else {
			strcat(str,"\t{ffdd22}VIP:{565656}Nie        \n",2000);}
			Dialog_Show(playerid,Stat,DIALOG_STYLE_MSGBOX,"Twoje Statystyki",str,"OK","OK");
			return 1;
		}
	//Skin
		CMD:skin(playerid,params[])
		{
			switch(GetPlayerState(playerid))
			{
				case 4..6: {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie zmienia siê skina podczas wchodzenia/wychodzenia z pojazdu!");return 1;}
			}
			new skid;
			if(sscanf(params,"i",skid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /skin [id]"); return 1;}
			if(0 > skid > 311) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Niepoprawne id skina"); return 1;}
			SetPlayerSkin(playerid, skid);
			PDV[playerid][PSk] = skid;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zmieni³eœ skina na :%i",skid);
			return 1;
		}
	//invis
		alias:invisible("invis");
		CMD:invisible(playerid,params[])
		{
			if(PDV[playerid][VIP] >= 1){goto a;}
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			a:
			SetPlayerColor(playerid,0xFFFFFF00);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Jestes teraz niewidzialny");
			return 1;
		}
	//Solo
		CMD:zsolo(playerid,params[])
		{
			if(PDV[playerid][Wat] != -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Juz coœ ogl¹dasz");}
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}			
			if(Busy(playerid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Jesteœ zajêty wyjdz z areny"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /solo [id] [bron] [id arena]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest online");return 1;}
			if(idp == playerid){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ty g³uptasie nie mo¿esz ogl¹daæ siebie");return 1;}
			if(PDV[idp][SoP] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie robi solówy"); return 1;}
			new ite = Iter_Free(SWaI[idp]);
			if(ite != ITER_NONE){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracza nie mo¿e ogl¹daæ wiêcej ludzi"); return 1;}
			GetPlayerPos(playerid,PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SetPlayerInterior(playerid, GetPlayerInterior(idp));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(idp));
			if(PDV[idp][SoA] == 1){
				TogglePlayerSpectating(playerid, 1);
				PlayerSpectatePlayer(playerid, idp,SPECTATE_MODE_NORMAL);
			}
			else if(PDV[idp][SoA] == 2){
				new x = random(sizeof(SAr2S));
				SetPlayerPos(playerid,SAr2S[x][0],SAr2S[x][1],SAr2S[x][2]);
				SetPlayerFacingAngle(playerid,SAr2S[x][3]);
				PDV[playerid][BlDM] = true;
				PDV[playerid][DMS] = CreateDynamic3DTextLabel("{ff0000}|DM OFF|", -1, 0.0,0.0,1.4, 15.0, playerid, INVALID_VEHICLE_ID,0,GetPlayerVirtualWorld(idp),GetPlayerInterior(idp));
			}
			else{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}ERROR: Z³e id Areny cofanie zmian...");
				ReS(playerid);
				return 1;
			}
			PDV[idp][SWat][ite] = playerid;
			Iter_Add(SWaI[idp],ite);
			PDV[playerid][Wat] = idp;
			return 1;
		}
		CMD:czsolo(playerid,params[])
		{
			if(PDV[playerid][Wat] != -1){
				foreach(new i : SWaI[PDV[playerid][Wat]]){
					if(i == playerid){
						Iter_Remove(SWaI[PDV[playerid][Wat]],i);
						TogglePlayerSpectating(playerid,0);
						PDV[playerid][Wat] = -1;
					}
				}	
			}
			else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie ogl¹dasz niczego LoL"); return 1;}
			return 1;
		}
		CMD:soloff(playerid,params[]){
			if(PDV[playerid][SolOff]){
				PDV[playerid][SolOff] = false;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}W³¹czono solówki!");
			}else{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wy³¹czono solówki!");
				PDV[playerid][SolOff] = true;
			}
			return 1;
		}
		CMD:solo(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(PDV[playerid][SolOff]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Najpierw w³¹cz solówki !"); return 1;}
			new idp,gid,arid;
			if(sscanf(params,"uii",idp,gid,arid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /solo [id] [bron] [id arena]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest online");return 1;}
			if(idp == playerid){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ty g³uptasie nie mozesz walczyæ ze sob¹");return 1;}
			if(PDV[idp][SoP] != -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz Ju¿ ma proœbê o solówke"); return 1;}
			if(3 < arid < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zle id areny"); return 1;}
			if(19 <= gid <= 21 || gid > 43){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Niepoprawne id broni"); return 1;}
			if(PDV[idp][SolOff]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz ma wy³¹czone solówki"); return 1;}
			new str2[24];
			switch(gid)
			{
				case 0:{strcat(str2,"Piêsci",sizeof(str2));}
				case 1:{strcat(str2,"Kastet",sizeof(str2));}
				case 2:{strcat(str2,"Kij Golfowy",sizeof(str2));}
				case 3:{strcat(str2,"Pa³ka policyjna",sizeof(str2));}
				case 4:{strcat(str2,"Nó¿",sizeof(str2));}
				case 5:{strcat(str2,"Kij Bejsbolowy",sizeof(str2));}
				case 6:{strcat(str2,"£opate",sizeof(str2));}
				case 7:{strcat(str2,"Kij Bilardowy",sizeof(str2));}
				case 8:{strcat(str2,"Katane",sizeof(str2));}
				case 9:{strcat(str2,"Pi³e",sizeof(str2));}
				case 10:{strcat(str2,"Rózowe Dildo",sizeof(str2));}
				case 11:{strcat(str2,"Dildo",sizeof(str2));}
				case 12:{strcat(str2,"Wibrator",sizeof(str2));}
				case 13:{strcat(str2,"Wibrator Srebrny",sizeof(str2));}
				case 14:{strcat(str2,"Kwiaty",sizeof(str2));}
				case 15:{strcat(str2,"Laske",sizeof(str2));}
				case 16:{strcat(str2,"Granaty",sizeof(str2));}
				case 17:{strcat(str2,"Granat Dymny",sizeof(str2));}
				case 18:{strcat(str2,"Molotovy",sizeof(str2));}
				case 22:{strcat(str2,"9mm",sizeof(str2));}
				case 23:{strcat(str2,"Ciche 9mm",sizeof(str2));}
				case 24:{strcat(str2,"Deagle",sizeof(str2));}
				case 25:{strcat(str2,"Shotgun",sizeof(str2));}
				case 26:{strcat(str2,"Sawn-off",sizeof(str2));}
				case 27:{strcat(str2,"Combat Shotgun",sizeof(str2));}
				case 28:{strcat(str2,"Micro uzi",sizeof(str2));}
				case 29:{strcat(str2,"MP5",sizeof(str2));}
				case 30:{strcat(str2,"AK-47",sizeof(str2));}
				case 31:{strcat(str2,"M4",sizeof(str2));}
				case 32:{strcat(str2,"Tec-9",sizeof(str2));}
				case 33:{strcat(str2,"Country Rifle",sizeof(str2));}
				case 34:{strcat(str2,"Snajperka",sizeof(str2));}
				case 35:{strcat(str2,"RPG",sizeof(str2));}
				case 36:{strcat(str2,"HeatSeek RPG",sizeof(str2));}
				case 37:{strcat(str2,"Miotacz ognia",sizeof(str2));}
				case 38:{strcat(str2,"Minigun",sizeof(str2));}
				case 39:{strcat(str2,"£adunek wybuchowy",sizeof(str2));}
				case 40:{strcat(str2,"Detonator",sizeof(str2));}
				case 41:{strcat(str2,"Spray",sizeof(str2));}
				case 42:{strcat(str2,"Gaœnica",sizeof(str2));}
			}
			PDV[idp][SoBr] = gid;
			PDV[idp][SoP] = playerid;
			PDV[idp][SoA] = arid;
			PDV[playerid][SoA] = arid;
			PDV[playerid][SoP] = idp;
			new str[256];
			format(str,sizeof(str),"{ffffff}Gracz %s wyzywa ciê na {FF0000}solówe {ffffff}na %s",PDV[playerid][Nck],str2);
			Dialog_Show(idp,SolD,DIALOG_STYLE_MSGBOX,"solówka",str,"Tak","Nie");
			return 1;
		}
		CMD:idbroni(playerid,params[])
		{
			new str[670],iz =sizeof(str);
			strcat(str,"0 - Piesci\n",iz);
			strcat(str,"1 - Kastet\n",iz);
			strcat(str,"2 - Kij Golfowy\n",iz);
			strcat(str,"3 - Palka policyjna\n",iz);
			strcat(str,"4 - noz\n",iz);
			strcat(str,"5 - Kij Bejsbolowy\n",iz);
			strcat(str,"6 - £opata\n",iz);
			strcat(str,"7 - Kij bilardowy\n",iz);
			strcat(str,"8 - Katana\n",iz);
			strcat(str,"9 - Pila\n",iz);
			strcat(str,"10 - Dildo Rozowe\n",iz);
			strcat(str,"11 - Dildo zwykle\n",iz);
			strcat(str,"12 - Wibrator\n",iz);
			strcat(str,"13 - Wibrator Srebrny\n",iz);
			strcat(str,"14 - Kwiaty\n",iz);
			strcat(str,"15 - Laska\n",iz);
			strcat(str,"16 - Granat\n",iz);
			strcat(str,"17 - Gaz dymny\n",iz);
			strcat(str,"18 - Molotov\n",iz);
			strcat(str,"22 - 9mm\n",iz);
			strcat(str,"23 - ciche 9mm\n",iz);
			strcat(str,"24 - Deagle\n",iz);
			strcat(str,"25 - Shotgun\n",iz);
			strcat(str,"26 - Sawn-off\n",iz);
			strcat(str,"27 - Combat Shotgun\n",iz);
			strcat(str,"28 - Micro uzi\n",iz);
			strcat(str,"29 - MP5\n",iz);
			strcat(str,"30 - AK-47\n",iz);
			strcat(str,"31 - M4\n",iz);
			strcat(str,"32 - Tec-9\n",iz);
			strcat(str,"33 - Winchester\n",iz);
			strcat(str,"34 - Snajperka\n",iz);
			strcat(str,"35 - RPG\n",iz);
			strcat(str,"36 - HeatSeek RPG\n",iz);
			strcat(str,"37 - Miotacz ognia\n",iz);
			strcat(str,"38 - Minigun\n",iz);
			strcat(str,"39 - Ladunek przylepny\n",iz);
			strcat(str,"40 - Detonator\n",iz);
			strcat(str,"41 - Spray\n",iz);
			strcat(str,"42 - Gasnica\n",iz);
			strcat(str,"43 - Kamera\n",iz);
			strcat(str,"46 - Spadochron\n",iz);
			Dialog_Show(playerid,WepIds,DIALOG_STYLE_MSGBOX,"ID Broni",str,"OK","OK");
			return 1;
		}
	//100HP/100Armor
		alias:hp("zycie","100hp","heal");
		CMD:hp(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(PDV[playerid][VIP] < 1) {
				new Res = TkPlMo(playerid,5000);
				if(Res == 0) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki na kupienie HP"); return 1;}
				else {
					SetPlayerHealth(playerid,100);
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uleczono za 5,000$");
				}
			}
			return 1;
		}
		alias:armor("arm","armour","kamizelka");
		CMD:armor(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(PDV[playerid][VIP] < 1) {
				new Res = TkPlMo(playerid,10000);
				if(Res == 0) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki na kupienie Armora"); return 1;}
				else {
					SetPlayerArmour(playerid,100);
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uzbrojono za 10,000$");
				}
			}
			else {
				SetPlayerArmour(playerid,100);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uzbrojono do 100 Armora za F R E E");

			}
			return 1;
		}
	//Samochody
		alias:repair("napraw","rep");
		CMD:repair(playerid,params[])
		{
			if(PDV[playerid][ColDr] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zwolnij z naprawianiem tego auta %is zosta³o",(PDV[playerid][ColDr] - GetTickCount())/1000); return 1;}
			if(Busy(playerid) || PDV[playerid][Plays] != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie mo¿esz teraz naprawiaæ auta"); return 1;}
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(GetPlayerVehicleSeat(playerid) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wsi¹dŸ do auta jako kierowca"); return 1;}
			new vehid = GetPlayerVehicleID(playerid);
			PDV[playerid][ColDr] = GetTickCount()+10000;
			RepairVehicle(vehid);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Auto naprawione");
			return 1;
		}
		alias:flip("f");
		CMD:flip(playerid,params[])
		{
			if(PDV[playerid][ColD] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zwolnij z flipowaniem tego auta %is zosta³o",(PDV[playerid][ColD] - GetTickCount())/1000); return 1;}
			if(Busy(playerid) || PDV[playerid][Plays] != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie mo¿esz teraz flipowaæ"); return 1;}
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(GetPlayerVehicleSeat(playerid) != 0) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wsiadz do auta jako kierowca"); return 1;}
			PDV[playerid][ColD] = GetTickCount()+10000;
			new vehid = GetPlayerVehicleID(playerid);
			new Float:x, Float:y, Float:z,Float:Ang;
			GetVehiclePos(vehid, x,y,z);
			GetVehicleZAngle(vehid,Ang);
			SetVehiclePos(vehid,x,y,z+1);
			SetVehicleZAngle(vehid,Ang);
			GameTextForPlayer(playerid, "~y~~h~Flip!", 1000, 3);
			PlayerPlaySound(playerid, 1133, 0.0,0.0,0.0);
			return 1;
		}
		CMD:tune(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(GetPlayerVehicleSeat(playerid) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wsi¹dŸ do auta jako kierowca"); return 1;}
			new Res = TkPlMo(playerid,6000);
			if(Res == 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
			new vehid = GetPlayerVehicleID(playerid);
			AddVehicleComponent(vehid, 1087);
			AddVehicleComponent(vehid,random(13)+1073);
			ChangeVehiclePaintjob(vehid, random(3));
			TuneVeh(vehid);
			AddVehicleComponent(vehid,1010);
			PDV[playerid][nos] = true;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Ztuningowano pojazd");
			PlayerPlaySound(playerid, 1133,0.0,0.0,0.0);
			return 1;
		}
		CMD:acar(playerid,params[])
		{
			if(PDV[playerid][APL] < 4){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new mod[24];
			if(sscanf(params,"s[24]",mod)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /car [nazwa auta]"); return 1;}
			new modid = GetVehidByName(mod);
			if(modid == -1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki pojazd nie istnieje"); return 1;}
			mod[0] = EOS;
			new Float:x,Float:y,Float:z,Float:an;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid, an);
			new vehid = CreateVehicle(modid, x,y,z,an, random(255),random(255), -1);
			PutPlayerInVehicle(playerid, vehid, 0);
			SetVehicleVirtualWorld(vehid, GetPlayerVirtualWorld(playerid));
			PlayerTextDrawShow(playerid, PTD[0][playerid]);
			return 1;
		}
		CMD:car(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(IsPlayerInAnyVehicle(playerid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}WyjdŸ z Auta");return 1;}
			new mod[24];
			if(sscanf(params,"s[24]",mod)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /car [nazwa auta]"); return 1;}
			new modid = GetVehidByName(mod);
			if(modid == -1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki pojazd nie istnieje"); return 1;}
			mod[0] = EOS;
			if(PDV[playerid][APL] < 4){
				switch(modid)
				{
					case 432,435,441,449,450,460,464,465,501,520,532,537,538,564,569,570,584,590,591,594,606,607,608,610,611:{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ten pojazd jest zabroniony");
						return 1;}
				}
			}
			new Float:x,Float:y,Float:z,Float:an;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid, an);
			if(PDV[playerid][cID] != -1){
				if(GetVehicleModel(PDV[playerid][cID]) == modid){
					RepairVehicle(PDV[playerid][cID]);
					SetVehiclePos(PDV[playerid][cID], x,y,z);
					SetVehicleZAngle(PDV[playerid][cID], an);
					PutPlayerInVehicle(playerid, PDV[playerid][cID], 0);
				}else {
					DestroyVehicle(PDV[playerid][cID]);
					PDV[playerid][cID] = -1;
					PDV[playerid][cID] = CreateVehicle(modid, x,y,z, an, random(256),random(256), -1);
					PutPlayerInVehicle(playerid, PDV[playerid][cID], 0);

				}
			}
			else {
				PDV[playerid][cID] = CreateVehicle(modid, x,y,z, an, random(256),random(256), -1);
				PutPlayerInVehicle(playerid, PDV[playerid][cID], 0);

			}
			PlayerTextDrawShow(playerid, PTD[0][playerid]);
			return 1;
		}
	//Priv
		CMD:pm(playerid,params[])
		{
			if(PDV[playerid][ChSp] >= 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Woah zwolnij kowboju"); return 1;}
			new idp,Ms[110];
			if(sscanf(params,"us[110]",idp,Ms)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /pm [id] [wiadomosc]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony");return 1;}
			SCM(idp,-1,"{565656}%s {00af2b}>>> {565656}Ja : {999999}%s",PDV[playerid][Nck],Ms);
			SCM(playerid,-1,"{565656}Ja {00af2b}>>> {565656}%s : {999999}%s",PDV[idp][Nck],Ms);
			foreach(Player,i){
				if(PDV[i][SPM]){
					SCM(i,-1,"{565656}%s >>> %i : %s",PDV[playerid][Nck],idp,Ms);
				}
			}
			return 1;
		}
		CMD:l(playerid,params[]){
			if(PDV[playerid][ChSp] >= 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Woah zwolnij kowboju"); return 1;}
			new Ms[128];
			if(sscanf(params,"s[128]",Ms)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /l [tekst]"); return 1;}
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid, x,y,z);
			foreach(Player,i){
				if(IsPlayerConnected(i)){
					if(IsPlayerInRangeOfPoint(i, 30.0, x,y,z)){
						SCM(i,-1,"{005c00}[Local] {005c49}%s:{5cff5c}%s",Ms);
					}
				}
			}
			return 1;
		}
		CMD:atpm(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			if(!PDV[playerid][SPM]){
				PDV[playerid][SPM] = true;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wlaczyles podglad wiadomosci");
			}
			else {
				PDV[playerid][SPM] = false;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wylaczyles podglad wiadomosci");
			}

			return 1;
		}
	//sp lp
		CMD:sp(playerid,params[]){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			Dialog_Show(playerid, spD, DIALOG_STYLE_LIST, "Twoje zapisane pozycje", "1\n2\n3\n", "Ok","Anuluj");
			return 1;
		}
		CMD:lp(playerid,params[]){
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			Dialog_Show(playerid, lpD, DIALOG_STYLE_LIST, "Twoje zapisane pozycje", "1\n2\n3\n", "Ok","Anuluj");
			return 1;
		}
	//Autor/Reg
		CMD:autor(playerid,params[])
		{
			Autor(playerid);
			return 1;
		}
		CMD:kontakt(playerid,params[])
		{
			Kontakt(playerid);
			return 1;
		}
		CMD:regulamin(playerid,params[])
		{
			Regulamin(playerid);
			return 1;
		}
		CMD:areg(playerid,params[])
		{
			areg(playerid);
			return 1;
		}
	//Weap Buy
		CMD:bronie(playerid,params[])
		{
			new str[1024];
			strcat(str,"Bron\tCena\n");
			strcat(str,"Colt\t2000$\n");
			strcat(str,"Colt z Tlumikiem\t3000$\n");
			strcat(str,"Deagle\t7000$\n");
			strcat(str,"Shotgun\t10000$\n");
			strcat(str,"SawnOff\t25000$\n");
			strcat(str,"Combat Shot.\t15000$\n");
			strcat(str,"Uzi\t5000$\n");
			strcat(str,"MP5\t3000$\n");
			strcat(str,"AK\t11000$\n");
			strcat(str,"M4\t14500$\n");
			strcat(str,"Tec-9\t6500$\n");
			strcat(str,"Winchester\t4000$\n");
			strcat(str,"Snajperka\t20000$\n");
			strcat(str,"Spray\t3999$\n");
			strcat(str,"Gasnica\t3999$\n");
			strcat(str,"Granat\t40000$\n");
			strcat(str,"Molotov\t70000$\n");
			strcat(str,"Kastet\t300$\n");
			strcat(str,"Kij od golfa\t200$\n");
			strcat(str,"Kij policyjny\t50$\n");
			strcat(str,"Noz\t3999$\n");
			strcat(str,"Kij bejsbolowy\t50$\n");
			strcat(str,"£opata\t100$\n");
			strcat(str,"Kij bilardowy\t50$\n");
			strcat(str,"Katana\t200$\n");
			strcat(str,"Pila\t6000$\n");
			strcat(str,"Roz.Dildo\t100$\n");
			strcat(str,"Dildo\t50$\n");
			strcat(str,"Wibrator\t150$\n");
			strcat(str,"Kwiaty\t100$\n");
			Dialog_Show(playerid,WeaW,DIALOG_STYLE_TABLIST_HEADERS,"Bronie",str,"Kup","Anuluj");
			return 1;
		}
	//Listy
		CMD:top(playerid,params[]){
			Dialog_Show(playerid, TopD, DIALOG_STYLE_LIST, "TOP 10", "Top Kasy\nTop Expa\nTop Killi\nTop Oof\nTop Czaszek\nTop Onede\nTop Mini\nTop Pompa\nTop Snajpy\nTop Online", "OK","Anuluj");
			return 1;
		}
		CMD:teles(playerid,params[])
		{
			new str[1005],iz = sizeof(str);
			strcat(str,"Las Venturas\n",iz);
			strcat(str,"San Fierro\n",iz);
			strcat(str,"Los Santos\n",iz);
			strcat(str,"Lotnisko Las Venturas\n",iz);
			strcat(str,"Lotnisko San Fierro\n",iz);
			strcat(str,"Lotnisko Los Santos\n",iz);
			strcat(str,"Kopalnia\n",iz);
			strcat(str,"Statek\n",iz);
			strcat(str,"Fabryka Broni\n",iz);
			strcat(str,"Mini-Golf\n",iz);
			strcat(str,"Wojsko\n",iz);
			strcat(str,"Klify\n",iz);
			strcat(str,"Brickleberry\n",iz);
			strcat(str,"Yellowstone\n",iz);
			strcat(str,"A2\n",iz);
			strcat(str,"Magazyny\n",iz);
			strcat(str,"Wiezienie\n",iz);
			strcat(str,"Pustynia\n",iz);
			strcat(str,"Farma\n",iz);
			strcat(str,"Calligula\n",iz);
			strcat(str,"Miasteczko\n",iz);
			strcat(str,"Rybak\n",iz);
			strcat(str,"pgr\n",iz);
			strcat(str,"rcshop\n",iz);
			strcat(str,"Tama\n",iz);
			strcat(str,"rury\n",iz);
			strcat(str,"Gora\n",iz);
			strcat(str,"Bagno\n",iz);
			strcat(str,"Zadupie\n",iz);
			strcat(str,"Wzgorze\n",iz);
			strcat(str,"Las\n",iz);
			strcat(str,"Port\n",iz);
			strcat(str,"Boisko\n",iz);
			strcat(str,"Molo\n",iz);
			strcat(str,"-Praca-\n",iz);
			strcat(str,"Cmentarz\n",iz);
			strcat(str,"cpn\n",iz);
			strcat(str,"Kfc\n",iz);
			strcat(str,"Vinewood\n",iz);
			strcat(str,"ruina\n",iz);
			strcat(str,"tenis\n",iz);
			strcat(str,"Plaza\n",iz);
			strcat(str,"Marina\n",iz);
			strcat(str,"Parafia\n",iz);
			strcat(str,"TuneLV\n",iz);
			strcat(str,"TuneLS\n",iz);
			strcat(str,"TuneSF\n",iz);
			strcat(str,"4smoki\n",iz);
			strcat(str,"Faraon\n",iz);
			strcat(str,"Kosciol\n",iz);
			strcat(str,"PlazaSF\n",iz);
			strcat(str,"DomPapieza\n",iz);
			strcat(str,"Golf\n",iz);
			strcat(str,"McDonald\n",iz);
			strcat(str,"Zlomowisko\n",iz);
			strcat(str,"SzkolaJazdy\n",iz);
			strcat(str,"StrazPozarna\n",iz);
			strcat(str,"Dworzec\n",iz);
			strcat(str,"DomBiskupa\n",iz);
			strcat(str,"Pier69\n",iz);
			strcat(str,"Salon\n",iz);
			strcat(str,"sfpd\n",iz);
			strcat(str,"lvpd\n",iz);
			strcat(str,"lspd\n",iz);
			strcat(str,"Klub\n",iz);
			strcat(str,"Park\n",iz);
			strcat(str,"BurgerKing\n",iz);
			strcat(str,"Szpital San Fierro\n",iz);
			strcat(str,"StacjaRadiowa\n",iz);
			strcat(str,"Korwinolandia\n",iz);
			strcat(str,"Zlom\n",iz);
			strcat(str,"Drwal\n",iz);
			strcat(str,"Doki\n",iz);
			strcat(str,"Most\n",iz);
			strcat(str,"PeronLS\n",iz);
			strcat(str,"PeronSF\n",iz);
			strcat(str,"PeronLV\n",iz);
			strcat(str,"StadionLV\n",iz);
			strcat(str,"StadionLS\n",iz);
			strcat(str,"StadionSF\n",iz);
			strcat(str,"Bay\n",iz);
			strcat(str,"Osiedle\n",iz);
			strcat(str,"tor 1\n",iz);
			strcat(str,"tor 2\n",iz);
			strcat(str,"tor 3\n",iz);
			strcat(str,"skocznia 1\n",iz);
			strcat(str,"skocznia 2\n",iz);
			strcat(str,"wyskok 1\n",iz);
			strcat(str,"wyskok 2\n",iz);
			strcat(str,"wyskok 3\n",iz);
			strcat(str,"wyskok 4\n",iz);
			strcat(str,"wyskok 5\n",iz);
			strcat(str,"wyskok 6\n",iz);
			strcat(str,"parkour 1\n",iz);
			strcat(str,"parkour 2\n",iz);
			strcat(str,"parkour 3\n",iz);
			Dialog_Show(playerid,telesD,DIALOG_STYLE_TABLIST,"Teleporty",str,"Ok","Ok");
			return 1;
		}	

		CMD:cmd(playerid,params[])
		{
			new str[1556];
			new x = sizeof(str);
			strcat(str,"{3399cc}/idzdo [id] - Wysy³asz proœbê o teleportacje\n",x);
			strcat(str,"/tpoff - Wy³¹czasz mo¿liwosæ teleportacji do Ciebie\n",x);
			strcat(str,"/dotacja - Darmowy exp i $ na dzieñ\n",x);
			strcat(str,"/rsp - Respawn postaci\n",x);
			strcat(str,"/sv - Zapisuje statystyki\n",x);
			strcat(str,"/teles - Spis teleportów\n",x);
			strcat(str,"/solo - Wyzywasz gracza na solówkê\n",x);
			strcat(str,"/solooff - Wy³¹czasz solówki\n",x);
			strcat(str,"/zsolo - Podgladasz solówkê\n",x);
			strcat(str,"/czsolo - Przestajesz podgl¹daæ solówkê\n",x);
			strcat(str,"/tune - Ulepszanie pojazdu\n",x);
			strcat(str,"/fix - Naprawiasz pojazd\n",x);
			strcat(str,"/flip - Stawiasz pojazd na 4 ko³a\n",x);
			strcat(str,"/admins - Spis obecnych administratorów na serwerze\n",x);
			strcat(str,"/zw - Wstrzymanie gry\n",x);
			strcat(str,"/jj - Powrót do gry\n",x);
			strcat(str,"/bronie - Lista dostêpnych broni\n",x);
			strcat(str,"/cars - Spis pojazdów\n",x);
			strcat(str,"/idbroni - Tabela z id broni\n",x);
			strcat(str,"/armor - Uzupe³nienie pancerza\n",x);
			strcat(str,"/zycie - Uzupe³nienie ¿ycia\n",x);
			strcat(str,"/skin [id] - Zmiana skina\n",x);
			strcat(str,"/staty [id] - Sprawdzasz statystyki innego gracza\n",x);
			strcat(str,"/dom - Menu domu\n",x);
			strcat(str,"/solo - Wyzywasz gracza na solówkê\n",x);
			strcat(str,"/solo - Wyzywasz gracza na solówkê\n",x);
			strcat(str,"/wyjdz - Wychodzisz z domu\n",x);
			strcat(str,"/opusc - Opuszczasz arene\n",x);
			strcat(str,"/onede - Do³¹czasz do areny onede\n",x);
			strcat(str,"/minigun - Do³¹czasz do areny minigun\n",x);
			strcat(str,"/pompa - Do³¹czasz do areny shotgun\n",x);
			strcat(str,"/snajper - Do³¹czasz do areny sniper\n",x);
			strcat(str,"/pl - Sprawdzasz swój PacketLoss\n",x);
			strcat(str,"/car [nazwa] - Przywo³ujesz pojazd\n",x);
			strcat(str,"/pm [id] [tekst] - Wysy³asz przywatn¹ wiadomoœæ\n",x);
			strcat(str,"/l [tekst] - Wysy³asz wiadomoœæ do osób w pobli¿u\n",x);
			strcat(str,"/autor - Najwa¿niejsze informacje o serwerze\n",x);
			strcat(str,"/regulamin - Zasady serwera\n",x);
			strcat(str,"/areg - Zasady administracji\n",x);
			strcat(str,"/kontakt - kontakt z zarz¹dem\n",x);
			strcat(str,"/dystans [id] - Sprawdzasz dystans do danego gracza\n",x);
			strcat(str,"/vicinity - Sprawdzasz graczy w pobli¿u\n",x);
			strcat(str,"/raport [id] - Zg³aszasz gracza do administracji",x);
			///dokoñczyæ pod koniec serwera i spisaæ wszystkie komendy
			//Zgadzam siê!
			Dialog_Show(playerid,commandsD,DIALOG_STYLE_MSGBOX,"Komendy",str,"OK","OK");
			return 1;
		}
	
		CMD:acm(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new strfor[557];
			new iz = sizeof(strfor);
			strcat(strfor,"/kick [id] [Powód] - Wiadomoœæ\n",iz);
			strcat(strfor,"/mute [id] [czas] [Powód] - Uciszasz kogos na dana ilosc czasu",iz);
			strcat(strfor,"/bant \n",iz);
			strcat(strfor,"/ban \n",iz);
			strcat(strfor,"/tpt - teleportacja do gracza \n",iz);
			strcat(strfor,"/tph - teleportacja gracza do siebie\n",iz);
			strcat(strfor,"/emulate id - pisanie za dan¹ osobê \n",iz);
			strcat(strfor,"/gmoney \n",iz);
			strcat(strfor,"/gexp \n",iz);
			strcat(strfor,"/wypociny \n",iz);
			strcat(strfor,"/blockcmd \n",iz);
			strcat(strfor,"/alogin \n",iz);
			strcat(strfor,"/reporty \n",iz);
			strcat(strfor,"/armp \n",iz);
			strcat(strfor,"/healp \n",iz);
			strcat(strfor,"/god \n",iz);
			strcat(strfor,"/warn \n",iz);
			strcat(strfor,"/unwarn \n",iz);
			strcat(strfor,"/freeze \n",iz);
			strcat(strfor,"/freezeall \n",iz);
			strcat(strfor,"/unfreezeall \n",iz);
			strcat(strfor,"/ip \n",iz);
			strcat(strfor,"/healall \n",iz);
			strcat(strfor,"/armorall \n",iz);
			strcat(strfor,"/gweap \n",iz);
			strcat(strfor,"/kill \n",iz);
			strcat(strfor,"/jail \n",iz);
			strcat(strfor,"/unjail \n",iz);
			strcat(strfor,"/sethp \n",iz);
			strcat(strfor,"/c \n",iz);
			strcat(strfor,"/cidpon \n",iz);
			strcat(strfor,"/wywalboty \n",iz);
			strcat(strfor,"/svall \n",iz);
			strcat(strfor,"/setrank \n",iz);
			strcat(strfor,"/wiad \n",iz);
			strcat(strfor,"/rlg \n",iz);
			strcat(strfor,"/rspauta \n",iz);
			strcat(strfor,"/arespawn \n",iz);
			Dialog_Show(playerid,ACM_1,DIALOG_STYLE_MSGBOX,"{00af2b}CMD Moda",strfor,"OK","Next");
			return 1;
		}
	//Sync
		alias:sync("rsp");
		CMD:sync(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(Busy(playerid)){return 1;}
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid,0);
			TogglePlayerControllable(playerid,1);
			GetPlayerPos(playerid, PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SpawnPlayer(playerid);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zakonczono synchronizacje");
			return 1;
		}
	//Administrative
		alias:alogin("logonadmin");
		CMD:alogin(playerid,params[])
		{
			if(PDV[playerid][nAPL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			else {
				if(PDV[playerid][APL] >= 1)
				{
					Dialog_Show(playerid,AdPassUL,DIALOG_STYLE_MSGBOX,"Panel Logowania Admina","Czy napewno chcesz siê wylogowaæ z rangi Administracyjynej?","Tak","Nie");
				}
				else {
					if(!strcmp("sIT", PDV[playerid][AdP],false)){
						new str[156];
						format(str,sizeof(str),"Twoj level Admina:{565656}%i\n\n{ffffff}Nick:{0000aa}%s\n\n{32cd32}Pierwszy raz przy logowaniu ? Wpisz swoje haslo na Admina !",PDV[playerid][nAPL],PDV[playerid][Nck]);
						Dialog_Show(playerid,AdPassR,DIALOG_STYLE_PASSWORD,"Panel Logowania Admina",str,"OK","Nope");

					}
					else{
						new str[156];
						format(str,sizeof(str),"{ffffff}Twoj level Admina: {565656}%i\n\n {ffffff}Nick:{0000aa}%s\n\n{32cd32}Zaloguj siê by otrzymaæ uprawnienia admina podajac has³o",PDV[playerid][nAPL],PDV[playerid][Nck]);
						Dialog_Show(playerid,AdPassL,DIALOG_STYLE_PASSWORD,"Panel Logowania Admina",str,"OK","Nope");
					}
				}
			}
			return 1;
		}
		CMD:adpanel(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			Dialog_Show(playerid, AdminDIAL, DIALOG_STYLE_TABLIST, "Admin Panel", "Zmieñ Has³o na Konto Admina\nSkasuj Konto \tAPL {dd0000}6\n{ffffff}Zmieñ Has³o Graczowi\tAPL {dd0000}6", "OK","Nje");
			return 1;
		}
		CMD:rspauta(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			RspCars();
			return 1;
		}
		CMD:spec(playerid,params[])
		{
			if(PDV[playerid][Spect] != -1){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Przesta³eœ Specowaæ");
				TogglePlayerSpectating(playerid, 0);
				PDV[playerid][Spect] = -1;
				ReS(playerid);
			}
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /spec [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest pod³¹czony"); return 1;}
			GetPlayerPos(playerid, PDV[playerid][LaX], PDV[playerid][LaY], PDV[playerid][LaZ]);
			PDV[playerid][Spect] = idp;
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(idp));
			SetPlayerInterior(playerid, GetPlayerInterior(idp));
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, idp, SPECTATE_MODE_NORMAL);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Teraz specujesz %s",PDV[idp][Nck]);
			return 1;
		}
	//Lokalizacja
		CMD:dotacja(playerid,params[])
		{
			if(PDV[playerid][TkD]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ wzi¹³eœ dotacje w tym dniu"); return 1;}
			PDV[playerid][TkD] = true;
			new qu[56];
			mysql_format(DBM,qu,sizeof(qu),"UPDATE `plys` SET `tkd`='1' WHERE `id`='%i'",PDV[playerid][iDP]);
			new ranM = random(50000)+20000,ranR = random(50)+25;
			GiPlMo(playerid,ranM);
			GiRe(playerid,ranR);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wzi¹³eœ Dotacje Otrzyma³eœ %i$ i %i Expa",ranM,ranR);
			return 1;
		}
		alias:dystans("distance");
		CMD:dystans(playerid,params[])
		{
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /dystans [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
			GetPlayerPos(playerid,x1,y1,z1);
			GetPlayerPos(idp,x2,y2,z2);
			x1 = floatabs(floatsqroot((x1+y1+z1)-(x2+y2+z2)));
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}%s jest %1.fm od ciebie",idp,x1);
			return 1;
		}
		CMD:vicinity(playerid,params[])
		{
			new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
			GetPlayerPos(playerid,x1,y1,z1);
			new str[256],s;
			strcat(str,"Gracze w okolicy:\n",256);
			foreach(Player,i){
				if(IsPlayerConnected(i)){
					if(i == playerid){}
					else{
						GetPlayerPos(i,x2,y2,z2);
						x2 = floatabs(floatsqroot((x1+y1+z1)-(x2+y2+z2)));
						if(x2 <= 150.0){
							new str2[32];
							format(str2,32,"Gracz %s Odleg³oœæ:%1.f\n",PDV[i][Nck],x2);
							strcat(str,str2,256);
							s++;
						}
					}
				}
			}
			if(s == 0){return Dialog_Show(playerid, VIC, DIALOG_STYLE_MSGBOX, "VICINITY", "{FF0000}Brak Graczy w okolicy", "OK", "OK");}
			Dialog_Show(playerid, VIC, DIALOG_STYLE_MSGBOX, "VICINITY", str, "OK", "OK");
			return 1;
		}
		CMD:idzdo(playerid,params[])
		{
			if(PDV[playerid][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zraniony(a) i masz zablokowane cmd %is zosta³o",(PDV[playerid][Btle] - GetTickCount())/1000); return 1;}
			if(PDV[playerid][TpSp]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zwolnij z ta teleportacja"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /idzdo [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(Busy(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz jest zajety");}
			if(PDV[idp][TpOf]) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz ma wylaczone tp"); return 1;}
			if(PDV[idp][Ptp] != -1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Do gracza ktos siê teleportuje"); return 1;}
			new str[156];
			format(str,sizeof(str),"{cccccc}Osoba {afffd4}%s {cccccc}Chce siê do ciebie teleportowac akceptujesz to?",PDV[playerid][Nck]);
			PDV[idp][Ptp] = playerid;
			Dialog_Show(idp,Tp,DIALOG_STYLE_MSGBOX,"Teleport",str,"OK","Nie");
			return 1;
		}
		CMD:tpoff(playerid,params[])
		{
			if(PDV[playerid][TpOf]){PDV[playerid][TpOf] = false; SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wlaczyles teleportacje");}
			else {PDV[playerid][TpOf] = true; SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wylaczyles teleportacje");}
			return 1;
		}
		alias:tph("tphere");
		CMD:tph(playerid,params[])
		{
			if(PDV[playerid][APL] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /tph [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(Busy(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz jest zajety"); return 1;}
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(GetPlayerVehicleSeat(idp) == 0){
				new vehid= GetPlayerVehicleID(idp);
				SetVehiclePos(vehid, x,y,z);
			}else{SetPlayerPos(idp,x+2,y,z);}
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}zosta³eœ(aœ) teleportowany przez %s",PDV[playerid][Nck]);
			return 1;
		}
		alias:tpt("tpto");
		CMD:tpt(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /tpt [id]"); return 1;}
			if(idp == playerid) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}AHA?");return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(Busy(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz jest zajety"); return 1;}
			new Float:x,Float:y,Float:z;
			GetPlayerPos(idp,x,y,z);
			if(GetPlayerVehicleSeat(playerid) == 0){
				new vehid = GetPlayerVehicleID(playerid);
				SetVehiclePos(vehid,x,y,z+5);
			}else{ SetPlayerPos(playerid,x+2,y,z);}
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Admin %s Teleportowal siê do ciebie",PDV[playerid][Nck]);
			return 1;
		}
	//Reporty
		alias:report("raport");
		CMD:report(playerid,params[])
		{
			if(PDV[playerid][RpCl] == true){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Woah zwolnij kowboju");return 1;}
			new idp,res[32];
			if(sscanf(params,"ur[32]",idp,res)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /report [id oskarzanego] [Powód]"); return 1;}
			if(idp == playerid){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}AHA?"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			InfAd(playerid,idp,res);
			return 1;
		}
		alias:reporty("raporty","reports");
		CMD:reporty(playerid,params[])
		{
			if(PDV[playerid][APL] < 1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new str[650];
			strcat(str, "Repor\tOskar\tPowód\n",sizeof(str));
			foreach(new i : ReporI)
			{
				strcat(str, Repor[i], sizeof(str));
			}
			Dialog_Show(playerid,RepO,DIALOG_STYLE_TABLIST_HEADERS,"Reporty",str,"Ok","Nic tu po mnie");
			return 1;
		}
		CMD:mute(playerid,params[])
		{
			if(PDV[playerid][APL] < 1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new res[64],idp,t;
			if(sscanf(params,"uis[64]",idp,t,res)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /Mute [id] [czas] [Powód]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			else {
				if(PDV[playerid][APL] < PDV[idp][APL] && ZjebUmysl == true) {KP(playerid,"{9b9da0}| {B90E0E}Anti-M-HAdm {9b9da0}| Cya",INVALID_PLAYER_ID); return 1;}
				MPl(idp,res,playerid,t);
			}
			return 1;
		}
		CMD:unmute(playerid,params[])
		{
			if(PDV[playerid][APL] < 1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /unMute [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			else {
				UMPl(idp,playerid);
			}
			return 1;
		}
		alias:gmoney("dajhajs","dajszmal","dajkapuste","givemoney","gmon","dajkase");
		CMD:gmoney(playerid,params[])
		{
			if(PDV[playerid][APL] < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp,mo;
			if(sscanf(params,"ui",idp,mo)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /gmoney [id] [ilosc]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			GiPlMo(idp,mo);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Admin %s dal ci %i$",PDV[playerid][Nck],mo);
			return 1;
		}
		alias:armp("armorp","armourp");
		CMD:armp(playerid,params[])
		{
			if(PDV[playerid][APL] < 1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /armp [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[idp][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz jest ranny i nie moze byc leczony"); return 1;}
			SetPlayerArmour(idp,100);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Admin %s dal armor",PDV[playerid][Nck]);	
			return 1;
		}
		alias:healp("hpp");
		CMD:healp(playerid,params[])
		{
			if(PDV[playerid][APL] < 1) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /healp [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[idp][Btle] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz jest ranny i nie moze byc leczony"); return 1;}
			SetPlayerHealth(idp,100);
			PDV[idp][God] = false;
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Admin %s uleczyl ciê",PDV[playerid][Nck]);
			return 1;
		}
		CMD:god(playerid,params[])
		{
			if(PDV[playerid][APL] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}		
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /god [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony");return 1;}
			PDV[idp][God] = true;
			SetPlayerHealth(idp,0x7F800000);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Otrzyma³eœ Goda od %s",PDV[playerid][Nck]);
			return 1;
		}
		CMD:vehgod(playerid,params[])
		{
			if(PDV[playerid][APL] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {FF0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /vehgod [id]"); return 1;}
			PDV[idp][VehGod] = true;
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Otrzyma³eœ VehGoda od %s",PDV[playerid][Nck]);
			return 1;
		}
		CMD:kick(playerid,params[])
		{
			if(PDV[playerid][APL] < 2) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new res[64],idp;
			if(sscanf(params, "us[64]", idp, res)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /Kick [id] [Powód]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			else {
				if(PDV[playerid][APL] < PDV[idp][APL] && ZjebUmysl == true) {KP(playerid,"{9b9da0}| {B90E0E}Anti-K-HAdm {9b9da0}| Cya",INVALID_PLAYER_ID); return 1;}
				KP(idp,res,playerid);
			}
			return 1;
		}
		CMD:warn(playerid,params[])
		{
			if(PDV[playerid][APL] < 2) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new res[64],idp;
			if(sscanf(params,"us[64]",idp,res)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /warn [id] [Powód]");}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			PDV[idp][wrn]++;
			SCMAS(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz %s zosta³ ostrze¿ony przez Admina %s %i|3 Powód: %s",PDV[idp][Nck],PDV[playerid][Nck],PDV[idp][wrn],res);
			PlayerPlaySound(idp, 1147, 0,0,0);
			new quer[128];
			if(PDV[idp][wrn] >= 3){
				BPT(idp,"3/3 Warny ban na 3 dni",playerid,3,0);
				PDV[idp][wrn] = 0;
				mysql_format(DBM, quer, sizeof(quer), "UPDATE `plys SET `Warn`='0' WHERE `id`='%i'",PDV[idp][iDP]);
				mq(quer);
				return 1;
			}
			mysql_format(DBM, quer, sizeof(quer), "UPDATE `plys SET `Warn`='%i' WHERE `id`='%i'",PDV[idp][wrn],PDV[idp][iDP]);
			mq(quer);
			return 1;
		}
		CMD:unwarn(playerid,params[])
		{
			if(PDV[playerid][APL] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /unwarn [id]");}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			PDV[idp][wrn]--;
			new quer[128];
			mysql_format(DBM, quer, sizeof(quer), "UPDATE `plys SET `Warn`='%i' WHERE `id`='%i'",PDV[idp][wrn],PDV[idp][iDP]);
			mq(quer);
			return 1;
		}
		CMD:freeze(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /freeze [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[idp][FrP]){
				TogglePlayerControllable(idp,1);
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) odmrozony");
				PDV[idp][FrP] = false;
			}else {
				TogglePlayerControllable(idp,0);
				SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}zosta³eœ(aœ) zamrozony");
				PDV[idp][FrP] = true;
			}
			return 1;
		}
		CMD:blockcmd(playerid,params[])
		{
			if(PDV[playerid][APL] < 4){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /blockcmd [id]"); return 1;}
			if(PDV[idp][BlCMD]){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Odblokowa³eœ CMD graczowi");
				SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Odblokowano ci CMD");
				PDV[idp][BlCMD] = false;
			}
			else{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zablokowa³eœ CMD graczowi");
				SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zablokowano ci CMD Admin Blokuj¹cy:%s",PDV[playerid][Nck]);
				PDV[idp][BlCMD] = true;
			}
			return 1;
		}
		CMD:emulate(playerid,params[])
		{
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp,say[144];
			if(sscanf(params,"us[144]",idp,say)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /emulate [id] [:)]"); return 1;}
			if(say[0] == '/'){
				PC_EmulateCommand(idp,say);
			}
			else{
				OnPlayerText(idp,say);
			}
			return 1;
		}
		CMD:ip(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /ip [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}%s",PDV[idp][ipP]);
			return 1;
		}
		CMD:healall(playerid,params[])
		{
			if(PDV[playerid][APL] < 3) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i){
				if(!Busy(i)){
					SetPlayerHealth(i,100);
				}
			}
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Admin {aaffaa}%s {afffd4}Uzdrowil kazdego",PDV[playerid][Nck]);
			return 1;
		}
		CMD:armorall(playerid,params[])
		{
			if(PDV[playerid][APL] < 3) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i){
				if(!Busy(i)){
					SetPlayerArmour(i,100);
				}
			}
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Admin {aaffaa}%s {afffd4}dal armor kazdemu",PDV[playerid][Nck]);
			return 1;
		}
		alias:gpweap("giveweapon","gw","dajbron");
		CMD:gpweap(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			new idp,wep,am;
			if(sscanf(params,"uii",idp,wep,am)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /gpweap [idp] [bron] [ammo]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			GivePlayerWeapon(idp, wep, am);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Admin %s dal ci bron",PDV[playerid][Nck]);
			return 1;
		}
		CMD:explode(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}U¿ycie: /explode [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[playerid][APL] < PDV[idp][APL] && ZjebUmysl){
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x,y,z);
				CreateExplosion(x,y,z, 0, 10.0);
			}
			new Float:x,Float:y,Float:z;
			GetPlayerPos(idp, x,y,z);
			CreateExplosion(x,y,z, 0, 10.0);
			return 1;
		}
		CMD:kill(playerid,params[])
		{
			if(PDV[playerid][APL] < 3) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /Kill [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			SetPlayerHealth(idp, 0);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {a30023}zosta³eœ(aœ) zabity przez admina %s",PDV[playerid][Nck]);
			return 1;
		}
		CMD:jail(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie Masz dostêpu do tej komendy"); return 1;}
			new idp,t,reas[64];
			if(sscanf(params,"uis[64]",idp,t,reas)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}U¿ycie: /jail [id] [czas] [Powód]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			JL(idp,t,playerid,reas);
			return 1;
		}
		CMD:unjail(playerid,params[])
		{
			if(PDV[playerid][APL] < 3){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie Masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}U¿ycie: /unjail [id]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			UJL(idp);
			return 1;
		}
		CMD:bant(playerid,params[])
		{
			if(PDV[playerid][APL] < 3)  { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new res[64],idp,td,tm;
			if(sscanf(params,"uiis[64]",td,tm,res)) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /bant [id] [C Dni] [C Min] [Powód]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[playerid][APL] < PDV[idp][APL] && ZjebUmysl == true) {KP(playerid,"{9b9da0}| {B90E0E}Anti-BT-HAdm {9b9da0}| Cya",INVALID_PLAYER_ID); return 1;}
			BPT(idp,res,playerid,td,tm);
			return 1;
		}
		CMD:sethp(playerid,params[])
		{
			if(PDV[playerid][APL] < 4) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp,Float:hp;
			if(sscanf(params,"uf",idp,hp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /sethp [id] [hp]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			SetPlayerHealth(playerid,hp);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Ustawiles graczowi hp %s",PDV[idp][Nck]);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {afffd4}Admin %s zmienil ci hp",PDV[playerid][Nck]);
			PDV[idp][God] = false;
			return 1;
		}
		alias:ban("b");
		CMD:ban(playerid,params[])
		{
			if(PDV[playerid][APL] < 4) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new res[64],idp;
			if(sscanf(params,"us[64]",idp,res)) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /ban [id] [Powód]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			else {
				if(PDV[playerid][APL] < PDV[idp][APL] && ZjebUmysl == true) {KP(playerid,"{9b9da0}| {B90E0E}Anti-B-HAdm {9b9da0}| Cya",INVALID_PLAYER_ID); return 1;}
				BP(idp,res,playerid);
			}
			return 1;
		}
		alias:gexp("dajexp","givexp","giveexp","dexp");
		CMD:gexp(playerid,params[])
		{
			if(PDV[playerid][APL] < 4){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp,am;
			if(sscanf(params,"ui",idp,am)){ SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /giexp [id] [ilosc]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(-10000 > am > 10000){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie mozesz dac wiecej niz 10k lub mniej");return 1;}
			GiRe(idp,am);
			SCM(idp,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Admin %s dal ci %i expa",PDV[playerid][Nck],am);
			return 1;
		}
		CMD:ub(playerid,params[])
		{
			if(PDV[playerid][APL] < 4) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp;
			if(sscanf(params,"u",idp)) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /ub [idpgr]"); return 1;}
			else {
				UBP(idp,playerid);
			}
			return 1;
		}
		CMD:freezeall(playerid,params[])
		{
			if(PDV[playerid][APL] < 4) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i) {
				TogglePlayerControllable(i,0);
				PDV[i][FrP] = true;
			}
			TogglePlayerControllable(playerid,1);
			return 1;
		}
		CMD:unfreezeall(playerid,params[])
		{
			if(PDV[playerid][APL] < 4) {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i){
				TogglePlayerControllable(i,0);
				PDV[i][FrP] = false;
			}
			return 1;
		}
		alias:cls("c");
		CMD:cls(playerid,params[])
		{
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			ClsChat();
			return 1;
		}
		CMD:cidpon(playerid,params[])
		{
			if(PDV[playerid][APL] < 5) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new name[32];
			if(sscanf(params,"s[32]",name)){ SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /cidpon [Nazwa gracza]"); return 1;}
			else {
				new query[64];
				SqlEscStr(name,name);
				mysql_format(DBM,query,sizeof(query),"SELECT `id` WHERE `nck`='%s'",name);
				tmq(query,"cidponx","is[32]",playerid,name);
			}
			return 1;
		}
		CMD:wywalboty(playerid,params[])
		{
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i){
				new ip[16];
				GetPlayerIp(playerid,ip,16);
				if(getBots(ip) > 2)
				{
					BlockIpAddress(ip, 60000);
				    Kick(i);
				}
			}
			return 1;
		}
		CMD:sv(playerid,params[])
		{
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Pomyœlnie zapisano statystyki!");
			if(PDV[playerid][SCl] >= GetTickCount()){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Staty mo¿esz zapisywaæ co pó³ godziny"); return 1;}
			PDV[playerid][SCl] = GetTickCount()+1800000;
			SVPlayer(playerid);
			return 1;
		}
		CMD:svall(playerid,params[])
		{
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			foreach(Player,i){
				SVPlayer(i);
			}
			TextDrawShowForAll(Save);
			GM[svTx] = GetTickCount()+4000;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Pomyœlnie zapisano wszystkim statystyki!");
			return 1;
		}
		CMD:setrank(playerid,params[])
		{
			if(PDV[playerid][APL] < 6) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new idp,r;
			if(sscanf(params,"ui",idp,r)){ SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /setrpl [idg] [idr]"); return 1;}
			if(!IsPlayerConnected(idp)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz nie jest po³¹czony"); return 1;}
			if(PDV[playerid][APL] < r) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Rank id is higher than the giver of rank"); return 1;}
			if(0 > r > 6) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Rank id too high or too low"); return 1;}
			new quer[128];
			mysql_format(DBM,quer,sizeof(quer),"UPDATE `plys` SET `AdmPerLevel`='%i',`AdP`='sIT' WHERE `id`='%i'",r,PDV[idp][iDP]);
			new quere = mq(quer);
			PDV[idp][nAPL] = r;
			if(quere == 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}MySQL Error couldn't give a Rank");}
			else {SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Dano range pomyœlnie");}
			return 1;
		}
		CMD:wiad(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){ SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new ran = random(sizeof(RandomMsg));
			SCMA(-1,RandomMsg[ran]);
			return 1;
		}
		CMD:rlg(playerid,params[])
		{
			if(PDV[playerid][APL] < 6) { SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wy³¹czanie Serwera . . .");
			GM[Rest] = GetTickCount()+800;
			return 1;
		}
	//Domy
		CMD:dom(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o, biedak!"); return 1;}
			new str[370],x=sizeof(str);
			strcat(str,"{ffffff}-Nazwa domu:",x);
			strcat(str,HDV[PDV[playerid][OwOf]][estanam],x);
			strcat(str,"\n",x);
			strcat(str,"{ffffff}-Has³o:",x);
			strcat(str,HDV[PDV[playerid][OwOf]][hpass],x);
			strcat(str,"\n",x);
			strcat(str,"{ffffff}-Drzwi:Otwarte/zamkniête\n",x);
			strcat(str,"{ffffff}-Sejf domowy:\n",x);
			strcat(str,"\t{FFAA1D}-{ffffff}Wp³aæ hajs\n",x);
			strcat(str,"\t{FFAA1D}-{ffffff}Wyp³aæ hajs\n",x);
			strcat(str,"\t{FFAA1D}-{ffffff}Wp³aæ exp\n",x);
			strcat(str,"\t{FFAA1D}-{ffffff}Wyp³aæ exp\n",x);
			strcat(str,"{ffffff}-Meble(WIP)\n",x);
			strcat(str,"{ffffff}-Klucze\n",x);
			strcat(str,"{ffffff}-Zabezpieczenia\n",x);
			strcat(str,"{ffffff}-Sprzedaj dom\n",x);
			Dialog_Show(playerid,DomD,DIALOG_STYLE_TABLIST,"Menu - Dom",str,"OK","Wyjdz");
			return 1;
		}
		CMD:zabezpiecz(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, SecD, DIALOG_STYLE_TABLIST, "Zabezpieczenia", "Zamek na drzwi\nStalowe Drzwi\nDrzwi na karte\nDrzwi sejfowe", "OK","Cofaj!");
			return 1;
		}
		CMD:pukpuk(playerid,params[])
		{
			new i = IPAH(playerid);
			if(i == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ w pobli¿u domu"); return 1;}
			if(!HDV[i][Bin]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dom jest niezamieszkany");return 1;}
			foreach(Player,g)
			{
				if(GetPlayerVirtualWorld(g) == HDV[i][hID]+300){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}PUK! PUK! ktoœ puka");}
			}
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Wkurwi³eœ graczy w domu gratulacje!");
			return 1;
		}
		alias:rob("Obrabuj","Zrabuj");
		CMD:rob(playerid,params[])
		{
			new i = IPAH(playerid);
			if(i == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ w pobli¿u domu"); return 1;}
			if(!HDV[i][Bin]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dom jest niezamieszkany"); return 1;}
			if(i == PDV[playerid][OwOf]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ty g³uptasie nie mo¿esz obrabowaæ samego siebie"); return 1;}
			new r = random(100);
			switch(HDV[i][Security]){
				case 0:{
					if(r <= 91){
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Obrabowa³eœ Dom!");
						GiRe(playerid,HDV[i][expi]/10);
						GiPlMo(playerid,HDV[i][moni]/2);
						new str[128];
						format(str,128,"\t{ffffff}*****{56aaaa}£upy{ffffff}*****\t\n\tExp:%d\t\n\tKasa:%d\t",HDV[i][expi]/10,HDV[i][moni]/2);
						Dialog_Show(playerid, Robbed, DIALOG_STYLE_MSGBOX, "{00ff00}Twoje ³upy", str, "OK","OK");
						HDV[i][expi] -= HDV[i][expi]/10;
						HDV[i][moni] -= HDV[i][moni]/2;
					}
					else{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie uda³o ci siê! :C");
						PDV[playerid][Bounty][0] += 15000*1;
						PDV[playerid][Bounty][1] += 30*1;
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nagroda za gracza %s : %d$/%d Exp",PDV[playerid][Nck],PDV[playerid][Bounty][0],PDV[playerid][Bounty][1]);
					}
				}
				case 1:{
					if(r <= 60){
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Obrabowa³eœ Dom!");
						GiRe(playerid,HDV[i][expi]/10);
						GiPlMo(playerid,HDV[i][moni]/2);
						new str[128];
						format(str,128,"\t{ffffff}*****{56aaaa}£upy{ffffff}*****\t\n\tExp:%d\t\n\tKasa:%d\t",HDV[i][expi]/10,HDV[i][moni]/2);
						Dialog_Show(playerid, Robbed, DIALOG_STYLE_MSGBOX, "{00ff00}Twoje ³upy", str, "OK","OK");
						HDV[i][expi] -= HDV[i][expi]/10;
						HDV[i][moni] -= HDV[i][moni]/2;
					}
					else{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie uda³o ci siê! :C");
						PDV[playerid][Bounty][0] += 15000*2;
						PDV[playerid][Bounty][1] += 30*2;
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nagroda za gracza %s : %d$/%d Exp",PDV[playerid][Nck],PDV[playerid][Bounty][0],PDV[playerid][Bounty][1]);
					}
				}
				case 2:{
					if(r <= 44){
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Obrabowa³eœ Dom!");
						GiRe(playerid,HDV[i][expi]/10);
						GiPlMo(playerid,HDV[i][moni]/2);
						new str[128];
						format(str,128,"\t{ffffff}*****{56aaaa}£upy{ffffff}*****\t\n\tExp:%d\t\n\tKasa:%d\t",HDV[i][expi]/10,HDV[i][moni]/2);
						Dialog_Show(playerid, Robbed, DIALOG_STYLE_MSGBOX, "{00ff00}Twoje ³upy", str, "OK","OK");
						HDV[i][expi] -= HDV[i][expi]/10;
						HDV[i][moni] -= HDV[i][moni]/2;
					}
					else{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie uda³o ci siê! :C");
						PDV[playerid][Bounty][0] += 15000*3;
						PDV[playerid][Bounty][1] += 30*3;
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nagroda za gracza %s : %d$/%d Exp",PDV[playerid][Nck],PDV[playerid][Bounty][0],PDV[playerid][Bounty][1]);
					}
				}
				case 3:{
					if(r <= 10){
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Obrabowa³eœ Dom!");
						GiRe(playerid,HDV[i][expi]/10);
						GiPlMo(playerid,HDV[i][moni]/2);
						new str[128];
						format(str,128,"\t{ffffff}*****{56aaaa}£upy{ffffff}*****\t\n\tExp:%d\t\n\tKasa:%d\t",HDV[i][expi]/10,HDV[i][moni]/2);
						Dialog_Show(playerid, Robbed, DIALOG_STYLE_MSGBOX, "{00ff00}Twoje ³upy", str, "OK","OK");
						HDV[i][expi] -= HDV[i][expi]/10;
						HDV[i][moni] -= HDV[i][moni]/2;
					
					}
					else{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie uda³o ci siê! :C");
						PDV[playerid][Bounty][0] += 15000*4;
						PDV[playerid][Bounty][1] += 30*4;
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nagroda za gracza %s : %d$/%d Exp",PDV[playerid][Nck],PDV[playerid][Bounty][0],PDV[playerid][Bounty][1]);					
					}
				}
				case 4:{
					if(r <= 2){
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Obrabowa³eœ Dom!");
						GiRe(playerid,HDV[i][expi]/10);
						GiPlMo(playerid,HDV[i][moni]/2);
						new str[128];
						format(str,128,"\t{ffffff}*****{56aaaa}£upy{ffffff}*****\t\n\tExp:%d\t\n\tKasa:%d\t",HDV[i][expi]/10,HDV[i][moni]/2);
						Dialog_Show(playerid, Robbed, DIALOG_STYLE_MSGBOX, "{00ff00}Twoje ³upy", str, "OK","OK");
						HDV[i][expi] -= HDV[i][expi]/10;
						HDV[i][moni] -= HDV[i][moni]/2;
					}
					else{
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie uda³o ci siê! :C");
						PDV[playerid][Bounty][0] += 15000*5;
						PDV[playerid][Bounty][1] += 30*5;
						SCMA(-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nagroda za gracza %s : %d$/%d Exp",PDV[playerid][Nck],PDV[playerid][Bounty][0],PDV[playerid][Bounty][1]);
					}
				}
			}
			PDV[playerid][RobCld] = GetTickCount()+900000;
			return 1;
		}
		CMD:spass(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, PassD, DIALOG_STYLE_PASSWORD, "Has³o Na Dom", "Za³ó¿ has³o na dom dziêki temu 1 prostemu triku", "OK", "Nie");
			return 1;
		}
		CMD:meble(playerid,params[]){
			return 1;
		}
		CMD:estatename(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid,estnmD,DIALOG_STYLE_INPUT,"Zmien nazwê swojej posiad³oœci","Wpisz tu now¹ nazwe swojej posiad³oœci","OK","Wstecz");
			return 1;
		}
		CMD:sejf(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			new str[48];
			format(str,sizeof(str),"Twój stan sejfu wynosi:\nEXP:\t%i\nHajs:\t%i",HDV[PDV[playerid][OwOf]][expi],HDV[PDV[playerid][OwOf]][moni]);
			Dialog_Show(playerid,sejfd,DIALOG_STYLE_MSGBOX,"Twoj stan sejfu",str,"OK","OK");
			return 1;
		}
		alias:hlock("hlck","zamknijd");
		CMD:hlock(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			if(HDV[PDV[playerid][OwOf]][Lck]){
				HDV[PDV[playerid][OwOf]][Lck] = false;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Otworzy³eœ swój dom :3!");
			}else {
				HDV[PDV[playerid][OwOf]][Lck] = true;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zamkn¹³eœ swój dom!");
			}
			return 1;
		}
		CMD:wexp(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, wexpD, DIALOG_STYLE_INPUT, "Wp³aæ Expa", "Iloœæ Expa Któr¹ chcesz wp³aciæ", "OK", "Anuluj");
			return 1;
		}
		CMD:wmon(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, wmonD, DIALOG_STYLE_INPUT, "Wp³aæ Kase", "Iloœæ Kasy Któr¹ chcesz wp³aciæ", "OK", "Anuluj");
			return 1;
		}
		CMD:wyexp(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, wyexpD, DIALOG_STYLE_INPUT, "Wyp³aæ Exp", "Iloœæ Expa Któr¹ chcesz wyp³aciæ", "OK", "Anuluj");
			return 1;
		}
		CMD:wymon(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			Dialog_Show(playerid, wymonD, DIALOG_STYLE_INPUT, "Wyp³aæ Kase", "Iloœæ Kasy Któr¹ chcesz wyp³aciæ", "OK", "Anuluj");
			return 1;
		}
		CMD:buy(playerid,params[])
		{
			if(PDV[playerid][OwOf] != -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Masz ju¿ dom!"); return 1;}
			new i = IPAH(playerid);
			if(i == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ w pobli¿u domu"); return 1;}
			if(HDV[i][Bin]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dom jest zajêty"); return 1;}
			new x = TkPlRe(playerid,HDV[i][ExP]);
			if(!x){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak expa by kupiæ ten dom"); return 1;}
			x = TkPlMo(playerid,HDV[i][MoP]);
			if(!x){
				GiRe(playerid,HDV[i][ExP]);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak hajsu by kupiæ ten dom");
				return 1;
			}
			HDV[i][Bin] = true;
			HDV[i][Oid] = PDV[playerid][iDP];
			HDV[i][ONck] = PDV[playerid][Nck];
			PDV[playerid][OwOf] = HDV[i][hID];
			new quer[128];
			mysql_format(DBM, quer, sizeof(quer), "UPDATE `HoS` SET `Bin`='1',`Oid`='%i' WHERE `id`='%i'",HDV[i][Oid],HDV[i][hID]);
			mq(quer);
			DestroyDynamicPickup(HDV[i][hidP]);
			DestroyDynamicMapIcon(HDV[i][hidMI]);
			DestroyDynamic3DTextLabel(HDV[i][hid3D]);
			new str[256];
			format(str,sizeof(str),"{ff0000}Zajete\n{56ff56}Posiad³oœæ:{ffffff}%s\n{56ff56}Wlasciciel:{ffffff}%s\n{56ff56}Interior:{ffffff}%i\nID:%i",HDV[i][estanam],HDV[i][ONck],HDV[i][Iid],HDV[i][hID]);
			HDV[i][hidP] = CreateDynamicPickup(1272, 1, HDV[i][XP],HDV[i][YP],HDV[i][ZP], 0, 0);
			HDV[i][hidMI] = CreateDynamicMapIcon(HDV[i][XP],HDV[i][YP],HDV[i][ZP], 32, 0);
			UpdateDynamic3DTextLabelText(HDV[i][hid3D], 0xFFFFFFFF, str);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Kupi³eœ Dom!");
			return 1;
		}
		CMD:sell(playerid,params[])
		{
			if(PDV[playerid][OwOf] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz domu O.o"); return 1;}
			new i = PDV[playerid][OwOf]; //Nie chcia³o mi siê patrzeæ na spaggetti z HDV[PDV[playerid][OwOf]][COS]
			GiRe(playerid,HDV[i][expi]);
			GiPlMo(playerid,HDV[i][moni]);
			HDV[i][expi] = 0;
			HDV[i][moni] = 0;
			HDV[i][Bin] = false;
			HDV[i][Oid] = -1;
			HDV[i][ONck][23] = EOS;
			PDV[playerid][OwOf] = -1;
			new quer[188];
			mysql_format(DBM, quer, sizeof(quer), "UPDATE `HoS` SET `Bin`='1',`Oid`='-1',`expi`='0',`moi`='0' WHERE `id`='%i'",HDV[i][hID]);
			mq(quer);
			DestroyDynamicPickup(HDV[i][hidP]);
			DestroyDynamicMapIcon(HDV[i][hidMI]);
			HDV[i][hidP] = CreateDynamicPickup(1273, 1, HDV[i][XP],HDV[i][YP],HDV[i][ZP], 0, 0);
			HDV[i][hidMI] = CreateDynamicMapIcon(HDV[i][XP],HDV[i][YP],HDV[i][ZP], 31, 0);
			format(quer,sizeof(quer),"{00ff00}NA SPRZEDAZ!\n{56ff56}Posiad³oœæ:{ffffff}%s\n{56ff56}Czynsz:{ffffff}%i{00aa00}${ffffff}/%i{ffaaaa}Exp\n{56ff56}Interior:{ffffff}%i\nID:%i",HDV[i][estanam],HDV[i][MoP],HDV[i][ExP],HDV[i][Iid],HDV[i][hID]);
			UpdateDynamic3DTextLabelText(HDV[i][hid3D], 0xFFFFFFFF, quer);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Sprzeda³eœ Dom");
			return 1;
		}
		CMD:klucze(playerid,params[]){
			return 1;
		}
		CMD:wejdz(playerid,params[])
		{
			new i = IPAH(playerid);
			if(i == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ w pobli¿u domu"); return 1;}
			if(HDV[i][Lck] && HDV[i][Oid] != PDV[playerid][iDP]){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dom jest zamkniêty"); return 1;}
			if(!HDV[i][Bin]){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Masz 30 sekund na zwiedzenie");
				PDV[playerid][CtD] = GetTickCount()+30000;
				PDV[playerid][SetF] = 4;
			}
			SetPlayerInterior(playerid, IntIdK[HDV[i][Iid]]);
			SetPlayerVirtualWorld(playerid, i+300);
			SetPlayerPos(playerid, IntId[HDV[i][Iid]][0],IntId[HDV[i][Iid]][1],IntId[HDV[i][Iid]][2]);
			SetPlayerFacingAngle(playerid, IntId[HDV[i][Iid]][3]);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wszed³eœ do domu");
			return 1;
		}
		CMD:wyjdz(playerid,params[])
		{
			PDV[playerid][CtD] = 0;
			PDV[playerid][SetF] = 0;
			new x = GetPlayerVirtualWorld(playerid);
			if(x < 300){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie ma z czego wychodziæ?"); return 1;}
			x -= 300;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid,HDV[x][XP],HDV[x][YP],HDV[x][ZP]);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Wyszed³eœ z domu");
			return 1;
		}
		CMD:arespawn(playerid,params[]){
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			SpawnPlayer(playerid);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zrespawnowa³eœ siê za pomoc¹ /arespawn");
			return 1;
		}
		CMD:interiory(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			new inty;
			if(sscanf(params,"i",inty)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /interiory [id]"); return 1;}
			if(0 > inty > sizeof(IntId)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Z³e id interioru LoL 0-144"); return 1;}
			GetPlayerPos(playerid, PDV[playerid][LaX],PDV[playerid][LaY],PDV[playerid][LaZ]);
			SetPlayerInterior(playerid, IntIdK[inty]);
			SetPlayerPos(playerid, IntId[inty][0],IntId[inty][1],IntId[inty][2]);
			SetPlayerFacingAngle(playerid, IntId[inty][3]);
			return 1;
		}
		CMD:addh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			new inty,rey,cshy,estaname[24];
			if(sscanf(params,"iiis[24]",inty,rey,cshy,estaname)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /addh [int] [exp] [kasa] [nazwadomu]"); return 1;}
			if(0 > inty > sizeof(IntId)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Z³e id interioru sprawdz /interiory [id]"); return 1;}
			if(rey < 1 || cshy < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wartosci na koñcu nie mog¹ byæ mniejsze od 0"); return 1;}
			new x = AddHous(playerid,inty,rey,cshy,estaname);
			if(x){
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00dd00}Domy:Poprawnie stworzono Dom!!! Yay!");
			}else{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {dd0000}Domy:Kurwa nie dzia³a");
			}
			return 1;
		}
		CMD:hioh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			new inty,Hid;
			if(sscanf(params,"ii",inty,Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /chioh [int] [Hid]"); return 1;}
			if(!Iter_Contains(IHo, Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki dom nie istnieje"); return 1;}
			if(0 > inty > sizeof(IntId)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Z³e id interioru sprawdz /interiory [id]"); return 1;}
			new quer[128];
			mysql_format(DBM,quer,128, "UPDATE `HoS` SET `Iid`='%d' WHERE `id`='%d'", inty,Hid);
			mq(quer);
			HDV[Hid][Iid] = inty;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00dd00}Zmieniono id interioru domu: %i",Hid);
			return 1;
		}
		CMD:hcoh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			new inty,Hid;
			if(sscanf(params,"ii",inty,Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /chcoh [Hajsy] [Hid]"); return 1;}
			if(!Iter_Contains(IHo, Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki dom nie istnieje"); return 1;}
			if(inty < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}W g³owie masz olej?"); return 1;}
			HDV[Hid][MoP] = inty;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00dd00}Zmieniono Koszt w hajsie domu: %i",Hid);
			return 1;
		}
		CMD:heoh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostepu do tej komendy"); return 1;}
			new inty,Hid;
			if(sscanf(params,"ii",inty,Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /chcoh [Hajsy] [Hid]"); return 1;}
			if(!Iter_Contains(IHo, Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki dom nie istnieje"); return 1;}
			if(inty < 1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}W g³owie masz olej?"); return 1;}
			HDV[Hid][ExP] = inty;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00dd00}Zmieniono Koszt w expie domu: %i",Hid);
			return 1;
		}
		CMD:remh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new Hid;
			if(sscanf(params,"i",Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /remh [id]"); return 1;}
			if(!Iter_Contains(IHo, Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Taki dom nie istnieje"); return 1;}
			DelHous(Hid);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Poprawnie Usun¹³eœ Dom");
			return 1;
		}
		CMD:moveh(playerid,params[])
		{
			if(PDV[playerid][APL] < 6){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy");return 1;}
			new Hid;
			if(sscanf(params,"i",Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie /moveh [id]"); return 1;}
			if(!Iter_Contains(IHo,Hid)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie ma takiego domu"); return 1;}
			new quer[256];
			GetPlayerPos(playerid,HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP]);
			mysql_format(DBM, quer, sizeof(quer), "UPDATE `HoS` SET `XP`='%f',`YP`='%f',`ZP`='%f' WHERE `id`='%i'",HDV[Hid][XP],HDV[Hid][YP],HDV[Hid][ZP],Hid);
			mq(quer);
			DestroyDynamicPickup(HDV[Hid][hidP]);
			DestroyDynamic3DTextLabel(HDV[Hid][hid3D]);
			hElemCr(Hid);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Poprawnie Przenios³eœ Dom");
			return 1;
		}
	//Vehicle Params
		CMD:lock(playerid,params[]){
			if(GetPlayerVehicleSeat(playerid) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Nie jesteœ kierowc¹ pojazdu!"); return 1;}
			new v = GetPlayerVehicleID(playerid);
			SetVehicleParamsEx(v, 0, 0, 0, 1, 0, 0, 0);
			SetVehicleParamsForPlayer(v, playerid, 0, 0);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Broooom! Pi Pi! Zamkniête!");
			return 1;
		}
		CMD:unlock(playerid,params[]){
			if(GetPlayerVehicleSeat(playerid) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Nie jesteœ kierowc¹ pojazdu!"); return 1;}
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, 0, 0, 0, 0, 0, 0);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Broooom! Pi Pi! Otwarte!");
			return 1;
		}
		CMD:lockp(playerid,params[]){
			if(GetPlayerVehicleSeat(playerid) != 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Nie posiadasz privCar'a"); return 1;}
			SetVehicleParamsEx(PDV[playerid][pvidp], 0, 0, 0, 1, 0, 0, 0);
			SetVehicleParamsForPlayer(PDV[playerid][pvidp], playerid, 0, 0);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Broooom! Pi Pi! Zamkniête!");
			return 1;
		}
		CMD:unlockp(playerid,params[]){
			if(GetPlayerVehicleSeat(playerid) != 0){ SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Nie posiadasz privCar'a"); return 1;}
			SetVehicleParamsEx(PDV[playerid][pvidp], 0, 0, 0, 0, 0, 0, 0);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca  {9b9da0}| {ff0000}Broooom! Pi Pi! Otwarte!");
			return 1;
		}
	//Gangi
		CMD:gang(playerid,params[]){
			if(PDV[playerid][IGid] == -1){
				Dialog_Show(playerid, GangD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Menu", "Stwórz Gang\nLista Gangów\nTop Respektu\nInformacje", "OK","Anuluj");
			}else{
				Dialog_Show(playerid, GangJD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Menu", "Twój Gang\nLista Gangów\nTop Respektu\nInformacje", "OK","Anuluj");
			}
			return 1;
		}
		CMD:stworzgang(playerid,params[]){
			if(PDV[playerid][IGid] != -1){return 0;}
			Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "Stwórz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie");
			return 1;
		}
		CMD:listagangow(playerid,params[]){
			new str[530],iz=sizeof(str);
			foreach(new x : GTHC){
				strcat(str, GDV[x][gName],iz);
				strcat(str,"\n",iz);
			}
			if(isnull(str)){
				strcat(str,"{ff0000}Brak gangów",iz);
			}
			Dialog_Show(playerid, GangLD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Lista Gangów", str, "Wybierz","Nie");
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
			new str[416];
			strcat(str, "------------------System Gangów------------------\nKrótko o gangach:\nWst¹pienie lub za³o¿enie gangu zalicza osi¹gniêcie i daje mo¿liwoœæ zaliczenia innych.",sizeof(str));
			strcat(str,"\nJeœli gang posiada teren wszyscy cz³onkowie na tym zyskuj¹ otrzymuj¹c co godzinê exp na w³asne konto.\nGangi nale¿y ulepszaæ by z czasem wiêcej z niego zyskiwaæ.",sizeof(str));
			strcat(str,"\nZa³o¿enie gangu kosztuje : 50k expa i 300k$\nUtrzymanie gangu kosztuje 2.4kExp i 15k$ na dzien",sizeof(str));
			Dialog_Show(playerid, infoD, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- Info", str, "OK","");
			return 1;
		}
		CMD:mojgang(playerid,params[]){
			if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
			Dialog_Show(playerid, GangMD, DIALOG_STYLE_LIST, "{aaffaa}Gang {ffffff}- Mój gang", "Dodaj Gracza\nUsun Cz³onka\nInfo O Gangu\nUlepsz Gang\nCz³onkowie\nPrzed³u¿ Gang", "OK","Anuluj");
			return 1;
		}
		CMD:dodajg(playerid,params[]){
			if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
			if(PDV[playerid][GPid] <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz permisji do tej komendy"); return 1;}
			Dialog_Show(playerid, GangDGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Dodaj Gracza", "{ffffff}Podaj ID gracza którego chcesz dodaæ", "OK","Nie");
			return 1;
		}
		CMD:usung(playerid,params[]){
			if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz gangu"); return 1;}
			if(PDV[playerid][GPid] <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz permisji do tej komendy"); return 1;}
			Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");
			return 1;
		}
		CMD:gaccept(playerid,params[]){
			if(PDV[playerid][IGidI] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak zaproszenia"); return 1;}
			foreach(Player,i){
				if(PDV[i][IGid] == PDV[playerid][IGidI] && PDV[i][GPid] <= 1){
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz %s zaakceptowa³ zaproszenie",PDV[playerid][Nck]);
				}
			}
			PDV[playerid][IGid] = PDV[playerid][IGidI];
			PDV[playerid][IGidI] = -1;
			GDV[PDV[playerid][IGid]][gMem]++;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Do³¹czy³eœ do gangu %s",GDV[PDV[playerid][IGid]][gName]);
			return 1;
		}
		CMD:gdeny(playerid,params[]){
			if(PDV[playerid][IGidI] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Zaproszenia"); return 1;}
			foreach(Player,i){
				if(PDV[i][IGid] == PDV[playerid][IGidI] && PDV[i][GPid] <= 1){
					SCM(i,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Gracz %s odrzuci³ zaproszenie",PDV[playerid][Nck]);
				}
			}
			PDV[playerid][IGidI] = -1;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Odrzuci³eœ zaproszenie");
			return 1;
		}
		CMD:gopusc(playerid,params[]){
			if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Gangu"); return 1;}
			if(PDV[playerid][GPid] == 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Jesteœ liderem nie mo¿esz siê usun¹æ"); return 1;}
			new str[45];
			format(str,sizeof(str),"Gracz %s opuœci³ gang",PDV[playerid][Nck]);
			MSGGang(PDV[playerid][IGid],INVALID_PLAYER_ID,str);
			GDV[PDV[playerid][IGid]][gMem]--;
			PDV[playerid][IGid] = -1;
			PDV[playerid][GPid] = 0;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Odszed³eœ z gangu");
			return 1;
		}
		CMD:gulepsz(playerid,params[]){
			if(PDV[playerid][GPid] != 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie jesteœ liderem gangu"); return 1;}
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
			format(str,sizeof(str),"Gang:%s\nTag:%s\n\nRespekt:%i\nIloœæ Terenów:%i\nIloœæ Cz³onków:%i\nCz³onkowie Online:{00ff00}%s",GDV[PDV[playerid][IGid]][gName],GDV[PDV[playerid][IGid]][gTag],GDV[PDV[playerid][IGid]][gRspkt],GDV[PDV[playerid][IGid]][gTrtCoun],GDV[PDV[playerid][IGid]][gMem],st2);
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
			format(str,sizeof(str),"{ffffff}Cz³onkowie Online:{00ff00}%s",st2);
			Dialog_Show(playerid, infoD, DIALOG_STYLE_TABLIST_HEADERS, "{aaffaa}Gang {ffffff}- Info o Gangu", str, "Ok","");	
			return 1;
		}
		CMD:gprzedluz(playerid,params[]){
			if(PDV[playerid][IGid] == -1){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak Gangu"); return 1;}
			Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed³u¿", "{ffffff}Wpisz iloœæ dni na któr¹ chcesz przed³u¿yæ {aaffaa}Gang","OK","Anuluj");
			return 1;
		}
		CMD:spar(playerid,params[]){
			if(PDV[playerid][GPid] < 2){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej komendy"); return 1;}
			new spra;
			if(sscanf(params,"i",spra)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie:/spar [id]");}
			return 1;
		}
		CMD:sparaccept(playerid,params[]){
			return 1;
		}
	//Zones
		CMD:stworzteren(playerid,params[])
		{
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej cmd"); return 1;}
			if(floatround(GM[GZs0],floatround_round) == 0){
				if(sscanf(params,"s[24]",GZnm)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /stworzteren [nazwa]"); return 1;}
				new Float:z;
				GetPlayerPos(playerid, GM[GZs0],GM[GZs1], z);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Uda³o ci siê stworzyæ pierwsz¹ czêœæ strefy idŸ teraz do drugiego rogu");
			}else{
				new Float:z;
				GetPlayerPos(playerid,GM[GZs2],GM[GZs3],z);
				GM[crtingz] = false;
				new x = CreateZone(GZnm,GM[GZs0],GM[GZs1],GM[GZs2],GM[GZs3]);
				GZnm[23] = EOS;
				GM[GZs0] = 0.000;
				GM[GZs1] = 0.000;
				GM[GZs2] = 0.000;
				GM[GZs3] = 0.000;
				if(x == 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Dojebano do limitu stref");}
				else{SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo Stworzy³eœ strefe");}
			}
			return 1;
		}
		CMD:sledzt(playerid,params[]){
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej cmd"); return 1;}
			if(!PDV[playerid][zSl]){
				PDV[playerid][zSl] = true;
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}W³¹czy³eœ Œledzenie id terenu");
			}else{
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Wy³¹czy³eœ Œledzenie id terenu");
				PDV[playerid][zSl] = false;
			}
			return 1;
		}
		CMD:usunteren(playerid,params[]){
			if(PDV[playerid][APL] < 5){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie masz dostêpu do tej cmd"); return 1;}
			new x;
			if(sscanf(params,"i",x)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}U¿ycie: /ausunteren [id]"); return 1;}
			if(!Iter_Contains(aZones, x)){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Takie coœ nie istnieje"); return 1;}
			DestroyZone(x);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Poprawnie usuniêto strefe");
			return 1;
		}
//Dialog ---WATCHOUT NOT DOCUMENTED---
	Dialog:expirG(playerid,response,listitem,inputtext[]){
		if(PDV[playerid][IGid] == -1){return 1;}
		if(response){
			if(isnull(inputtext)){Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed³u¿", "{ffffff}Wpisz iloœæ dni na któr¹ chcesz przed³u¿yæ {aaffaa}Gang\n{ff0000}Wpisz COŒ!","OK","Anuluj");}
			if(!IsNumeric(inputtext)){Dialog_Show(playerid, expirG, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Przed³u¿", "{ffffff}Wpisz iloœæ dni na któr¹ chcesz przed³u¿yæ {aaffaa}Gang\n{ff0000}ILOŒÆ DNI!","OK","Anuluj");}
			new v = strval(inputtext);
			new cos = TkPlRe(playerid,v * 2400);
			if(!cos){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak œrodków potrzebne %i Exp",v * 2400); return 1;}
			cos = TkPlMo(playerid,v * 15000);
			if(!cos){
				GiRe(playerid,v * 2400);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Brak œrodków potrzebne %i Hajsu",v * 15000);
				return 1;
			}
			GDV[PDV[playerid][IGid]][gExpire] += v;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff80}Przed³u¿y³eœ Gang na {00ffff}%i {00ff80}dni",GDV[PDV[playerid][IGid]][gExpire]);
		}
		return 1;
	}
	Dialog:GangMD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else{
			switch(listitem){
				case 0:{callcmd::dodajg(playerid,"");}
				case 1:{callcmd::usung(playerid,"");}
				case 2:{callcmd::mginfo(playerid,"");}
				case 3:{callcmd::gulepsz(playerid,"");}
				case 4:{callcmd::mgczlonkowie(playerid,"");}
				case 5:{callcmd::gprzedluz(playerid,"");}
			}
		}
		return 1;
	}
	Dialog:GangUpGD(playerid,response,listitem,inputtext[]){
		if(PDV[playerid][GPid] != 2){ return 1;}
		if(!response){ return 1;}
		listitem++;
		switch(listitem){
			case 0:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem){
					new v = TkPlRe(playerid,75000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
					v = TkPlMo(playerid,500000);
					if(!v){
						GiRe(playerid,75000);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki");
						return 1;
					}
					GDV[PDV[playerid][IGid]][LVL] = 1;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy³eœ Gang");
				}
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ masz wiêkszy lvl b¹dŸ taki sam");
			}
			case 1:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem){
					new v = TkPlRe(playerid,100000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
					v = TkPlMo(playerid,750000);
					if(!v){
						GiRe(playerid,100000);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki");
						return 1;
					}
					GDV[PDV[playerid][IGid]][LVL] = 2;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy³eœ Gang");
				}
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ masz wiêkszy lvl b¹dŸ taki sam");
			}
			case 2:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem){
					new v = TkPlRe(playerid,150000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
					v = TkPlMo(playerid,1000000);
					if(!v){
						GiRe(playerid,150000);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki");
						return 1;
					}
					GDV[PDV[playerid][IGid]][LVL] = 3;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy³eœ Gang");
				}
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ masz wiêkszy lvl b¹dŸ taki sam");
			}
			case 3:{
				if(GDV[PDV[playerid][IGid]][LVL] < listitem){
					new v = TkPlRe(playerid,200000);
					if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
					v = TkPlMo(playerid,2000000);
					if(!v){
						GiRe(playerid,200000);
						SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki");
						return 1;
					}
					GDV[PDV[playerid][IGid]][LVL] = 4;
					SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Brawo ulepszy³eœ Gang");
				}
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Ju¿ masz wiêkszy lvl b¹dŸ taki sam");
			}
		}
		return 1;
	}
	Dialog:GangDGD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else {
			if(PDV[playerid][GPid] == 0){return 1;}
			if(PDV[playerid][IGid] == -1){return 1;}
			if(isnull(inputtext)){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}BRAK ID GRACZA!\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			new x = strval(inputtext);
			if(!IsPlayerConnected(x)){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz nie istnieje!\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			if(PDV[x][IGid] != -1){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest ju¿ w innym gangu\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			PDV[x][IGidI] = PDV[playerid][IGid];
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {00ff00}Zosta³eœ zaproszony do Gangu {aaffaa}%s{00ff00} przez {aaffaa}%s{ffffff} /gaccept",GDV[PDV[playerid][IGid]][gName],PDV[playerid][Nck]);
		}	
		return 1;
	}
	Dialog:GangUGD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else {
			if(PDV[playerid][GPid] == 0){return 1;}
			if(PDV[playerid][IGid] == -1){return 1;}
			if(isnull(inputtext)){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}BRAK ID GRACZA!\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			new x = strval(inputtext);
			if(!IsPlayerConnected(x)){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz nie istnieje!\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			if(PDV[x][IGid] != PDV[x][IGid]){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest nie w tym gangu\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			if(PDV[x][GPid] == 2){Dialog_Show(playerid, GangUGD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Usun Gracza", "{ff0000}Gracz jest liderem!\n{ffffff}Podaj ID gracza którego chcesz Usun¹æ", "OK","Nie");return 1;}
			PDV[x][IGid] = -1;
			PDV[x][GPid] = 0;
			GDV[PDV[playerid][IGid]][gMem]--;
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Zosta³eœ wyrzucony z gangu przez %s",PDV[playerid][Nck]);
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
					format(str,sizeof(str),"Gang:%s\nTag:%s\n\nID:%i\nRespekt:%i\nTereny:%i\nCz³onkowie Online:%s",GDV[x][gName],GDV[x][gTag],x,GDV[x][gRspkt],GDV[x][gTrtCoun],MembersOnline);
					Dialog_Show(playerid, infoD, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- Lista Gangów", str, "OK","");
					break;
				}
			}
		}
		return 1;
	}
	Dialog:GangSD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else{
			if(isnull(inputtext)){Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "{ff0000}Ju¿ taka nazwa gangu istnieje!\nStwórz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie");}
			if(strlen(inputtext) > 31){Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "Stwórz Gang\n{ff0000}Za du¿o znaków max(30)\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie"); return 1;}
			if(strfind(inputtext,",") != -1){Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "Stwórz Gang\n{ff0000}le wpisa³eœ Tag i nazwe gangu popatrz na dole po przyk³ad\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie"); return 1;}
			new TagG[6],NazwaG[24];
			new h = strfind(inputtext, ",");
			strmid(TagG, inputtext, 0, h, sizeof(TagG));
			strmid(NazwaG, inputtext, h, 31, sizeof(NazwaG));
			foreach(new x : GTHC){
				if(!strcmp(GDV[x][gTag], TagG, false)){
					Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "{ff0000}Ju¿ taka nazwa gangu istnieje!\nStwórz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie");
					return 1;
				}
				else if(!strcmp(GDV[x][gName],NazwaG,false)){
					Dialog_Show(playerid, GangSD, DIALOG_STYLE_INPUT, "{aaffaa}Gang {ffffff}- Stwórz Gang", "{ff0000}Ju¿ taka nazwa gangu istnieje!\nStwórz Gang\n{aaffaa}Gang kosztuje {ffaaaa}30k {aaffaa}Expa i {ffaaaa}300k$ {aaffaa}Pieniêdzy\n{aaaaaa}Przed stworzeniem Gangu podaj jego Tag i Nazwe po przecinku\nPrzyk³ad:PK,PartiaKorwin", "Ok","Nie");
					return 1;
				}
			}
			new str[170];
			SetPVarString(playerid, "TagGp", TagG);
			SetPVarString(playerid, "NazwaGp", NazwaG);
			format(str,sizeof(str),"{ffffff}Czy napewno chcesz stworzyæ Gang?\nNazwa Gangu:{aaffaa}%s\n{ffffff}Tag Gangu:{aaffaa}%s\nBêdzie cie to kosztowa³o 30k Expa i 300k$",NazwaG,TagG);
			Dialog_Show(playerid, GangSDc, DIALOG_STYLE_MSGBOX, "{aaffaa}Gang {ffffff}- Stwórz Gang{ff0000}Potwierdz", str, "Tak","Nie");
		}
		return 1;
	}
	Dialog:GangSDc(playerid,response,listitem,inputtext[]){
		new TagG[6],NazwaG[24];
		GetPVarString(playerid, "TagGp", TagG, 6);
		GetPVarString(playerid, "NazwaGp", NazwaG, 24);
		DeletePVar(playerid, "TagGp");
		DeletePVar(playerid, "NazwaGp");
		if(strlen(TagG) <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {FF0000}Tag musi mieæ wiêcej ni¿ 0 znaków!!!!"); return 1;}
		if(strlen(NazwaG) <= 0){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {FF0000}Nazwa musi mieæ wiêcej ni¿ 0 znaków!!!!"); return 1;}
		if(!response){}
		else {
			new v = TkPlRe(playerid,30000);
			if(!v){SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki"); return 1;}
			v = TkPlMo(playerid,300000);
			if(!v){
				GiRe(playerid,30000);
				SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {ff0000}Nie wystarczaj¹ce œrodki");
				return 1;
			}
			CreateGang(NazwaG,PDV[playerid][iDP],TagG);
			SCM(playerid,-1,"{9b9da0}| {ff0033}Ja{ffff33}mai{33cc00}ca {9b9da0}| {aaffaa}Pomyœlnie stworzono Gang:%s",NazwaG);
		}
		return 1;
	}
	Dialog:GangJD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else{
			switch(listitem){
				case 0:{callcmd::stworzgang(playerid,"");}
				case 1:{callcmd::listagangow(playerid,"");}
				case 2:{callcmd::topgangow(playerid,"");}
				case 3:{callcmd::ginfo(playerid,"");}
			}
		}
		return 1;
	}
	Dialog:GangD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else {
			switch(listitem){
				case 0:{callcmd::mojgang(playerid,"");}
				case 1:{callcmd::listagangow(playerid,"");}
				case 2:{callcmd::topgangow(playerid,"");}
				case 3:{callcmd::ginfo(playerid,"");}
			}
		}
		return 1;
	}
	Dialog:TopD(playerid,response,listitem,inputtext[]){
		if(!response){}
		else{
			switch(listitem){
				case 0:{
					new str[340];
					format(str,sizeof(str),"Nick\tKasa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopKasyn],Top[0][TopKasy],Top[1][TopKasyn],Top[1][TopKasyn],Top[2][TopKasyn],Top[2][TopKasy],Top[3][TopKasyn],Top[3][TopKasy],
						Top[4][TopKasyn],Top[4][TopKasyn],Top[5][TopKasy],Top[5][TopKasyn],Top[6][TopKasyn],Top[6][TopKasy],Top[7][TopKasyn],Top[7][TopKasy],Top[8][TopKasyn],Top[8][TopKasy],Top[9][TopKasyn],Top[9][TopKasy]);
					Dialog_Show(playerid,TopDx,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str,"OK","OK");
				}
				case 1:{
					new str[340];
					format(str,sizeof(str),"Nick\tExp\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopRspn],Top[0][TopRsp],Top[1][TopRspn],Top[1][TopRsp],Top[2][TopRspn],Top[2][TopRsp],Top[3][TopRspn],Top[3][TopRsp],
						Top[4][TopRspn],Top[4][TopRsp],Top[5][TopRspn],Top[5][TopRsp],Top[6][TopRspn],Top[6][TopRsp],Top[7][TopRspn],Top[7][TopRsp],Top[8][TopRspn],Top[8][TopRsp],Top[9][TopRspn],Top[9][TopRsp]);
					Dialog_Show(playerid,TopDx,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str,"OK","OK");
				}
				case 2:{
					new str[340];
					format(str,sizeof(str),"Nick\tZabójstwa\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopKilln],Top[0][TopKill],Top[1][TopKilln],Top[1][TopKill],Top[2][TopKilln],Top[2][TopKill],Top[3][TopKilln],Top[3][TopKill],
						Top[4][TopKilln],Top[4][TopKill],Top[5][TopKilln],Top[5][TopKill],Top[6][TopKilln],Top[6][TopKill],Top[7][TopKilln],Top[7][TopKill],Top[8][TopKilln],Top[8][TopKill],Top[9][TopKilln],Top[9][TopKill]);
					Dialog_Show(playerid,TopDx,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str,"OK","OK");
				}
				case 3:{
					new str[340];
					format(str,sizeof(str),"Nick\tOofed\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i\n%s\t%i",Top[0][TopDeathn],Top[0][TopDeath],Top[1][TopDeathn],Top[1][TopDeath],Top[2][TopDeathn],Top[2][TopDeath],Top[3][TopDeathn],Top[3][TopDeath],
						Top[4][TopDeathn],Top[4][TopDeath],Top[5][TopDeathn],Top[5][TopDeath],Top[6][TopDeathn],Top[6][TopDeath],Top[7][TopDeathn],Top[7][TopDeath],Top[8][TopDeathn],Top[8][TopDeath],Top[9][TopDeathn],Top[9][TopDeath]);
					Dialog_Show(playerid,TopDx,DIALOG_STYLE_TABLIST_HEADERS,"Top 10",str,"OK","OK");
				}
				case
