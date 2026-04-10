// Ubicación: ~/Desktop/juego-vete/languages/ScoreLogic.cpp

#include "GameFramework/Actor.h"

// Definición de la estructura de puntos para el ranking del stand
struct FVetScore {
    FString VetName;
    int32 DogsVaccinated;
    float RemainingTime;
};

// Lógica para sumar puntos cuando el perro es pinchado
int32 CalculatePoints(bool bPerfectHit, float TimeMultiplier) {
    int32 BasePoints = 100;
    return bPerfectHit ? (BasePoints * 1.5 * TimeMultiplier) : BasePoints;
}
