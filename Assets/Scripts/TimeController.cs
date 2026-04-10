using UnityEngine;
using TMPro; // Recommended for VR UI

public class TimeController : MonoBehaviour {
    public float timeRemaining = 60f;
    public bool timerIsRunning = false;
    public TextMeshProUGUI timeText; // Assign in Inspector

    private void Start() {
        // Start the timer when the game begins
        timerIsRunning = true;
    }

    private void Update() {
        if (timerIsRunning) {
            if (timeRemaining > 0) {
                timeRemaining -= Time.deltaTime;
                DisplayTime(timeRemaining);
            } else {
                Debug.Log("Time has run out!");
                timeRemaining = 0;
                timerIsRunning = false;
                GameOver();
            }
        }
    }

    void DisplayTime(float timeToDisplay) {
        timeToDisplay += 1;
        float minutes = Mathf.FloorToInt(timeToDisplay / 60);
        float seconds = Mathf.FloorToInt(timeToDisplay % 60);
        
        if (timeText != null) {
            timeText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
        }
    }

    void GameOver() {
        // Logic for game over, show leaderboard, etc.
        Debug.Log("Game Over! Final Score: " + ScoreManager.Instance.GetCurrentScore());
        ScoreManager.Instance.SaveScore("VR_Player_01"); // Example name
    }
}
