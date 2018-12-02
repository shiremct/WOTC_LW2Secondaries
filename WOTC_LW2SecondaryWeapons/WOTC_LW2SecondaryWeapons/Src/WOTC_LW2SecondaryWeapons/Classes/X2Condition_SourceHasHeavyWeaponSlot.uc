
class X2Condition_SourceHasHeavyWeaponSlot extends X2Condition;


event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit	SourceUnit;

	SourceUnit = XComGameState_Unit(kSource);

	if (SourceUnit == none)
		return 'AA_NotAUnit';

	if (!SourceUnit.HasHeavyWeapon())
		return 'AA_AbilityUnavailable';

	return 'AA_Success';
}