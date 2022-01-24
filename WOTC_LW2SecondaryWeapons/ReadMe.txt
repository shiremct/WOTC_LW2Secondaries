[h1]Long War 2 Secondaries for WOTC[/h1]

Brings Long War 2's new secondary weapons out for use with custom soldier classes in WOTC! Includes weapons, upgrade schematics, and all associated abilities as of LW2 version 1.5, as well as a few new ones.


[h1]Dependencies[/h1]

Requires the [url=http://steamcommunity.com/sharedfiles/filedetails/?id=1134256495] [b]WOTC Community Highlander[/b] [/url]:
[i][b]Why?:[/b] The Highlander adds support for adding new sockets to attach the weapons to the soldier. Without it, the weapon meshes will not show up (animations will play with no visible weapon).[/i]


[h1]Features[/h1]

More than just a straight port of assets and code, this version includes some enhancements and additional features not present in Long War 2:
[list]
[*] [b]3 Tiers for All Items[/b] - The Sawed-Off Shotgun and the Combat Knife only had one upgrade which came rather late and had roughly Tier 2.5 stats. The stats and tech requirements for the first upgrade have been reduced and a Tier 3 upgrade has been added for smoother progression. The Tier 3 models/textures were provided by Iridar and look great!

[*] [b]Added Ability Tags[/b] - Ability Tags have been setup so that the actual values from the config files will be pulled in for most localization text. The Localization text has been cleaned up and altered to support the Ability Tags. (I've only done this in English - If you would like to submit a translation, let me know in the Discussion section)

[*] [b]Support for Covert Infiltration/Finite Build systems[/b] - By default, the weapons are setup to function like base-game weapon upgrades that are infinite and use Upgrade Schematics; however, the config framework and a boolean toggle in the config files are there to switch to upgrading them as finite items like LW2. It will also automatically detect if Covert Infiltration/Prototype Armoury is installed and function as a CI Bridge. Cost configurations have been expanded to include more resource types that can be configured as desired and all resource costs will be ignored in the UI if set to 0. Additionally, conditions have been added to all of the abilities where it's appropriate to disable their display and effects when a valid weapon type is not equipped, allowing better support for multi-purpose classes that have access to multiple weapons. The list of valid weapon types for each set of abilities is expandable to support any additional weapon categories that the modding community may release in the future.

NOTE: The bFiniteItems variable should not be changed mid-campaign... things will likely break.

[*] [b]Some Small Bug-Fixes[/b] - I fixed a few issues and inconsistencies that I found while testing the abilities. If you find any more, let me know and I'll try to sort them out.
[/list]


[h1]How to Use[/h1]

This mod now adds basic support for the 4 base game classes to use these secondary weapons. Each class will have the choice between their normal secondary weapon, one long-range secondary (arcthrower for specialists, gauntlet for grenadiers, and holotargeter for rangers/sharpshooters) and one short range secondary (combat knife for rangers, sawed off shotguns for everyone else). The base classes will only have access to the base abilities - custom classes that are assigned the weapons and abilities will have to be used to get access to the more specialized abilities. If you want to try your hand at creating your own custom classes from existing assets, i recommend checking out [url=http://steamcommunity.com/sharedfiles/filedetails/?id=1128707437] [b]Richard's WOTC Create Your Own Class Template[/b] [/url].

NOTE: In order to make integration with the base game classes possible, all of the abilities used by their normal secondary weapons had to have weapon restrictions added. The abilities and the weapons they are restricted to can be edited in XComLW2SecondariesWOTC.ini - this should only be necessary if additional weapon types/categories are released in future mods that need to work with these abilities. IF this happens, let me know and I'll add them to the default list for everyone.

The names of the weapons and abilities are identical to what they were in Long War 2, but for those who may not be familier, below are the names to reference:

[table]
[tr]	-
	[th]Arc Thrower:[/th]
	[th]Combat Knife:[/th]
	[th]Holo-Targeter:[/th]
	[th]Sawed-Off Shotgun:[/th]
	[th]Gauntlet:[/th]
[/tr]
[tr]
	[th]Weapon Type:[/th]
	[td]"arcthrower"[/td]
	[td]"combatknife"[/td]
	[td]"holotargeter"[/td]
	[td]"sawedoffshotgun"[/td]
	[td]"lw_gauntlet"[/td]
[/tr]
[tr]
	[th]Abilities:[/th]
	[td]
	"ArcthrowerStun"
	"EMPulser"
	"Electroshock"
	"StunGunner"
	"ChainLightning"
	[/td]
	[td]
	"KnifeFighter"
	"Combatives"
	[/td]
	[td]
	"Holotarget"
	"Rapidtargeting"
	"Multitargeting"
	"HDHolo"
	"IndependentTracking"
	"VitalPointTargeting"
	[/td]
	[td]
	"PointBlank"
	"BothBarrels"
	"PumpAction"
	"Spare Shells"
	[/td]
	[td]
	"HeavyArmaments"
	"LWRocketLauncher"
	"LWBlasterLauncher"
	"ConcussionRocket"
	"BunkerBuster"
	"ShockAndAwe"
	"FireInTheHole"
	"JavelinRockets"
	"LWFlamethrower"
	"Roust"
	"Firestorm"
	"Quickburn"
	"Burnout"
	"FireAndSteel"
	"Incinerator"
	"Phosphorus"
	"NapalmX"
	"HighPressure"
	[/td]
[/tr]
[/table]
[list]
[*]By default, the Combat Knife abilities can also work with swords
[/list]


[h1]Thanks and Credits[/h1]

All credit for original visuals and original abilities goes to Pavonis Interactive and the LW2 team. See their mod page [url=http://steamcommunity.com/sharedfiles/filedetails/?id=844674609] [b]Here[/b] [/url] for detailed team credits. Huge thanks to [b]Iridar[/b] for contributing the amazing new Mag & Beam Sawed-off Shotgun models, and the Beam tier Combat Knife model; to [b]Favid[/b] for porting the toughest parts of the Gauntlet code that I had been putting off doing myself and letting me use it; to the X2CommunityHighlander team for extending what we can do with mods; and many thanks to Firaxis for a mod-friendly game.

Thanks to [b]Erazil[/b] & [b]zetmerguez[/b] for the French translation and [b]mogwai[/b] for the Chinese translation. All of the dynamic ability tags in the localization text make it a real challenge/chore to translate - they were kind enough to put in a lot of work to make that happen!


[h1]Known Issues[/h1]
[list]
[*] Gauntlet is attached to the wrong location on the serpent suit mesh (the cosmetic torso mesh, not the armor type). The fix for this (cosmetic only) issue from LW2 is not currently working. Using a different cosmetic torso will let you use the Serpent Suit without the visual issue.
[/list]