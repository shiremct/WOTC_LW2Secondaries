//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWSawedOffShotgun.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for SawedOffShotgun Ranger secondary weapon
//
//  ***** Modified to work outside LW2 *****
//---------------------------------------------------------------------------------------
class X2Item_LWSawedOffShotgun extends X2Item config(GameData_WeaponData);

// ***** UI Image and item Archetype definitions  *****
var config string SawedOffShotgun_CV_UIImage;
var config string SawedOffShotgun_MG_UIImage;
var config string SawedOffShotgun_BM_UIImage;

var config string SawedOffShotgun_CV_GameArchetype;
var config string SawedOffShotgun_MG_GameArchetype;
var config string SawedOffShotgun_BM_GameArchetype;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue SawedOffShotgun_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue SawedOffShotgun_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue SawedOffShotgun_BEAM_BASEDAMAGE;

// ***** Built-in abilities assigned to the weapons *****
var config array<name> SawedOffShotgun_CONVENTIONAL_INCLUDEDABILITIES;
var config array<name> SawedOffShotgun_MAGNETIC_INCLUDEDABILITIES;
var config array<name> SawedOffShotgun_BEAM_INCLUDEDABILITIES;

// ***** Core properties and variables for weapons *****
var config int SawedOffShotgun_CONVENTIONAL_AIM;
var config int SawedOffShotgun_CONVENTIONAL_RADIUS;  // used only for multitargeting ability
var config int SawedOffShotgun_CONVENTIONAL_CRITCHANCE;
var config int SawedOffShotgun_CONVENTIONAL_ICLIPSIZE;
var config int SawedOffShotgun_CONVENTIONAL_ISOUNDRANGE;
var config int SawedOffShotgun_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int SawedOffShotgun_CONVENTIONAL_RANGE;

var config int SawedOffShotgun_MAGNETIC_AIM;
var config int SawedOffShotgun_MAGNETIC_RADIUS;  // used only for multitargeting ability
var config int SawedOffShotgun_MAGNETIC_CRITCHANCE;
var config int SawedOffShotgun_MAGNETIC_ICLIPSIZE;
var config int SawedOffShotgun_MAGNETIC_ISOUNDRANGE;
var config int SawedOffShotgun_MAGNETIC_IENVIRONMENTDAMAGE;
var config int SawedOffShotgun_MAGNETIC_RANGE;

var config int SawedOffShotgun_BEAM_AIM;
var config int SawedOffShotgun_BEAM_RADIUS;  // used only for multitargeting ability
var config int SawedOffShotgun_BEAM_CRITCHANCE;
var config int SawedOffShotgun_BEAM_ICLIPSIZE;
var config int SawedOffShotgun_BEAM_ISOUNDRANGE;
var config int SawedOffShotgun_BEAM_IENVIRONMENTDAMAGE;
var config int SawedOffShotgun_BEAM_RANGE;

var config array<int> SAWED_OFF_RANGE;

// ***** Schematic/Item cost properties *****
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> SawedOffShotgun_MAGNETIC_REQUIRED_TECHS;

var config int SawedOffShotgun_BEAM_SCHEMATIC_SUPPLYCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_ALLOYCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int SawedOffShotgun_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_ALLOYCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_ITEMCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
var config int SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> SawedOffShotgun_BEAM_REQUIRED_TECHS;


// ***** Create Item Templates *****
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_SawedOffShotgun_Conventional());
	Templates.AddItem(CreateTemplate_SawedOffShotgun_Magnetic());
	Templates.AddItem(CreateTemplate_SawedOffShotgun_Beam());

	// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Templates.AddItem(CreateTemplate_SawedOffShotgun_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_SawedOffShotgun_Beam_Schematic());
	}

	return Templates;
}


