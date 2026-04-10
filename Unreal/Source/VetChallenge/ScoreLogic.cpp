// Copyright Vet Challenge VR. All Rights Reserved.
// Migrated from: languages/ScoreLogic.cpp

#include "ScoreLogic.h"

AScoreLogic::AScoreLogic()
{
	PrimaryActorTick.bCanEverTick = false;
}

void AScoreLogic::BeginPlay()
{
	Super::BeginPlay();
}

int32 AScoreLogic::CalculatePoints(bool bPerfectHit, float TimeMultiplier)
{
	const int32 BasePoints = 100;
	if (bPerfectHit)
	{
		return FMath::RoundToInt(BasePoints * 1.5f * TimeMultiplier);
	}
	return BasePoints;
}

void AScoreLogic::AddScoreEntry(const FVetScore& Entry)
{
	Leaderboard.Add(Entry);

	// Sort leaderboard by TotalScore descending
	Leaderboard.Sort([](const FVetScore& A, const FVetScore& B) {
		return A.TotalScore > B.TotalScore;
	});
}
