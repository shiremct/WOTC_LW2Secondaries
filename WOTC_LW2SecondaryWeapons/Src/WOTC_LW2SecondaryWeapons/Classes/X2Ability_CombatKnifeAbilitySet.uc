// Implements all Combat Knife abilities
class X2Ability_CombatKnifeAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills);

var config int KNIFE_FIGHTER_TILE_RANGE;
var localized string CounterattackDodgeName;
var config int COUNTERATTACK_DODGE_AMOUNT;
var config int COMBATIVES_DODGE;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_SKILLS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddKnifeFighter());
	Templates.AddItem(AddCombatives());
	/*»»»*/	Templates.AddItem(AddCombativesAttack());
	/*»»»*/	Templates.AddItem(AddCombativesPreparationAbility());
	/*»»»*/	Templates.AddItem(AddCombativesCounterattackAbility());
	/*»»»*/	Templates.AddItem(CombativesStats());
	return Templates;
}

// Knife Fighter: Ability to stab adjacent enemies with the Combat Knife
static function X2AbilityTemplate AddKnifeFighter()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KnifeFighter');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityKnifeFighter";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
    //Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 96 * default.KNIFE_FIGHTER_TILE_RANGE;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

// Combatives: Ability that allows countering enemy melee attacks with the Combat Knife and grants a boost to Dodge
static function X2AbilityTemplate AddCombatives()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('Combatives', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityCombatives", false, 'eAbilitySource_Perk');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBATIVES_DODGE, true);
	Template.AdditionalAbilities.AddItem('CombativesAttack');
	Template.AdditionalAbilities.AddiTEm('CombativesPreparation');
	Template.AdditionalAbilities.AddItem('CombativesCounterattack');
	Template.AdditionalAbilities.AddItem('CombativesStats');
	return Template;
}

// Combatives - Stats: Associated ability that grants the dodge bonus and activates the counter-attack animation set for the Combat Knife
static function X2AbilityTemplate CombativesStats()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatEffect;
	local X2Effect_AdditionalAnimSets			AnimSetEffect;
	local X2Condition_ValidWeaponType			WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesStats');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_Ability_Combatives";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bUniqueSource = true;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.COMBATIVES_DODGE));
	StatEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(StatEffect);
	Template.bCrossClassEligible = false;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;

	AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
	AnimSetEffect.AddAnimSetWithPath("LWCombatKnifeWOTC.Anims.AS_CombatKnife_CounterAttack");
	AnimSetEffect.TargetConditions.AddItem(WeaponCondition);
	Template.AddTargetEffect(AnimSetEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBATIVES_DODGE);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Combatives - Attack: Associated ability that applys the counter-attack
static function X2AbilityTemplate AddCombativesAttack()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee	MeleeHitCalc;
	local X2Effect_ApplyWeaponDamage		PhysicalDamageEffect;
	local X2Effect_SetUnitValue				SetUnitValEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesAttack');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_Ability_Combatives";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;
	Template.bUniqueSource = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;

	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = MeleeHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Damage Effect
	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(PhysicalDamageEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = 0;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	SetUnitValEffect.bApplyOnHit = true;
	SetUnitValEffect.bApplyOnMiss = true;
	Template.AddShooterEffect(SetUnitValEffect);

	// Remove the dodge increase (happens with a counter attack, which is one time per turn)
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability'.default.CounterattackDodgeEffectName);
	RemoveEffects.bApplyOnHit = true;
	RemoveEffects.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = CounterAttack_MergeVisualization_MrNice;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.CinescriptCameraType = "Ranger_Reaper";

	return Template;
}

