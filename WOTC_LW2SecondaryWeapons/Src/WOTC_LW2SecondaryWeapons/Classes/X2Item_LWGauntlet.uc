//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWGauntlet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for Technical class Gauntlet weapon
//
//  ***** Modified to work outside LW2 *****
//---------------------------------------------------------------------------------------
class X2Item_LWGauntlet extends X2Item config(GameData_WeaponData);

// ***** UI Image definitions  *****
var config string Gauntlet_CV_UIImage;
var config string Gauntlet_MG_UIImage;
var config string Gauntlet_BM_UIImage;

// ***** Localized Strings  *****
var localized string PrimaryRangeLabel;
var localized string PrimaryRadiusLabel;
var localized string SecondaryRangeLabel;
var localized string SecondaryRadiusLabel;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Gauntlet_Primary_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Gauntlet_Primary_BEAM_BASEDAMAGE;

var config WeaponDamageValue Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Gauntlet_Secondary_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Gauntlet_Secondary_BEAM_BASEDAMAGE;

// ***** Built-in abilities assigned to the weapons *****
var config array<name> Gauntlet_CONVENTIONAL_INCLUDEDABILITIES;
var config array<name> Gauntlet_MAGNETIC_INCLUDEDABILITIES;
var config array<name> Gauntlet_BEAM_INCLUDEDABILITIES;

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_CONVENTIONAL_AIM;
var config int Gauntlet_Primary_CONVENTIONAL_RANGE;
var config int Gauntlet_Primary_CONVENTIONAL_RADIUS;
var config int Gauntlet_Primary_CONVENTIONAL_CRITCHANCE;
var config int Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
var config int Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
var config int Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int Gauntlet_Secondary_CONVENTIONAL_AIM;
var config int Gauntlet_Secondary_CONVENTIONAL_RANGE;
var config int Gauntlet_Secondary_CONVENTIONAL_RADIUS;
var config int Gauntlet_Secondary_CONVENTIONAL_CRITCHANCE;
var config int Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;
var config int Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_CONVENTIONAL_OPPOSEDSTATSTRENTH;

var config int Gauntlet_Primary_MAGNETIC_AIM;
var config int Gauntlet_Primary_MAGNETIC_RANGE;
var config int Gauntlet_Primary_MAGNETIC_RADIUS;
var config int Gauntlet_Primary_MAGNETIC_CRITCHANCE;
var config int Gauntlet_Primary_MAGNETIC_ICLIPSIZE;
var config int Gauntlet_Primary_MAGNETIC_ISOUNDRANGE;
var config int Gauntlet_Primary_MAGNETIC_IENVIRONMENTDAMAGE;

var config int Gauntlet_Secondary_MAGNETIC_AIM;
var config int Gauntlet_Secondary_MAGNETIC_RANGE;
var config int Gauntlet_Secondary_MAGNETIC_RADIUS;
var config int Gauntlet_Secondary_MAGNETIC_CRITCHANCE;
var config int Gauntlet_Secondary_MAGNETIC_ISOUNDRANGE;
var config int Gauntlet_Secondary_MAGNETIC_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_MAGNETIC_OPPOSEDSTATSTRENTH;

var config int Gauntlet_Primary_BEAM_AIM;
var config int Gauntlet_Primary_BEAM_RANGE;
var config int Gauntlet_Primary_BEAM_RADIUS;
var config int Gauntlet_Primary_BEAM_CRITCHANCE;
var config int Gauntlet_Primary_BEAM_ICLIPSIZE;
var config int Gauntlet_Primary_BEAM_ISOUNDRANGE;
var config int Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;

var config int Gauntlet_Secondary_BEAM_AIM;
var config int Gauntlet_Secondary_BEAM_RANGE;
var config int Gauntlet_Secondary_BEAM_RADIUS;
var config int Gauntlet_Secondary_BEAM_CRITCHANCE;
var config int Gauntlet_Secondary_BEAM_ISOUNDRANGE;
var config int Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_BEAM_OPPOSEDSTATSTRENTH;

// ***** Schematic/Item cost properties *****
var config int Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> Gauntlet_MAGNETIC_REQUIRED_TECHS;

var config int Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ALLOYCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ITEMCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> Gauntlet_BEAM_REQUIRED_TECHS;


// ***** Create Item Templates *****
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_Gauntlet_Conventional());
	Templates.AddItem(CreateTemplate_Gauntlet_Magnetic());
	Templates.AddItem(CreateTemplate_Gauntlet_Beam());

	// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bFiniteItems)
	{
		Templates.AddItem(CreateTemplate_Gauntlet_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_Gauntlet_Beam_Schematic());
	}

	return Templates;
}


// ***** Conventional Gauntlet Item Details *****
static function X2DataTemplate CreateTemplate_Gauntlet_Conventional()
{
	local X2MultiWeaponTemplate Template;
	local name AbilityName;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Gauntlet_CV_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;

	Template.Aim = default.Gauntlet_Primary_CONVENTIONAL_AIM;
	Template.iRange = default.Gauntlet_Primary_CONVENTIONAL_RANGE;
	Template.iRadius = default.Gauntlet_Primary_CONVENTIONAL_RADIUS;
	Template.CritChance = default.Gauntlet_Primary_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.iStatStrength=0;
	Template.DamageTypeTemplateName = 'Explosion';	
	Template.BaseDamage = default.Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;
	
	Template.AltAim = default.Gauntlet_Secondary_CONVENTIONAL_AIM;
	Template.iAltRange = default.Gauntlet_Secondary_CONVENTIONAL_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_CONVENTIONAL_RADIUS;
	Template.AltCritChance = default.Gauntlet_Secondary_CONVENTIONAL_CRITCHANCE;
	Template.iAltSoundRange = default.Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength = default.Gauntlet_Secondary_CONVENTIONAL_OPPOSEDSTATSTRENTH;
	Template.AltBaseDamage = default.Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;
	
	Template.NumUpgradeSlots = 1;
	Template.bMergeAmmo = true;
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_CONVENTIONAL_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_CONVENTIONAL_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RADIUS);

	Template.Abilities.AddItem('Gauntlet_LoadPerkPackages');
	foreach default.Gauntlet_CONVENTIONAL_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}

	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_CV";

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bFiniteItems)
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'LWGauntlet_MG_Schematic';
	}	}
	
	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}


