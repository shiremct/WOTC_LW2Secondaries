class X2AbilityCharges_BonusCharges extends X2AbilityCharges;

//// Add bonus ability charges
//struct BonusAbilityCharge
//{
    //var int BonusCharges;
    //var name BonusAbility;
	//var name BonusItem;
//};
//
//var array<BonusAbilityCharge> BonusAbilityCharges;

var int BonusAbilityCharges;
var name BonusAbility;
var name BonusItem;


//function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
//{
    //local int					Charges;
	//local BonusAbilityCharge	BonusCharge
//
    //Charges = InitialCharges;
	//foreach BonusAbilityCharges(BonusCharge)
	//{
		//if (Unit.HasSoldierAbility(BonusCharge.BonusAbility, true) || Unit.HasItemOfTemplateType (BonusCharge.BonusItem))
		//{
			//Charges += BonusCharge.BonusCharges;
	//}	}
//
	//return Charges;
//}


function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

    Charges = InitialCharges;
    if (Unit.HasSoldierAbility(BonusAbility, true) || Unit.HasItemOfTemplateType (BonusItem))
    {
        Charges += BonusAbilityCharges;
    }
    return Charges;
}

defaultproperties
{
    InitialCharges=1
}