// ***** Conventional SawedOffShotgun Item Details *****
static function X2DataTemplate CreateTemplate_SawedOffShotgun_Conventional()
{
	local X2WeaponTemplate Template;
	local name AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SawedOffShotgun_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'SawedOffShotgun';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.SawedOffShotgun_CV_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.RangeAccuracy = default.SAWED_OFF_RANGE;
	Template.BaseDamage = default.SawedOffShotgun_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.SawedOffShotgun_CONVENTIONAL_AIM;
	Template.CritChance = default.SawedOffShotgun_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.SawedOffShotgun_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.SawedOffShotgun_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SawedOffShotgun_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.iRange = default.SawedOffShotgun_CONVENTIONAL_RANGE;
	Template.NumUpgradeSlots = 1;

	foreach default.SawedOffShotgun_CONVENTIONAL_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.SawedOffShotgun_CV_GameArchetype;

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'SawedOffShotgun_MG_Schematic';
	}	}
	
	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}


// ***** Magnetic SawedOffShotgun Item Details *****
static function X2DataTemplate CreateTemplate_SawedOffShotgun_Magnetic()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SawedOffShotgun_MG');

	Template.WeaponCat = 'SawedOffShotgun';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.SawedOffShotgun_MG_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.RangeAccuracy = default.SAWED_OFF_RANGE;
	Template.BaseDamage = default.SawedOffShotgun_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.SawedOffShotgun_MAGNETIC_AIM;
	Template.iRadius = default.SawedOffShotgun_MAGNETIC_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.SawedOffShotgun_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.SawedOffShotgun_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.SawedOffShotgun_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SawedOffShotgun_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iRange = default.SawedOffShotgun_MAGNETIC_RANGE;
	Template.NumUpgradeSlots = 1;

	foreach default.SawedOffShotgun_MAGNETIC_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
		
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.SawedOffShotgun_MG_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Projectile_MagXCom';
	
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'SawedOffShotgun_BM_Schematic';
		}

		Template.CreatorTemplateName = 'SawedOffShotgun_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'SawedOffShotgun_CV'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.SawedOffShotgun_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetMagSawedOffShotgunPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost;

	if (bLegend)
	{
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.SawedOffShotgun_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


// ***** Beam SawedOffShotgun Item Details *****
static function X2DataTemplate CreateTemplate_SawedOffShotgun_Beam()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SawedOffShotgun_BM');

	Template.WeaponCat = 'SawedOffShotgun';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.SawedOffShotgun_BM_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.RangeAccuracy = default.SAWED_OFF_RANGE;
	Template.BaseDamage = default.SawedOffShotgun_BEAM_BASEDAMAGE;
	Template.Aim = default.SawedOffShotgun_BEAM_AIM;
	Template.iRadius = default.SawedOffShotgun_BEAM_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.SawedOffShotgun_BEAM_CRITCHANCE;
	Template.iClipSize = default.SawedOffShotgun_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.SawedOffShotgun_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SawedOffShotgun_BEAM_IENVIRONMENTDAMAGE;
	Template.iRange = default.SawedOffShotgun_BEAM_RANGE;
	Template.NumUpgradeSlots = 1;

	foreach default.SawedOffShotgun_BEAM_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
		
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.SawedOffShotgun_BM_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Template.CreatorTemplateName = 'SawedOffShotgun_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'SawedOffShotgun_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.SawedOffShotgun_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetBeamSawedOffShotgunPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'SawedOffShotgun_MG';
			ItemCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.SawedOffShotgun_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'SawedOffShotgun_MG';
			ItemCost.Quantity = default.SawedOffShotgun_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.SawedOffShotgun_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.SawedOffShotgun_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


// ***** Magnetic SawedOffShotgun Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_SawedOffShotgun_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SawedOffShotgun_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.SawedOffShotgun_MG_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SawedOffShotgun_MG';

	// Requirements
	foreach default.SawedOffShotgun_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	return Template;
}

static function SetMagSawedOffShotgunSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost;

	if (bLegend)
	{
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


// ***** Beam SawedOffShotgun Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_SawedOffShotgun_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SawedOffShotgun_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.SawedOffShotgun_BM_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SawedOffShotgun_BM';

	// Requirements
	foreach default.SawedOffShotgun_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('SawedOffShotgun_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	return Template;
}

static function SetBeamSawedOffShotgunSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost;

	if (bLegend)
	{
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.SawedOffShotgun_BEAM_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
