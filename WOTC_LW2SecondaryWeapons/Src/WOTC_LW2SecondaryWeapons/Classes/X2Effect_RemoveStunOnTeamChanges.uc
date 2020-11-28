
class X2Effect_RemoveStunOnTeamChanges extends X2Effect_Persistent;

// Register for the UnitChangedTeam Event Trigger
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager				EventManager;
	local Object						EffectObj;
	//local Object						TargetObj;
	//local XComGameState_Unit			SourceUnit, TargetUnit;

	//TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	//SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventManager = `XEVENTMGR;
	EffectObj = EffectGameState;
	//TargetObj = TargetUnit;

	EventManager.RegisterForEvent(EffectObj, 'UnitChangedTeam', RemoveStun, ELD_OnStateSubmitted,,,, EffectObj);
}

// Remove stun effect
static function EventListenerReturn RemoveStun(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Unit		TargetUnit, ExpectedTargetUnit;
	//local XComGameState_Unit		SourceUnit;
	local XComGameState_Effect		EffectState;
	local X2Effect_RemoveEffects	RemoveEffects;
	local EffectAppliedData			ApplyData;

	// Get the Expected TargetUnit
	EffectState = XComGameState_Effect(CallbackData);
	ExpectedTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// Get the Target Unit that actually triggered the event
	//SourceUnit = XComGameState_Unit(EventSource);
	TargetUnit = XComGameState_Unit(EventData);

	// Check that the TargetUnit is the Expected TargetUnit
	if (ExpectedTargetUnit.ObjectID != TargetUnit.ObjectID)
	{
		return ELR_NoInterrupt;
	}
	
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);

	ApplyData.EffectRef.LookupType = TELT_AbilityShooterEffects;
	ApplyData.EffectRef.TemplateEffectLookupArrayIndex = 0;
	ApplyData.PlayerStateObjectRef = TargetUnit.ControllingPlayer;
	ApplyData.SourceStateObjectRef = TargetUnit.GetReference();
	ApplyData.TargetStateObjectRef = TargetUnit.GetReference();
	RemoveEffects.ApplyEffect(ApplyData, TargetUnit, NewGameState);

	return ELR_NoInterrupt;
}