// ***** Magnetic Gauntlet Item Details *****
static function X2DataTemplate CreateTemplate_Gauntlet_Magnetic()
{
	local X2MultiWeaponTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;
	local name					AbilityName;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_MG');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'magnetic';
	Template.strImage = default.Gauntlet_MG_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;

	Template.Aim = default.Gauntlet_Primary_MAGNETIC_AIM;
	Template.iRange = default.Gauntlet_Primary_MAGNETIC_RANGE;
	Template.iRadius = default.Gauntlet_Primary_MAGNETIC_RADIUS;
	Template.CritChance = default.Gauntlet_Primary_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.Gauntlet_Primary_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.Gauntlet_Primary_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iStatStrength=0;
	Template.DamageTypeTemplateName = 'Explosion';	
	Template.BaseDamage = default.Gauntlet_Primary_MAGNETIC_BASEDAMAGE;
	
	Template.AltAim = default.Gauntlet_Secondary_MAGNETIC_AIM;
	Template.iAltRange = default.Gauntlet_Secondary_MAGNETIC_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_MAGNETIC_RADIUS;
	Template.AltCritChance = default.Gauntlet_Secondary_MAGNETIC_CRITCHANCE;
	Template.iAltSoundRange = default.Gauntlet_Secondary_MAGNETIC_ISOUNDRANGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength = default.Gauntlet_Secondary_MAGNETIC_OPPOSEDSTATSTRENTH;
	Template.AltBaseDamage = default.Gauntlet_Secondary_MAGNETIC_BASEDAMAGE;
	
	Template.NumUpgradeSlots = 1;
	Template.bMergeAmmo = true;
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_MAGNETIC_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_MAGNETIC_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_MAGNETIC_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_MAGNETIC_RADIUS);

	Template.Abilities.AddItem('Gauntlet_LoadPerkPackages');
	foreach default.Gauntlet_MAGNETIC_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}	

	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_MG";

	Template.iPhysicsImpulse = 5;
	
	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bFiniteItems)
	{
		if (class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bHidePreviousTiers)
		{
			Template.HideIfPurchased = 'LWGauntlet_BM_Schematic';
	}	}

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'LWGauntlet_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'LWGauntlet_CV'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Gauntlet_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}


// ***** Beam Gauntlet Item Details *****
static function X2DataTemplate CreateTemplate_Gauntlet_Beam()
{
	local X2MultiWeaponTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;
	local name					TechRequirement;
	local name					AbilityName;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_BM');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'beam';
	Template.strImage = default.Gauntlet_BM_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	
	Template.Aim = default.Gauntlet_Primary_BEAM_AIM;
	Template.iRange = default.Gauntlet_Primary_BEAM_RANGE;
	Template.iRadius = default.Gauntlet_Primary_BEAM_RADIUS;
	Template.CritChance = default.Gauntlet_Primary_BEAM_CRITCHANCE;
	Template.iClipSize = default.Gauntlet_Primary_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.Gauntlet_Primary_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
	Template.iStatStrength=0;
	Template.DamageTypeTemplateName = 'Explosion';	
	Template.BaseDamage = default.Gauntlet_Primary_BEAM_BASEDAMAGE;
	
	Template.AltAim = default.Gauntlet_Secondary_BEAM_AIM;
	Template.iAltRange = default.Gauntlet_Secondary_BEAM_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_BEAM_RADIUS;
	Template.AltCritChance = default.Gauntlet_Secondary_BEAM_CRITCHANCE;
	Template.iAltSoundRange = default.Gauntlet_Secondary_BEAM_ISOUNDRANGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength = default.Gauntlet_Secondary_BEAM_OPPOSEDSTATSTRENTH;
	Template.AltBaseDamage = default.Gauntlet_Secondary_BEAM_BASEDAMAGE;
	
	Template.NumUpgradeSlots = 1;
	Template.bMergeAmmo = true;
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_BEAM_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_BEAM_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_BEAM_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_BEAM_RADIUS);

	Template.Abilities.AddItem('Gauntlet_LoadPerkPackages');
	foreach default.Gauntlet_BEAM_INCLUDEDABILITIES(AbilityName)
	{
		Template.Abilities.AddItem(AbilityName);
	}
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_BlasterLauncher_BM";

	Template.iPhysicsImpulse = 5;

	if (!class'X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons'.default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'LWGauntlet_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'LWGauntlet_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Gauntlet_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		if (default.Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'LWGauntlet_MG';
			ItemCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}


// ***** Magnetic Gauntlet Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Gauntlet_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'LWGauntlet_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Gauntlet_MG_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LWGauntlet_MG';
	Template.HideIfPurchased = 'LWGauntlet_BM';

	// Requirements
	foreach default.Gauntlet_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


// ***** Beam Gauntlet Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Gauntlet_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'LWGauntlet_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Gauntlet_BM_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LWGauntlet_BM';

	// Requirements
	foreach default.Gauntlet_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('LWGauntlet_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}