static function CounterAttack_MergeVisualization_MrNice(X2Action BuildTree, out X2Action VisualizationTree)
{
    local XComGameStateVisualizationMgr         VisMgr;
    local X2Action_MarkerTreeInsertBegin        MarkerStart;
    local X2Action_MarkerTreeInsertEnd          MarkerEnd;
    local X2Action_ApplyWeaponDamageToUnit      ApplyDamage;
    local XComGameStateContext_Ability          Context;
    local Array<X2Action>                       FoundActions;
    local X2Action                              FoundAction;
    local X2Action                              FireAction;
    local X2Action                              ExitCoverAction;
    local X2Action                              EnterCoverAction;
    local X2Action                              DeathAction;
    local X2Action_MarkerNamed                  FireReplace;
    local X2Action_MarkerNamed                  ExitReplace;
    local X2Action_MarkerNamed                  EnterReplace;   
    local X2Action                              Action;
    local VisualizationActionMetadata           Metadata;
    //local X2Action_MoveTurn                       MoveTurnAction;
    //local XComGameState_Unit                  CounteredUnit;
 
    VisMgr = `XCOMVISUALIZATIONMGR; 
 
    MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
    MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));
    Context = XComGameStateContext_Ability(MarkerStart.StateChangeContext);
 
    //  Make the Countering unit always face the Countered unit (this doesn't always happen automatically) -- not sure it actually works
    //CounteredUnit = XComGameState_Unit(MarkerStart.StateChangeContext.AssociatedState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
    //Metadata = MarkerStart.Metadata;
    //MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(Metadata, Context, false, MarkerStart));
    //MoveTurnAction.m_vFacePoint =  `XWORLD.GetPositionFromTileCoordinates(CounteredUnit.TileLocation);
    //MoveTurnAction.UpdateAimTarget = true;
 
    //Find the apply weapon damage relevant to this counterattack
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', FoundActions, , Context.InputContext.SourceObject.ObjectID);
    if (FoundActions.Length > 0)
    {   
        ApplyDamage = X2Action_ApplyWeaponDamageToUnit(FoundActions[0]);
 
        DeathAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_Death');
        if (DeathAction != none)
        {
            FoundActions.Length = 0;                        
            if (ApplyDamage.ParentActions[0].HasChildOfType(class'X2Action_EnterCover', FoundActions))
            {
                X2Action_EnterCover(FoundActions[0]).bSkipEnterCover = true;
            }
        }
 
        FireAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_Fire');
        if (FireAction != none)
        {
            FireReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            FireReplace.SetName("FireActionCounterAttackStub");
            VisMgr.ReplaceNode(FireReplace, FireAction);
        }
        
        ExitCoverAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover');
        if (ExitCoverAction != none)
        {
            ExitReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            ExitReplace.SetName("ExitActionCounterAttackStub");
            VisMgr.ReplaceNode(ExitReplace, ExitCoverAction);
        }
 
        EnterCoverAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_EnterCover');
        if (EnterCoverAction != none)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            EnterReplace.SetName("EnterActionCounterAttackStub");
            VisMgr.ReplaceNode(EnterReplace, EnterCoverAction);
        }
 
        //EnterCoverAction = VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover',, Context.InputContext.PrimaryTarget.ObjectID);
 
        //  Nuke all X2Action_ApplyWeaponDamageToTerrain in both trees. They happen when the attack doesn't reach its target (Counter-attacked aiblity will always cause this)
        //  While the Counterattack itself will cause this if it misses. These actions cause both participants to flinch, interrupting proper animatitions.
        VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', FoundActions, , Context.InputContext.PrimaryTarget.ObjectID);
        foreach FoundActions(FoundAction)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', FoundAction.StateChangeContext));
            EnterReplace.SetName("ApplyDamageTerrainStub");
            VisMgr.ReplaceNode(EnterReplace, FoundAction);
        }
 
        VisMgr.GetNodesOfType(BuildTree, class'X2Action_ApplyWeaponDamageToTerrain', FoundActions);
        foreach FoundActions(FoundAction)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', FoundAction.StateChangeContext));
            EnterReplace.SetName("ApplyDamageTerrainStub");
            VisMgr.ReplaceNode(EnterReplace, FoundAction);
        }
        
        VisMgr.InsertSubtree(MarkerStart, MarkerEnd, ApplyDamage);
        //VisMgr.ConnectAction(EnterCoverAction, VisualizationTree,, MarkerEnd);
 
        Metadata = ApplyDamage.Metadata;
        Action = class'X2Action_WaitForFinishAnim'.static.AddToVisualizationTree(MetaData, ApplyDamage.StateChangeContext, false, ApplyDamage);
        VisMgr.ConnectAction(MarkerEnd, VisualizationTree,, Action);
    }
}

// Combatives - Preparation: Associated ability that grants the dodge bonus used to gaurantee the first roll for counterattacking during the enemies turn
static function X2AbilityTemplate AddCombativesPreparationAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_ToHitModifier			DodgeEffect;
	local X2Effect_SetUnitValue				SetUnitValEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesPreparation');

	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// During the Enemy player's turn, the Unit gets a dodge increase
	DodgeEffect = new class'X2Effect_ToHitModifier';
	DodgeEffect.EffectName = class'X2Ability'.default.CounterattackDodgeEffectName;
	DodgeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	DodgeEffect.AddEffectHitModifier(eHit_Graze, default.COUNTERATTACK_DODGE_AMOUNT, default.CounterattackDodgeName, class'X2AbilityToHitCalc_StandardMelee', true, false, true, true, , false);
	DodgeEffect.bApplyAsTarget = true;
	Template.AddShooterEffect(DodgeEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(SetUnitValEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

// Combatives - Event Listener: Associated ability that sets up the melee counter-attack event listener
static function X2AbilityTemplate AddCombativesCounterattackAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Condition_ValidWeaponType		WeaponCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesCounterattack');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_Ability_Combatives";

	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.bUniqueSource = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.MeleeCounterattackListener;  // this probably has to change
	Template.AbilityTriggers.AddItem(EventListener);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Add dead eye to guarantee the explosion occurs
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.CinescriptCameraType = "Muton_Counterattack";  // might need to change this to ranger or stun lancer ...

	return Template;
}