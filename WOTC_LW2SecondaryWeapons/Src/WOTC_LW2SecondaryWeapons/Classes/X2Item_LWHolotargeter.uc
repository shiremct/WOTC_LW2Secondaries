//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWHolotargeter.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for holotargeter Sharpshooter secondary weapon
//
//  ***** Modified to work outside LW2 *****
//---------------------------------------------------------------------------------------
class X2Item_LWHolotargeter extends X2Item config(GameData_WeaponData);

// ***** UI Image and item Archetype definitions  *****
var config string Holotargeter_CV_UIImage;
var config string Holotargeter_MG_UIImage;
var config string Holotargeter_BM_UIImage;

var config string Holotargeter_CV_GameArchetype;
var config string Holotargeter_MG_GameArchetype;
var config string Holotargeter_BM_GameArchetype;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Holotargeter_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Holotargeter_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Holotargeter_BEAM_BASEDAMAGE;

// ***** Built-in abilities assigned to the weapons *****
var config array<name> Holotargeter_CONVENTIONAL_INCLUDEDABILITIES;
var config array<name> Holotargeter_MAGNETIC_INCLUDEDABILITIES;
var config array<name> Holotargeter_BEAM_INCLUDEDABILITIES;

// ***** Core properties and variables for weapons *****
var config int Holotargeter_CONVENTIONAL_AIM;
var config int Holotargeter_CONVENTIONAL_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_CONVENTIONAL_CRITCHANCE;
var config int Holotargeter_CONVENTIONAL_ICLIPSIZE;
var config int Holotargeter_CONVENTIONAL_ISOUNDRANGE;
var config int Holotargeter_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int Holotargeter_MAGNETIC_AIM;
var config int Holotargeter_MAGNETIC_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_MAGNETIC_CRITCHANCE;
var config int Holotargeter_MAGNETIC_ICLIPSIZE;
var config int Holotargeter_MAGNETIC_ISOUNDRANGE;
var config int Holotargeter_MAGNETIC_IENVIRONMENTDAMAGE;

var config int Holotargeter_BEAM_AIM;
var config int Holotargeter_BEAM_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_BEAM_CRITCHANCE;
var config int Holotargeter_BEAM_ICLIPSIZE;
var config int Holotargeter_BEAM_ISOUNDRANGE;
var config int Holotargeter_BEAM_IENVIRONMENTDAMAGE;

// ***** Schematic/Item cost properties *****
var config int Holotargeter_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int Holotargeter_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config int Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> Holotargeter_MAGNETIC_REQUIRED_TECHS;

var config int Holotargeter_BEAM_SCHEMATIC_SUPPLYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_ALLOYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_ELERIUMCOST;
var config int Holotargeter_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int Holotargeter_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int Holotargeter_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_ALLOYCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int Holotargeter_BEAM_INDIVIDUAL_ITEMCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
var config int Holotargeter_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> Holotargeter_BEAM_REQUIRED_TECHS;


// ***** Create Item Templates *****
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_Holotargeter_Conventional());
	Templates.AddItem(CreateTemplate_Holotargeter_Magnetic());
	Templates.AddItem(CreateTemplate_Holotargeter_Beam());

	// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Templates.AddItem(CreateTemplate_Holotargeter_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_Holotargeter_Beam_Schematic());
	}

	return Templates;
}


// ***** Conventional Holotargeter Item Details *****
static function X2DataTemplate CreateTemplate_Holotargeter_Conventional()
{
	local X2WeaponTemplate Template;
	local name AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Holotargeter_CV_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 6;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.Holotargeter_CONVENTIONAL_AIM;
	Template.iRadius = default.Holotargeter_CONVENTIONAL_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	Template.bHideDamageStat = true;

	Template.Abilities.AddItem('Holotargeter_LoadPerkPackages');
	foreach default.Holotargeter_CONVENTIONAL_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}

	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Holotargeter_CV_GameArchetype;

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'Holotargeter_MG_Schematic';
	}	}
	
	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}


// ***** Magnetic Holotargeter Item Details *****
static function X2DataTemplate CreateTemplate_Holotargeter_Magnetic()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_MG');

	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_MG_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 7;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.Holotargeter_MAGNETIC_AIM;
	Template.iRadius = default.Holotargeter_MAGNETIC_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	Template.bHideDamageStat = true;

	Template.Abilities.AddItem('Holotargeter_LoadPerkPackages');
	foreach default.Holotargeter_MAGNETIC_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}	

	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Holotargeter_MG_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Electrical';
	
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'Holotargeter_BM_Schematic';
		}

		Template.CreatorTemplateName = 'Holotargeter_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'Holotargeter_CV'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Holotargeter_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetMagHolotargeterPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Holotargeter_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Holotargeter_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Holotargeter_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


// ***** Beam Holotargeter Item Details *****
static function X2DataTemplate CreateTemplate_Holotargeter_Beam()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_BM');

	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_BM_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 8;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_BEAM_BASEDAMAGE;
	Template.Aim = default.Holotargeter_BEAM_AIM;
	Template.iRadius = default.Holotargeter_BEAM_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_BEAM_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	Template.bHideDamageStat = true;

	Template.Abilities.AddItem('Holotargeter_LoadPerkPackages');
	foreach default.Holotargeter_BEAM_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Holotargeter_BM_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Electrical';

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Template.CreatorTemplateName = 'Holotargeter_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'Holotargeter_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Holotargeter_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetBeamHolotargeterPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'Holotargeter_MG';
			ItemCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Holotargeter_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.Holotargeter_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'Holotargeter_MG';
			ItemCost.Quantity = default.Holotargeter_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Holotargeter_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Holotargeter_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


// ***** Magnetic Holotargeter Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Holotargeter_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holotargeter_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_MG_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holotargeter_MG';

	// Requirements
	foreach default.Holotargeter_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	return Template;
}

static function SetMagHolotargeterSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


// ***** Beam Holotargeter Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Holotargeter_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holotargeter_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_BM_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holotargeter_BM';

	// Requirements
	foreach default.Holotargeter_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('Holotargeter_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	return Template;
}

static function SetBeamHolotargeterSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Holotargeter_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.Holotargeter_BEAM_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Holotargeter_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Holotargeter_BEAM_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}