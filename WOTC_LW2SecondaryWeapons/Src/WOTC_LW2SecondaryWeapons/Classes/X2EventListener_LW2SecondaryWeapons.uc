class X2EventListener_LW2SecondaryWeapons extends X2EventListener;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateOverrideHasHeavyWeaponListenerTemplate());
	Templates.AddItem(CreateOnItemRangeListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateOverrideHasHeavyWeaponListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GauntletOverrideHasHeavyWeapon');

	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideHasHeavyWeapon', OnGauntletOverrideHasHeavyWeapon, ELD_Immediate, 75);
	`LOG("Register Event OverrideHasHeavyWeapon: LW2 Secondaries - Gauntlet");

	return Template;
}


static function EventListenerReturn OnGauntletOverrideHasHeavyWeapon(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple						OverrideTuple;
	local XComGameState_Unit				UnitState;
	local XComGameState						CheckGameState;
	local bool								bOverrideHasHeavyWeapon;
	local bool								bHasHeavyWeapon;
	local XComGameState_Item				InventoryItem;
	local array<XComGameState_Item>			CurrentInventory;
	local X2WeaponTemplate					WeaponTemplate;
	local name								WeaponCategory;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local XGWeapon							HeavyWeapon;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
		return ELR_NoInterrupt;

	bOverrideHasHeavyWeapon = OverrideTuple.Data[0].b;
	bHasHeavyWeapon = OverrideTuple.Data[1].b;
	UnitState = XComGameState_Unit(EventSource);
	CheckGameState = XComGameState(OverrideTuple.Data[2].o);

	if (UnitState == none)
	{
		return ELR_NoInterrupt;
	}

	// Search the inventory for the heavy gauntlet
	CurrentInventory = UnitState.GetAllInventoryItems(, true);
	foreach CurrentInventory(InventoryItem)
	{
		WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
		if (WeaponTemplate == none)
			return ELR_NoInterrupt;

		WeaponCategory = WeaponTemplate.WeaponCat;
	
		if (WeaponCategory == 'lw_gauntlet')
		{
			bOverrideHasHeavyWeapon = true;
			bHasHeavyWeapon = false;

			OverrideTuple.Data[0].b = bOverrideHasHeavyWeapon;
			OverrideTuple.Data[1].b = bHasHeavyWeapon;

			// Remove the equipped heavy weapon, if applicable
			InventoryItem = UnitState.GetItemInSlot(eInvSlot_HeavyWeapon, CheckGameState);
			if (InventoryItem != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unequip Heavy Weapon From Unit Loadout");
				XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
				XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
				
				// Weapon must be graphically detached, otherwise destroying it leaves a NULL component attached at that socket
				HeavyWeapon = XGWeapon(InventoryItem.GetVisualizer());
				XComUnitPawn(UnitState.GetVisualizer()).DetachItem(HeavyWeapon.GetEntity().Mesh);
				HeavyWeapon.Destroy();

				// Add the dropped item back to the HQ
				if (UnitState.RemoveItemFromInventory(InventoryItem, NewGameState))
				{
					XComHQ.PutItemInInventory(NewGameState, InventoryItem);
				}

				UnitState.ValidateLoadout(NewGameState);
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}	
			return ELR_NoInterrupt;
		}
	}
	return ELR_NoInterrupt;
}


static function CHEventListenerTemplate CreateOnItemRangeListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'JavelinRocketsOverrideItemRange');

	Template.RegisterInTactical = true;

	Template.AddCHEvent('OnGetItemRange', OnJavelinRocketsOverrideItemRange, ELD_Immediate);
	`LOG("Register Event OnGetItemRange: LW2 Secondaries - Gauntlet");
	return Template;
}

static function EventListenerReturn OnJavelinRocketsOverrideItemRange(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	local XComGameState_Ability		Ability;
	local XComGameState_Item		SourceWeapon;
	local X2MultiWeaponTemplate		WeaponTemplate;
	local XComGameState_Unit		UnitState;
	
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
		return ELR_NoInterrupt;

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability

	if(Ability == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Item.OwnerStateObject.ObjectID));
	if(!UnitState.HasSoldierAbility('JavelinRockets'))
		return ELR_NoInterrupt;

	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2MultiWeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return ELR_NoInterrupt;

	if(class'X2Ability_GauntletAbilitySet'.default.JAVELIN_ROCKETS_VALID_ABILITIES.Find(Ability.GetMyTemplateName()) != -1)
	{
		OverrideTuple.Data[1].i += class'X2Ability_GauntletAbilitySet'.default.JAVELIN_ROCKETS_BONUS_RANGE_TILES;
		`LOG("Javelin Rockets Range Override: Adding" @ class'X2Ability_GauntletAbilitySet'.default.JAVELIN_ROCKETS_BONUS_RANGE_TILES @ "Tiles to Range.");
	}

	return ELR_NoInterrupt;
}