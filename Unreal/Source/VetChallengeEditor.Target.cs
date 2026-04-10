// Copyright Vet Challenge VR. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class VetChallengeEditorTarget : TargetRules
{
	public VetChallengeEditorTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V4;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_3;
		ExtraModuleNames.Add("VetChallenge");
	}
}
