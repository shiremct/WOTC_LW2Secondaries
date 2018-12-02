//---------------------------------------------------------------------------------------
//  FILE:    X2MultiWeaponTemplate.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Template to allow defining alt versions of (limited) stats for joining two weapons together into a single pawn
//---------------------------------------------------------------------------------------
class X2MultiWeaponTemplate extends X2WeaponTemplate;

//  Combat related stuff
var int							AltAim;
var int							iAltRange					<ToolTip = "-1 will mean within the unit's sight, 0 means melee">;
var int							iAltRadius					<ToolTip = "radius in METERS for AOE range">;
var int							AltCritChance;
var int							iAltSoundRange				<ToolTip="Range in Meters, for alerting enemies.  (Yellow alert)">;
var int							iAltEnvironmentDamage		<ToolTip = "damage to environmental effects; should be 50, 100, or 150.">;
var WeaponDamageValue			AltBaseDamage;       
var array<WeaponDamageValue>	AltExtraDamage;


// new stats, used for stat checks (e.g. panic on flamethrower)
var int							iStatStrength				<Tooltip="Stat strength for opposed checks of weapon">;
var int							iAltStatStrength			<Tooltip="Stat strength for opposed checks of alt weapon">;


//These aren't currently needed, so aren't configured
//var int             iAltTypicalActionCost					<ToolTip = "typical cost in action points to fire the weapon (only used by some abilities)">;
//var int             iAltClipSize							<ToolTip="ammo amount before a reload is required">;
//var bool            AltInfiniteAmmo						<ToolTip="no reloading required!">;
//var name            AltDamageTypeTemplateName				<ToolTip = "Template name for the type of ENVIRONMENT damage this weapon does">;
//var array<int>      AltRangeAccuracy						<ToolTip = "Array of accuracy modifiers, where index is tiles distant from target.">;



function AddAltExtraDamage(const int _Damage, const int _Spread, const int _PlusOne, const name _Tag)
{
	local WeaponDamageValue NewVal;
	NewVal.Damage = _Damage;
	NewVal.Spread = _Spread;
	NewVal.PlusOne = _PlusOne;
	NewVal.Tag = _Tag;
	AltExtraDamage.AddItem(NewVal);
}