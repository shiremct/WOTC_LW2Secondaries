// Implements all Gauntlet abilities
class X2Ability_GauntletAbilitySet extends X2Ability
    dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills);
    
var config bool SUPPRESSION_PREVENTS_ABILITIES;
var config array<name> SUPPRESSION_EFFECTS;

var config int HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES;
var config int HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES;
var config int SHOCK_AND_AWE_BONUS_CHARGES;
var config int FIRE_AND_STEEL_DAMAGE_BONUS;
var config int JAVELIN_ROCKETS_BONUS_RANGE_TILES;
var config array<name> JAVELIN_ROCKETS_VALID_ABILITIES;

var config int CONCUSSION_ROCKET_RADIUS_TILES;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN;
var config WeaponDamageValue CONCUSSION_ROCKET_DAMAGE_VALUE;
var config int CONCUSSION_ROCKET_ENV_DAMAGE;

var config WeaponDamageValue BUNKER_BUSTER_DAMAGE_VALUE;
var config float BUNKER_BUSTER_RADIUS_METERS;
var config int BUNKER_BUSTER_ENV_DAMAGE;

var config int MOVEMENT_SCATTER_AIM_MODIFIER;
var config int MOVEMENT_SCATTER_TILE_MODIFIER;
var config int NUM_AIM_SCATTER_ROLLS;
var config array<name> SCATTER_REDUCTION_ABILITIES;
var config array<int> SCATTER_REDUCTION_MODIFIERS;
var config array<int> ROCKET_RANGE_PROFILE;


var config int FLAMETHROWER_BURNING_BASE_DAMAGE;
var config int FLAMETHROWER_BURNING_DAMAGE_SPREAD;
var config int FLAMETHROWER_DIRECT_APPLY_CHANCE;
var config int FLAMETHROWER_CHARGES;
var config int FLAMETHROWER_HIGH_PRESSURE_CHARGES;

var config float ROUST_RADIUS_MULTIPLIER;
var config float ROUST_RANGE_MULTIPLIER;
var config int ROUST_DIRECT_APPLY_CHANCE;
var config int ROUST_CHARGES;
var config float ROUST_DAMAGE_PENALTY;
var config int ROUST_HIGH_PRESSURE_CHARGES;

var config float INCINERATOR_RADIUS_MULTIPLIER;
var config float INCINERATOR_RANGE_MULTIPLIER;
var config int FIRESTORM_CHARGES;
var config int FIRESTORM_HIGH_PRESSURE_CHARGES;
var config int FIRESTORM_RADIUS_METERS;
var config float FIRESTORM_DAMAGE_BONUS;

var config float BURNOUT_RADIUS;

var config int NAPALMX_BASE_PERCENT_CHANCE;

var config int QUICKBURN_COOLDOWN;
var config int PHOSPHORUS_BONUS_SHRED;

var config array<name> VALID_WEAPON_CATEGORIES_FOR_SKILLS;
var config array<name> GAUNTLET_ABILITY_PERK_PACKAGES_TO_LOAD;


