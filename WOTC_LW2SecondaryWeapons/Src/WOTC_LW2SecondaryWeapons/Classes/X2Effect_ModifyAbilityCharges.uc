
class X2Effect_ModifyAbilityCharges extends X2Effect_Persistent;

// Variables to pass into the effect:
var array<name>		AbilitiesToModify;	//»» List of abilities that will have their charges modified
var int				iChargeModifier;	//»» Number of charges to add to or subtract from defined abilities
var int				iMinCharges;		//»» Values of -1 (default) mean no min (still capped at zero, but keeps it consistent)
var int				iMaxCharges;		//»» Values of -1 (default) mean no max


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit		TargetUnit;
	local XComGameStateHistory		History;
	local XComGameState_Ability		AbilityState;
	local StateObjectReference		AbilityStateRef;
	local X2AbilityTemplate			AbilityTemplate;
	local int						CurrentCharges, NewCharges;
	local bool						bAddAmmoForCharges;

	// Skip initial mission setup effects if initiating a later stage of a multi-part mission
	if (class'X2Condition_TacticalToTacticalTransfer'.static.SkipSetupForMultiPartMission(ApplyEffectParameters))
		return;

	// Get Target's XComGameState_Unit
	TargetUnit = XComGameState_Unit(kNewTargetState);
	
	if (TargetUnit == none || AbilitiesToModify.Length == 0)
		return;

	History = `XCOMHISTORY;

	// Loop through the target's abilities to modify charges
	foreach TargetUnit.Abilities(AbilityStateRef)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityStateRef.ObjectID));
		AbilityTemplate = AbilityState.GetMyTemplate();

		// Check that the ability being evaluated is one defined to be modified
		if (AbilitiesToModify.Find(AbilityTemplate.DataName) != -1)
		{
			// Flag whether this ability uses Ammo or Charges
			bAddAmmoForCharges = AbilityTemplate.bUseAmmoAsChargesForHUD;

			// Get current Ammo/Charges for the ability
			CurrentCharges = bAddAmmoForCharges ? AbilityState.GetCharges() : AbilityState.iCharges;

			// Calculate NewCharges for the ability
			NewCharges = CurrentCharges + iChargeModifier;

			if (iMinCharges < 0) iMinCharges = 0;
			if (NewCharges < iMinCharges) NewCharges = iMinCharges;
			if (iMaxCharges >= 0 && NewCharges > iMaxCharges) NewCharges = iMaxCharges;

			SetCharges(AbilityState, NewCharges, NewGameState);
		}
	}
}

simulated function SetCharges(XComGameState_Ability AbilityState, int NewCharges, XComGameState NewGameState)
{
	local XComGameState_Item	SourceWeapon;
	local X2AbilityTemplate		AbilityTemplate;

	AbilityTemplate = AbilityState.GetMyTemplate();

	// Add Ammo to source weapon if ability uses Ammo for charges
	if (AbilityTemplate != None && AbilityTemplate.bUseAmmoAsChargesForHUD)
	{
		if (AbilityState.SourceAmmo.ObjectID > 0)
		{
			SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceAmmo.ObjectID));
			if (SourceWeapon != none)
			{
				SourceWeapon = XComGameState_Item(NewGameState.CreateStateObject(SourceWeapon.class, SourceWeapon.ObjectID));
				SourceWeapon.Ammo = NewCharges * AbilityTemplate.iAmmoAsChargesDivisor;
				NewGameState.AddStateObject(SourceWeapon);
			}
		}
		else
		{
			SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
			if (SourceWeapon != none)
			{
				SourceWeapon = XComGameState_Item(NewGameState.CreateStateObject(SourceWeapon.class, SourceWeapon.ObjectID));
				SourceWeapon.Ammo = NewCharges * AbilityTemplate.iAmmoAsChargesDivisor;
				NewGameState.AddStateObject(SourceWeapon);
			}
		}
	}
	// If ability does NOT use Ammo for chargers, set charges to new value
	else
	{
		AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(AbilityState.class, AbilityState.ObjectID));
		AbilityState.iCharges = NewCharges;
		NewGameState.AddStateObject(AbilityState);
	}
}


defaultproperties
{
	iMinCharges = -1
	iMaxCharges = -1
}