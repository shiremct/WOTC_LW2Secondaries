//---------------------------------------------------------------------------------------
//  FILE:    X2Item_ArcthrowerWeapon.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for Arcthrower secondary weapon
//
//  ***** Modified to work outside LW2 *****
//---------------------------------------------------------------------------------------
class X2Item_ArcthrowerWeapon extends X2Item config(GameData_WeaponData);

//�*****�UI Image and item Archetype definitions��*****
var config string Arcthrower_CV_UIImage;
var config string Arcthrower_MG_UIImage;
var config string Arcthrower_BM_UIImage;

var config string Arcthrower_CV_GameArchetype;
var config string Arcthrower_MG_GameArchetype;
var config string Arcthrower_BM_GameArchetype;

//�*****�Damage�arrays�for�attack�actions��*****
var config WeaponDamageValue Arcthrower_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Arcthrower_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Arcthrower_BEAM_BASEDAMAGE;

//�*****�Built-in abilities assigned to the�weapons�*****
var config array<name> Arcthrower_CONVENTIONAL_INCLUDEDABILITIES;
var config array<name> Arcthrower_MAGNETIC_INCLUDEDABILITIES;
var config array<name> Arcthrower_BEAM_INCLUDEDABILITIES;

//�*****�Range Accuracy table variables�*****
var config bool Arcthrower_USE_DEFAULT_SHORT_RANGE_TABLE;
var config bool Arcthrower_USE_DEFAULT_MID_RANGE_TABLE;
var config array<int> Arcthrower_CUSTOM_RANGE_TABLE;

//�*****�Core properties and variables�for�weapons�*****
var config int Arcthrower_CONVENTIONAL_AIM;
var config int Arcthrower_CONVENTIONAL_CRITCHANCE;
var config int Arcthrower_CONVENTIONAL_ICLIPSIZE;
var config int Arcthrower_CONVENTIONAL_ISOUNDRANGE;
var config int Arcthrower_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int Arcthrower_MAGNETIC_AIM;
var config int Arcthrower_MAGNETIC_CRITCHANCE;
var config int Arcthrower_MAGNETIC_ICLIPSIZE;
var config int Arcthrower_MAGNETIC_ISOUNDRANGE;
var config int Arcthrower_MAGNETIC_IENVIRONMENTDAMAGE;

var config int Arcthrower_BEAM_AIM;
var config int Arcthrower_BEAM_CRITCHANCE;
var config int Arcthrower_BEAM_ICLIPSIZE;
var config int Arcthrower_BEAM_ISOUNDRANGE;
var config int Arcthrower_BEAM_IENVIRONMENTDAMAGE;

//�*****�Schematic/Item cost properties�*****
var config int Arcthrower_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int Arcthrower_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config int Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> Arcthrower_MAGNETIC_REQUIRED_TECHS;

var config int Arcthrower_BEAM_SCHEMATIC_SUPPLYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_ALLOYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_ELERIUMCOST;
var config int Arcthrower_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int Arcthrower_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
var config int Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;

var config int Arcthrower_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_ALLOYCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int Arcthrower_BEAM_INDIVIDUAL_ITEMCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
var config int Arcthrower_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;

var config array<name> Arcthrower_BEAM_REQUIRED_TECHS;


//�*****�Create Item Templates�*****
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_Arcthrower_Conventional());
	Templates.AddItem(CreateTemplate_Arcthrower_Magnetic());
	Templates.AddItem(CreateTemplate_Arcthrower_Beam());

	// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Templates.AddItem(CreateTemplate_Arcthrower_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_Arcthrower_Beam_Schematic());
	}	

	return Templates;
}


//�*****�Conventional Arcthrower Item Details�*****
static function X2DataTemplate CreateTemplate_Arcthrower_Conventional()
{
	local X2WeaponTemplate Template;
	local name AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_CV');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityArcthrowerStun");
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Arcthrower_CV_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	if (default.Arcthrower_USE_DEFAULT_SHORT_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	}
	else if (default.Arcthrower_USE_DEFAULT_MID_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	}
	else
	{
		Template.RangeAccuracy = default.Arcthrower_CUSTOM_RANGE_TABLE;
	}

	Template.BaseDamage = default.Arcthrower_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.Arcthrower_CONVENTIONAL_AIM;
	Template.CritChance = default.Arcthrower_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;

	foreach default.Arcthrower_CONVENTIONAL_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Arcthrower_CV_GameArchetype;

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'Arcthrower_MG_Schematic';
	}	}
	
	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}


