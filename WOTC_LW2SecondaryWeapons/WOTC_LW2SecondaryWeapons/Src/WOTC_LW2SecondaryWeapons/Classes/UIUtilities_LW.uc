//---------------------------------------------------------------------------------------
//  FILE:    UIUtilities_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Miscellanous UI helper routines
//--------------------------------------------------------------------------------------- 

class UIUtilities_LW extends Object;

var localized string m_sAverageScatterText;

static function vector2d GetMouseCoords()
{
	local PlayerController PC;
	local PlayerInput kInput;
	local vector2d vMouseCursorPos;

	foreach `XWORLDINFO.AllControllers(class'PlayerController',PC)
	{
		if ( PC.IsLocalPlayerController() )
		{
			break;
		}
	}
	kInput = PC.PlayerInput;

	XComTacticalInput(kInput).GetMouseCoordinates(vMouseCursorPos);
	return vMouseCursorPos;
}

static function string GetHTMLAverageScatterText(float value, optional int places = 2)
{
	local XGParamTag LocTag;
	local string ReturnString, FloatString, TempString;
	local int i;
	local float TempFloat, TestFloat;

	TempFloat = value;
	for (i=0; i< places; i++)
	{
		TempFloat *= 10.0;
	}
	TempFloat = Round(TempFloat);
	for (i=0; i< places; i++)
	{
		TempFloat /= 10.0;
	}

	TempString = string(TempFloat);
	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
	{
		FloatString = Left(TempString, i);
		TestFloat = float(FloatString);
		if (TempFloat ~= TestFloat)
		{
			break;
		}
	}

	if (Right(FloatString, 1) == ".")
	{
		FloatString $= "0";
	}

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = FloatString;
	ReturnString = `XEXPAND.ExpandString(default.m_sAverageScatterText);

	return class'UIUtilities_Text'.static.GetColoredText(ReturnString, eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}