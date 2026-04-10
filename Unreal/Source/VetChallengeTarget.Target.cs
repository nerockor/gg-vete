// Copyright Vet Challenge VR. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class VetChallengeTarget : TargetRules
{
	public VetChallengeTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;
		DefaultBuildSettings = BuildSettingsVersion.V4;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_3;
		ExtraModuleNames.Add("VetChallenge");
	}
}
