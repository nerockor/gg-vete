using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;

[Serializable]
public class ScoreEntry {
    public string playerName;
    public int score;
    public string date;
}

[Serializable]
public class LeaderboardData {
    public List<ScoreEntry> entries = new List<ScoreEntry>();
}

public class ScoreManager : MonoBehaviour {
    public static ScoreManager Instance;
    
    private int currentScore = 0;
    private string savePath;
    private LeaderboardData leaderboard = new LeaderboardData();

    void Awake() {
        if (Instance == null) Instance = this;
        else Destroy(gameObject);

        savePath = Path.Combine(Application.persistentDataPath, "leaderboard.json");
        LoadLeaderboard();
        CheckDailyReset();
    }

    void OnEnable() {
        VaccineLogic.OnScoreUpdate += AddScore;
    }

    void OnDisable() {
        VaccineLogic.OnScoreUpdate -= AddScore;
    }

    public void AddScore(int points) {
        currentScore += points;
        Debug.Log($"Score updated: {currentScore}");
        // Update UI logic here
    }

    public void SaveScore(string playerName) {
        leaderboard.entries.Add(new ScoreEntry {
            playerName = playerName,
            score = currentScore,
            date = DateTime.Now.ToString("yyyy-MM-dd")
        });
        
        string json = JsonUtility.ToJson(leaderboard, true);
        File.WriteAllText(savePath, json);
    }

    private void LoadLeaderboard() {
        if (File.Exists(savePath)) {
            string json = File.ReadAllText(savePath);
            leaderboard = JsonUtility.FromJson<LeaderboardData>(json);
        }
    }

    private void CheckDailyReset() {
        string today = DateTime.Now.ToString("yyyy-MM-dd");
        // Simple logic: if entries are from a different day, we reset or filter
        leaderboard.entries.RemoveAll(e => e.date != today);
    }
    
    public int GetCurrentScore() => currentScore;
}
