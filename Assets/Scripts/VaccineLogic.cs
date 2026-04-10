using UnityEngine;
using System;

public class VaccineLogic : MonoBehaviour {
    public static event Action<int> OnScoreUpdate; // Para avisar al GameManager
    public GameObject splashEffect; // Partículas de líquido

    private void OnTriggerEnter(Collider other) {
        // Validamos si golpeamos la zona correcta del perro
        if (other.CompareTag("TargetArea")) {
            TriggerSuccess(other.gameObject);
        } else if (other.CompareTag("Obstacle")) {
            TriggerFailure();
        }
    }

    void TriggerSuccess(GameObject dog) {
        OnScoreUpdate?.Invoke(100); // Suma puntos
        
        if (splashEffect != null) {
            Instantiate(splashEffect, transform.position, Quaternion.identity);
        }
        
        // El perro reacciona y desaparece
        DogAI dogAI = dog.GetComponentInParent<DogAI>();
        if (dogAI != null) {
            dogAI.Disappear(true);
        }
        Debug.Log("Inyección exitosa en zona muscular.");
    }

    void TriggerFailure() {
        OnScoreUpdate?.Invoke(-50); // Penaliza si pincha en lugar erróneo
        Debug.Log("Fallo: El perro se movió o pinchazo errado.");
    }
}
