
class X2AbilityTag_LW2SecondariesWOTC extends X2AbilityTag config(GameData_SoldierSkills);

var config bool bColorConfigValueDescriptions;

// Modified and Implemented from Xylith's XModBase

// The previous X2AbilityTag. We save it so we can just call it to handle any tag we don't
// recognize, so we don't have to include a copy of the regular X2AbilityTag code. This also
// makes it so we will play well with any other mods that replace X2AbilityTag this way.
var X2AbilityTag WrappedTag;

var localized string strGenericClassName;


event ExpandHandler(string InString, out string OutString)
{
	local name						Type, nName;
	local XComGameStateHistory		History;
	local XComGameState_Unit		TargetUnitState;
	//local X2SoldierClassTemplate	ClassTemplate;
	local XComGameState_Ability		AbilityState;
	local XComGameState_Effect		EffectState;
	local UITacticalHUD				TacticalHUD;
	local int						iVal;

	Type = name(InString);
	History = `XCOMHISTORY;

	switch (Type)
	{	// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Generic				?
		// ??????????????????????????
				
		// Toggle coloring of variables within Loc text
		case 'WOTCLW2SW_COLOR_1_OPEN': // Orange
			if (default.bColorConfigValueDescriptions)	{Outstring = "<font color='#CA7200'>";}
			else										{Outstring = "";}
			break;
				
		case 'WOTCLW2SW_COLOR_2_OPEN': // Green
			if (default.bColorConfigValueDescriptions)	{Outstring = "<font color='#3ABD23'>";}
			else										{Outstring = "";}
			break;

		case 'WOTCLW2SW_COLOR_CLOSE':
			if (default.bColorConfigValueDescriptions)	{Outstring = "</font>";}
			else										{Outstring = "";}
			break;


		// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Arcthrower			?
		// ??????????????????????????

		case 'ARCTHROWER_STUN_COOLDOWN':
			OutString = string(class'X2Ability_ArcthrowerAbilitySet'.default.STUN_COOLDOWN - 1);
			break;
		case 'ARCTHROWER_CV_AIM':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_CONVENTIONAL_AIM);
			break;
		case 'ARCTHROWER_MG_AIM':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_MAGNETIC_AIM);
			break;
		case 'ARCTHROWER_BM_AIM':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_BEAM_AIM);
			break;
		case 'ARCTHROWER_CV_CLIPSIZE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_CONVENTIONAL_ICLIPSIZE);
			break;
		case 'ARCTHROWER_MG_CLIPSIZE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_MAGNETIC_ICLIPSIZE);
			break;
		case 'ARCTHROWER_BM_CLIPSIZE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_BEAM_ICLIPSIZE);
			break;
		case 'ARCTHROWER_CV_DAMAGE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_CONVENTIONAL_BASEDAMAGE.Damage);
			break;
		case 'ARCTHROWER_MG_DAMAGE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_MAGNETIC_BASEDAMAGE.Damage);
			break;
		case 'ARCTHROWER_BM_DAMAGE':
			OutString = string(class'X2Item_ArcthrowerWeapon'.default.Arcthrower_BEAM_BASEDAMAGE.Damage);
			break;
		case 'ARCTHROWER_EMPULSER_HACK_DEFENSE_PENALTY':
			OutString = string(class'X2Ability_ArcthrowerAbilitySet'.default.EMPULSER_HACK_DEFENSE_CHANGE);
			break;
		case 'ARCTHROWER_STUNGUNNER_AIM_BONUS':
			Outstring = "";
			if (StrategyParseObj == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				EffectState = XComGameState_Effect(ParseObj);
				if (AbilityState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
				else if (EffectState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
			if (TargetUnitState != none)
			{
				//nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, GameState).GetMyTemplate()).WeaponTech;
				nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(AbilityState.GetSourceWeapon().InventorySlot, GameState).GetMyTemplate()).WeaponTech;
				switch (nName)
				{
					case 'conventional':
						OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_CV);
						break;
					case 'magnetic':
						OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_MG);
						break;
					case 'beam':
						OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_BM);
						break;
				}
			}
			break;
		case 'ARCTHROWER_STUNGUNNER_AIM_BONUS_CV':
			OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_CV);
			break;
		case 'ARCTHROWER_STUNGUNNER_AIM_BONUS_MG':
			OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_MG);
			break;
		case 'ARCTHROWER_STUNGUNNER_AIM_BONUS_BM':
			OutString = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_BM);
			break;
		case 'ARCTHROWER_CHAIN_LIGHTNING_COOLDOWN':
			OutString = string(class'X2Ability_ArcthrowerAbilitySet'.default.CHAIN_LIGHTNING_COOLDOWN - 1);
			break;


		// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Combat Knife			?
		// ??????????????????????????

		case 'COMBATKNIFE_CV_AIM':
			OutString = string(class'X2Item_LWCombatKnife'.default.CombatKnife_CONVENTIONAL_AIM);
			break;
		case 'COMBATKNIFE_MG_AIM':
			OutString = string(class'X2Item_LWCombatKnife'.default.CombatKnife_MAGNETIC_AIM);
			break;
		case 'COMBATKNIFE_BM_AIM':
			OutString = string(class'X2Item_LWCombatKnife'.default.CombatKnife_BEAM_AIM);
			break;
		case 'KNIFE_FIGHTER_TILE_RANGE':
			OutString = string(class'X2Ability_CombatKnifeAbilitySet'.default.KNIFE_FIGHTER_TILE_RANGE);
			break;
		case 'COMBATKNIFE_COMBATIVES_DODGE_BONUS':
			OutString = string(class'X2Ability_CombatKnifeAbilitySet'.default.COMBATIVES_DODGE);
			break;			
			

		// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Gauntlet				?
		// ??????????????????????????

		case 'HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES);
			break;
		case 'HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES);
			break;
		case 'HEAVY_ARMAMENTS_BONUS_CHARGES_COMBINED':
			if (class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES == class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES)
			{ OutString = string(class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES); }
			else
			{ OutString = string(class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES) $ "/" $ string(class'X2Ability_GauntletAbilitySet'.default.HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES); }
			break;
		case 'LWROCKET_BASE_CHARGES':
			OutString = string(class'X2Item_LWGauntlet'.default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE);
			break;
		case 'LWFLAMER_BASE_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FLAMETHROWER_CHARGES);
			break;
		case 'SHOCK_AND_AWE_BONUS_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.SHOCK_AND_AWE_BONUS_CHARGES);
			break;
		case 'FIRE_AND_STEEL_DAMAGE_BONUS':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FIRE_AND_STEEL_DAMAGE_BONUS);
			break;
		case 'JAVELIN_ROCKETS_BONUS_RANGE_TILES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.JAVELIN_ROCKETS_BONUS_RANGE_TILES);
			break;
		case 'FLAMETHROWER_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FLAMETHROWER_CHARGES);
			break;
		case 'ROUST_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.ROUST_CHARGES);
			break;
		case 'FIRESTORM_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FIRESTORM_CHARGES);
			break;
		case 'FLAMETHROWER_HIGH_PRESSURE_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FLAMETHROWER_HIGH_PRESSURE_CHARGES);
			break;
		case 'ROUST_HIGH_PRESSURE_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.ROUST_HIGH_PRESSURE_CHARGES);
			break;
		case 'FIRESTORM_HIGH_PRESSURE_CHARGES':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FIRESTORM_HIGH_PRESSURE_CHARGES);
			break;
		case 'ROUST_RADIUS_MULTIPLIER':
			OutString = string(int((class'X2Ability_GauntletAbilitySet'.default.ROUST_RADIUS_MULTIPLIER - 1) * 100));
			break;
		case 'ROUST_RANGE_MULTIPLIER':
			OutString = string(int((class'X2Ability_GauntletAbilitySet'.default.ROUST_RANGE_MULTIPLIER - 1) * 100));
			break;
		case 'ROUST_DAMAGE_PENALTY':
			OutString = string(int((class'X2Ability_GauntletAbilitySet'.default.ROUST_DAMAGE_PENALTY - 1) * 100));
			break;
		case 'INCINERATOR_RADIUS_MULTIPLIER':
			OutString = string(int((class'X2Ability_GauntletAbilitySet'.default.INCINERATOR_RADIUS_MULTIPLIER - 1) * 100));
			break;
		case 'INCINERATOR_RANGE_MULTIPLIER':
			OutString = string(int((class'X2Ability_GauntletAbilitySet'.default.INCINERATOR_RANGE_MULTIPLIER - 1) * 100));
			break;
		case 'FIRESTORM_DAMAGE_BONUS':
			OutString = string(int(class'X2Ability_GauntletAbilitySet'.default.FIRESTORM_DAMAGE_BONUS));
			break;
		case 'FIRESTORM_RADIUS_METERS':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.FIRESTORM_RADIUS_METERS);
			break;
		case 'BURNOUT_RADIUS':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.ROUST_HIGH_PRESSURE_CHARGES);
			break;
		case 'BURNOUT_SMOKE_DEFNESE':
			OutString = string(-class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD);
			break;
		case 'QUICKBURN_COOLDOWN':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.QUICKBURN_COOLDOWN - 1);
			break;
		case 'PHOSPHORUS_BONUS_SHRED':
			OutString = string(class'X2Ability_GauntletAbilitySet'.default.ROUST_HIGH_PRESSURE_CHARGES);
			break;
		case 'ROCKETSCATTER':
			TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
			AbilityState = XComGameState_Ability(ParseObj);
			EffectState = XComGameState_Effect(ParseObj);
			if (AbilityState != none)
				TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
			else if (EffectState != none)
				TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if (TacticalHUD != none && TacticalHUD.GetTargetingMethod() != none && TargetUnitState != none)
			{
				iVal = class'X2Ability_GauntletAbilitySet'.static.GetNumAimRolls(TargetUnitState);
				Outstring = class'X2Ability_GauntletAbilitySet'.default.strMaxScatter $ string(iVal);
			}
			else
			{
				Outstring = "";
			}
			break;


		// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Holotargeter			?
		// ??????????????????????????

		case 'HOLOTARGETER_CV_AIM_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HOLO_CV_AIM_BONUS);
			break;
		case 'HOLOTARGETER_MG_AIM_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HOLO_MG_AIM_BONUS);
			break;
		case 'HOLOTARGETER_BM_AIM_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HOLO_BM_AIM_BONUS);
			break;
		case 'HOLOTARGETER_CV_CRIT_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HDHOLO_CV_CRIT_BONUS);
			break;
		case 'HOLOTARGETER_MG_CRIT_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HDHOLO_MG_CRIT_BONUS);
			break;
		case 'HOLOTARGETER_BM_CRIT_BONUS':
			OutString = string(class'X2Effect_LWHolotarget'.default.HDHOLO_BM_CRIT_BONUS);
			break;
		case 'HOLOTARGETER_CV_RADIUS':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_RADIUS - 1);
			break;
		case 'HOLOTARGETER_MG_RADIUS':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_RADIUS - 1);
			break;
		case 'HOLOTARGETER_BM_RADIUS':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_RADIUS - 1);
			break;
		case 'HOLOTARGETER_CV_DAMAGE':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.Damage);
			break;
		case 'HOLOTARGETER_MG_DAMAGE':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.Damage);
			break;
		case 'HOLOTARGETER_BM_DAMAGE':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.Damage);
			break;
		case 'HOLOTARGETER_AIM_BONUS':
			if (StrategyParseObj == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				EffectState = XComGameState_Effect(ParseObj);
				if (AbilityState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
				else if (EffectState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
			if (TargetUnitState != none)
			{
				//nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, GameState).GetMyTemplate()).WeaponTech;
				nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(AbilityState.GetSourceWeapon().InventorySlot, GameState).GetMyTemplate()).WeaponTech;
				switch (nName)
				{
					case 'conventional':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HOLO_CV_AIM_BONUS) $ "%";
						break;
					case 'magnetic':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HOLO_MG_AIM_BONUS) $ "%";
						break;
					case 'beam':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HOLO_BM_AIM_BONUS) $ "%";
						break;
				}
			}
			break;
		case 'HOLOTARGETER_HDHOLO_CRIT_BONUS':
			if (StrategyParseObj == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				EffectState = XComGameState_Effect(ParseObj);
				if (AbilityState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
				else if (EffectState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
			if (TargetUnitState != none)
			{
				//nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, GameState).GetMyTemplate()).WeaponTech;
				nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(AbilityState.GetSourceWeapon().InventorySlot, GameState).GetMyTemplate()).WeaponTech;
				switch (nName)
				{
					case 'conventional':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HDHOLO_CV_CRIT_BONUS) $ "%";
						break;
					case 'magnetic':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HDHOLO_MG_CRIT_BONUS) $ "%";
						break;
					case 'beam':
						OutString = " +" $ string(class'X2Effect_LWHolotarget'.default.HDHOLO_BM_CRIT_BONUS) $ "%";
						break;
				}
			}
			break;
		case 'HOLOTARGETER_VITAL_POINT_TARGETING_DAMAGE_BONUS':
			if (StrategyParseObj == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				EffectState = XComGameState_Effect(ParseObj);
				if (AbilityState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
				else if (EffectState != none)
					TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
			if (TargetUnitState != none)
			{
				//nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, GameState).GetMyTemplate()).WeaponTech;
				nName = X2WeaponTemplate(TargetUnitState.GetItemInSlot(AbilityState.GetSourceWeapon().InventorySlot, GameState).GetMyTemplate()).WeaponTech;
				switch (nName)
				{
					case 'conventional':
						OutString = " +" $ string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.Damage);
						break;
					case 'magnetic':
						OutString = " +" $ string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.Damage);
						break;
					case 'beam':
						OutString = " +" $ string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.Damage);
						break;
				}
			}
			break;
		case'HOLOTARGETER_RAPID_TARGETING_COOLDOWN':
			OutString = string(class'X2Ability_HolotargeterAbilitySet'.default.RAPID_TARGETING_COOLDOWN - 1);
			break;
		case'HOLOTARGETER_MULTI_TARGETING_COOLDOWN':
			OutString = string(class'X2Ability_HolotargeterAbilitySet'.default.MULTI_TARGETING_COOLDOWN - 1);
			break;
		case'HOLOTARGETER_INDEPENDENT_TARGETING_BONUS_TURNS':
			OutString = string(class'X2Effect_LWHolotarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS);
			break;


		// ??????????????????????????
		// ?   Localization Tags:	?
		// ??????????????????????????
		// ?   Sawed-Off Shotgun	?
		// ??????????????????????????
		
		case 'SAWEDOFFSHOTGUN_CV_AMMO':
			OutString = string(class'X2Item_LWSawedOffShotgun'.default.SawedOffShotgun_CONVENTIONAL_ICLIPSIZE);
			break;
		case 'SAWEDOFFSHOTGUN_MG_AMMO':
			OutString = string(class'X2Item_LWSawedOffShotgun'.default.SawedOffShotgun_MAGNETIC_ICLIPSIZE);
			break;
		case 'SAWEDOFFSHOTGUN_BM_AMMO':
			OutString = string(class'X2Item_LWSawedOffShotgun'.default.SawedOffShotgun_BEAM_ICLIPSIZE);
			break;
		case 'SAWEDOFFSHOTGUN_PUMP_ACTION_AMMO_BONUS':
			OutString = string(class'X2Ability_SawedOffShotgunAbilitySet'.default.PUMP_ACTION_EXTRA_AMMO);
			break;
		case 'SPARE_SHELLS_RELOADS':
			OutString = string(class'X2Ability_SawedOffShotgunAbilitySet'.default.SPARE_SHELLS_RELOADS);
			break;		


		// We don't handle this tag, check the wrapped tag.
		default:
			WrappedTag.ParseObj = ParseObj;
			WrappedTag.StrategyParseObj = StrategyParseObj;
			WrappedTag.GameState = GameState;
			WrappedTag.ExpandHandler(InString, OutString);
			// clear them out again
			WrappedTag.ParseObj = none;
			WrappedTag.StrategyParseObj = none;
			WrappedTag.GameState = none;  
			return;
	}
}