
class X2Condition_HolotargeterSquadsightEffect extends X2Condition;


event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit				SourceUnit, TargetUnit;
	local int								TargetID;
	local GameRulesCache_VisibilityInfo		VisInfo;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit != none)
		TargetID = TargetUnit.ObjectID;
	else
		TargetID = XComGameState_InteractiveObject(kTarget).ObjectID;

	// If Source has the a squadsite effect, succeed
	if (SourceUnit.AffectedByEffectNames.Find('Squadsight') != -1 || SourceUnit.AffectedByEffectNames.Find('Holotargeter_AllowSquadsightEffect') != -1)
		return 'AA_Success';

	// Otherwise, require the target to be in normal visibilty range
	if (!`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetID, VisInfo) || !VisInfo.bVisibleGameplay)
		return 'AA_NotInRange';

	return 'AA_Success';
}