// Copyright Vet Challenge VR. All Rights Reserved.
// Migrated from: languages/ScoreLogic.cpp

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "ScoreLogic.generated.h"

/**
 * Score calculation and ranking data for the Vet Challenge stand.
 * Handles point calculation with time multipliers and perfect-hit bonuses.
 */

USTRUCT(BlueprintType)
struct FVetScore
{
	GENERATED_BODY()

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Score")
	FString VetName;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Score")
	int32 DogsVaccinated = 0;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Score")
	float RemainingTime = 0.0f;

	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Score")
	int32 TotalScore = 0;
};

UCLASS()
class VETCHALLENGE_API AScoreLogic : public AActor
{
	GENERATED_BODY()

public:
	AScoreLogic();

	/**
	 * Calculate points for a vaccination attempt.
	 * @param bPerfectHit   True if the player hit the exact target area.
	 * @param TimeMultiplier  Multiplier based on remaining time (higher = faster reaction).
	 * @return  The calculated score for this attempt.
	 */
	UFUNCTION(BlueprintCallable, Category = "Score")
	static int32 CalculatePoints(bool bPerfectHit, float TimeMultiplier);

	/** Current round score entries */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Score")
	TArray<FVetScore> Leaderboard;

	/** Add a score entry to the leaderboard */
	UFUNCTION(BlueprintCallable, Category = "Score")
	void AddScoreEntry(const FVetScore& Entry);

protected:
	virtual void BeginPlay() override;
};