var localized string strMaxScatter;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	// Rocket Launcher Abilities
	Templates.AddItem(LoadPerkPackages_Gauntlet());
    Templates.AddItem(LWRocketLauncher());
    Templates.AddItem(LWBlasterLauncher());
	Templates.AddItem(ConcussionRocket());
    Templates.AddItem(BunkerBuster());

	Templates.AddItem(HeavyArmaments());
	Templates.AddItem(CreatePassive('JavelinRockets', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityJavelinRockets"));
    Templates.AddItem(CreatePassive('FireInTheHole', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityFireInTheHole",,true));
    Templates.AddItem(ShockAndAwe());

	// Flamethrower Abilities
    Templates.AddItem(LWFlamethrower());
	Templates.AddItem(Roust());
    /*»»»*/	Templates.AddItem(RoustDamage());
	Templates.AddItem(Firestorm());
    /*»»»*/	Templates.AddItem(FirestormDamage());
    /*»»»*/	Templates.AddItem(FirestormFireImmunity());

    Templates.AddItem(CreatePassive('Incinerator', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityHighPressure"));
	Templates.AddItem(CreatePassive('Phosphorus', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityPhosphorus"));
	Templates.AddItem(CreatePassive('NapalmX', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityNapalmX"));
    Templates.AddItem(Quickburn());
    Templates.AddItem(Burnout());
	/*»»»*/	Templates.AddItem(CreatePassive('BurnoutPassive', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityIgnition"));
	Templates.AddItem(CreatePassive('HighPressure', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityInferno"));
    Templates.AddItem(PhosphorusBonus());
    Templates.AddItem(FireAndSteel());

    return Templates;
}


static function X2AbilityTemplate LoadPerkPackages_Gauntlet()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LoadPerks				LoadPerksEffect;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Gauntlet_LoadPerkPackages');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = true;

	// Passive effect that loads the Gauntlet perk packages
	LoadPerksEffect = new class'X2Effect_LoadPerks';
	LoadPerksEffect.BuildPersistentEffect(1, true);
	LoadPerksEffect.AbilitiesToLoad = default.GAUNTLET_ABILITY_PERK_PACKAGES_TO_LOAD;
	Template.AddTargetEffect(LoadPerksEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	return Template;
}

// Helper function to setup basic framework for passive abilities
static function X2AbilityTemplate CreatePassive(name AbilityName, optional string IconString, optional name IconEffectName = AbilityName, optional bool bDisplayIcon = true)
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, AbilityName);
	Template.IconImage = IconString;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bUniqueSource = true;
	Template.bIsPassive = true;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, bDisplayIcon,, Template.AbilitySourceName);
	IconEffect.EffectName = IconEffectName;
	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}


//--------------------------------------------------------------------------------------------
//-----------------------  ROCKET ABILITIES --------------------------------------------------
//--------------------------------------------------------------------------------------------

// LWRocketLauncher - Basic rocketlauncher ability
static function X2AbilityTemplate LWRocketLauncher()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LWRocketLauncher');
    Template.Hostility = eHostility_Offensive;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    // Activated ability
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    // Uses weapon ammo instead of ability charges
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);
    Template.bUseAmmoAsChargesForHUD = true;

    // Ends turn unless the user has Salvo
    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Rocket_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss or crit
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Gets damage from the equipped Gauntlet
    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    // Target with mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    // Radius based on equipped Gauntlet
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    // Ignores the dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Controls rocket pathing and scatter
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    
    // Typical heavy weapon visualizations
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.ActivationSpeech = 'RocketLauncher';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

// LWBlasterLauncher - Upgraded rocketlauncher ability with blasterlauncher targeting (used by BEAM tier gauntlet by default)
static function X2AbilityTemplate LWBlasterLauncher()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LWBlasterLauncher');
    Template.Hostility = eHostility_Offensive;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_blasterlauncher";

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    // Activated ability
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    
    // Uses weapon ammo instead of ability charges
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);
    Template.bUseAmmoAsChargesForHUD = true;
    
    // Ends turn unless the user has Salvo
    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Rocket_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    // Cannot miss or crit
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;
    
    // Gets damage from the equipped Gauntlet
    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(WeaponDamageEffect);
    
    // Target with mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    
    // Radius based on equipped Gauntlet
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    // Ignores the dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    
    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);
    
    // Controls blaster bomb pathing and scatter
    Template.TargetingMethod = class'X2TargetingMethod_LWBlasterLauncher';
    
    // Typical heavy weapon visualizations
    Template.ActivationSpeech = 'BlasterLauncher';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}


// Concussion Rocket - Fire a special rocket that does limited damage but has a chance to stun or disorient organic enemies within its area of effect and leaves a cloud of smoke.
static function X2AbilityTemplate ConcussionRocket()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCharges                  Charges;
    local X2AbilityCost_Charges             ChargeCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Effect_PersistentStatChange     DisorientedEffect;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
    local X2Effect_Stunned                  StunnedEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitType              ImmuneUnitCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'ConcussionRocket');
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityConcussionRocket";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Rocket_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = 1;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeOrganic = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.RequireWithinRange = true;
    Template.AbilityTargetConditions.AddItem (UnitPropertyCondition);
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    ImmuneUnitCondition = new class'X2Condition_UnitType';
    ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
    ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM2');
    ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM3');
    Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);
    Template.AbilityMultiTargetConditions.AddItem(ImmuneUnitCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.fTargetRadius = default.CONCUSSION_ROCKET_RADIUS_TILES * 1.5; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bIgnoreBaseDamage = true;
    WeaponDamageEffect.EffectDamageValue=default.CONCUSSION_ROCKET_DAMAGE_VALUE;
    WeaponDamageEffect.bExplosiveDamage = true;
    WeaponDamageEffect.EnvironmentalDamageAmount=default.CONCUSSION_ROCKET_ENV_DAMAGE;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2,100,false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    StunnedEffect.ApplyChanceFn = ApplyChance_Concussion_Stunned;
    Template.AddMultiTargetEffect(StunnedEffect);

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.ApplyChanceFn = ApplyChance_Concussion_Disoriented;
    Template.AddMultiTargetEffect(DisorientedEffect);

    WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
    Template.AddMultiTargetEffect (WeaponEffect);

    Template.AddMultiTargetEffect (class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

    Template.ActivationSpeech = 'Explosion';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

static function name ApplyChance_Concussion_Stunned (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit UnitState;
    local int RandRoll;

    UnitState = XComGameState_Unit(kNewTargetState);
    RandRoll = `SYNC_RAND_STATIC(100);
    if (UnitState != none)
    {
        if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN)
        {
            return 'AA_Success';
        }
    }
    return 'AA_EffectChanceFailed';
}

static function name ApplyChance_Concussion_Disoriented (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit UnitState;
    local int RandRoll;

    UnitState = XComGameState_Unit(kNewTargetState);
    RandRoll = `SYNC_RAND_STATIC(100);

    if (UnitState != none)
    {
        if (!UnitState.IsStunned())
        {
            if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT)
            {
            return 'AA_Success';
            }
        }
    }
    return 'AA_EffectChanceFailed';
}


// Bunker Buster - Fire a high-radius rocket with excellent environmental damage. Requires two actions to fire.
static function X2AbilityTemplate BunkerBuster()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCharges                  Charges;
    local X2AbilityCost_Charges             ChargeCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'BunkerBuster');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_heavy_rockets";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 2;
    ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Rocket_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = 1;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.fTargetRadius = default.BUNKER_BUSTER_RADIUS_METERS; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bIgnoreBaseDamage = true;
    WeaponDamageEffect.EffectDamageValue=default.BUNKER_BUSTER_DAMAGE_VALUE;
    WeaponDamageEffect.bExplosiveDamage = true;
    WeaponDamageEffect.EnvironmentalDamageAmount=default.BUNKER_BUSTER_ENV_DAMAGE;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    Template.ActivationSpeech = 'Explosion';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

    return Template;
}


// HeavyArmaments - Passive ability to attach icon to the unit in tactical and grant bonus charges when equipping a heavy weapon slot armor
static function X2AbilityTemplate HeavyArmaments()
{
	
	local X2AbilityTemplate							Template;
	local X2Condition_SourceHasHeavyWeaponSlot		HeavyWeaponCondition;
	local X2Effect_BonusRocketCharges				RocketChargesEffect;
	local X2Effect_ModifyAbilityCharges				FlamerChargesEffect;
	
	Template = CreatePassive('HeavyArmaments', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityHeavyArmaments");
	Template.bDisplayInUITacticalText = false;

	// Effects granting bonus standard rocket/flamethrower charges when equipped with a heavy weapon slot armor/ability
	HeavyWeaponCondition = new class'X2Condition_SourceHasHeavyWeaponSlot';

    RocketChargesEffect = new class'X2Effect_BonusRocketCharges';
    RocketChargesEffect.BonusUses = default.HEAVY_ARMAMENTS_BONUS_ROCKET_CHARGES;
    RocketChargesEffect.SlotType = eInvSlot_SecondaryWeapon;
    RocketChargesEffect.BuildPersistentEffect(1, true, false);
	RocketChargesEffect.TargetConditions.AddItem(HeavyWeaponCondition);
	Template.AddTargetEffect(RocketChargesEffect);

	FlamerChargesEffect = new class 'X2Effect_ModifyAbilityCharges';
	FlamerChargesEffect.AbilitiesToModify.AddItem('LWFlamethrower');
	FlamerChargesEffect.iChargeModifier = default.HEAVY_ARMAMENTS_BONUS_FLAMER_CHARGES;
	FlamerChargesEffect.BuildPersistentEffect (1, true, false, false);
	FlamerChargesEffect.TargetConditions.AddItem(HeavyWeaponCondition);
	Template.AddTargetEffect(FlamerChargesEffect);

	return Template;
}


// Shock and Awe - Passive effect granting one additional standard rocket
static function X2AbilityTemplate ShockAndAwe()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_BonusRocketCharges		RocketChargesEffect;
	
	Template = CreatePassive('ShockAndAwe', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityShockAndAwe");
	Template.bDisplayInUITacticalText = false;

	// Effect granting a bonus rocket
    RocketChargesEffect = new class 'X2Effect_BonusRocketCharges';
    RocketChargesEffect.BonusUses = default.SHOCK_AND_AWE_BONUS_CHARGES;
    RocketChargesEffect.SlotType = eInvSlot_SecondaryWeapon;
    RocketChargesEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect (RocketChargesEffect);

	return Template;
}


//--------------------------------------------------------------------------------------------
//-----------------------  ROCKET SCATTER UTILITY  -------------------------------------------
//--------------------------------------------------------------------------------------------

static function vector GetScatterAmount(XComGameState_Unit Unit, vector ScatteredTargetLoc)
{
    local vector ScatterVector, ReturnPosition;
    local float EffectiveOffense;
    local int Idx, NumAimRolls, TileDistance, TileScatter;
    local float AngleRadians;
    local XComWorldData WorldData;

    //`LWTRACE("GetScatterAmount: Starting Calculation");

    WorldData = `XWORLD;

    NumAimRolls = GetNumAimRolls(Unit);
    TileDistance = TileDistanceBetween(Unit, ScatteredTargetLoc);
    NumAimRolls = Min(NumAimRolls, TileDistance);   //clamp the scatter for short range

    EffectiveOffense = GetEffectiveOffense(Unit, TileDistance);

    //`LWTRACE("GetScatterAmount: (Distance) Offense=" $ EffectiveOffense $ ", Rolls=" $ NumAimRolls $ ", Tiles=" $ TileDistance);

    for(Idx=0 ; Idx < NumAimRolls  ; Idx++)
    {
        if(`SYNC_RAND_STATIC(100) >= EffectiveOffense)
            TileScatter += 1;
    }

    //`LWTRACE("GetScatterAmount: (Select) TileScatter=" $ TileScatter);

    //pick a random direction in radians
    AngleRadians = `SYNC_FRAND_STATIC() * 2.0 * 3.141592653589793;
    ScatterVector.x = Cos(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ScatterVector.y = Sin(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ReturnPosition = ScatteredTargetLoc + ScatterVector;

    //`LWTRACE("GetScatterAmount: (FracResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

    ReturnPosition = WorldData.FindClosestValidLocation(ReturnPosition, true, true);

    //`LWTRACE("GetScatterAmount: (ValidResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

    return ReturnPosition;
}

static function float GetExpectedScatter(XComGameState_Unit Unit, vector TargetLoc)
{
    local float ExpectedScatter;
    local int TileDistance;

    TileDistance = TileDistanceBetween(Unit, TargetLoc);
    ExpectedScatter = (100.0 - GetEffectiveOffense(Unit, TileDistance))/100.0 * float(GetNumAimRolls(Unit));

    return ExpectedScatter;
}

static function float GetEffectiveOffense(XComGameState_Unit Unit, int TileDistance)
{
    local float EffectiveOffense;

    EffectiveOffense = Unit.GetCurrentStat(eStat_Offense);
    if(Unit.ActionPoints.Length <= 1)
        EffectiveOffense += default.MOVEMENT_SCATTER_AIM_MODIFIER;

    //adjust effective aim for distance
    if(default.ROCKET_RANGE_PROFILE.Length > 0)
    {
        if(TileDistance < default.ROCKET_RANGE_PROFILE.Length)
            EffectiveOffense += default.ROCKET_RANGE_PROFILE[TileDistance];
        else  //  if this tile is not configured, use the last configured tile
            EffectiveOffense += default.ROCKET_RANGE_PROFILE[default.ROCKET_RANGE_PROFILE.Length-1];
    }
    return EffectiveOffense;
}

static function int GetNumAimRolls(XComGameState_Unit Unit)
{
    local int NumAimRolls;
    local name AbilityName;
    local int Idx;

    //set up baseline value
    NumAimRolls = default.NUM_AIM_SCATTER_ROLLS;

    foreach default.SCATTER_REDUCTION_ABILITIES(AbilityName, Idx)
    {
        if(Unit.FindAbility(AbilityName).ObjectID > 0)
            NumAimRolls += default.SCATTER_REDUCTION_MODIFIERS[Idx];
    }

    if(Unit.ActionPoints.Length <= 1)
        NumAimRolls += default.MOVEMENT_SCATTER_TILE_MODIFIER;

    return NumAimRolls;
}

static function int TileDistanceBetween(XComGameState_Unit Unit, vector TargetLoc)
{
    local XComWorldData WorldData;
    local vector UnitLoc;
    local float Dist;
    local int Tiles;

    WorldData = `XWORLD;
    UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
    Dist = VSize(UnitLoc - TargetLoc);
    Tiles = Dist / WorldData.WORLD_StepSize;
    return Tiles;
}


//--------------------------------------------------------------------------------------------
//-----------------------  FLAMETHROWER ABILITIES --------------------------------------------
//--------------------------------------------------------------------------------------------


// Flamethrower
static function X2AbilityTemplate LWFlamethrower()
{
    local X2AbilityTemplate								Template;
    local X2AbilityCost_ActionPoints					ActionPointCost;
    local X2AbilityTarget_Cursor						CursorTarget;
    local X2AbilityMultiTarget_Cone_LWFlamethrower		ConeMultiTarget;
    local X2Condition_UnitProperty						UnitPropertyCondition;
    local X2AbilityTrigger_PlayerInput					InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited				FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim				StandardAim;
    local X2Effect_Burning								BurningEffect;
    local X2AbilityCharges_BonusCharges					Charges;
    local X2AbilityCost_Charges							ChargeCost;
	local X2Condition_ValidWeaponType					WeaponCondition;
	local X2Effect_Panicked								PanickedEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LWFlamethrower');

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);

    // Configurable charges, but if the user has the HighPressure ability or the HighPressureTanks item, they get bonus charges
    Charges = new class'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.FLAMETHROWER_CHARGES;
    Charges.BonusAbility = 'HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges =  default.FLAMETHROWER_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    // Each attack costs one charge
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    // Costs one action point and ends turn
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Flamer_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Player aims with the mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    // Flamethrower can wrap around cover.
	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

    // Allows different Gauntlet tiers to have a different cone length/radius, and some other stuff.
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER, default.INCINERATOR_RADIUS_MULTIPLIER);
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    // Can't use it while you're dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    // Panic effects need to come before the damage. This is needed for proper visualization ordering.
    // Effect on a successful flamethrower attack is triggering the Apply Panic Effect Ability
	PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanickedEffect.ApplyChanceFn = NapalmXApplyChance;
	PanickedEffect.bRemoveWhenSourceDies = false;
	Template.AddMultiTargetEffect(PanickedEffect);

    // Grants ability that checks if user can damage robots
    Template.AdditionalAbilities.AddItem('PhosphorusBonus');

    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.25f;
    FireToWorldEffect.FireChance_Level2 = 0.15f;
    FireToWorldEffect.FireChance_Level3 = 0.10f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    // Chance to burn targets
    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    // The damage caused to the targets. Special because it works off of secondary stats of the equipped Gauntlet
    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());

    // 
    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    // Flamthrower animations and stuff
    Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    // Trick to allow a different custom firing animation depending on which tier Gauntlet is equipped
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;

    // Interactions with the Chosen and Shadow
    // NOTE: Does NOT increase rate of Lost spawns
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    return Template;
}

// Function to handle the chance to apply panicked effects from NapalmX
function name NapalmXApplyChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit		SourceUnit, TargetUnit;
	local XComGameState_Item		SourceItemState;
	local X2MultiWeaponTemplate		MultiWeaponTemplate;
	local int						EffectStrength, EffectResistance;
	local float						fPanicChance, RandRoll;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none && SourceUnit != none)
	{
		// SourceUnit must have the NapalmX ability/effct
		if (SourceUnit.AppliedEffectNames.Find('NapalmX') == -1)
			return 'AA_MissingRequiredEffect';

		// Exclude Robotic enemies
		if (TargetUnit.GetMyTemplate().bIsRobotic)
			return 'AA_UnitIsImmune';

		// Exclude enemies that are immune to mental effects
		if (TargetUnit.GetMyTemplate().ImmuneTypes.Find('Mental') != -1)
			return 'AA_UnitIsImmune';
		
		// Determine the SourceItem's effect strength
		SourceItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
		MultiWeaponTemplate = X2MultiWeaponTemplate(SourceItemState.GetMyTemplate());
		if(MultiWeaponTemplate != none)
		{
			EffectStrength = MultiWeaponTemplate.iAltStatStrength;
		}
		else
		{
			EffectStrength =  50;
		}

		// Determine the TargetUnit's vulnerability to the effect
		EffectResistance = TargetUnit.GetCurrentStat(eStat_Will);

		// Roll for effect application
		fPanicChance = default.NAPALMX_BASE_PERCENT_CHANCE + EffectStrength - EffectResistance;
		RandRoll = `SYNC_RAND(100);

		if (RandRoll < fPanicChance)
			return 'AA_Success';

		return 'AA_EffectChanceFailed';
	}

	return 'AA_NotAUnit';
}

static function X2Effect_ApplyAltWeaponDamage CreateFlamethrowerDamageAbility()
{
    local X2Effect_ApplyAltWeaponDamage WeaponDamageEffect;
    local X2Condition_UnitProperty      Condition_UnitProperty;
    local X2Condition_Phosphorus        PhosphorusCondition;

    WeaponDamageEffect = new class'X2Effect_ApplyAltWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;

    PhosphorusCondition = new class'X2Condition_Phosphorus';
    WeaponDamageEffect.TargetConditions.AddItem(PhosphorusCondition);

    Condition_UnitProperty = new class'X2Condition_UnitProperty';
    Condition_UnitProperty.ExcludeFriendlyToSource = false;
    WeaponDamageEffect.TargetConditions.AddItem(Condition_UnitProperty);

    return WeaponDamageEffect;
}

// This ability is granted automatically by the Flamethrower
// It checks if the user of the Flamethrower ability has the Phosphorus ability, and if so, lets the Flamethrower damage robots
static function X2AbilityTemplate PhosphorusBonus()
{

	local X2AbilityTemplate					Template;
	local X2Effect_Phosphorus				PhosphorusEffect;
	
	Template = CreatePassive('PhosphorusBonus', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityPhosphorus",, false);
	Template.bDontDisplayInAbilitySummary = true;

	PhosphorusEffect = new class'X2Effect_Phosphorus';
    PhosphorusEffect.BuildPersistentEffect (1, true, false);
    PhosphorusEffect.bDisplayInUI = false;
    PhosphorusEffect.BonusShred = default.PHOSPHORUS_BONUS_SHRED;
    Template.AddTargetEffect(PhosphorusEffect);

	return Template;
}


// Roust: Special Flamethrower shot that does limited damage but forces enemies to change their position.
static function X2AbilityTemplate Roust()
{
    local X2AbilityTemplate								Template;
    local X2AbilityCost_ActionPoints					ActionPointCost;
    local X2AbilityTarget_Cursor						CursorTarget;
    local X2AbilityMultiTarget_Cone_LWFlamethrower		ConeMultiTarget;
    local X2Condition_UnitProperty						UnitPropertyCondition, ShooterCondition;
    local X2AbilityTrigger_PlayerInput					InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited				FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim				StandardAim;
    local X2Effect_Burning								BurningEffect;
    local X2AbilityCharges_BonusCharges					Charges;
    local X2AbilityCost_Charges							ChargeCost;
    local X2Effect_FallBack								FallBackEffect;
	local X2Condition_ValidWeaponType					WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Roust');

    Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityRoust";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY - 1;
    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);
    Template.bPreventsTargetTeleport = false;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    // Configurable charges, but if the user has the HighPressure ability or the HighPressureTanks item, they get bonus charges
    Charges = new class 'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.ROUST_CHARGES;
    Charges.BonusAbility = 'HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges =  default.ROUST_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    // Each attack costs one charge
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    // Costs one action point and ends turn
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Flamer_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();

    // Cannot be used while suppressed
    ShooterCondition=new class'X2Condition_UnitProperty';
    ShooterCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(ShooterCondition);
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Player aims with the mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    
    // Flamethrower can wrap around cover.
    Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';
    
    // Allows different Gauntlet tiers to have a different cone length/radius, and some other stuff.
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER, default.INCINERATOR_RADIUS_MULTIPLIER);
	ConeMultiTarget.AddConeSizeMultiplier(, default.ROUST_RANGE_MULTIPLIER, default.ROUST_RADIUS_MULTIPLIER);
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    // Can't use it while you're dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    
    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.20f;
    FireToWorldEffect.FireChance_Level2 = 0.00f;
    FireToWorldEffect.FireChance_Level3 = 0.00f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    // Chance to burn targets
    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.ROUST_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    // The damage caused to the targets. Special because it works off of secondary stats of the equipped Gauntlet
    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());

    // Effect that causes the targets to run away
    FallBackEffect = new class'X2Effect_FallBack';
    FallBackEffect.BehaviorTree = 'FlushRoot';
    Template.AddMultiTargetEffect(FallBackEffect);

    //
    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    // Flamthrower animations and stuff
    Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    // Trick to allow a different custom firing animation depending on which tier Gauntlet is equipped
    Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    // Interactions with the Chosen and Shadow
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    // This contains the damage reduction
    Template.AdditionalAbilities.AddItem('RoustDamage');

    return Template;
}

// Ability granted by Roust that reduces its damage
static function X2AbilityTemplate RoustDamage()
{

	local X2AbilityTemplate					Template;
	local X2Effect_RoustDamage                  DamagePenalty;
	
	Template = CreatePassive('RoustDamage', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityRoust",, false);
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;

	DamagePenalty = new class'X2Effect_RoustDamage';
    DamagePenalty.Roust_Damage_Modifier = default.ROUST_DAMAGE_PENALTY;
    DamagePenalty.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamagePenalty);

	return Template;
}

// Firestorm: Once per battle, attack all units in a complete circle around the soldier's position. Also grants immunity to fire damage.
static function X2AbilityTemplate Firestorm()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCharges_BonusCharges         Charges;
    local X2AbilityCost_Charges                 ChargeCost;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2AbilityTrigger_PlayerInput          InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited     FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2Effect_Burning                      BurningEffect;
	local X2Condition_ValidWeaponType			WeaponCondition;
	local X2Effect_Panicked						PanickedEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Firestorm');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityFirestorm";

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);

    Charges = new class 'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.FIRESTORM_CHARGES;
    Charges.BonusAbility = 'HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges = default.FIRESTORM_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWGauntlet_Flamer_DoNotConsumeAllActionsEffect');
    Template.AbilityCosts.AddItem(ActionPointCost);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

	//Panic effects need to come before the damage. This is needed for proper visualization ordering.
    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanickedEffect.ApplyChanceFn = NapalmXApplyChance;
	PanickedEffect.bRemoveWhenSourceDies = false;
	Template.AddMultiTargetEffect(PanickedEffect);
    
    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.10f;
    FireToWorldEffect.FireChance_Level2 = 0.25f;
    FireToWorldEffect.FireChance_Level3 = 0.60f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());
    Template.AddMultiTargetEffect(FireToWorldEffect);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = false;
    CursorTarget.FixedAbilityRange = 1;
    Template.AbilityTargetStyle = CursorTarget;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = default.FIRESTORM_RADIUS_METERS;
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.AddAbilityBonusRadius('Incinerator', default.FIRESTORM_RADIUS_METERS * ((default.INCINERATOR_RANGE_MULTIPLIER - 1) * 0.5));
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    Template.AddShooterEffectExclusions();

    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    Template.ActionFireClass = class'X2Action_Fire_Firestorm';
    Template.TargetingMethod = class'X2TargetingMethod_Grenade';

    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.AdditionalAbilities.AddItem('FirestormFireImmunity');
    Template.AdditionalAbilities.AddItem('FirestormDamage');

    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.CustomFireAnim = 'FF_FireFlameThrower';

    // Interactions with the Chosen and Shadow
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    return Template;
}