//�*****�Magnetic Arcthrower Item Details�*****
static function X2DataTemplate CreateTemplate_Arcthrower_Magnetic()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_MG');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityArcthrowerStun");
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_MG_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	if (default.Arcthrower_USE_DEFAULT_SHORT_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	}
	else if (default.Arcthrower_USE_DEFAULT_MID_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	}
	else
	{
		Template.RangeAccuracy = default.Arcthrower_CUSTOM_RANGE_TABLE;
	}

	Template.BaseDamage = default.Arcthrower_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.Arcthrower_MAGNETIC_AIM;
	Template.CritChance = default.Arcthrower_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;

	foreach default.Arcthrower_MAGNETIC_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Arcthrower_MG_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Electrical';
	
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'Arcthrower_BM_Schematic';
		}

		Template.CreatorTemplateName = 'Arcthrower_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'Arcthrower_CV'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}	
	else
	{
		foreach default.Arcthrower_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetMagArcthrowerPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Arcthrower_MAGNETIC_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Arcthrower_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Arcthrower_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


//�*****�Beam Arcthrower Item Details�*****
static function X2DataTemplate CreateTemplate_Arcthrower_Beam()
{
	local X2WeaponTemplate	Template;
	local name				TechRequirement;
	local name				AbilityName;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_BM');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LWSecondariesWOTC.LW_AbilityArcthrowerStun");
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_BM_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;
		
	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	if (default.Arcthrower_USE_DEFAULT_SHORT_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
	}
	else if (default.Arcthrower_USE_DEFAULT_MID_RANGE_TABLE)
	{
		Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	}
	else
	{
		Template.RangeAccuracy = default.Arcthrower_CUSTOM_RANGE_TABLE;
	}

	Template.BaseDamage = default.Arcthrower_BEAM_BASEDAMAGE;
	Template.Aim = default.Arcthrower_BEAM_AIM;
	Template.CritChance = default.Arcthrower_BEAM_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;

	foreach default.Arcthrower_BEAM_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}

	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = default.Arcthrower_CV_GameArchetype;

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Electrical';

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.static.UseFiniteItems())
	{
		Template.CreatorTemplateName = 'Arcthrower_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'Arcthrower_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Arcthrower_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	return Template;
}

static function SetBeamArcthrowerPricing(X2WeaponTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'Arcthrower_MG';
			ItemCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Arcthrower_BEAM_INDIVIDUAL_LEGEND_TRADINGPOSTVALUE;
		}
	}
	else
	{
		if (default.Arcthrower_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'Arcthrower_MG';
			ItemCost.Quantity = default.Arcthrower_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Arcthrower_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Arcthrower_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}
	}
}


//�*****�Magnetic Arcthrower Upgrade Schematic�*****
static function X2DataTemplate CreateTemplate_Arcthrower_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Arcthrower_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_MG_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Arcthrower_MG';

	// Requirements
	foreach default.Arcthrower_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	return Template;
}

static function SetMagArcthrowerSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


//�*****�Beam Arcthrower Upgrade Schematic�*****
static function X2DataTemplate CreateTemplate_Arcthrower_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Arcthrower_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_BM_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Arcthrower_BM';

	// Requirements
	foreach default.Arcthrower_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('Arcthrower_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	return Template;
}

static function SetBeamArcthrowerSchematicPricing(X2SchematicTemplate Template, bool bLegend)
{
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;

	if (bLegend)
	{
		if (default.Arcthrower_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_LEGEND_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_LEGEND_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
	else
	{
		if (default.Arcthrower_BEAM_SCHEMATIC_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Arcthrower_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Arcthrower_BEAM_SCHEMATIC_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
	}
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}