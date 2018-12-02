class X2Condition_TacticalToTacticalTransfer extends Object;

// Prevents initial setup effects (abilities with UnitPostBeginPlay triggers) from triggering again when initiating the beginning of a later stage of a multi-part mission
static function bool SkipSetupForMultiPartMission(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Priority;

	History = `XCOMHISTORY;

	// Check to see if this is a direct mission transfer in a multi-part mission - If not, return false
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
		return false;
	
	// Check to see if this ability uses a UnitPostBeginPlay trigger - If not, return false
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
		return false;

	// If this IS a direct mission transfer in a multi-part mission and the ability IS using a UnitPostBeginPlay trigger, return true, indicating this effect should be skipped
	return true;
}