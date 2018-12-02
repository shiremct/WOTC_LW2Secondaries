
class X2Condition_SourceEffectRequirement extends X2Condition;

// Variables to pass into the condition check:
var array<name>	ExcludingEffectNames;
var array<name>	RequiredEffectNames;
var bool		bRequireAll;			//»» True (default) makes the RequiredEffectNames array behave as an 'AND' statement. False makes it an 'OR' statement.


event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit	SourceUnit;
	local name					EffectName;
	local bool					bHasRequired;
	local int					i;

	// Get Target's XComGameState_Unit
	SourceUnit = XComGameState_Unit(kSource);

	// Check that the Source has ONE or ALL Required Effects (depending on bRequireAll flag)
	if (RequiredEffectNames.Length > 0)
	{	
		bHasRequired = false;
		for (i=0; (i < RequiredEffectNames.Length); ++i)
		{
			EffectName = RequiredEffectNames[i];
			if (SourceUnit.AffectedByEffectNames.Find(EffectName) != -1)
			{
				bHasRequired = true;

				if (bRequireAll) continue;
				else break;
			}
			else
			{
				if (bRequireAll)
				{
					bHasRequired = false;
					break;
				}
				else continue;
			}
		}
		if (!bHasRequired)
		{
			return 'AA_MissingRequiredEffect';
		}
	}


	// Check that the Source has NO Excluding Effects 
	if (ExcludingEffectNames.Length > 0)
	{
		for (i=0; (i < ExcludingEffectNames.Length); ++i)
		{
			EffectName = ExcludingEffectNames[i];
			if (SourceUnit.AffectedByEffectNames.Find(EffectName) != -1)
			{
				return 'AA_HasAnExcludingEffect';
			}
		}
	}

	return 'AA_Success';
}


defaultproperties
{
	bRequireAll = true
}