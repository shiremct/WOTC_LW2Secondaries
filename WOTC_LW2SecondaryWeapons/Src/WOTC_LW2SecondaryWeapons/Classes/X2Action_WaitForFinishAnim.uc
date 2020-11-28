//-----------------------------------------------------------
//	Class:	X2Action_WaitForFinishAnim
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

//	Created by MrNice, this needs to be inserted into Viz Tree by Counter Attack Merge Viz in order for HL_CounterAttack animation to keep playing
//	past the point where it hits UnitHit (NotifyTarget). This is a vanilla bug that's not instantly noticeable just because Counterattack is only used during one specific muton animation.

class X2Action_WaitForFinishAnim extends X2Action;

var AnimNodeSequence PlayingSequence;

simulated state Executing
{
Begin:
	// UnitPawn.GetAnimTreeController().FullBodyDynamicNode.GetTerminalSequence(); // Needs FullBodyDynamicNode deprivated, so haven't tested this actually works

	PlayingSequence = X2Action_ApplyWeaponDamageToUnit(ParentActions[0]).PlayingSequence; // Yes, could of course be made "safer"!
	//`log(`showvar(PlayingSequence.AnimSeqName));

	FinishAnim(PlayingSequence);

	//while( PlayingSequence.bPlaying )
	//{
		//`log(`showvar(PlayingSequence.GetTimeLeft()));
		//Sleep(0);
	//}
	
	CompleteAction();
}