// Granted by Firestorm 
// Handles the damage for the Firestorm ability
static function X2AbilityTemplate FirestormDamage()
{

	local X2AbilityTemplate					Template;
	local X2Effect_AbilityDamageMult		DamageBonus;
	
	Template = CreatePassive('FirestormDamage', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityFirestorm",, false);
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;

	DamageBonus = new class'X2Effect_AbilityDamageMult';
    DamageBonus.Penalty = false;
    DamageBonus.Mult = false;
    DamageBonus.DamageMod = default.FIRESTORM_DAMAGE_BONUS;
    DamageBonus.ActiveAbility = 'Firestorm';
    DamageBonus.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamageBonus);

	return Template;
}

// Granted by Firestorm 
// Provides immunity to fire
static function X2AbilityTemplate FirestormFireImmunity()
{

	local X2AbilityTemplate					Template;
	local X2Effect_DamageImmunity           DamageImmunity;
	
	Template = CreatePassive('FirestormFireImmunity', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityFirestorm");
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;

	DamageImmunity = new class'X2Effect_DamageImmunity';
    DamageImmunity.ImmuneTypes.AddItem('Fire');
    DamageImmunity.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(DamageImmunity);

	return Template;
}

// Quickburn: Activate so your next use of the flamethrower will not cost an action.
static function X2AbilityTemplate Quickburn()
{
    local X2AbilityTemplate					Template;
    local X2Effect_Quickburn				QuickburnEffect;
    local X2AbilityCooldown					Cooldown;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Quickburn');
    Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityQuickburn";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STASIS_LANCE_PRIORITY;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AddShooterEffectExclusions();
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.QUICKBURN_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

    Template.AbilityCosts.AddItem(default.FreeActionCost);

    QuickburnEffect = new class 'X2Effect_Quickburn';
    QuickburnEffect.BuildPersistentEffect (1, false, false, true, eGameRule_PlayerTurnEnd);
    QuickburnEFfect.EffectName = 'QuickburnEffect';
    QuickburnEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    Template.AddTargetEffect (QuickburnEffect);

    Template.bCrossClassEligible = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.bShowActivation = true;
    Template.bSkipFireAction = true;

    return Template;
}

// Burnout: Activating your Flamethrower leaves a small smoke cloud around your position, providing a defensive bonus.
static function X2AbilityTemplate Burnout()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Burnout');
    Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityIgnition";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = true;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.bDontDisplayInAbilitySummary = true;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Template.bSkipFireAction = true;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'FlamethrowerActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.bUseSourceWeaponLocation = false;
    RadiusMultiTarget.fTargetRadius = default.BURNOUT_RADIUS * 1.5; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
    Template.AddTargetEffect (WeaponEffect);

    Template.AddMultiTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	Template.AddShooterEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

    Template.AdditionalAbilities.AddItem('BurnoutPassive');
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

// Fire and Steel: Attacks with your gauntlet, and fires set by gauntlet weapons, do +1 damage.
static function X2AbilityTemplate FireAndSteel()
{

	local X2AbilityTemplate					Template;
	local X2Effect_BonusWeaponDamage        DamageEffect;
	
	Template = CreatePassive('FireAndSteel', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityFireandSteel");
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;

	DamageEffect = new class'X2Effect_BonusWeaponDamage';
    DamageEffect.BonusDmg = default.FIRE_AND_STEEL_DAMAGE_BONUS;
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamageEffect);

	return Template;
}


//--------------------------------------------------------------------------------------------
//----------------------- FLAMETHROWER UTILITY -----------------------------------------------
//--------------------------------------------------------------------------------------------


function LWFlamethrower_BuildVisualization(XComGameState VisualizeGameState)
{
    local X2AbilityTemplate                 AbilityTemplate;
    local AbilityInputContext               AbilityContext;
    local XComGameStateContext_Ability      Context;
    local X2WeaponTemplate                  WeaponTemplate;
    local XComGameState_Item                SourceWeapon;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityContext = Context.InputContext;
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);
    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
    if (SourceWeapon != None)
    {
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
    }
    AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower'; // default to something safe
    if(WeaponTemplate != none)
    {
        switch (WeaponTemplate.DataName)
        {
            case 'LWGauntlet_CG':
            case 'LWGauntlet_BM':
                AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower_Lv2'; // use the fancy animation
                break;
            default:
                break;
        }
    }

    //Continue building the visualization as normal.
    TypicalAbility_BuildVisualization(VisualizeGameState);
}

// Helper function for adding Suppression restrictions to abilities
static function HandleSuppressionRestriction(X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;
    local name SuppressionEffect;

    if(default.SUPPRESSION_PREVENTS_ABILITIES)
	{   
        SuppressedCondition = new class'X2Condition_UnitEffects';

        foreach default.SUPPRESSION_EFFECTS(SuppressionEffect)
	    {
		    SuppressedCondition.AddExcludeEffect(SuppressionEffect, 'AA_UnitIsSuppressed');
	    }

		Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	}
}