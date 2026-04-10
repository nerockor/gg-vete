using UnityEngine;

public class DogAI : MonoBehaviour {
    private bool isVaccinated = false;

    public void Disappear(bool success) {
        if (isVaccinated) return;
        isVaccinated = true;

        if (success) {
            Debug.Log("Dog vaccinated successfully! Playing animation/effects.");
            // Here you would trigger a happy animation or particle effect
        } else {
            Debug.Log("Injection failed or dog startled.");
        }

        // Simple logic for the micro-game: remove the dog after a delay
        Destroy(gameObject, 1.0f);
    }
}
